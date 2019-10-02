import QtQuick 2.9
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.2

Page {
    id: gamePage
    property alias loader: gameLoader
    property alias item: gameLoader.item
    property bool ready: gameLoader.source==""?false:gameLoader.status == Loader.Ready
    flickable: null

    NoGame {
        anchors.fill: flickable
        visible: !ready
        loading: gameLoader.status === Loader.Loading
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        contentWidth: item?item.width:0
        contentHeight: item?item.height:0
        clip: true
        interactive: item?item.shouldFlick:false
        boundsBehavior: Flickable.StopAtBounds

        Loader {
            x: 0
            y: 0
            id: gameLoader
            source: ""
//            asynchronous: true
            visible: ready
//            onStatusChanged: {
//                if(status === Loader.Ready) {
//                    initGame()
//                }
//            }
        }

        Binding {
            target: gameLoader.item
            property: "parentWidth"
            value: flickable.width
        }

        Binding {
            target: gameLoader.item
            property: "parentHeight"
            value: flickable.height
        }

        Binding {
            target: gameLoader.item
            property: "flickable"
            value: flickable
        }

        Connections {
            target: gameLoader.item
            onEnd: {
                setStats(selectedGameDbName, won)
                PopupUtils.open(Qt.resolvedUrl("EndDialog.qml"), gamePage, {"won":won})
            }
        }
    }
    Scrollbar {
        flickableItem: flickable
        align: Qt.AlignTrailing
        anchors.right: flickable.right
    }

    function initGame() {
        print("initGame:"+selectedGameDbName)
        var savedGame = getSaveState(selectedGameDbName)
        var savedGameIndex = getSaveStateIndex(selectedGameDbName)
        var savedSeed = getSaveStateSeed(selectedGameDbName)
        gameLoader.item.init(savedGame, savedGameIndex, savedSeed)
    }

    function saveState(saveState, savedIndex, savedSeed) {
        setSaveState(selectedGameDbName, saveState, savedIndex, savedSeed)
    }

    function removeState() {
        removeSaveState(selectedGameDbName)
    }

    function setSource(path, json) {
        if(gameLoader.source!=="") {
            if(gameLoader.item) {
                gameLoader.item.saveGame()
            }
        }
        if(path == "")
            gameLoader.source = ""
        else if(typeof json !== 'undefined')
            gameLoader.setSource(path, json)
        else
            gameLoader.setSource(path)
    }

    head.actions: [
        Action {
            iconName: "undo"
            text: i18n.tr("Undo")
            visible: gameLoader.item?gameLoader.item.hasPreviousMove:false
            onTriggered: {
                gameLoader.item.undo()
            }
        },
        Action {
            iconName: "redo"
            text: i18n.tr("Redo")
            visible: gameLoader.item?gameLoader.item.hasNextMove:false
            onTriggered: {
                gameLoader.item.redo()
            }
        },
        Action {
            iconName: "home"
            text: i18n.tr("New Game")
            onTriggered: {
                setStats(selectedGameDbName, false)
                newGame()
            }
        },
        Action {
            iconName: "reload"
            text: i18n.tr("Redeal")
            visible: ready
            onTriggered: {
                redealGame()
                setStats(selectedGameDbName, false)
            }
        },
        Action {
            iconName: "reset"
            text: i18n.tr("Restart")
            visible: ready
            onTriggered: {
                restartGame()
                setStats(selectedGameDbName, false)
            }
        }
    ]

}
