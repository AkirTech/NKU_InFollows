import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import QtQuick.Dialogs

Window {
    id: interestManagerWindow
    width: 600
    height: 500
    title: "NKU_InFollows-兴趣管理"
    visible: false
    Material.theme: Material.Dark
    Material.accent: Material.Purple
    color: "#121212"
    
    property string dataFilePath: "u_interests.json"
    
    ListModel {
        id: interestsModel
    }
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 30
        spacing: 20
        
        RowLayout {
            Layout.fillWidth: true
            
            Text {
                text: "我的兴趣"
                font.pointSize: 24
                font.weight: Font.Bold
                color: "#ffffff"
            }
            
            Item {
                Layout.fillWidth: true
            }
            
            Button {
                text: "添加兴趣"
                Layout.preferredWidth: 100
                onClicked: {
                    addInterestDialog.open()
                }
            }
        }
        
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: "#333333"
        }
        
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            StackLayout {
                anchors.fill: parent
                
                Rectangle {
                    id: listContainer
                    anchors.fill: parent
                    radius: 10
                    color: "#1e1e1e"
                    border.color: "#333333"
                    border.width: 1
                    visible: interestsModel.count > 0
                    
                    ListView {
                        id: interestsListView
                        anchors.fill: parent
                        anchors.margins: 15
                        model: interestsModel
                        spacing: 10
                        clip: true
                        
                        delegate: Item {
                            width: interestsListView.width
                            height: 50
                            
                            Rectangle {
                                anchors.fill: parent
                                radius: 8
                                color: "#2d2d2d"
                                
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 15
                                    spacing: 15
                                    
                                    Text {
                                        text: model.text
                                        font.pointSize: 14
                                        color: "#ffffff"
                                        Layout.fillWidth: true
                                        Layout.alignment: Qt.AlignVCenter
                                    }
                                    
                                    Button {
                                        text: "删除"
                                        Layout.preferredWidth: 60
                                        Material.accent: "#ff5252"
                                        onClicked: {
                                            interestsModel.remove(index)
                                            saveData()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                Rectangle {
                    id: emptyContainer
                    anchors.fill: parent
                    radius: 10
                    color: "#1e1e1e"
                    border.color: "#333333"
                    border.width: 1
                    visible: interestsModel.count === 0
                    
                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 10
                        
                        Text {
                            text: "暂无兴趣标签"
                            color: "#757575"
                            font.pointSize: 16
                            Layout.alignment: Qt.AlignHCenter
                        }
                        
                        Text {
                            text: "点击上方按钮添加"
                            color: "#555555"
                            font.pointSize: 12
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }
            }
        }
        
        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignRight
            spacing: 15
            
            Button {
                text: "保存"
                Layout.preferredWidth: 80
                onClicked: {
                    saveData()
                }
            }
            
            Button {
                text: "关闭"
                Layout.preferredWidth: 80
                onClicked: {
                    interestManagerWindow.close()
                }
            }
        }
    }
    
    Dialog {
        id: addInterestDialog
        title: "添加兴趣"
        modal: true
        focus: true
        width: 380
        
        ColumnLayout {
            width: parent.width
            spacing: 20
            anchors.margins: 20
            
            TextField {
                id: interestInput
                Layout.fillWidth: true
                placeholderText: "请输入兴趣标签"
                color: "#ffffff"
                background: Rectangle { color: "#1e1e1e"; radius: 4 }
                
                onAccepted: {
                    addInterest()
                }
            }
            
            RowLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignRight
                spacing: 15
                
                Button {
                    text: "取消"
                    Layout.preferredWidth: 80
                    Layout.preferredHeight: 36
                    onClicked: {
                        addInterestDialog.close()
                    }
                }
                
                Button {
                    text: "添加"
                    Layout.preferredWidth: 80
                    Layout.preferredHeight: 36
                    onClicked: {
                        addInterest()
                    }
                }
            }
        }
        
        onOpened: {
            interestInput.text = ""
            interestInput.forceActiveFocus()
        }
    }
    
    function addInterest() {
        var text = interestInput.text.trim()
        if (text !== "") {
            interestsModel.append({ text: text })
            interestInput.text = ""
            addInterestDialog.close()
            saveData()
        }
    }
    
    function saveData() {
        var arr = []
        for (var i = 0; i < interestsModel.count; i++) {
            arr.push(interestsModel.get(i).text)
        }
        FileIO.save(JSON.stringify(arr), dataFilePath)
    }
    
    function loadData() {
        var jsonString = FileIO.loadAsString(dataFilePath)
        if (jsonString) {
            try {
                var arr = JSON.parse(jsonString)
                interestsModel.clear()
                for (var i = 0; i < arr.length; i++) {
                    interestsModel.append({ text: arr[i] })
                }
            } catch (e) {
                console.error("Failed to parse u_interests.json:", e)
            }
        } else {
            interestsModel.append({ text: "科技" })
            interestsModel.append({ text: "教育" })
            interestsModel.append({ text: "体育" })
            saveData()
        }
    }
    
    Component.onCompleted: {
        loadData()
    }
}