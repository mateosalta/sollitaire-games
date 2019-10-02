import QtQuick 2.9
import Ubuntu.Components 1.3
import "../components"

Board {
    id: board
    columns: 6
    columnSpaces: 8
    rows: 1
    rowSpaces: 2
    cardYStacks: 13

    decks: 1

    onSingelPress: {
        if (!stack)
            return
        startMove()
        print(tableauStackList[0])
        if (stack === stockStack) {
            if(stockStack.count>0) {
                var count = stockStack.count
                for(var iii=1; iii<=4; iii++) {
                    moveCard(
                                stockStack.count-iii,
                                stockStack, tableauStackList[iii-1],
                                true)
                }
            }
        } else if(stack !== foundationStack ){
            var lastCard = stack.lastCard
            if(lastCard && lastCard.card!==1) {
                var success = false
                var foundSuit = false
                for(var key in tableauStackList ) {
                    var tmpStack = tableauStackList[key]
                    if(stack === tmpStack)
                        continue
                    if(tmpStack.lastCard) {
                        if(tmpStack.lastCard.suit === lastCard.suit) {
                            foundSuit = true
                            if(tmpStack.lastCard.card===1 || tmpStack.lastCard.card > lastCard.card) {
                                success = true
                                break
                            }
                        }
                    }
                }
                if(success) {
                    moveCard(
                                stack.count-1,
                                stack, foundationStack)
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
                        moveCard(
                                    previousSelectedStack.count-1,
                                    previousSelectedStack, hoverStack)
                        endMove()
                    }
                }
                stopHighlight()
            }
        }
    }

    onHoverStackChanged: {
        if (selectedStack) {
            if (!hoverStack) {
                stopHighlight()
                return
            } else if (!hoverStack.cardsDropable) {
                stopHighlight()
                return
            }
            else if (selectedStack === hoverStack) {
                stopHighlight()
                return
            }
            highlightFrom(selectedStack.count-1)
        }
    }

    function checkGame() {
        if(stockStack.count>0)
            return false
        for(var iii = 0; iii<tableauStackList.length; iii++) {
            for(var jjj=0; jjj<tableauStackList[iii].count; jjj++) {
                if(tableauStackList[iii].repeater.itemAt(jjj).card!==1)
                    return false
            }
        }
        end(true)
    }

    Stack {
        id: foundationStack
        x: board.width - board.columnWidth - board.columnMargin
        y: board.columnMargin
        cardWidth: board.columnWidth
        cardHeight: board.columnHeight
        showHidden: false

        foundation: true

        cardsMoveable: false
        nrCardsMoveable: 1

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

        cardsMoveable: true
        nrCardsMoveable: 1

        fannedDown: true

        cardsDropable: false
    }

    Stack {
        id: tableauStack1
        cardWidth: board.columnWidth
        cardHeight: board.columnHeight
        x: stockStack.x+columnMargin+columnWidth
        y: columnMargin

        tableau: true

        cardsMoveable: true
        nrCardsMoveable: 1

        fannedDown: true

        cardsDropable: count===0
    }

    Stack {
        id: tableauStack2
        cardWidth: board.columnWidth
        cardHeight: board.columnHeight
        x: tableauStack1.x+columnMargin+columnWidth
        y: columnMargin

        tableau: true

        cardsMoveable: true
        nrCardsMoveable: 1

        fannedDown: true

        cardsDropable: count===0
    }

    Stack {
        id: tableauStack3
        cardWidth: board.columnWidth
        cardHeight: board.columnHeight
        x: tableauStack2.x+columnMargin+columnWidth
        y: columnMargin

        tableau: true

        cardsMoveable: true
        nrCardsMoveable: 1

        fannedDown: true

        cardsDropable: count===0
    }

    Stack {
        id: tableauStack4
        cardWidth: board.columnWidth
        cardHeight: board.columnHeight
        x: tableauStack3.x+columnMargin+columnWidth
        y: columnMargin

        tableau: true

        cardsMoveable: true
        nrCardsMoveable: 1

        fannedDown: true

        cardsDropable: count===0
    }

    dealingModel: [
        QtObject { property Stack stackId: tableauStack1; property bool isUp:true;},
        QtObject { property Stack stackId: tableauStack2; property bool isUp:true;},
        QtObject { property Stack stackId: tableauStack3; property bool isUp:true;},
        QtObject { property Stack stackId: tableauStack4; property bool isUp:true;}
    ]

    onInit: {
        var tmpGSL = [tableauStack1, tableauStack2, tableauStack3, tableauStack4]
        tableauStackList = tmpGSL;
    }
}
