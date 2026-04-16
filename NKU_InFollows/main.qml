import QtQuick 
import QtQuick.Window 
import QtQuick.Controls 
import QtQuick.Layouts 
import QtQuick.Controls.Material

ApplicationWindow {

    id: mainWindow
    Material.theme: Material.Dark
    Material.accent: Material.Purple
    visible: true
    width: 768
    height: 512
    title: "NKU_InFollows"
    color: "#121212"
    StackView {
        id : stackView
        anchors.fill: parent
        initialItem: "Eula.qml"
    }

}
