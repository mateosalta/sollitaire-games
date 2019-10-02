import QtQuick 2.9
import Ubuntu.Components 1.3
import "../components"

Board {
    id: board
    columns: 9
    columnSpaces: 10
    rows: 2
    rowSpaces: 3
    cardYStacks: 12

    decks: 1
    canAutoPlay: true

    property int freeCells: 4 - cellStack1.count - cellStack2.count - cellStack3.count - cellStack4.count
    onFreeCellsChanged: {
        print("freeCells: "+freeCells)
    }

    property Stack nextCellStack: getNextCell()

    function getNextCell() {
        if(cellStack1.count<1)
            return cellStack1
        if(cellStack2.count<1)
            return cellStack2
        if(cellStack3.count<1)
            return cellStack3
        return cellStack4
    }

    onSingelPress: {
        if (!card || !stack)
            return
        startMove()
        var done = false
        if ((stack.tableau || stack.cell) && stack.indexOf(card) === stack.count - 1) {
            var suit = card.suit
            var cardNr = card.card
            switch (suit) {
            case 1:
                if (foundationStack1.lastCard.card + 1 === cardNr) {
                    moveCardAndFlip(stack.count - 1, stack, foundationStack1)
                    done = true
                }
                break
            case 2:
                if (foundationStack2.lastCard.card + 1 === cardNr) {
                    moveCardAndFlip(stack.count - 1, stack, foundationStack2)
                    done = true
                }
                break
            case 3:
                if (foundationStack3.lastCard.card + 1 === cardNr) {
                    moveCardAndFlip(stack.count - 1, stack, foundationStack3)
                    done = true
                }
                break
            case 4:
                if (foundationStack4.lastCard.card + 1 === cardNr) {
                    moveCardAndFlip(stack.count - 1, stack, foundationStack4)
                    done = true
                }
                break
            }
            if(!done) {
                if(!autoPlaying && nextCellStack.count===0) {
                    moveCardAndFlip(stack.count - 1, stack, nextCellStack)
                    done = true
                }
            }
        }
        endMove()
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
                                        previousSelectedStack, hoverStack,
                                        true, !previousSelectedStack.foundation)
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
            var checkNextNumberSameSuit = function (card) {
                if (!card.up)
                    return
                var topCard = hoverStack.lastCard
                if (topCard && topCard.card + 1 === card.card
                        && topCard.suit === card.suit) {
                    highlightFrom(selectedStack.count - 1)
                }
            }

            var checkFreeCell = function (index, card) {
                if (!card.up)
                    return
                if (!checkTableau(selectedStack, index))
                    return
                var topCard = hoverStack.lastCard
                if(topCard) {
                    if(hoverStack.count === 0||
                            ( (!topCard.sameColor(card) ) && topCard.card === card.card + 1)) {
                        if(selectedStack.count - 1 - index <= freeCells) {
                            highlightFrom(index)
                            return true
                        }
                    }
                }
                return false
            }

            if (hoverStack.foundation) {
                checkNextNumberSameSuit(selectedCard)
            } else if (hoverStack.cell) {
                if(hoverStack.count===0)
                    highlightFrom(selectedStack.count-1)
                else {
                    stopHighlight()
                    return
                }
            } else {
                if (selectedStack === hoverStack) {
                    stopHighlight()
                    return
                }
                forEachFromSelected(checkFreeCell)
            }
        }
    }

    function checkGame() {
        print("checkGame")
        for(var index in tableauStackList) {
            if(tableauStackList[index].count!==0)
                return
        }
        end(true)
    }

    function checkTableau(stack, index) {
        var previousSuit = -1
        var previousCard = -1
        for(var iii = index; iii < stack.count; iii++) {
            if(previousSuit == -1) {
                //Filler
            }
            else if(stack.repeater.itemAt(iii).sameColor(previousSuit) || stack.repeater.itemAt(iii).card !== previousCard-1){
                return false
            }
            previousSuit = stack.repeater.itemAt(iii).suit
            previousCard = stack.repeater.itemAt(iii).card
        }
        return true
    }

    property int yCardSpace: (height - 1.5*columnHeight - 3*columnMargin)/cardMarginY
    onYCardSpaceChanged: {
        print("Room for "+yCardSpace+" cards")
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
        placeholderCard: 14

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
        placeholderCard: 14

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
        placeholderCard: 14

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
        placeholderCard: 14

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
        placeholderCard: 14

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
        placeholderCard: 14

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
        placeholderCard: 14

        cardsMoveable: true
        cardsDropable: true
    }

    Stack {
        id: tableauStack1
        x: board.columnMargin
        y: board.columnHeight + board.columnMargin * 2
        width: board.columnWidth
        cardHeight: board.columnHeight
        height: contentToBig?childrenRect.height:board.height - y
        fannedDown: true

        tableau: true

        cardsVisible: yCardSpace
        placeholderCard: 14

        cardsMoveable: true
        cardsDropable: true
    }

    Stack {
        id: foundationStack4
        x: foundationStack3.x + board.columnWidth + board.columnMargin
        y: board.columnMargin
        width: board.columnWidth
        cardHeight: board.columnHeight
        showHidden: false

        foundation: true

        placeholderSuit: 4

        cardsDropable: true
        cardsMoveable: true
        nrCardsMoveable: 1
    }

    Stack {
        id: foundationStack3
        x: foundationStack2.x + board.columnWidth + board.columnMargin
        y: board.columnMargin
        width: board.columnWidth
        cardHeight: board.columnHeight
        showHidden: false

        foundation: true

        placeholderSuit: 3

        cardsDropable: true
        cardsMoveable: true
        nrCardsMoveable: 1
    }

    Stack {
        id: foundationStack2
        x: foundationStack1.x + board.columnWidth + board.columnMargin
        y: board.columnMargin
        width: board.columnWidth
        cardHeight: board.columnHeight
        showHidden: false

        foundation: true

        placeholderSuit: 2

        cardsDropable: true
        cardsMoveable: true
        nrCardsMoveable: 1
    }

    Stack {
        id: foundationStack1
        x: cellStack4.x + board.columnWidth * 2 + board.columnMargin * 2
        y: board.columnMargin
        width: board.columnWidth
        cardHeight: board.columnHeight
        showHidden: false

        foundation: true

        placeholderSuit: 1

        cardsDropable: true
        cardsMoveable: true
        nrCardsMoveable: 1
    }

    Stack {
        id: cellStack4
        x: cellStack3.x + board.columnWidth + board.columnMargin
        y: board.columnMargin
        cardWidth: board.columnWidth
        cardHeight: board.columnHeight
        fannedRight: true
        showHidden: false

        cell: true

        cardsMoveable: true
        cardsDropable: count<1
        nrCardsMoveable: 1
        cardsVisible: 1
    }

    Stack {
        id: cellStack3
        x: cellStack2.x + board.columnWidth + board.columnMargin
        y: board.columnMargin
        cardWidth: board.columnWidth
        cardHeight: board.columnHeight
        fannedRight: true
        showHidden: false

        cell: true

        cardsMoveable: true
        cardsDropable: count<1
        nrCardsMoveable: 1
        cardsVisible: 1
    }

    Stack {
        id: cellStack2
        x: cellStack1.x + board.columnWidth + board.columnMargin
        y: board.columnMargin
        cardWidth: board.columnWidth
        cardHeight: board.columnHeight
        fannedRight: true
        showHidden: false

        cell: true

        cardsMoveable: true
        cardsDropable: count<1
        nrCardsMoveable: 1
        cardsVisible: 1
    }

    Stack {
        id: cellStack1
        x: board.columnMargin
        y: board.columnMargin
        cardWidth: board.columnWidth
        cardHeight: board.columnHeight
        fannedRight: true
        showHidden: false

        cell: true

        cardsMoveable: true
        cardsDropable: count<1
        nrCardsMoveable: 1
        cardsVisible: 1
    }

    onInit: {
        // Setting up the tableauStackList
        var tmpMSL = [tableauStack1,tableauStack2,tableauStack3,
                tableauStack4,tableauStack5,tableauStack6,
                tableauStack7,tableauStack8]
        tableauStackList = tmpMSL
        var tmpDM = []
        for(var iii=0;iii<52;iii++) {
            tmpDM[iii] = createDMObjectForIndex(iii)
            tmpDM[iii].isUp = true
        }
        for(;iii<52;iii++) {
            tmpDM[iii] = createDMObjectForIndex(iii)
            tmpDM[iii].isUp = true
        }
        dealingModel = tmpDM;
    }

    function createDMObjectForIndex(index) {
        switch(index%8) {
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
        }
    }

    function createDMObject(stack) {
        var tmp = Qt.createQmlObject("import QtQuick 2.2; import \"../components\"; QtObject { property Stack stackId; property bool isUp;}",stack)
        tmp.stackId = stack
        return tmp
    }
}
