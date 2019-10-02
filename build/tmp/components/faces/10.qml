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
        anchors.left: parent.left
        y: (face.height - suitSize)/3
        width: suitSize
        height: suitSize
        suit: face.suit
    }

    Suit {
        anchors.right: parent.right
        y: (face.height - suitSize)/3
        width: suitSize
        height: suitSize
        suit: face.suit
    }

    Suit {
        anchors.horizontalCenter: parent.horizontalCenter
        y: (face.height - suitSize)/6
        width: suitSize
        height: suitSize
        suit: face.suit
    }

    Suit {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 5*(face.height - suitSize)/6
        width: suitSize
        height: suitSize
        suit: face.suit
        turned: true
    }

    Suit {
        anchors.left: parent.left
        y: 2*(face.height - suitSize)/3
        width: suitSize
        height: suitSize
        suit: face.suit
        turned: true
    }

    Suit {
        anchors.right: parent.right
        y: 2*(face.height - suitSize)/3
        width: suitSize
        height: suitSize
        suit: face.suit
        turned: true
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
