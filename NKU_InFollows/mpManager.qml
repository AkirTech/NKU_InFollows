import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import QtQuick.Dialogs

Window {
    id: mpManagerWindow
    width: 986
    height: 768
    title: "公众号管理"
    visible: false
    Material.theme: Material.Dark
    Material.accent: Material.Purple
    color: "#121212"
    
    property string dataFilePath: "bizs.json"
    
    ListModel {
        id: mp_sources
    }
    
    MessageDialog {
        id: confirmDialog
        title: "确认删除"
        text: "确定要删除这个公众号吗？"
        buttons: MessageDialog.Ok | MessageDialog.Cancel
        
        onAccepted: {
            var name = mp_sources.get(selectedIndex).name
            mp_sources.remove(selectedIndex)
            saveData()
        }
    }
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 30
        spacing: 20
        
        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft
            
            Text {
                text: "公众号列表"
                font.pointSize: 24
                font.weight: Font.Bold
                color: "#ffffff"
                Layout.alignment: Qt.AlignLeft
            }
            
            Item {
                Layout.fillWidth: true
            }
            
            Button {
                text: "添加公众号"
                Layout.preferredWidth: 120
                onClicked: {
                    addMpDialog.open()
                }
            }
        }
        
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: "#333333"
        }
        
        ListView {
            id: mpListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: mp_sources
            spacing: 10
            clip: true
            
            delegate: Rectangle {
                width: mpListView.width
                height: 80
                radius: 10
                color: "#1e1e1e"
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15
                    
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
                            text: model.name
                            font.pointSize: 16
                            font.weight: Font.Bold
                            color: "#ffffff"
                            Layout.fillWidth: true
                        }
                        
                        Text {
                            text: model.id
                            font.pointSize: 12
                            color: "#aaaaaa"
                            Layout.fillWidth: true
                        }
                    }
                    
                    RowLayout {
                        spacing: 10
                        
                        Button {
                            text: "编辑"
                            Layout.preferredWidth: 60
                            onClicked: {
                                mpManagerWindow.selectedIndex = index
                                editMpDialog.open()
                            }
                        }
                        
                        Button {
                            text: "删除"
                            Layout.preferredWidth: 60
                            Material.accent: "#ff5252"
                            onClicked: {
                                mpManagerWindow.selectedIndex = index
                                confirmDialog.open()
                            }
                        }
                    }
                }
            }
        }
    }
    
    Dialog {
        id: addMpDialog
        title: "添加公众号"
        width: 400
        height: 300
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20
            
            TextField {
                id: addNameField
                Layout.fillWidth: true
                placeholderText: "公众号名称"
                color: "#ffffff"
                background: Rectangle { color: "#2d2d2d"; radius: 4 }
            }
            
            TextField {
                id: addIdField
                Layout.fillWidth: true
                placeholderText: "ID"
                color: "#ffffff"
                background: Rectangle { color: "#2d2d2d"; radius: 4 }
            }
            
            RowLayout {
                Layout.alignment: Qt.AlignRight
                spacing: 10
                
                Button {
                    text: "取消"
                    onClicked: {
                        addMpDialog.close()
                    }
                }
                
                Button {
                    text: "添加"
                    onClicked: {
                        if (addNameField.text !== "" && addIdField.text !== "") {
                            mp_sources.append({
                                name: addNameField.text,
                                id: addIdField.text
                            })
                            saveData()
                            addMpDialog.close()
                            addNameField.text = ""
                            addIdField.text = ""
                        }
                    }
                }
            }
        }
    }
    
    Dialog {
        id: editMpDialog
        title: "编辑公众号"
        width: 400
        height: 300
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20
            
            TextField {
                id: editNameField
                Layout.fillWidth: true
                placeholderText: "公众号名称"
                color: "#ffffff"
                background: Rectangle { color: "#2d2d2d"; radius: 4 }
            }
            
            TextField {
                id: editIdField
                Layout.fillWidth: true
                placeholderText: "ID"
                color: "#ffffff"
                background: Rectangle { color: "#2d2d2d"; radius: 4 }
            }
            
            RowLayout {
                Layout.alignment: Qt.AlignRight
                spacing: 10
                
                Button {
                    text: "取消"
                    onClicked: {
                        editMpDialog.close()
                    }
                }
                
                Button {
                    text: "保存"
                    onClicked: {
                        if (editNameField.text !== "" && editIdField.text !== "") {
                            mp_sources.setProperty(selectedIndex, "name", editNameField.text)
                            mp_sources.setProperty(selectedIndex, "id", editIdField.text)
                            saveData()
                            editMpDialog.close()
                        }
                    }
                }
            }
        }
        
        onOpened: {
            editNameField.text = mp_sources.get(selectedIndex).name
            editIdField.text = mp_sources.get(selectedIndex).id
        }
    }
    
    property int selectedIndex: -1
    
    function saveData() {
        var obj = {}
        for (var i = 0; i < mp_sources.count; i++) {
            var item = mp_sources.get(i)
            obj[item.name] = item.id
        }
        FileIO.save(JSON.stringify(obj), dataFilePath)
    }
    
    function loadData() {
        var jsonString = FileIO.loadAsString(dataFilePath)
        if (jsonString) {
            try {
                var obj = JSON.parse(jsonString)
                mp_sources.clear()
                for (var key in obj) {
                    mp_sources.append({ name: key, id: obj[key] })
                }
            } catch (e) {
                console.error("Failed to parse bizs.json:", e)
            }
        } else {
            mp_sources.append({ name: "测试公众号", id: "123456098" })
            mp_sources.append({ name: "示例公众号", id: "46457235" })
            saveData()
        }
    }
    
    Component.onCompleted: {
        loadData()
    }
}
