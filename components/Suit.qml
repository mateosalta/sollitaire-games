import QtQuick 2.9

Image {
    property int suit
    property bool turned: false

    onTurnedChanged: turn()
    id: suitObj

    Rotation {
        id: rotation
        origin.x: suitObj.width/2
        origin.y: suitObj.height/2
        angle: 180
    }

    function turn() {
        if(turned)
            suitObj.transform = rotation
    }

    onSuitChanged: changeSuit()

    function changeSuit() {
        switch(suit) {
        case 0:
            source = "../svg/Ubuntu/suit.svg"
            break
        case 1:
            source = "../svg/Clubs/suit.svg"
            break
        case 2:
            source = "../svg/Diamonds/suit.svg"
            break
        case 3:
            source = "../svg/Hearts/suit.svg"
            break
        case 4:
            source = "../svg/Spades/suit.svg"
            break
        }
    }

    Component.onCompleted: { changeSuit(); turn() }
}
