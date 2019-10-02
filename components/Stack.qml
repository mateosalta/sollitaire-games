import QtQuick 2.9

Item {
    id: stack
    property bool fannedDown: tableau?true:false
    property bool fannedRight: false
    property bool goUpZ: false
    property bool showHidden: true
    property bool transparant: false
    property real cardWidth: width
    property real cardHeight: height
    property Card lastCard: count > 0 ? repeater.itemAt(count - 1) : back
    property Card backCard: back
    property bool cardsMoveable: false
    property bool cardsDropable: false

    property int count: model.count
    property int cardsVisible: goUpZ ? 3 : count
    property int amountComming: 0
    property int amountGoing: 0
    property int nrCardsMoveable: count
    property bool onlyUpMoveable: true
    property int _hiddenCards: count-cardsVisible<0?0:count-cardsVisible
    property int cardsShown: 0

    property int placeholderSuit: 0
    property int placeholderCard: 0

    property int highlightFrom: -1

    property bool flipZ: false

    property bool foundation: false
    property bool tableau: false
    property bool stock: false
    property bool waste: false
    property bool cell: false

    property alias deck: deck
    property alias decks: deck.decks
    property alias suits: deck.suits
    property alias model: deck.model
    property alias repeater: repeater

    property int cardsSetZ: 0
    property int extraZ: 0
    z: cardsSetZ>0?cardsSetZ + extraZ:0

    objectName: "stack"

    width: childrenRect.width
    height: childrenRect.height

    Deck {
        id: deck
        onOneComming: {
            amountComming++
        }
    }

    Card {
        id: back
        outline: true
        width: cardWidth
        height: cardHeight
        z: 0

        moveable: false
        visible: !transparant
        card: placeholderCard
        suit: placeholderSuit
    }

    Repeater {
        id: repeater
        model: deck.model
        delegate: Card {
            id: cardObj
            width: cardWidth
            height: cardHeight
            x: getX(index)
            y: getY(index)
            z: getZ(index)
            card: thisCard
            suit: thisSuit
            up: thisUp
            highlighted: highlightFrom > -1
                         && index >= highlightFrom ? true : false
            visible: animating ? true : true //Should be getVisible(index)

            moveable: cardsMoveable && (onlyUpMoveable?up:true) && nrCardsMoveable>=count-index

            stackIndex: index

            autoMove: thisAutoMove

            onAfterAnimation: repeater.checkUpCards()
            Component.onCompleted: {
                print("itemAdded: "+stackIndex)
                if(amountComming>0) {
                    stack.amountComming--
                    repeater.checkUpCards()
                }
                if(stack.amountComming === 0) {
                    stack.flipZ = false
                }
                print("itemAdded: still "+stack.amountComming)
            }
            Component.onDestruction: {
                print("itemRemoved: "+stackIndex)
                if(stack.amountGoing>0) {
                    stack.amountGoing--
                    repeater.checkUpCards()
                }
                print("itemRemoved: still "+stack.amountGoing)
            }
        }

        function checkUpCards() {
            var tmpCardsShown = 0
            for (var iii = 0; iii < count; iii++) {
                if (itemAt(iii) && itemAt(iii).up)
                    tmpCardsShown++
            }
            cardsShown = tmpCardsShown
        }
    }

    function indexOf(item) {
        for (var iii = 0; iii < count; iii++) {
            if (repeater.itemAt(iii) === item)
                return iii
        }
        return
    }

    function getVisible(index) {
        if (index < _hiddenCards)
            return false
        else
            return true
    }

    function getX(index) {
        if(!getVisible(index))
            return 0.0
        if (goUpZ) {
            return (index-_hiddenCards) * cardMarginX / 2
        }
        if (fannedRight) {
            return (index-_hiddenCards) * cardMarginX * 1.5
        }
        return 0.0
    }

    function getY(index) {
        if(!getVisible(index))
            return 0.0
        if (goUpZ) {
            return (index-_hiddenCards) * cardMarginY / 4
        }
        if (fannedDown) {
            return (index-_hiddenCards) * cardMarginY
        }
        return 0
    }

    function getZ(index) {
        if(flipZ && index>=count-amountGoing) {
           return 2*count-amountGoing-1-index
        }
        else {
            return index
        }
    }

    function mapToItemFromIndex(toStack, index) {
        if(typeof index === 'undefined')
            index = 0
        return stack.mapToItem(toStack, getX(index), getY(index))
    }

    function init() {
        amountComming = 0
        amountGoing = 0
        cardsSetZ = 0
        flipZ = 0
    }
}
