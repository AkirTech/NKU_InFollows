import QtQuick 
import QtQuick.Window 
import QtQuick.Controls 
import QtQuick.Layouts 
import QtQuick.Controls.Material

ApplicationWindow {

    property int currentIndex: 0
    id: mainWindow
    Material.theme: Material.Dark
    Material.accent: "#66cc66"
    visible: true
    width: 640
    height: 480
    title: "NKU_InFollows"
    color: "#ffffff"
    StackView {
        id : stackView
        anchors.fill: parent
        initialItem: "Greet.qml"
    }

    MyButton { 
        id : buttonnext
        width:160
        height:40
        anchors.horizontalCenterOffset: 200
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        
        textPointSize: 20
        text: "Next ->"
        onClicked: {
            if (mainWindow.currentIndex === 0) {
                stackView.push("Collect1.qml")
                mainWindow.currentIndex = 1
            } else if (mainWindow.currentIndex === 1) {
                stackView.push("Settings.qml")
                mainWindow.currentIndex = 2
            }
        }

    }
    MyButton { 
        id : buttonback
        width:160
        height:40
        visible: mainWindow.currentIndex > 0
        anchors.horizontalCenterOffset: -200
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        textPointSize: 25
        text: "Back"
        onClicked: {
            stackView.pop();
            mainWindow.currentIndex -=1;
        }

    }

}
