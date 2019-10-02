import QtQuick 2.9
import Ubuntu.Components 1.3
//import Ubuntu.Components.ListItems 0.1 as ListItem

Page {
    id: page

    ListView {
        id: listView
        anchors.fill: parent
        model: gamesModel
        delegate: statsDelegate
    }

    Component {
        id: statsDelegate

        Column {
            property int nrWins: getStats(dbName)["won"]
            property int nrLost: getStats(dbName)["lost"]
            property bool _visible: nrWins>0 || nrLost>0
            width: parent.width

            ListItem {
            Label {
                text: gamesRepeater.itemAt(index).title
                }
                width: parent.width
                visible: _visible
            }

            ListItem {
            Label {
                text: i18n.tr("%1 win","%1 wins",nrWins).arg(nrWins)
                }
                visible: _visible
            }

            ListItem {
            Label {
                text: i18n.tr("%1 los","%1 losses",nrLost).arg(nrLost)
                }
                visible: _visible
            }
        }
    }
}
