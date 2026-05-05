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
    title: "NKU_InFollows-公众号管理"
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
            try {
                if (selectedIndex >= 0 && selectedIndex < mp_sources.count) {
                    var name = mp_sources.get(selectedIndex).name
                    mp_sources.remove(selectedIndex)
                    saveData()
                }
            } catch (e) {
                console.error("删除错误:", e)
            }
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
        height: 400
        modal: true
        focus: true
        
        property bool isSearching: false
        property bool hasSearched: false
        property var searchResult: null
        property string foundNickname: ""
        property string foundSignature: ""
        property string foundId: ""
        property string foundCover: ""
        property string foundRawId: ""
        
        onOpened: {
            addNameField.text = ""
            addMpDialog.searchResult = null
            addMpDialog.foundNickname = ""
            addMpDialog.foundSignature = ""
            addMpDialog.foundId = ""
            addMpDialog.foundCover = ""
            addMpDialog.foundRawId = ""
            addMpDialog.hasSearched = false
            addMpDialog.isSearching = false
            searchStatus.text = ""
            previewInfo.visible = false
            confirmButton.visible = false
        }
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15
            
            TextField {
                id: addNameField
                Layout.fillWidth: true
                placeholderText: "公众号名称"
                color: "#ffffff"
                background: Rectangle { color: "#2d2d2d"; radius: 4 }
            }
            
            Button {
                text: "搜索"
                Layout.fillWidth: true
                enabled: !addMpDialog.isSearching && addNameField.text.length > 0
                
                onClicked: {
                    try {
                        addMpDialog.isSearching = true
                        searchStatus.text = "正在搜索...（若长时间无响应请重新登录微信公众平台）"
                        previewInfo.visible = false
                        confirmButton.visible = false
                        
                        console.log("搜索公众号:", addNameField.text)
                        console.log("mptoken:", mptoken)
                        
                        var mpUrl = "http://localhost:8001/api/v1/wx/mps/search"
                        var searchUrl = mpUrl
                        console.log("Search URL (base):", searchUrl)
                        
                        var result = webParser.getMPSearchRq(addNameField.text, searchUrl, mptoken)
                        console.log("Search result:", result)
                        
                        if (result && Object.keys(result).length > 0) {
                            addMpDialog.searchResult = result
                            addMpDialog.foundNickname = mpSourceParser.getNickname(result)
                            addMpDialog.foundSignature = mpSourceParser.getDescription(result)
                            addMpDialog.foundId = mpSourceParser.getRealID(result)
                            addMpDialog.foundCover = mpSourceParser.getAvatar(result)
                            addMpDialog.foundRawId = mpSourceParser.getRawID(result)
                            
                            if (addMpDialog.foundSignature.length > 40) {
                                addMpDialog.foundSignature = addMpDialog.foundSignature.substring(0, 40) + "..."
                            }
                            
                            previewNickname.text = "公众号: " + addMpDialog.foundNickname
                            previewSignature.text = "简介: " + addMpDialog.foundSignature
                            
                            searchStatus.text = "搜索成功！"
                            previewInfo.visible = true
                            confirmButton.visible = true
                            addMpDialog.hasSearched = true
                        } else {
                            searchStatus.text = "未找到匹配的公众号"
                        }
                    } catch (e) {
                        console.error("搜索错误:", e)
                        searchStatus.text = "搜索出错，请稍后重试"
                    } finally {
                        addMpDialog.isSearching = false
                    }
                }
            }
            
            Text {
                id: searchStatus
                text: ""
                color: "#aaaaaa"
                font.pointSize: 10
                Layout.alignment: Qt.AlignCenter
            }
            
            ColumnLayout {
                id: previewInfo
                visible: false
                Layout.fillWidth: true
                spacing: 10
                
                Rectangle {
                    Layout.fillWidth: true
                    height: 80
                    radius: 8
                    color: "#2d2d2d"
                    
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8
                        
                        Text {
                            id: previewNickname
                            text: ""
                            color: "#ffffff"
                            font.weight: Font.Bold
                            Layout.fillWidth: true
                        }
                        
                        Text {
                            id: previewSignature
                            text: ""
                            color: "#aaaaaa"
                            font.pointSize: 10
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                        }
                    }
                }
            }
            
            RowLayout {
                Layout.alignment: Qt.AlignRight
                spacing: 10
                
                Button {
                    text: "取消"
                    onClicked: {
                        addNameField.text = ""
                        addMpDialog.searchResult = null
                        addMpDialog.foundNickname = ""
                        addMpDialog.foundSignature = ""
                        addMpDialog.foundId = ""
                        addMpDialog.hasSearched = false
                        addMpDialog.isSearching = false
                        searchStatus.text = ""
                        previewInfo.visible = false
                        confirmButton.visible = false
                        addMpDialog.close()
                    }
                }
                
                Button {
                    id: confirmButton
                    text: "确认添加"
                    visible: false
                    enabled: addMpDialog.hasSearched
                    
                    onClicked: {
                        if (addMpDialog.foundNickname === "" || addMpDialog.foundId === "") {
                            searchStatus.text = "请先搜索公众号"
                            return
                        }
                        
                        try {
                            var mpUrl = "http://localhost:8001"
                            var result = webParser.addMP(mpUrl, mptoken, addMpDialog.foundNickname, addMpDialog.foundCover, addMpDialog.foundRawId, addMpDialog.foundSignature)
                            console.log("Add MP result:", result)
                            
                            if (result.startsWith("SUCCESS")) {
                                mp_sources.append({
                                    name: addMpDialog.foundNickname,
                                    id: addMpDialog.foundId
                                })
                                saveData()
                                searchStatus.text = "添加成功！"
                                
                                addNameField.text = ""
                                addMpDialog.searchResult = null
                                addMpDialog.foundNickname = ""
                                addMpDialog.foundSignature = ""
                                addMpDialog.foundId = ""
                                addMpDialog.foundCover = ""
                                addMpDialog.foundRawId = ""
                                addMpDialog.hasSearched = false
                                previewInfo.visible = false
                                confirmButton.visible = false
                                
                                addMpDialog.close()
                            } else {
                                searchStatus.text = "添加失败: " + result
                            }
                        } catch (e) {
                            console.error("Add MP error:", e)
                            searchStatus.text = "添加出错，请稍后重试"
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
        modal: true
        focus: true
        
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
                        try {
                            if (editNameField.text !== "" && editIdField.text !== "" && selectedIndex >= 0 && selectedIndex < mp_sources.count) {
                                mp_sources.setProperty(selectedIndex, "name", editNameField.text)
                                mp_sources.setProperty(selectedIndex, "id", editIdField.text)
                                saveData()
                                editMpDialog.close()
                            }
                        } catch (e) {
                            console.error("保存错误:", e)
                        }
                    }
                }
            }
        }
        
        onOpened: {
            if (selectedIndex >= 0 && selectedIndex < mp_sources.count) {
                editNameField.text = mp_sources.get(selectedIndex).name
                editIdField.text = mp_sources.get(selectedIndex).id
            }
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
