import QtQuick 2.9
import "random.js" as Random
import "chance.js" as Chance

Item {
    id: deck

    property alias model: deckModel
    property int decks: 1
    property int suits: 4
    property int noCards: decks*52
    property int noCardsOfSuit: noCards/suits

    property int _previousCount: 0
    property var chance

    signal  oneComming()

    ListModel {
        id: deckModel

        function pop() {
            var temp = get(count-1)
            if(!temp)
                return temp
            var temp2 = makeArgs(temp.thisSuit, temp.thisCard, temp.thisUp, temp.thisAutoMove)
            remove(count-1)
            return temp2
        }

        function unShift() {
            var temp = get(0)
            if(!temp)
                return temp
            var temp2 = makeArgs(temp.thisSuit, temp.thisCard, temp.thisUp, temp.thisAutoMove)
            remove(0)
            return temp2
        }

        function addFromCard(card) {
            deckModel.append(makeArgs(card.suit, card.card, card.up, card.autoMove))
        }
    }

    function pop() {
        return deckModel.pop()
    }

    function fillNonRandom(up) {
        deckModel.clear()
        for(var jjj=0; jjj<noCards; jjj++) {
            var suit = Math.floor(jjj/noCardsOfSuit)+1
            var card = jjj%13 + 1
            deckModel.append(makeArgs(suit, card, up, true))
        }
    }

    function fillRandom(up, seed) {
        up = up?up:false
        deckModel.clear()
        if(!seed || seed === -1)
            chance = new Chance.Chance()
        else
            chance = new Chance.Chance(seed);
        print("seed: "+getSeed())
        var tmpArr = new Array
        for(var iii=0; iii<noCards; iii++)
            tmpArr[iii] = iii;
        for(var jjj=0; jjj<noCards; jjj++) {
            var rand = tmpArr.splice(chance.integer({min: 0, max: noCards-1-jjj}),1)
            var suit = Math.floor(rand/noCardsOfSuit)+1
            var card = rand%noCardsOfSuit + 1
            deck.oneComming()
            deckModel.append(makeArgs(suit, card, up, true))
        }
    }

    function getSeed() {
        return chance.seed
    }

    function makeArgs(suit, card, up, autoMove) {
        return {"thisSuit": suit, "thisCard": card, "thisUp": up, "thisAutoMove": autoMove}
    }
}
