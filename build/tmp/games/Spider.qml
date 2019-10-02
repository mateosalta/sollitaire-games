import QtQuick 2.9
import Ubuntu.Components 1.3
import "../components"

Board {
    id: board
    columns: 10
    columnSpaces: 11
    rows: 2
    rowSpaces: 3
    cardYStacks: 12

    decks: 2

    onSingelPress: {
        if (!card || !stack)
            return
        startMove()
        if (stack === stockStack) {
            if(deckReadyForNew()) {
                var count = stockStack.count
                for (var iii = 1; iii <= 10; iii++) {
                    moveCard(count-iii, stockStack, tableauStackList[iii-1], true)
                }
            }
        }
        endMove()
    }

    function deckReadyForNew() {
        for(var iii=0; iii<10; iii++) {
            if(tableauStackList[iii].count===0) {
                return false
            }
        }
        return true
    }

    onSelectedStackChanged: {
        if (previousSelectedStack) {
            if (!selectedStack) {
                if (hoverStack) {
                    if (previousSelectedStack.highlightFrom !== -1) {
                        startMove()
                        var countMoving = previousSelectedStack.count
                                - previousSelectedStack.highlightFrom
                        for (var iii = 0; iii < countMoving; iii++) {
                            moveCardAndFlip(
                                        previousSelectedStack.highlightFrom+iii,
                                        previousSelectedStack, hoverStack)
                        }
                        endMove()
                    }
                }
                stopHighlight()
            }
        }
    }

    onHoverStackChanged: {
        if (!hoverStack) {
            if (selectedStack) {
                stopHighlight()
            }
        } else if (!hoverStack.cardsDropable) {
            if (selectedStack) {
                stopHighlight()
            }
        } else if (selectedStack) {
            var checkSpider = function (index, card) {
                if (!card.up)
                    return
                var topHoverCard = hoverStack.lastCard
                if (!topHoverCard)
                    return
                if(card === selectedStack.lastCard && (topHoverCard.card === card.card + 1 || topHoverCard.card == 0)) {
                    highlightFrom(index)
                    return true
                }
                if(topHoverCard.card === card.card + 1 || topHoverCard.card == 0) {
                    var found = false
                    var cardNr = card.card
                    var cardIndex = selectedStack.indexOf(card)
                    for(var iii=cardIndex;iii<selectedStack.count;iii++) {
                        if(card.suit!==selectedStack.repeater.itemAt(iii).suit || cardNr - (iii-cardIndex) !==  selectedStack.repeater.itemAt(iii).card ) {
                            found = true
                            break
                        }
                    }
                    if(!found) {
                        highlightFrom(index)
                        return true
                    }

                    return false
                }
            }

            if (selectedStack === hoverStack)
                return
            forEachFromSelected(checkSpider)
        }
    }

    function checkGame() {
        if (tableauStack1.count === 0 && tableauStack2.count === 0
                && tableauStack3.count === 0 && tableauStack4.count === 0
                && tableauStack5.count === 0 && tableauStack6.count === 0
                && tableauStack7.count === 0 && tableauStack8.count === 0
                && tableauStack9.count === 0 && tableauStack10.count === 0) {
            end(true)
        }
    }

    function checkStack(stack) {
        if(stack.count<13)
            return
        var suit = stack.lastCard.suit
        var success = true
        for(var index=stack.count-1;index>=stack.count-13;index--) {
            if(stack.repeater.itemAt(index).card !== stack.count-index || stack.repeater.itemAt(index).suit !==suit) {
                success = false
                break
            }
        }
        if(success) {
            storeStack(stack)
        }
    }

    function storeStack(stack) {
        var toStack
        var suit = stack.lastCard.suit
        if(foundationStack1.count===0)
            toStack = foundationStack1
        else if(foundationStack2.count===0)
            toStack = foundationStack2
        else if(foundationStack3.count===0)
            toStack = foundationStack3
        else if(foundationStack4.count===0)
            toStack = foundationStack4
        else if(foundationStack5.count===0)
            toStack = foundationStack5
        else if(foundationStack6.count===0)
            toStack = foundationStack6
        else if(foundationStack7.count===0)
            toStack = foundationStack7
        else if(foundationStack8.count===0)
            toStack = foundationStack8

        var firstMove = stack.count - 13
        for (var iii = 0; iii < 13; iii++) {
            moveCardAndFlip(
                        firstMove+iii,
                        stack, toStack)
        }
    }

    property int yCardSpace: (height - 1.5*columnHeight - 3*columnMargin)/cardMarginY

    Stack {
        id: tableauStack10
        x: tableauStack9.x + board.columnWidth + board.columnMargin
        y: board.columnHeight + board.columnMargin * 2
        cardWidth: board.columnWidth
        cardHeight: board.columnHeight
        height: contentToBig?childrenRect.height:board.height - y
        fannedDown: true

        tableau: true

        cardsVisible: yCardSpace

        cardsMoveable: true
        cardsDropable: true
    }

    Stack {
        id: tableauStack9
        x: tableauStack8.x + board.columnWidth + board.columnMargin
        y: board.columnHeight + board.columnMargin * 2
        cardWidth: board.columnWidth
        cardHeight: board.columnHeight
        height: contentToBig?childrenRect.height:board.height - y
        fannedDown: true

        tableau: true

        cardsVisible: yCardSpace

        cardsMoveable: true
        cardsDropable: true
    }

    Stack {
        id: tableauStack8
        x: tableauStack7.x + board.columnWidth + board.columnMargin
        y: board.columnHeight + board.columnMargin * 2
        cardWidth: board.columnWidth
        cardHeight: board.columnHeight
        height: contentToBig?childrenRect.height:board.height - y
        fannedDown: true

        tableau: true

        cardsVisible: yCardSpace

        cardsMoveable: true
        cardsDropable: true
    }

    Stack {
        id: tableauStack7
        x: tableauStack6.x + board.columnWidth + board.columnMargin
        y: board.columnHeight + board.columnMargin * 2
        cardWidth: board.columnWidth
        cardHeight: board.columnHeight
        height: contentToBig?childrenRect.height:board.height - y
        fannedDown: true

        tableau: true

        cardsVisible: yCardSpace

        cardsMoveable: true
        cardsDropable: true
    }

    Stack {
        id: tableauStack6
        x: tableauStack5.x + board.columnWidth + board.columnMargin
        y: board.columnHeight + board.columnMargin * 2
        cardWidth: board.columnWidth
        cardHeight: board.columnHeight
        height: contentToBig?childrenRect.height:board.height - y
        fannedDown: true

        tableau: true

        cardsVisible: yCardSpace

        cardsMoveable: true
        cardsDropable: true
    }

    Stack {
        id: tableauStack5
        x: tableauStack4.x + board.columnWidth + board.columnMargin
        y: board.columnHeight + board.columnMargin * 2
        cardWidth: board.columnWidth
        cardHeight: board.columnHeight
        height: contentToBig?childrenRect.height:board.height - y
        fannedDown: true

        tableau: true

        cardsVisible: yCardSpace

        cardsMoveable: true
        cardsDropable: true
    }

    Stack {
        id: tableauStack4
        x: tableauStack3.x + board.columnWidth + board.columnMargin
        y: board.columnHeight + board.columnMargin * 2
        cardWidth: board.columnWidth
        cardHeight: board.columnHeight
        height: contentToBig?childrenRect.height:board.height - y
        fannedDown: true

        tableau: true

        cardsVisible: yCardSpace

        cardsMoveable: true
        cardsDropable: true
    }

    Stack {
        id: tableauStack3
        x: tableauStack2.x + board.columnWidth + board.columnMargin
        y: board.columnHeight + board.columnMargin * 2
        cardWidth: board.columnWidth
        cardHeight: board.columnHeight
        height: contentToBig?childrenRect.height:board.height - y
        fannedDown: true

        tableau: true

        cardsVisible: yCardSpace

        cardsMoveable: true
        cardsDropable: true
    }

    Stack {
        id: tableauStack2
        x: tableauStack1.x + board.columnWidth + board.columnMargin
        y: board.columnHeight + board.columnMargin * 2
        cardWidth: board.columnWidth
        cardHeight: board.columnHeight
        height: contentToBig?childrenRect.height:board.height - y
        fannedDown: true

        tableau: true

        cardsVisible: yCardSpace

        cardsMoveable: true
        cardsDropable: true
    }

    Stack {
        id: tableauStack1
        x: board.columnMargin
        y: board.columnHeight + board.columnMargin * 2
        cardWidth: board.columnWidth
        cardHeight: board.columnHeight
        height: contentToBig?childrenRect.height:board.height - y
        fannedDown: true

        tableau: true

        cardsVisible: yCardSpace

        cardsMoveable: true
        cardsDropable: true
    }

    Stack {
        id: foundationStack8
        x: board.width - board.columnWidth - board.columnMargin
        y: board.columnMargin
        width: board.columnWidth
        cardHeight: board.columnHeight
        showHidden: false

        foundation: true

        placeholderSuit: 4

        cardsDropable: false
    }

    Stack {
        id: foundationStack7
        x: foundationStack8.x - board.columnWidth - board.columnMargin
        y: board.columnMargin
        width: board.columnWidth
        cardHeight: board.columnHeight
        showHidden: false

        foundation: true

        placeholderSuit: 3

        cardsDropable: false
    }

    Stack {
        id: foundationStack6
        x: foundationStack7.x - board.columnWidth - board.columnMargin
        y: board.columnMargin
        width: board.columnWidth
        cardHeight: board.columnHeight
        showHidden: false

        foundation: true

        placeholderSuit: 2

        cardsDropable: false
    }

    Stack {
        id: foundationStack5
        x: foundationStack6.x - board.columnWidth - board.columnMargin
        y: board.columnMargin
        width: board.columnWidth
        cardHeight: board.columnHeight
        showHidden: false

        foundation: true

        placeholderSuit: 1

        cardsDropable: false
    }

    Stack {
        id: foundationStack4
        x: foundationStack5.x - board.columnWidth - board.columnMargin
        y: board.columnMargin
        width: board.columnWidth
        cardHeight: board.columnHeight
        showHidden: false

        foundation: true

        placeholderSuit: 4

        cardsDropable: false
    }

    Stack {
        id: foundationStack3
        x: foundationStack4.x - board.columnWidth - board.columnMargin
        y: board.columnMargin
        width: board.columnWidth
        cardHeight: board.columnHeight
        showHidden: false

        foundation: true

        placeholderSuit: 3

        cardsDropable: false
    }

    Stack {
        id: foundationStack2
        x: foundationStack3.x - board.columnWidth - board.columnMargin
        y: board.columnMargin
        width: board.columnWidth
        cardHeight: board.columnHeight
        showHidden: false

        foundation: true

        placeholderSuit: 2

        cardsDropable: false
    }

    Stack {
        id: foundationStack1
        x: foundationStack2.x - board.columnWidth - board.columnMargin
        y: board.columnMargin
        width: board.columnWidth
        cardHeight: board.columnHeight
        showHidden: false

        foundation: true

        placeholderSuit: 1

        cardsDropable: false
    }

    Stack {
        id: stockStack
        x: board.columnMargin
        y: board.columnMargin
        cardWidth: board.columnWidth
        cardHeight: board.columnHeight
        goUpZ: true

        stock: true
    }

    onInit: {
        // Setting up the tableauStackList
        var tmpMSL = [tableauStack1,tableauStack2,tableauStack3,
                tableauStack4,tableauStack5,tableauStack6,
                tableauStack7,tableauStack8,tableauStack9,
                tableauStack10]
        tableauStackList = tmpMSL
        var tmpDM = []
        for(var iii=0;iii<44;iii++) {
            tmpDM[iii] = createDMObjectForIndex(iii)
            tmpDM[iii].isUp = false
        }
        for(;iii<54;iii++) {
            tmpDM[iii] = createDMObjectForIndex(iii)
            tmpDM[iii].isUp = true
        }
        dealingModel = tmpDM;
    }
    function createDMObjectForIndex(index) {
        switch(index%10) {
        case 0:
            return createDMObject(tableauStack1)
        case 1:
            return createDMObject(tableauStack2)
        case 2:
            return createDMObject(tableauStack3)
        case 3:
            return createDMObject(tableauStack4)
        case 4:
            return createDMObject(tableauStack5)
        case 5:
            return createDMObject(tableauStack6)
        case 6:
            return createDMObject(tableauStack7)
        case 7:
            return createDMObject(tableauStack8)
        case 8:
            return createDMObject(tableauStack9)
        case 9:
            return createDMObject(tableauStack10)
        }
    }

    function createDMObject(stack) {
        var tmp = Qt.createQmlObject("import QtQuick 2.2; import \"../components\"; QtObject { property Stack stackId; property bool isUp;}",stack)
        tmp.stackId = stack
        return tmp
    }
}
