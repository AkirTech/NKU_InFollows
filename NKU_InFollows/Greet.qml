import QtQuick 
import QtQuick.Window 
import QtQuick.Controls 
import QtQuick.Layouts 
import QtQuick.Effects
import QtQuick.Controls.Material

Rectangle {
    id: mainrect
    width: 410
    height: 300
    radius: 20
    anchors.top:parent.top
    anchors.horizontalCenter:parent.horizontalCenter
    anchors.margins: 40
    Text {
        anchors.top: parent.top
        anchors.topMargin: 100
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 20
        color: "#ffffff"
        horizontalAlignment: Text.AlignHCenter 
        font.letterSpacing: 5
        text: "\\(@^0^@)/\nNKU_InFollows!"
    }
    gradient: Gradient {
            GradientStop { position: 0.0; color: "#6ea3f2" }
            GradientStop { position: 1.0; color: "#2e6bd1" }
    }
    
    
}