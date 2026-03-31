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
    radius: 20
    anchors.top:parent.top
    anchors.horizontalCenter:parent.horizontalCenter
    anchors.margins: 40
    
    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: "#40000000"
        shadowBlur: 0.6
        shadowVerticalOffset: 8
    }
    
    gradient: Gradient {
        GradientStop { 
            position: 0.0; 
            color: "#667eea" 
        }
        GradientStop { 
            position: 0.5; 
            color: "#764ba2" 
        }
        GradientStop { 
            position: 1.0; 
            color: "#f093fb" 
        }
    }
    
    Rectangle {
        id: decorativeCircle1
        width: 150
        height: 150
        radius: width / 2
        color: "#ffffff"
        opacity: 0.1
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: -50
        anchors.rightMargin: -50
        
        SequentialAnimation {
            running: true
            loops: Animation.Infinite
            NumberAnimation {
                target: decorativeCircle1
                property: "scale"
                from: 1.0
                to: 1.2
                duration: 3000
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: decorativeCircle1
                property: "scale"
                from: 1.2
                to: 1.0
                duration: 3000
                easing.type: Easing.InOutQuad
            }
        }
    }
    
    Rectangle {
        id: decorativeCircle2
        width: 100
        height: 100
        radius: width / 2
        color: "#ffffff"
        opacity: 0.08
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.bottomMargin: -30
        anchors.leftMargin: -30
        
        SequentialAnimation {
            running: true
            loops: Animation.Infinite
            NumberAnimation {
                target: decorativeCircle2
                property: "scale"
                from: 1.0
                to: 1.3
                duration: 4000
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: decorativeCircle2
                property: "scale"
                from: 1.3
                to: 1.0
                duration: 4000
                easing.type: Easing.InOutQuad
            }
        }
    }
    
    Text {
        id: emojiText
        anchors.top: parent.top
        anchors.topMargin: 70
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 36
        color: "#ffffff"
        horizontalAlignment: Text.AlignHCenter
        text: "👋"
        
        SequentialAnimation {
            id: emojiAnimation
            running: true
            loops: Animation.Infinite
            
            NumberAnimation {
                target: emojiText
                property: "scale"
                from: 1.0
                to: 1.2
                duration: 800
                easing.type: Easing.OutBack
            }
            NumberAnimation {
                target: emojiText
                property: "scale"
                from: 1.2
                to: 1.0
                duration: 800
                easing.type: Easing.InBack
            }
            PauseAnimation {
                duration: 2000
            }
        }
    }
    
    Text {
        id:greettext
        anchors.top: emojiText.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 28
        font.family: "Segoe UI"
        font.weight: Font.Bold
        color: "#ffffff"
        horizontalAlignment: Text.AlignHCenter 
        font.letterSpacing: 2
        text: "NKU_InFollows"
        
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "#80000000"
            shadowBlur: 0.3
        }

        NumberAnimation {
            target: greettext
            property: "opacity"
            from: 0.0
            to: 1.0
            duration: 3000
            easing.type: Easing.InOutQuad
            loops: 1
            running: true
        }
    }
    
    Text {
        id: subtitleText
        anchors.top: greettext.bottom
        anchors.topMargin: 15
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 12
        font.family: "Segoe UI"
        color: "#ffffff"
        opacity: 0.8
        horizontalAlignment: Text.AlignHCenter
        text: "Welcome to NKU InFollows System"
        
        SequentialAnimation {
            running: true
            loops: Animation.Infinite
            
            NumberAnimation {
                target: subtitleText
                property: "opacity"
                from: 0.5
                to: 0.9
                duration: 2000
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: subtitleText
                property: "opacity"
                from: 0.9
                to: 0.5
                duration: 2000
                easing.type: Easing.InOutQuad
            }
        }
    }
}