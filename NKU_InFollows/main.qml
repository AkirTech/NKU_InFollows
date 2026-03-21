import QtQuick 
import QtQuick.Window 
import QtQuick.Controls 
import QtQuick.Layouts 
import QtQuick.Controls.Material

ApplicationWindow {
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
        anchors.bottomMargin: 10
        
        textPointSize: 25
        text: "Next"
        onClicked: {
            stackView.push("Collect1.qml")
        }

    }
    MyButton { 
        id : buttonback
        width:160
        height:40
        anchors.horizontalCenterOffset: -200
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        textPointSize: 25
        text: "Back"
        onClicked: {
            stackView.pop()
        }

    }
}
