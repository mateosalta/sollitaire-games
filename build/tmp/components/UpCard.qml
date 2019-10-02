import QtQuick 2.9
import Ubuntu.Components 1.3

UbuntuShapeOverlay {
    property bool singleLabel: width<4*lu.width
    color: "white"
    overlayColor: "transparent"
overlayRect: Qt.rect(0.25, 0.25, 0.5, 0.2)
       // aspect: UbuntuShape.Flat

    CardColumn {
        id: lu
        card: cardObj.card
        suit: cardObj.suit
        showAce: cardObj.showAce

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: cardMarginX
    }

    Item {
        id: m
        anchors.left: lu.right
        anchors.right: run.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        Face {
            anchors.centerIn: parent
            width: m.width
            height: m.height - lu.width - run.width
            card: cardObj.card
            suit: cardObj.suit
            color: "white"
        }
    }

    CardColumn {
        id: run
        card: cardObj.card
        suit: cardObj.suit
        showAce: cardObj.showAce
        turned: true

        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        visible: !singleLabel
        width: singleLabel?0:lu.width
    }
}
