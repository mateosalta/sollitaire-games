import QtQuick 2.9

Rectangle {
    property int suit
    property int card
    property real suitSize: Math.min(face.width/2.5,face.height/4)

    id: face

    onCardChanged: {
        changeCard()
    }

    function changeCard() {
        if(card < 1 || card > 13) {
            faceLoader.source = ""
            return;
        }
        faceLoader.source = "faces/"+card+".qml"
    }

    function makeBingings() {
        if(faceLoader.item) {
            faceLoader.item.suit = Qt.binding(function() {return face.suit });
            faceLoader.item.suitSize = Qt.binding(function() {return face.suitSize });
            faceLoader.item.color = face.color
        }
    }

    Component.onCompleted: changeCard()

    Loader {
        id: faceLoader
        anchors.fill: parent
        onSourceChanged: {makeBingings()}
    }
}
