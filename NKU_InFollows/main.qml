import QtQuick 
import QtQuick.Window 
import QtQuick.Controls 
import QtQuick.Layouts 
import QtQuick.Controls.Material

ApplicationWindow {

    property int currentIndex: 0
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
        initialItem: "Greet.qml"
    }

    MyButton { 
        id : buttonnext
        width:40
        height:40
        anchors.verticalCenter:parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 15
        
        baseColor: "#1e1e1e"
        bordercolor: "#424242"
        textColor: "#e0e0e0"
        guideColor: "#2196f3"
        textPointSize: 20
        text: ">"
        onClicked: {
            if (mainWindow.currentIndex === 0) {
                stackView.push("aiInit.qml");
                mainWindow.currentIndex  = mainWindow.currentIndex+1;
            } else if (mainWindow.currentIndex === 1) {
                maincfg.set("ai_mode", mode_checkbox.checked ? "ollama" : "openai");
                maincfg.set("api_url", api_url_field.text);
                if (mode_checkbox2.checked) { 
                    maincfg.set("api_key", api_key_field.text);
                }
                stackView.push("Collect1.qml");
                mainWindow.currentIndex = mainWindow.currentIndex+1;
            }
        }

    }
    MyButton { 
        id : buttonback
        width:40
        height:40
        visible: mainWindow.currentIndex > 0
        anchors.verticalCenter:parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 15
        
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
