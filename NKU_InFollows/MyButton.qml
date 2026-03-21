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
    property color bordercolor: "#1098ad"
    property color textColor: bordercolor
    property color guideColor: "#4c6ef5"
    property int textPointSize: 20
    // Fontsize
    background: Rectangle {
        id:mainBg
        width:control.width
        height:control.height
        /*
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#6ea3f2" }
            GradientStop { position: 1.0; color: "#2e6bd1"}
        }
        */
        color: control.baseColor
        
        border.color: control.bordercolor
        border.width: 2
        
        radius: control.radius
        Rectangle {                         //左边矩形
            id:inBg
            width: 8
            height: parent.height -  mainBg.radius      // 边框厚度
            color: control.guideColor    // 边框颜色
            anchors.left:parent.left
            anchors.verticalCenter:parent.verticalCenter
            radius:3
        }
        /* MultiEffect {
        source: inBg
        anchors.fill: parent
        // 关键：启用自动内边距，防止阴影被父项裁剪
        autoPaddingEnabled: true 
        
        // 启用并配置阴影
        shadowEnabled: true
        shadowColor: "#80000000" // 半透明黑色 
        shadowBlur: 0.2          // 模糊程度 (0.0 - 1.0) 
        shadowHorizontalOffset: 2  // 水平偏移
        shadowVerticalOffset: 1    // 垂直偏移 [citation:10]
        // shadowOpacity: 0.8       // 也可以单独控制透明度
    }*/
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
        }
    }
}
    
}