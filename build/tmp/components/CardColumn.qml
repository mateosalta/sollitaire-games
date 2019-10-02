import QtQuick 2.9

Item {
    property int card
    property int suit
    property string _label
    property bool turned: false
    property bool showAce: true

    id: column

    function turn() {
        if(turned)
            column.transform = rotation
    }

    Rotation {
        id: rotation
        origin.x: column.width/2
        origin.y: column.height/2
        angle: 180
    }

    onTurnedChanged: turn()

    function cardToLabel() {
        if(showAce && card==1) {
            _label = "A"
        }
        else if(card>0 && card<11) {
            _label = card.toString()
        }
        else if(card==11) {
            _label = "J"
        }
        else if(card==12) {
            _label = "Q"
        }
        else if(card==13) {
            _label = "K"
        }
    }

    onCardChanged: cardToLabel()

    Component.onCompleted: { cardToLabel(); turn(); }

    Text {
        id: txt
        text: _label
        height: Math.min(cardMarginY - anchors.margins - img.height*0.3, cardMarginX*4/3 - anchors.margins - img.height*0.3)
        anchors.top: column.top
        anchors.horizontalCenter: column.horizontalCenter
        anchors.margins: cardMarginX/4
        anchors.bottomMargin: 0
        font.pixelSize: height*0.85
        color: suit>1 && suit<4 ? "#d40000":"Black"
    }

    Suit {
        id: img
        anchors.top: txt.bottom
        anchors.horizontalCenter: column.horizontalCenter
        anchors.margins: cardMarginX/8
        anchors.topMargin: 0
        width: column.width - anchors.margins*2
        height: width
        suit: column.suit
    }
}
