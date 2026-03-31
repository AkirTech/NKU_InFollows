// 例如，创建一个自定义样式的按钮组件 RoundedButton.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Controls.Material

Button {
    id: control
    // 可以暴露一些可定制的属性

    property url iconSource: ""               // 图标文件路径 (SVG/PNG等)
    property int iconWidth: 24                 // 图标显示宽度
    property int iconHeight: 24                // 图标显示高度
    property int iconSpacing: 8                 // 图标与文字的间距
    // 可选：图标位置（"left" / "right" / "top" / "bottom"），默认为左侧
    property string iconPosition: "left"
    
    property int textLeftMargin : 10
    property int textRightMargin : 10
    property int radius: 15

    property color baseColor: "#FFFFFF"
    property color bordercolor: "transparent"
    property color textColor: "#b9f6ca"
    property color guideColor: "#4c6ef5"
    property color hoverColor: "#f0f8ff"
    property color pressedColor: "#e6f2ff"
    property int textPointSize: 20
    property bool enableShadow: true
    // Fontsize
    background: Rectangle {
        id: mainBg
        width: control.width
        height: control.height
        
        color: control.pressed ? control.pressedColor : (control.hovered ? control.hoverColor : control.baseColor)
        
        radius: control.radius
        
        layer.enabled: control.enableShadow
        layer.effect: MultiEffect {
            shadowEnabled: control.enableShadow
            shadowColor: "#30000000"
            shadowBlur: 0.4
            shadowVerticalOffset: 3
            shadowHorizontalOffset: 0
            autoPaddingEnabled: true
        }
        
        Rectangle {
            id: borderRect
            anchors.fill: parent
            radius: control.radius
            color: "transparent"
            border.width: 2
            border.color: control.bordercolor
            
            Rectangle {
                anchors.fill: parent
                radius: control.radius
                color: "transparent"
                border.width: 2
                border.color: "transparent"
                /*Rectangle {
                    width: parent.width
                    height: 2
                    anchors.top: parent.top
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: control.guideColor }
                        GradientStop { position: 1.0; color: control.bordercolor }
                    }
                }
                Rectangle {
                    width: 2
                    height: parent.height
                    anchors.left: parent.left
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: control.guideColor }
                        GradientStop { position: 1.0; color: control.bordercolor }
                    }
                }
                Rectangle {
                    width: 2
                    height: parent.height
                    anchors.right: parent.right
                    color: control.bordercolor
                }
                Rectangle {
                    width: parent.width
                    height: 2
                    anchors.bottom: parent.bottom
                    color: control.bordercolor
                } */
            }
        }
        
        Rectangle {
            id: glowEffect
            anchors.fill: parent
            radius: control.radius
            color: control.guideColor
            opacity: control.hovered ? 0.1 : 0.0
            
            Behavior on opacity {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }
    
    contentItem: 
     Item {
    // 让内容项自动撑满按钮
    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    Row {
        id: row
        anchors.centerIn: parent
        spacing: control.iconSpacing
        // 通过 LayoutMirroring 实现图标在右
        LayoutMirroring.enabled: control.iconPosition === "right"
        LayoutMirroring.childrenInherit: true

        Image {
            source: control.iconSource
            sourceSize.width: control.iconWidth
            sourceSize.height: control.iconHeight
            width: control.iconWidth
            height: control.iconHeight
            fillMode: Image.PreserveAspectFit
            visible: source.toString() !== ""   // 无图标时隐藏
        }

        Text {
            text: control.text
            color: control.textColor
            anchors.top : parent.top
            anchors.topMargin: 8                // 上边距!!!!!
           // anchors.bottomMargin:control.textRightMargin
            //anchors.leftMargin: control.textLeftMargin
            //anchors.rightMargin: control.textLeftMargin
            font.pointSize: control.textPointSize
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            opacity: control.pressed ? 0.5 : 0.8
        }
    }
}
    
}