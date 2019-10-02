import QtQuick 2.9
import ".."

Rectangle {
    property int suit
    property string _source
    property real suitSize

    onSuitChanged: setSuitName()

    function setSuitName() {
        var suitName
        switch(suit) {
        case 1:
            suitName = "Clubs"
            break;
        case 2:
            suitName = "Diamonds"
            break;
        case 3:
            suitName = "Hearts"
            break;
        case 4:
            suitName = "Spades"
            break;
        }
        if(suitName)
            _source = "../../svg/" + suitName + "/Q.svg"
        else
            _source = ""
    }

    Component.onCompleted: setSuitName()

    anchors.fill: parent
    id: face

    Image {
        anchors.fill: parent
        source: _source
    }

    Suit {
        anchors.left: parent.left
        y: suitSize*0.08
        width: suitSize*0.85
        height: width
        suit: face.suit
    }

    Suit {
        anchors.right: parent.right
        y: parent.height - height - suitSize*0.08
        width: suitSize*0.85
        height: width
        suit: face.suit
        turned: true
    }
}
