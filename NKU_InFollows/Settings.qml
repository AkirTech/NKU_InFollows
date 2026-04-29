import QtQuick 
import QtQuick.Window 
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

Window {
    id: root
    width: 1100
    height: 800
    title: "设置"
    visible: false
    Material.theme: Material.Dark
    Material.accent: Material.Purple
    color: "#121212"
    
    property int selectedIndex: 0
    
    RowLayout {
        anchors.fill: parent
        spacing: 0
        
        Rectangle {
            id: leftPanel
            Layout.preferredWidth: 250
            Layout.fillHeight: true
            color: "#1e1e1e"
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 10
                
                Text {
                    text: "设置"
                    font.pointSize: 24
                    font.weight: Font.Bold
                    color: "#ffffff"
                    Layout.alignment: Qt.AlignLeft
                    Layout.bottomMargin: 20
                }
                
                ListView {
                    id: settingsList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 8
                    clip: true
                    
                    model: ListModel {
                        id: settingsModel
                        ListElement {
                            name: "通用设置"
                            icon: "⚙️"
                            description: "基本应用设置"
                        }
                        ListElement {
                            name: "公众号设置"
                            icon: "📱"
                            description: "公众号配置"
                        }
                        ListElement {
                            name: "AI 设置"
                            icon: "🤖"
                            description: "AI 服务配置"
                        }
                        ListElement {
                            name: "关于"
                            icon: "ℹ️"
                            description: "版本信息"
                        }
                    }
                    
                    delegate: Rectangle {
                        width: settingsList.width
                        height: 60
                        radius: 12
                        color: index === root.selectedIndex ? "#6200ee" : "transparent"
                        
                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                                easing.type: Easing.InOutQuad
                            }
                        }
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 12
                            
                            Text {
                                text: icon
                                font.pointSize: 20
                                Layout.alignment: Qt.AlignVCenter
                            }
                            
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2
                                
                                Text {
                                    text: name
                                    font.pointSize: 14
                                    font.weight: index === root.selectedIndex ? Font.Bold : Font.Normal
                                    color: index === root.selectedIndex ? "#ffffff" : "#bbbbbb"
                                    Layout.fillWidth: true
                                }
                                
                                Text {
                                    text: description
                                    font.pointSize: 10
                                    color: "#888888"
                                    Layout.fillWidth: true
                                }
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            
                            onClicked: {
                                root.selectedIndex = index
                            }
                            
                            onEntered: {
                                if (index !== root.selectedIndex) {
                                    parent.color = "#333333"
                                }
                            }
                            
                            onExited: {
                                if (index !== root.selectedIndex) {
                                    parent.color = "transparent"
                                }
                            }
                        }
                    }
                }
            }
        }
        
        Rectangle {
            id: rightPanel
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#242424"
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 30
                spacing: 20
                
                Text {
                    id: titleText
                    text: settingsModel.get(root.selectedIndex).name
                    font.pointSize: 28
                    font.weight: Font.Bold
                    color: "#ffffff"
                    Layout.alignment: Qt.AlignLeft
                }
                
                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: "#333333"
                    Layout.bottomMargin: 10
                }
                
                Loader {
                    id: contentLoader
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    
                    sourceComponent: {
                        switch(root.selectedIndex) {
                            case 0: return generalSettingsComponent
                            case 1: return mpSettingsComponent
                            case 2: return aiSettingsComponent
                            case 3: return aboutComponent
                            default: return generalSettingsComponent
                        }
                    }
                }
            }
        }
    }
    
    Component {
        id: generalSettingsComponent
        
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 15
            
            Text {
                text: "基本信息"
                font.pointSize: 16
                font.weight: Font.Bold
                color: "#ffffff"
                Layout.alignment: Qt.AlignLeft
                Layout.bottomMargin: 10
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 60
                radius: 8
                color: "#2d2d2d"
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15
                    
                    Text {
                        text: "用户名"
                        font.pointSize: 14
                        font.weight: Font.Medium
                        color: "#cccccc"
                    }
                    
                    Text {
                        text: maincfg.get("username")
                        font.pointSize: 14
                        color: "#ffffff"
                        Layout.fillWidth: true
                    }
                }
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 60
                radius: 8
                color: "#2d2d2d"
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15
                    
                    Text {
                        text: "应用目录"
                        font.pointSize: 14
                        font.weight: Font.Medium
                        color: "#cccccc"
                    }
                    
                    Text {
                        text: maincfg.get("appDirPath")
                        font.pointSize: 12
                        color: "#aaaaaa"
                        Layout.fillWidth: true
                        elide: Text.ElideMiddle
                    }
                }
            }
        }
    }
    
    Component {
        id: mpSettingsComponent
        
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 15
            
            Text {
                text: "公众号配置"
                font.pointSize: 16
                font.weight: Font.Bold
                color: "#ffffff"
                Layout.alignment: Qt.AlignLeft
                Layout.bottomMargin: 10
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 60
                radius: 8
                color: "#2d2d2d"
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15
                    
                    Text {
                        text: "模式"
                        font.pointSize: 14
                        font.weight: Font.Medium
                        color: "#cccccc"
                    }
                    
                    ComboBox {
                        id: mpModeCombo
                        Layout.fillWidth: true
                        model: ["local"]
                        currentIndex: 0
                        
                        Component.onCompleted: {
                            var mode = maincfg.get("mp.mode")
                            if (mode === "local") {
                                currentIndex = 0
                            }
                        }
                        
                        onCurrentIndexChanged: {
                            maincfg.set("mp.mode", currentText)
                        }
                    }
                }
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 60
                radius: 8
                color: "#2d2d2d"
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15
                    
                    Text {
                        text: "URL"
                        font.pointSize: 14
                        font.weight: Font.Medium
                        color: "#cccccc"
                    }
                    
                    TextField {
                        id: mpUrlField
                        Layout.fillWidth: true
                        text: maincfg.get("mp.url")
                        placeholderText: "请输入 URL"
                        color: "#ffffff"
                        background: Rectangle { color: "#1e1e1e"; radius: 4 }
                        
                        onTextChanged: {
                            maincfg.set("mp.url", text)
                        }
                    }
                }
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 60
                radius: 8
                color: "#2d2d2d"
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15
                    
                    Text {
                        text: "密码"
                        font.pointSize: 14
                        font.weight: Font.Medium
                        color: "#cccccc"
                    }
                    
                    TextField {
                        id: mpPwdField
                        Layout.fillWidth: true
                        text: maincfg.get("mp.password")
                        placeholderText: "请输入密码"
                        echoMode: TextField.Password
                        color: "#ffffff"
                        background: Rectangle { color: "#1e1e1e"; radius: 4 }
                        
                        onTextChanged: {
                            maincfg.set("mp.password", text)
                        }
                    }
                }
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 60
                radius: 8
                color: "#2d2d2d"
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15
                    
                    Text {
                        text: "速率限制"
                        font.pointSize: 14
                        font.weight: Font.Medium
                        color: "#cccccc"
                    }
                    
                    TextField {
                        id: mpRateLimitField
                        Layout.fillWidth: true
                        text: maincfg.get("mp.rate_limit")
                        placeholderText: "请输入速率限制"
                        color: "#ffffff"
                        background: Rectangle { color: "#1e1e1e"; radius: 4 }
                        
                        onTextChanged: {
                            maincfg.set("mp.rate_limit", text)
                        }
                    }
                }
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 60
                radius: 8
                color: "#2d2d2d"
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15
                    
                    Text {
                        text: "访问令牌"
                        font.pointSize: 14
                        font.weight: Font.Medium
                        color: "#cccccc"
                    }
                    
                    Text {
                        text: mptoken
                        font.pointSize: 12
                        color: "#aaaaaa"
                        Layout.fillWidth: true
                        elide: Text.ElideMiddle
                    }
                }
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 60
                radius: 8
                color: "#6200ee"
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15
                    
                    Text {
                        text: "📱"
                        font.pointSize: 20
                    }
                    
                    Text {
                        text: "管理公众号列表"
                        font.pointSize: 14
                        font.weight: Font.Medium
                        color: "#ffffff"
                        Layout.fillWidth: true
                    }
                    
                    Text {
                        text: "›"
                        font.pointSize: 20
                        color: "#ffffff"
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    
                    onClicked: {
                        var component = Qt.createComponent("mpManager.qml");
                        if (component.status === Component.Ready) {
                            var mpWindow = component.createObject(root, {
                                "width": 986,
                                "height": 768,
                                "visible": true
                            });
                        } else {
                            console.error("Failed to load mpManager.qml:", component.errorString());
                        }
                    }
                    
                    onEntered: {
                        parent.color = "#7b1fa2"
                    }
                    
                    onExited: {
                        parent.color = "#6200ee"
                    }
                }
            }
        }
    }
    
    Component {
        id: aiSettingsComponent
        
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 15
            
            Text {
                text: "AI 配置"
                font.pointSize: 16
                font.weight: Font.Bold
                color: "#ffffff"
                Layout.alignment: Qt.AlignLeft
                Layout.bottomMargin: 10
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 60
                radius: 8
                color: "#2d2d2d"
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15
                    
                    Text {
                        text: "AI 模式"
                        font.pointSize: 14
                        font.weight: Font.Medium
                        color: "#cccccc"
                    }
                    
                    ComboBox {
                        id: aiModeCombo
                        Layout.fillWidth: true
                        model: ["ollama"]
                        currentIndex: 0
                        
                        Component.onCompleted: {
                            var mode = maincfg.get("ai.mode")
                            if (mode === "ollama") {
                                currentIndex = 0
                            }
                        }
                        
                        onCurrentIndexChanged: {
                            maincfg.set("ai.mode", currentText)
                        }
                    }
                }
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 60
                radius: 8
                color: "#2d2d2d"
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15
                    
                    Text {
                        text: "API 密钥"
                        font.pointSize: 14
                        font.weight: Font.Medium
                        color: "#cccccc"
                    }
                    
                    TextField {
                        id: aiApiKeyField
                        Layout.fillWidth: true
                        text: maincfg.get("ai.api_key")
                        placeholderText: "请输入 API 密钥"
                        echoMode: TextField.Password
                        color: "#ffffff"
                        background: Rectangle { color: "#1e1e1e"; radius: 4 }
                        
                        onTextChanged: {
                            maincfg.set("ai.api_key", text)
                        }
                    }
                }
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 60
                radius: 8
                color: "#2d2d2d"
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15
                    
                    Text {
                        text: "AI URL"
                        font.pointSize: 14
                        font.weight: Font.Medium
                        color: "#cccccc"
                    }
                    
                    TextField {
                        id: aiUrlField
                        Layout.fillWidth: true
                        text: maincfg.get("ai.url")
                        placeholderText: "请输入 AI URL"
                        color: "#ffffff"
                        background: Rectangle { color: "#1e1e1e"; radius: 4 }
                        
                        onTextChanged: {
                            maincfg.set("ai.url", text)
                        }
                    }
                }
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 60
                radius: 8
                color: "#2d2d2d"
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15
                    
                    Text {
                        text: "AI 模型"
                        font.pointSize: 14
                        font.weight: Font.Medium
                        color: "#cccccc"
                    }
                    
                    TextField {
                        id: aiModelField
                        Layout.fillWidth: true
                        text: maincfg.get("ai.model")
                        placeholderText: "请输入 AI 模型"
                        color: "#ffffff"
                        background: Rectangle { color: "#1e1e1e"; radius: 4 }
                        
                        onTextChanged: {
                            maincfg.set("ai.model", text)
                        }
                    }
                }
            }
        }
    }
    
    Component {
        id: aboutComponent
        
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 20
            
            Rectangle {
                Layout.fillWidth: true
                height: 150
                radius: 12
                color: "#6200ee"
                
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 10
                    
                    Text {
                        text: "NKU_InFollows"
                        font.pointSize: 28
                        font.weight: Font.Bold
                        color: "#ffffff"
                        Layout.alignment: Qt.AlignHCenter
                    }
                    
                    Text {
                        text: "版本 1.0.0"
                        font.pointSize: 14
                        color: "#ffffff"
                        opacity: 0.8
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }
            
            Repeater {
                model: [
                    { title: "更新日志", icon: "📝" },
                    { title: "用户协议", icon: "📄" },
                    { title: "隐私政策", icon: "🔒" },
                    { title: "联系我们", icon: "📧" },
                    { title: "官方网站", icon: "🌐" }
                ]
                
                delegate: Rectangle {
                    Layout.fillWidth: true
                    height: 60
                    radius: 8
                    color: "#2d2d2d"
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 15
                        
                        Text {
                            text: icon
                            font.pointSize: 20
                        }
                        
                        Text {
                            text: title
                            font.pointSize: 14
                            color: "#ffffff"
                            Layout.fillWidth: true
                        }
                        
                        Text {
                            text: "›"
                            font.pointSize: 20
                            color: "#666666"
                        }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        
                        onEntered: {
                            parent.color = "#3d3d3d"
                        }
                        
                        onExited: {
                            parent.color = "#2d2d2d"
                        }
                    }
                }
            }
        }
    }
}
