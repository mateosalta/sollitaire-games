import QtQuick 2.9
import Ubuntu.Components 1.3

OutlineCard {
    property real ocap: 0.5
    property bool lighter: false
    UbuntuShape {
        anchors.fill: parent
        color: lighter?"green":"black"
        opacity: 0.5
    }
}
