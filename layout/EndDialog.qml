import QtQuick 2.9
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

Dialog {
    property bool won: false
    id: endDialog
    title: won?i18n.tr("Won!"):i18n.tr("Lost...")
    text: won?i18n.tr("What's next?"):i18n.tr("... What's next?")
    Button {
        text: i18n.tr("Try again...")
        visible: !won
        onClicked: {
            PopupUtils.close(endDialog)
            restartGame()
        }
    }
    Button {
        text: i18n.tr("Play again!")
        visible: won
        onClicked: {
            PopupUtils.close(endDialog)
            redealGame()
        }
    }
    Button {
        text: i18n.tr("Back to game list")
        onClicked: {
            PopupUtils.close(endDialog)
            pagestack.pop()
        }
    }
}
