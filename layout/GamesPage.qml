import QtQuick 2.9
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
//import Ubuntu.Components.ListItems 0.1 as ListItem

Page {
    id: page

    property real _smallListWidth: units.gu(25)
    property real _minInfoWidth: units.gu(60)

    property alias currentIndex: gameListView.currentIndex

    header: PageHeader {
        id: pageH
        title: i18n.tr("Games")
    }

    Rectangle {
        anchors.fill: gameListView
        visible: !mainView.small
        color: Theme.palette.normal.background
        z: -1
    }

    Component {
        id: gameDelegate
        // TODO: show if this game has progresses saved ?

        ListItem {
            property string gameTitle: index==-1?i18n.tr("Select a game"):gamesRepeater.itemAt(index).title
            property string gameRules: index==-1?"":gamesRepeater.itemAt(index).rules
            property string gameInfo: index==-1?"":gamesRepeater.itemAt(index).info
            Label {
                text: gamesRepeater.itemAt(index).title
                anchors.centerIn: parent
            }
            id: thisItem

            onClicked: {
                currentIndex = index
                if(mainView.small) {
                    startGame(index)
                }
            }
            swipeEnabled: mainView.small
            trailingActions: ListItemActions {
                actions: [
                    Action {
                        iconName: "info"
                        onTriggered: PopupUtils.open(infoOrRulesSheed, parent, {"index":index,"gameTitle":gameTitle,"mainText":gameInfo})
                    },
                    Action {
                        iconName: "view-list-symbolic"
                        onTriggered: PopupUtils.open(infoOrRulesSheed, parent, {"index":index,"gameTitle":gameTitle,"mainText":gameRules})
                    }
                ]
            }
            selected: gameListView.currentItem === thisItem
        }
    }

    ListView {
        id: gameListView
        model: gamesModel
        delegate: gameDelegate

        anchors.top: pageH.bottom
        anchors.bottom: page.bottom
        anchors.left: page.left
        currentIndex: -1

        clip: !mainView.small
    }

    onCurrentIndexChanged: {
        moreInfoFlickable.contentY = 0
    }


    Flickable {
        id: moreInfoFlickable
        anchors.left: gameListView.right
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: pageH.bottom
        visible: !mainView.small
        contentHeight: container.height + container.anchors.topMargin + container.anchors.bottomMargin + startContainer.height
        clip: true

        Column {
            id: container
            width: parent.width
            property string gameTitle: currentIndex==-1?i18n.tr("Select a game"):gamesRepeater.itemAt(currentIndex).title
            property string gameRules: currentIndex==-1?"":gamesRepeater.itemAt(currentIndex).rules
            property string gameInfo: currentIndex==-1?"":gamesRepeater.itemAt(currentIndex).info
            anchors.top: parent.top
            anchors.topMargin: units.gu(4)
            anchors.bottomMargin: units.gu(4)
            spacing: units.gu(2)

            Label {
                id: titleLabel
                color: Theme.palette.normal.baseText
                anchors.left: parent.left
                anchors.leftMargin: units.gu(8)
                anchors.right: parent.right
                anchors.rightMargin: units.gu(2)
                text: container.gameTitle
                fontSize: "x-large"
            }

            Label {
                id: gameInfoHeader
                color: Theme.palette.normal.baseText
                anchors.left: parent.left
                anchors.leftMargin: units.gu(2)
                anchors.right: parent.right
                anchors.rightMargin: units.gu(2)
                text: i18n.tr("Info:")
                fontSize: "large"
                visible: gameInfoLabel.text!=""
            }

            Label {
                id: gameInfoLabel
                color: Theme.palette.normal.baseText
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: units.gu(4)
                anchors.rightMargin: units.gu(2)
                wrapMode: Text.Wrap
                textFormat: Text.RichText
                text: container.gameInfo
                fontSize: "medium"
            }

            ListItem {
                id: divider
                anchors.leftMargin: units.gu(1)
                anchors.rightMargin: units.gu(1)
                visible: gameInfoLabel.text!="" && gameRulesLabel.text!=""
            }

            Label {
                id: gameRulesHeader
                color: Theme.palette.normal.baseText
                anchors.left: parent.left
                anchors.leftMargin: units.gu(2)
                anchors.right: parent.right
                anchors.rightMargin: units.gu(2)
                text: i18n.tr("Rules:")
                fontSize: "large"
                visible: gameRulesLabel.text!=""
            }

            Label {
                id: gameRulesLabel
                color: Theme.palette.normal.baseText
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: units.gu(4)
                anchors.rightMargin: units.gu(2)
                wrapMode: Text.Wrap
                textFormat: Text.RichText
                text: container.gameRules
                fontSize: "medium"
            }
        }
    }

    Item {
        id: startContainer
        visible: !mainView.small
        anchors.left: moreInfoFlickable.left
        anchors.right: moreInfoFlickable.right
        anchors.bottom: parent.bottom
        height: childrenRect.height + units.gu(3)
        Button {
            property bool redeal: currentIndex>=0 && currentIndex === selectedGameIndex

            id: startButton
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: units.gu(5)
            text: i18n.tr("Start")
            enabled: currentIndex!==-1
            onClicked: startGame(currentIndex)
        }
    }

    Rectangle {
        color: Theme.palette.normal.foreground
        opacity: 0.5
        z: -1
        anchors.fill: startContainer
    }

    states: [
        State {
            name: "small"
            when: mainView.small

            AnchorChanges {
                target: gameListView
                anchors.right: page.right
            }
            PropertyChanges {
                target: page
                flickable: gameListView
            }

        }, State {
            name: "wide"
            when: !mainView.small

            AnchorChanges {
                target: gameListView
                anchors.right: undefined
            }
            PropertyChanges {
                target: gameListView
                width: _smallListWidth
                topMargin: 0
            }
            PropertyChanges {
                target: page
                flickable: null
            }
        }
    ]

    Component {
        id: infoOrRulesSheed

        Dialog {
            property string gameTitle
            property string mainText

            id: sheet
            title: "Info on " + gameTitle
            Label {
                color: Theme.palette.normal.overlayText
                id: label
                text: mainText
                wrapMode: Text.WordWrap
            }
            Button {
                text: i18n.tr("Done")
                onClicked: PopupUtils.close(sheet)
            }
        }
    }
}
