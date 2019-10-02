import QtQuick 2.9
import ".."

Rectangle {
    property int suit
    property real suitSize

    anchors.fill: parent
    id: face

    Suit {
        anchors.top: parent.top
        anchors.left: parent.left
        width: suitSize
        height: suitSize
        suit: face.suit
    }

    Suit {
        anchors.top: parent.top
        anchors.right: parent.right
        width: suitSize
        height: suitSize
        suit: face.suit
    }

    Suit {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        width: suitSize
        height: suitSize
        suit: face.suit
    }

    Suit {
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        width: suitSize
        height: suitSize
        suit: face.suit
    }

    Suit {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: suitSize
        height: suitSize
        suit: face.suit
        turned: true
    }

    Suit {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: suitSize
        height: suitSize
        suit: face.suit
        turned: true
    }
}
