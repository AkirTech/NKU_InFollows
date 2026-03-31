import QtQuick 
import QtQuick.Window 
import QtQuick.Controls 
import QtQuick.Layouts 
import QtQuick.Controls.Material

ApplicationWindow {

    property int currentIndex: 0
    id: mainWindow
    Material.theme: Material.Dark
    visible: true
    width: 768
    height: 512
    title: "NKU_InFollows"
    color: "#121212"
    StackView {
        id : stackView
        anchors.fill: parent
        initialItem: "Greet.qml"
    }

    MyButton { 
        id : buttonnext
        width:60
        height:40
        anchors.verticalCenter:parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 30
        
        baseColor: "#1e1e1e"
        bordercolor: "#424242"
        textColor: "#e0e0e0"
        guideColor: "#2196f3"
        textPointSize: 20
        text: ">"
        onClicked: {
            if (mainWindow.currentIndex === 0) {
                stackView.push("Collect1.qml");
                mainWindow.currentIndex  = 1;
            } else if (mainWindow.currentIndex === 1) {
                stackView.push("Settings.qml");
                mainWindow.currentIndex = 2;
            }
        }

    }
    MyButton { 
        id : buttonback
        width:60
        height:40
        visible: mainWindow.currentIndex > 0
        anchors.verticalCenter:parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 30
        
        baseColor: "#1e1e1e"
        bordercolor: "#424242"
        textColor: "#e0e0e0"
        guideColor: "#2196f3"
        textPointSize: 25
        text: "<"
        onClicked: {
            stackView.pop();
            mainWindow.currentIndex -=1;
        }

    }

}
