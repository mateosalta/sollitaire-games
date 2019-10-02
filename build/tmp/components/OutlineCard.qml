import QtQuick 2.9
import Ubuntu.Components 1.3

UbuntuShape {
    color: "transparent"

    Suit {
        anchors.centerIn: parent
        suit: cardObj.suit
        width: parent.width/3
        height: width
    }
}
