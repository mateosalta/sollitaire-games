import QtQuick 2.9
import Ubuntu.Components 1.3
import "../components"

Board {
    id: board
    columns: 7
    rows: 2
    columnSpaces: 8
    rowSpaces: 3
    cardYStacks: 12

    canAutoPlay: true

    property int waisteStackCards: 3

    onInit: {
    }

    onSingelPress: {
        if (!card || !stack)
            return
        if (stack === stockStack) {
            if (stockStack.count===0) {
                startMove()
                var count = waisteStack.count
                for (var jjj = 1; jjj <= count; jjj++) {
                    moveCard(count-jjj, waisteStack, stockStack, false, true)
                }
            }
            else {
                startMove()
                var count2 = stockStack.count
                for (var iii = 1; iii <= waisteStackCards; iii++) {
                    if(!moveCard(count2-iii, stockStack, waisteStack, true, true))
                        break
                }
            }
        }
        else if (stack.indexOf(card) === stack.count - 1) {
            startMove()
            var suit = card.suit
            var cardNr = card.card
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

            if (hoverStack === foundationStack1 || hoverStack === foundationStack2
                    || hoverStack === foundationStack3 || hoverStack === foundationStack4) {
                checkNextNumberSameSuit(selectedCard)
            } else if (selectedStack === waisteStack) {
                checkDiffColor(waisteStack.count - 1,
                               waisteStack.repeater.itemAt(waisteStack.count - 1))
            } else {
                if (selectedStack === hoverStack)
                    return
                forEachFromSelected(checkDiffColor)
            }
        }
    }

    function checkGame() {
        print("checkGame")
        if (tableauStack1.count === 0 && tableauStack2.count === 0
                && tableauStack3.count === 0 && tableauStack4.count === 0
                && tableauStack5.count === 0 && tableauStack6.count === 0
                && tableauStack7.count === 0) {
            end(true)
        }
    }

    property int yCardSpace: (height - 1.5*columnHeight - 3*columnMargin)/cardMarginY
    onYCardSpaceChanged: {
        print("Room for "+yCardSpace+" cards")
    }

    tableauStackList: [tableauStack1, tableauStack2, tableauStack3, tableauStack4, tableauStack5, tableauStack6, tableauStack7]

    Stack {
        id: tableauStack7
        x: board.width - board.columnWidth - board.columnMargin
        y: board.columnHeight + board.columnMargin * 2
        cardWidth: board.columnWidth
        cardHeight: board.columnHeight
        height: contentToBig?childrenRect.height:board.height - y
        fannedDown: true

        cardsVisible: yCardSpace
        placeholderCard: 14

        cardsMoveable: true
        cardsDropable: true
    }

    Stack {
        id: tableauStack6
        x: tableauStack7.x - board.columnMargin - board.columnWidth
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
        x: tableauStack6.x - board.columnMargin - board.columnWidth
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
        x: tableauStack5.x - board.columnMargin - board.columnWidth
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
        x: tableauStack4.x - board.columnMargin - board.columnWidth
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
        x: tableauStack3.x - board.columnMargin - board.columnWidth
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
        x: tableauStack2.x - board.columnMargin - board.columnWidth
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
        x: board.width - board.columnWidth - board.columnMargin
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
        x: foundationStack4.x - board.columnMargin - board.columnWidth
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
        x: foundationStack3.x - board.columnMargin - board.columnWidth
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
        x: foundationStack2.x - board.columnMargin - board.columnWidth
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
        id: waisteStack
        x: stockStack.x + board.columnWidth + board.columnMargin
        y: board.columnMargin
        cardWidth: board.columnWidth
        cardHeight: board.columnHeight
        fannedRight: true
        showHidden: false

        waste: true

        cardsMoveable: true
        nrCardsMoveable: 1
        cardsVisible: waisteStackCards
    }

    Stack {
        id: stockStack
        x: board.columnMargin
        y: board.columnMargin
        cardWidth: board.columnWidth
        cardHeight: board.columnHeight
        goUpZ: true
        extraZ: 100

        stock: true
    }

    dealingModel: [
        QtObject {
            property Stack stackId: tableauStack1
            property bool isUp: true
        },
        QtObject {
            property Stack stackId: tableauStack2
            property bool isUp: false
        },
        QtObject {
            property Stack stackId: tableauStack3
            property bool isUp: false
        },
        QtObject {
            property Stack stackId: tableauStack4
            property bool isUp: false
        },
        QtObject {
            property Stack stackId: tableauStack5
            property bool isUp: false
        },
        QtObject {
            property Stack stackId: tableauStack6
            property bool isUp: false
        },
        QtObject {
            property Stack stackId: tableauStack7
            property bool isUp: false
        },
        QtObject {
            property Stack stackId: tableauStack2
            property bool isUp: true
        },
        QtObject {
            property Stack stackId: tableauStack3
            property bool isUp: false
        },
        QtObject {
            property Stack stackId: tableauStack4
            property bool isUp: false
        },
        QtObject {
            property Stack stackId: tableauStack5
            property bool isUp: false
        },
        QtObject {
            property Stack stackId: tableauStack6
            property bool isUp: false
        },
        QtObject {
            property Stack stackId: tableauStack7
            property bool isUp: false
        },
        QtObject {
            property Stack stackId: tableauStack3
            property bool isUp: true
        },
        QtObject {
            property Stack stackId: tableauStack4
            property bool isUp: false
        },
        QtObject {
            property Stack stackId: tableauStack5
            property bool isUp: false
        },
        QtObject {
            property Stack stackId: tableauStack6
            property bool isUp: false
        },
        QtObject {
            property Stack stackId: tableauStack7
            property bool isUp: false
        },
        QtObject {
            property Stack stackId: tableauStack4
            property bool isUp: true
        },
        QtObject {
            property Stack stackId: tableauStack5
            property bool isUp: false
        },
        QtObject {
            property Stack stackId: tableauStack6
            property bool isUp: false
        },
        QtObject {
            property Stack stackId: tableauStack7
            property bool isUp: false
        },
        QtObject {
            property Stack stackId: tableauStack5
            property bool isUp: true
        },
        QtObject {
            property Stack stackId: tableauStack6
            property bool isUp: false
        },
        QtObject {
            property Stack stackId: tableauStack7
            property bool isUp: false
        },
        QtObject {
            property Stack stackId: tableauStack6
            property bool isUp: true
        },
        QtObject {
            property Stack stackId: tableauStack7
            property bool isUp: false
        },
        QtObject {
            property Stack stackId: tableauStack7
            property bool isUp: true
        }
    ]
}
