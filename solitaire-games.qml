import QtQuick 2.9
import Ubuntu.Components 1.3
import U1db 1.0 as U1db
import QtQuick.XmlListModel 2.0
import "layout"

/*!
    \brief MainView with a Label and Button elements.
*/
MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the .desktop filename
    applicationName: "solitaire-games.mateo-salta"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    automaticOrientation: true



  //  headerColor: "#092200"
    backgroundColor: "#0F3602"
    //footerColor: "#1D7300"

    width: units.gu(100)
    height: units.gu(80)

    id: mainView

    property int selectedGameIndex:-1
    property string selectedGameTitle: selectedGameIndex<0?"":gamesRepeater.itemAt(selectedGameIndex).title
    property string selectedGameDbName: selectedGameIndex<0?"":gamesModel.get(selectedGameIndex).dbName

    property bool small: width<units.gu(85)

    XmlListModel {
        id: gamesModel
        source: "data/games.xml"
        query: "/games/game"
        XmlRole { name: "title";   query: "title/string()"}
        XmlRole { name: "path";    query: "path/string()"}
        XmlRole { name: "dbName";    query: "db-name/string()"}
        XmlRole { name: "rules";    query: "rules/string()"}
        XmlRole { name: "info";    query: "info/string()"}
    }

    Component.onCompleted: {
        print("Select language: "+Qt.locale().name.substring(0,2))
        gamesModelTranslation.source = "data/games_"+Qt.locale().name.substring(0,2)+".xml"
        i18n.bindtextdomain(i18n.domain, "share/locale")

        print("Set colors")
        Theme.palette.normal.foreground = headerColor
        Theme.palette.normal.background = backgroundColor
    }

    XmlListModel {
        id: gamesModelTranslation
        query: "/games/game"
        XmlRole { name: "title";   query: "title/string()"}
        XmlRole { name: "path";    query: "path/string()"}
        XmlRole { name: "dbName";    query: "db-name/string()"}
        XmlRole { name: "rules";    query: "rules/string()"}
        XmlRole { name: "info";    query: "info/string()"}
        function getIdByDbName(dbName) {
            for(var index=0; index<gamesModelTranslation.count; index++) {
                if(gamesModelTranslation.get(index)["dbName"]===dbName)
                    return index
            }
            return -1
        }
    }

    PageStack {
        id: pagestack
        GamesPage {
            id: gamesPage
        }
        Component.onCompleted: push(gamesPage)
    }

    Repeater {
        id: gamesRepeater
        model: gamesModel
        delegate: Item {
            property int languageId: gamesModelTranslation.getIdByDbName(dbName)
            property string title: languageId!==-1 && gamesModelTranslation.get(languageId)["title"]?gamesModelTranslation.get(languageId)["title"]:gamesModel.get(index)["title"]
            property string rules: languageId!==-1 && gamesModelTranslation.get(languageId)["rules"]?gamesModelTranslation.get(languageId)["rules"]:gamesModel.get(index)["rules"]
            property string info: languageId!==-1 && gamesModelTranslation.get(languageId)["info"]?gamesModelTranslation.get(languageId)["info"]:gamesModel.get(index)["info"]
            Component.onCompleted: {
                print("Try "+dbName)
                initDbForGame(dbName)
            }
        }
    }

    function newGame() {    //FIXME
        tabs.selectedTabIndex=0
        if(gamePage.loader.item)
            gamePage.loader.item.preEnd(false)
        gamePage.setSource("")
        selectedGameIndex = -1
    }

    function startGame(index) {
        var previousGameIndex = selectedGameIndex
        selectedGameIndex = index
        print("startGame: "+selectedGameDbName)
        pagestack.push(Qt.resolvedUrl("layout/GamePage.qml"), {gameName: selectedGameTitle})
        // if(gamePage.loader.item) {   //FIXME
        //     if(index===previousGameIndex) {
        //         tabs.selectedTabIndex = 1
        //         return
        //     }
        //     else
        //         gamePage.loader.item.preEnd(true)
        // }
        var savedGame = getSaveState(selectedGameDbName)
        var savedGameIndex = getSaveStateIndex(selectedGameDbName)
        var savedSeed = getSaveStateSeed(selectedGameDbName)
        pagestack.currentPage.setSource(Qt.resolvedUrl("games/"+gamesModel.get(selectedGameIndex)["path"]), {"savedGame":savedGame, "savedGameIndex": savedGameIndex, "savedSeed": savedSeed})
    }

    function restartGame() {
        pagestack.currentPage.loader.item.init([], 0, pagestack.currentPage.loader.item.gameSeed)
    }

    function redealGame() {
        pagestack.currentPage.loader.item.init([], 0, -1)
    }

    function setStats(dbName, won) {
        initDbForGame(dbName)
        var tempContents = {};
        tempContents = statsDoc.contents
        if(won) {
            tempContents[dbName]["won"]++
        }
        else {
            tempContents[dbName]["lost"]++
        }
        statsDoc.contents = tempContents
    }

    function getStats(dbName) {
        return statsDoc.contents[dbName]
    }

    function removeSaveState(dbName) {
        print("removeSaveState")
        setSaveState(dbName, [], 0, -1)
    }

    function setSaveState(dbName, json, index, savedSeed) {
        print("setSaveState:"+dbName+" "+index+" "+savedSeed)
        var tmpContents = {};
        tmpContents = savesDoc.contents
        tmpContents[dbName]["saveState"] = json
        tmpContents[dbName]["savedHistoryIndex"] = index
        tmpContents[dbName]["savedSeed"] = savedSeed
        savesDoc.contents = tmpContents
    }

    function getSaveState(dbName) {
        return savesDoc.contents[dbName]["saveState"]
    }

    function getSaveStateIndex(dbName) {
        print("getSaveStateIndex::"+savesDoc.contents[dbName]["savedHistoryIndex"])
        return savesDoc.contents[dbName]["savedHistoryIndex"]
    }

    function getSaveStateSeed(dbName) {
        print("getSaveStateSeed::"+savesDoc.contents[dbName]["savedSeed"])
        return savesDoc.contents[dbName]["savedSeed"]
    }


    function initDbForGame(dbName) {
        print("initDbForGame: "+dbName)
        var tempStats = {};
        if(statsDoc.contents) {
            tempStats = statsDoc.contents
        }

        if(!tempStats[dbName]) {
            tempStats[dbName] = {}
            tempStats[dbName]["won"] = 0
            tempStats[dbName]["lost"] = 0
        }

        statsDoc.contents = tempStats

        var tempSaves = {}
        if(savesDoc.contents) {
            tempSaves = savesDoc.contents
        }

        if(!tempSaves[dbName]) {
            tempSaves[dbName] = {}
            tempSaves[dbName]["saveState"] = []
            tempSaves[dbName]["savedHistoryIndex"] = 0
            tempSaves[dbName]["savedSeed"] = -1
        }

        savesDoc.contents = tempSaves
    }

    U1db.Database {
        id: mainDb
        path: "solitaire-games.db"
    }

    U1db.Document {
        id: statsDoc
        database: mainDb
        docId: 'stats'
        create: true
        defaults: {}
    }

    U1db.Document {
        id: savesDoc
        database: mainDb
        docId: 'saveStates'
        create: true
        defaults: {}
    }
}
