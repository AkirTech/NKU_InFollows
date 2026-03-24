import QtQuick 
import QtQuick.Window 
import QtQuick.Controls 
import QtQuick.Layouts 
import QtQuick.Effects
import QtQuick.Controls.Material

Rectangle {
    id: mainrect
    width: 500
    height: 300
    radius: 10
    anchors.top:parent.top
    anchors.horizontalCenter:parent.horizontalCenter
    anchors.margins: 40
    Text {
        id:greettext
        anchors.top: parent.top
        anchors.topMargin: 100
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 20
        color: "#ffffff"
        horizontalAlignment: Text.AlignHCenter 
        font.letterSpacing: 5
        text: "\\(@^0^@)/\nNKU_InFollows!"

        SequentialAnimation {
            id: spacingAnimation
            loops: Animation.Infinite      // 无限循环
            running: true                  // 启动动画

            NumberAnimation {
                target: greettext
                property: "font.letterSpacing"
                from: 5
                to: 20
                duration: 2000
            }
            NumberAnimation {
                target: greettext
                property: "font.letterSpacing"
                from: 20
                to: 5
                duration: 2000
            }
        }
        
    }
    gradient: Gradient {
            GradientStop { id:gradstp0;position: 0.0; color: "#ffffff" 
                
            
            }
            GradientStop { id:gradstp1;position: 1.0; color: "#f1f8e9" }

    }
    
    
}