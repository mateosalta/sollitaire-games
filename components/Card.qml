import QtQuick 2.9
import Ubuntu.Components 1.3
import "./"

Flipable {
    property int card:0
    property int suit:0
    property bool showAce: true
    property bool up: outline||shadow?false:true
    property bool outline: false
    property bool shadow: false
    property bool animated: !board._redoing
    property bool animating: xAnimation.running || yAnimation.running || angleAnimation.running
    property bool moveable: false
    property bool highlighted: false
    property int stackIndex: -1
    property bool autoMove: true

    property int _duration: UbuntuAnimation.FastDuration

    property alias frontCard: frontLoader.item

    signal afterAnimation()
    signal beforeAnimation()

    id: cardObj

    objectName: "card"

    onAnimatingChanged: {
        if(!animating)
            afterAnimation()
        else
            beforeAnimation()
    }

    onBeforeAnimation: {
        setParentZ(1)
    }
    onAfterAnimation: {
        setParentZ(-1)
    }

    transform: Rotation {
        id: rot
        origin.x: width/2
        origin.y: height/2
        axis.x: 0; axis.y: 1; axis.z: 0

        angle: up||outline||shadow?0:180

        Behavior on angle {
            id: angleBehavior
            animation: angleAnimation
            enabled: animated && !yAnimation.running && !xAnimation.running
        }
    }

    ParallelAnimation {
        id: angleAnimation
        SequentialAnimation {
            PropertyAnimation {
                target: cardObj
                property: "y"
                to: cardObj.y - 20
                duration: _duration
                easing: UbuntuAnimation.StandardEasing
            }
            PropertyAnimation {
                target: cardObj
                property: "y"
                to: cardObj.y
                duration: _duration
                easing: UbuntuAnimation.StandardEasing
            }
        }
        UbuntuNumberAnimation {
            duration: 2*_duration
        }
    }

    front: Item {
        width: cardObj.width
        height: cardObj.height
        UbuntuShape {
            id: highlight
            property int _border: 3
            x: - _border
            y: - _border
            width: cardObj.width + 2*_border
            height: cardObj.height + 2*_border
            visible: highlighted

            color: "white"
        }
        Loader {
            id: frontLoader
            anchors.fill: parent
            source: getSource()
        }
    }

    back: DownCard {
        width: cardObj.width
        height: cardObj.height
    }

    Behavior on x {
        id: xBehavior
        enabled: animated
        UbuntuNumberAnimation {
            id: xAnimation
            duration: _duration
        }
    }

    Behavior on y {
        id: yBehavior
        enabled: animated
        UbuntuNumberAnimation {
            id: yAnimation
            duration: _duration
        }
    }

    function setParentZ(parZ) {
        var tmpParent = parent
        if(tmpParent && tmpParent.objectName === "stack") {
            tmpParent.cardsSetZ += parZ
        }
    }

    function getSource() {
        if(outline)
            return "OutlineCard.qml"
        else if(shadow)
            return "ShadowCard.qml"
        return "UpCard.qml"
    }

    function sameColor(card) {
        if(card.suit === suit || card.suit+suit ==5)
            return true
        return false
    }
}
