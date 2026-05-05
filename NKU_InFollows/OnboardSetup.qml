import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.Dialogs

Rectangle {
    id: mainrect
    anchors.fill: parent
    anchors.margins: 30
    anchors.horizontalCenter: parent.horizontalCenter
    color: "transparent"
    
    MessageDialog {
        id: confirmcloseDialog
        
        title: "完成设置"
        text: "软件即将重新启动以开始服务。"
        buttons: MessageDialog.Ok | MessageDialog.Cancel
        
        onAccepted: {
            maincfg.set("OOBE", "finish")
            maincfg.set("restart_flag", "pending")
            mainWindow.close()
        }
    }
    
    ColumnLayout {
        id: mainLayout
        anchors.fill: parent
        spacing: 20
        
        Text {
            text: "初始设置"
            font.pointSize: 24
            font.weight: Font.Bold
            color: "#ffffff"
            Layout.alignment: Qt.AlignLeft
        }
        
        Text {
            text: "请选择您需要配置的选项"
            font.pointSize: 14
            color: "#aaaaaa"
            Layout.alignment: Qt.AlignLeft
            Layout.bottomMargin: 10
        }
        
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: "#333333"
        }
        
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
        
        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            spacing: 20
            
            Rectangle {
                Layout.preferredWidth: 400
                Layout.preferredHeight: 80
                radius: 12
                color: "#2d2d2d"
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 20
                    
                    Rectangle {
                        width: 50
                        height: 50
                        radius: 8
                        color: Material.accent
                        
                        Text {
                            anchors.centerIn: parent
                            text: "📱"
                            font.pointSize: 24
                        }
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 5
                        
                        Text {
                            text: "公众号管理"
                            font.pointSize: 16
                            font.weight: Font.Medium
                            color: "#ffffff"
                        }
                        
                        Text {
                            text: "添加和管理您关注的公众号"
                            font.pointSize: 12
                            color: "#888888"
                        }
                    }
                    
                    Button {
                        text: "配置"
                        Layout.preferredWidth: 80
                        onClicked: {
                            openMpManager()
                        }
                    }
                }
            }
            
            Rectangle {
                Layout.preferredWidth: 400
                Layout.preferredHeight: 80
                radius: 12
                color: "#2d2d2d"
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 20
                    
                    Rectangle {
                        width: 50
                        height: 50
                        radius: 8
                        color: Material.accent
                        
                        Text {
                            anchors.centerIn: parent
                            text: "🏷️"
                            font.pointSize: 24
                        }
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 5
                        
                        Text {
                            text: "兴趣管理"
                            font.pointSize: 16
                            font.weight: Font.Medium
                            color: "#ffffff"
                        }
                        
                        Text {
                            text: "设置您感兴趣的标签"
                            font.pointSize: 12
                            color: "#888888"
                        }
                    }
                    
                    Button {
                        text: "配置"
                        Layout.preferredWidth: 80
                        onClicked: {
                            openInterestManager()
                        }
                    }
                }
            }
        }
        
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
        
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: "#333333"
        }
        
        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignRight
            spacing: 15
            
            MyButton {
                id: backButton
                width: 100
                height: 40
                
                baseColor: "#1e1e1e"
                bordercolor: "#424242"
                textColor: "#e0e0e0"
                textPointSize: 14
                text: "返回"
                
                onClicked: {
                    stackView.pop()
                }
            }
            
            MyButton {
                id: finishButton
                width: 100
                height: 40
                
                baseColor: "#2196f3"
                bordercolor: "#2196f3"
                textColor: "#ffffff"
                textPointSize: 14
                text: "完成"
                
                onClicked: {
                    confirmcloseDialog.open()
                }
            }
        }
    }
    
    property var mpManagerWindow: null
    property var interestManagerWindow: null
    
    function openMpManager() {
        if (!mpManagerWindow || mpManagerWindow === null) {
            var component = Qt.createComponent("mpManager.qml")
            if (component.status === Component.Ready) {
                mpManagerWindow = component.createObject(mainrect)
                mpManagerWindow.show()
            } else {
                console.error("Failed to load mpManager.qml:", component.errorString())
            }
        } else {
            mpManagerWindow.show()
        }
    }
    
    function openInterestManager() {
        if (!interestManagerWindow || interestManagerWindow === null) {
            var component = Qt.createComponent("interestManager.qml")
            if (component.status === Component.Ready) {
                interestManagerWindow = component.createObject(mainrect)
                interestManagerWindow.show()
            } else {
                console.error("Failed to load interestManager.qml:", component.errorString())
            }
        } else {
            interestManagerWindow.show()
        }
    }
}