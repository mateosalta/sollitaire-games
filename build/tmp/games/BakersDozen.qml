import QtQuick 2.9
import Ubuntu.Components 1.3
import "../components"

Board {
    property bool moveKingsToBottom: true
    property bool foundationBySuit: true
    property bool tableauByAlternatingColor: false
    property bool letFillEmptySpots: false

    canAutoPlay: true

    id: board
    columns: 8
    columnSpaces: 9
    rows: 2
    rowSpaces: 3
    cardYStacks: 16

    decks: 1

    onSingelPress: {
        if (!card || !stack)
            return
        startMove()
        if (stack.tableau) {
            var suit = card.suit
            var cardNr = card.card
            if(foundationBySuit) {
                switch (suit) {
                case 1:
                    if (foundationStack1.lastCard.card + 1 === cardNr) {
                        moveCardAndFlip(stack.count - 1, stack, foundationStack1)
                    }
                    break
                case 2:
                    if (foundationStack2.lastCard.card + 1 === cardNr) {
                        moveCardAndFlip(stack.count - 1, stack, foundationStack2)
                    }
                    break
                case 3:
                    if (foundationStack3.lastCard.card + 1 === cardNr) {
                        moveCardAndFlip(stack.count - 1, stack, foundationStack3)
                    }
                    break
                case 4:
                    if (foundationStack4.lastCard.card + 1 === cardNr) {
                        moveCardAndFlip(stack.count - 1, stack, foundationStack4)
                    }
                    break
                }
            }
            else {
                for(var index in foundationStacks) {
                    if(cardNr === 1 && foundationStacks[index].count === 0) {
                        moveCardAndFlip(stack.count - 1, stack, foundationStacks[index])
                        break
                    }
                    else if(foundationStacks[index].lastCard.card+1 === cardNr) {
                        moveCardAndFlip(stack.count - 1, stack, foundationStacks[index])
                        break
                    }
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
                    return false
                var topCard = hoverStack.lastCard
                if (topCard && topCard.card + 1 === card.card
                        && topCard.suit === card.suit) {
                    highlightFrom(selectedStack.count - 1)
                    return true
                }
            }

            var checkDiffColor = function (index, card) {
                if (!card.up)
                    return
                var topCard = hoverStack.lastCard
                if (topCard && (!topCard.sameColor(card) || topCard.suit === 0)
                        && topCard.card === card.card + 1) {
                    highlightFrom(index)
                    return true
                }
                return false
            }

            if (hoverStack.foundation) {
                if(foundationBySuit) {
                    if(checkNextNumberSameSuit(selectedCard))
                        return
                }
                else {
                    if(hoverStack.lastCard.card + 1 === selectedStack.lastCard.card) {
                        highlightFrom(selectedStack.count-1)
                        return
                    }
                }
            } else {
                if (selectedStack === hoverStack) {
                    return
                }
                if(tableauByAlternatingColor) {
                    if(checkDiffColor(selectedStack.count-1, selectedStack.lastCard)) {
                        return
                    }
                }
                else {
                    if(hoverStack.lastCard.card - 1 === selectedStack.lastCard.card) {
                        highlightFrom(selectedStack.count-1)
                        return
                    }
                }
            }
        }
        stopHighlight()
    }

    function checkGame() {
        print("checkGame")
        if (foundationStack1.count + foundationStack2.count + foundationStack3.count + foundationStack4.count === 52) {
            end(true)
        }
    }

    property list<Stack> foundationStacks

    Stack {
        id: foundationStack1
        x: board.width - board.columnMargin - board.columnWidth
        y: board.columnMargin
        width: board.columnWidth
        cardHeight: board.columnHeight
        showHidden: false

        foundation: true

        placeholderSuit: foundationBySuit?1:0
        placeholderCard: 0

        cardsDropable: true
        cardsMoveable: true
        nrCardsMoveable: 1
    }

    Stack {
        id: foundationStack2
        x: board.width - board.columnMargin - board.columnWidth
        y: board.columnMargin*2 + board.columnHeight
        width: board.columnWidth
        cardHeight: board.columnHeight
        showHidden: false

        foundation: true

        placeholderSuit: foundationBySuit?2:0
        placeholderCard: 0

        cardsDropable: true
        cardsMoveable: true
        nrCardsMoveable: 1
    }

    Stack {
        id: foundationStack3
        x: board.width - board.columnMargin - board.columnWidth
        y: board.columnMargin*3 + board.columnHeight*2
        width: board.columnWidth
        cardHeight: board.columnHeight
        showHidden: false

        foundation: true

        placeholderSuit: foundationBySuit?3:0
        placeholderCard: 0

        cardsDropable: true
        cardsMoveable: true
        nrCardsMoveable: 1
    }

    Stack {
        id: foundationStack4
        x: board.width - board.columnMargin - board.columnWidth
        y: board.columnMargin*4 + board.columnHeight*3
        width: board.columnWidth
        cardHeight: board.columnHeight
        showHidden: false

        foundation: true

        placeholderSuit: foundationBySuit?4:0
        placeholderCard: 0

        cardsDropable: true
        cardsMoveable: true
        nrCardsMoveable: 1
    }

    property int yCardSpace: Math.floor((height - 3*columnHeight - 3*columnMargin)/cardMarginY)
    Component {
        id: tableauStackComp
        Stack {
            id: thisStack
            width: board.columnWidth
            height: contentToBig?childrenRect.height:getBakersY(index+7) - y
            cardWidth: board.columnWidth
            cardHeight: board.columnHeight
            x: getBakersX(index)
            y: getBakersY(index)

            tableau: true

            cardsMoveable: true
            cardsDropable: count>0?true:letFillEmptySpots
            placeholderCard: -1
            nrCardsMoveable: 1
        }
    }

    Repeater {
        id: tableauStackRep
        model: 13
        delegate: tableauStackComp

        function indexOf(item) {
            for (var iii = 0; iii < count; iii++) {
                if (tableauStackRep.itemAt(iii) === item)
                    return iii
            }
            return
        }
        onItemAdded: {
            var tmpTableauStackList = []
            for(var index in tableauStackList) {
                tmpTableauStackList[index]=tableauStackList[index]
            }
            tmpTableauStackList.push(item)
            tableauStackList = tmpTableauStackList
        }
    }

    onInit: {
        var tmpDM = []
        var iii
        for(iii=0;iii<52;iii++) {
            tmpDM[iii] = createDMObjectForIndex(iii%13)
            tmpDM[iii].isUp = true
        }
        dealingModel = tmpDM;
        foundationStacks = [foundationStack1, foundationStack2, foundationStack3, foundationStack4]
    }

    onDealingStackFilled: {
        var moveCardInModel = function (from, to) {
            board.dealingStack.deck.model.move(from, to, 1)
            print("dealingStackFilled: "+from+" to "+to)
        }

        print("dealingStackFilled")

        for(var column = 0; column<13; column++) {
            for(var index = column+2*13; index>=0; index-=13) {
                if(board.dealingStack.deck.model.get(index).thisCard === 13) {
                    var times = 0
                    while(index+times*13<39) {
                        times++
                        if(board.dealingStack.deck.model.get(index+times*13).thisCard === 13) {
                            break
                        }
                    }
                    if(times==0)
                        continue
                    moveCardInModel(index, index+times*13)
                    for(var iii=1; iii<=times; iii++) {
                        moveCardInModel(index+iii*13-1, index+(iii-1)*13)
                    }
                }
            }
        }
    }

    function getBakersX(index) {
        if(index>6)
            index -= 7
        return board.columnMargin*(1+index) + board.columnWidth*index
    }

    function getBakersY(index) {
        var row = Math.floor(index/7)
        return board.columnMargin*(row+1) + board.columnHeight*row + yCardSpace/2*board.cardMarginY*row
    }

    function createDMObjectForIndex(index) {
        return createDMObject(tableauStackRep.itemAt(index))
    }

    function createDMObject(stack) {
        var tmp = Qt.createQmlObject("import QtQuick 2.2; import \"../components\"; QtObject { property Stack stackId; property bool isUp;}",stack)
        tmp.stackId = stack
        return tmp
    }

}
