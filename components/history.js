var history

// Array Remove - By John Resig (MIT Licensed)
Array.prototype.remove = function(from, to) {
  var rest = this.slice((to || from) + 1 || this.length);
  this.length = from < 0 ? this.length + from : from;
  return this.push.apply(this, rest);
};

var History = function(savedGame) {
    var newSavedGame
    if(!savedGame) {
        newSavedGame = []
    }
    else {
        newSavedGame = savedGame
    }

   // print("History::"+newSavedGame.toString()+newSavedGame.length)
    this.marking = false
    this.json = newSavedGame
    historyIndex = 0
    if(!this.json.length) {
        historyLength = 0
    }
    else {
        historyLength = this.json.length
    }
}

History.prototype.addToHistory = function (fromIndex, fromStack, fromUp, toIndex, toStack, toUp, flipZ, autoMove) {
    if(!this.marking)
        return
    if(!this.current)
        this.current = []
    this.current[this.current.length] = {"fromIndex": fromIndex, "fromStack": fromStack,"fromUp": fromUp, "toIndex":toIndex, "toStack":toStack, "toUp":toUp, "flipZ":flipZ, "autoMove":autoMove}
}

History.prototype.startMove = function () {
   // print("History::startMove "+historyIndex)
    this.marking = true
}

History.prototype.readyForNext = function () {
    if(this.marking && this.current && this.current.length>0)
        return true
    return false
}

History.prototype.endMove = function () {
  //  print("History::endMove "+historyIndex)
    if(this.readyForNext()) {
        this.json.remove(historyIndex,-1)
        this.json[historyIndex] = this.current
        delete this.current
        historyIndex++
        historyLength = this.json.length
    }
    this.marking = false
}

History.prototype.goBackAndReturn = function () {
    var tmp
    if(historyIndex>0) {
        historyIndex--
        tmp = this.json[historyIndex]
    }

    return tmp
}

History.prototype.returnAndGoForward = function () {
    var tmp
    if(historyIndex<this.json.length) {
        tmp = this.json[historyIndex]
        historyIndex++
    }

    return tmp
}

function init(savedGame) {
    if(typeof savedGame == 'undefined')
        savedGame = []
    history = new History(savedGame)
}
