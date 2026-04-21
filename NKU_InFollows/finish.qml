import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import QtQuick.Controls.Material
import QtQuick.Dialogs
ApplicationWindow {
    id: finishWindow
    Material.theme: Material.Dark
    Material.accent: Material.Purple
    visible: true
    width: 986
    height: 768
    title: "NKU_InFollows"
    color: "#121212"
    Rectangle {
        id:mainrect
        width: 640
        height: 400
        anchors.top : parent.top
    
        anchors.horizontalCenter:parent.horizontalCenter
        anchors.topMargin: 30
        color: "transparent"

         MessageDialog {
                id: confirmDialog
            
                title: "打开Github页面？"
                text: "即将在Github打开本项目，是否继续？"
                buttons: MessageDialog.Ok | MessageDialog.Cancel
                // 当用户点击按钮时触发
                onAccepted: {
                    // 2. 用户点击“确定”后，打开网页
                    Qt.openUrlExternally("https://github.com/AkirTech/NKU_InFollows")
                }
                onRejected: {
                    // 可选：用户点击取消时的处理，比如关闭对话框或不做任何事
                    console.log("用户取消了操作")
                }
            }


        Column {
            anchors.centerIn: parent
            spacing: 20
        
            Image {
                id: iconImage
                source: "NKU_InFollows_icon.png"
                width: 120
                height: 120
                visible: false
                anchors.horizontalCenter: parent.horizontalCenter
            
            
            }
        
            Text {
                text: "NKU_InFlows"
                font.family: "Consolas"
                font.pixelSize: 28
                color: Material.foreground
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    
        Row {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 30
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20
        
            Button {
                text: "设置"
                onClicked: {
                    // 打开设置页面
                }
            }
        
            Button {
                text: "关于"
                onClicked: {
                    // 打开about页面
                
                     confirmDialog.open() // 打开确认对话框
                }
            }
        }



    }

}