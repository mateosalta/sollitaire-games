import QtQuick 2.9
import Ubuntu.Components 1.3

Item {
    anchors.fill: parent
    property bool loading: false
    Label {
        id: label
        anchors.centerIn: parent
        text: loading?i18n.tr("Loading..."):i18n.tr("Select a game to begin")
        fontSize: "x-large"
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.Wrap
    }
}
