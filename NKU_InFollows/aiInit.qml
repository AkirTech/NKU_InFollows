import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Shapes
import QtQuick.Layouts

Rectangle {
    id: mainrect
    anchors.fill: parent
    anchors.margins: 30
    anchors.horizontalCenter: parent.horizontalCenter
    color: "transparent"
    
    ColumnLayout {
        id: mainLayout
        anchors.fill: parent
        spacing: 20
        
        Text {
            text: "AI 配置"
            font.pointSize: 24
            font.weight: Font.Bold
            color: "#ffffff"
            Layout.alignment: Qt.AlignLeft
        }
        
        Text {
            text: "配置 AI 模型连接设置"
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
                Layout.preferredWidth: 450
                Layout.preferredHeight: 120
                radius: 12
                color: "#2d2d2d"
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 15
                    
                    Text {
                        text: "模式"
                        font.pointSize: 14
                        font.weight: Font.Medium
                        color: "#cccccc"
                        Layout.alignment: Qt.AlignLeft
                    }
                    
                    RowLayout {
                        spacing: 20
                        
                        CheckBox {
                            id: mode_checkbox
                            text: "Ollama (本地)"
                            checked: !mode_checkbox2.checked
                        }
                        
                        CheckBox {
                            id: mode_checkbox2
                            text: "OpenAI API"
                            checked: !mode_checkbox.checked
                        }
                    }
                }
            }
            
            Rectangle {
                Layout.preferredWidth: 450
                Layout.preferredHeight: 80
                radius: 12
                color: "#2d2d2d"
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 10
                    
                    Text {
                        text: "API URL"
                        font.pointSize: 14
                        font.weight: Font.Medium
                        color: "#cccccc"
                        Layout.alignment: Qt.AlignLeft
                    }
                    
                    TextField {
                        id: api_url_field
                        Layout.fillWidth: true
                        font.pointSize: 12
                        placeholderText: mode_checkbox.checked ? "http://localhost:11434/v1" : "输入 OpenAI API 地址"
                        echoMode: TextInput.Normal
                        color: "#ffffff"
                        background: Rectangle { color: "#1e1e1e"; radius: 4 }
                    }
                }
            }
            
            Rectangle {
                Layout.preferredWidth: 450
                Layout.preferredHeight: 80
                radius: 12
                color: "#2d2d2d"
                visible: mode_checkbox2.checked
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 10
                    
                    Text {
                        text: "API Key"
                        font.pointSize: 14
                        font.weight: Font.Medium
                        color: "#cccccc"
                        Layout.alignment: Qt.AlignLeft
                    }
                    
                    TextField {
                        id: api_key_field
                        Layout.fillWidth: true
                        font.pointSize: 12
                        placeholderText: "输入 API Key"
                        echoMode: TextInput.Password
                        color: "#ffffff"
                        background: Rectangle { color: "#1e1e1e"; radius: 4 }
                    }
                }
            }
            
            Rectangle {
                Layout.preferredWidth: 450
                Layout.preferredHeight: 80
                radius: 12
                color: "#2d2d2d"
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 10
                    
                    Text {
                        text: "模型名称"
                        font.pointSize: 14
                        font.weight: Font.Medium
                        color: "#cccccc"
                        Layout.alignment: Qt.AlignLeft
                    }
                    
                    TextField {
                        id: ai_modelinput
                        Layout.fillWidth: true
                        font.pointSize: 12
                        placeholderText: "例如: gpt-3.5-turbo"
                        color: "#ffffff"
                        background: Rectangle { color: "#1e1e1e"; radius: 4 }
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
                id: nextButton
                width: 100
                height: 40
                
                baseColor: "#2196f3"
                bordercolor: "#2196f3"
                textColor: "#ffffff"
                textPointSize: 14
                text: "下一步"
                
                onClicked: {
                    try {
                        maincfg.set("ai.mode", mode_checkbox.checked ? "ollama" : "openai")
                        maincfg.set("ai.url", api_url_field.text === "" ? "http://localhost:11434/v1" : api_url_field.text)
                        maincfg.set("ai.model", ai_modelinput.text)
                        if (mode_checkbox2.checked) {
                            maincfg.set("ai.api_key", api_key_field.text)
                        }
                    } catch (e) {
                        console.log(e)
                    }
                    stackView.push("OnboardSetup.qml")
                }
            }
        }
    }
}