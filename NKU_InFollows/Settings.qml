import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls.Material

Rectangle {
    id: root
    width: parent.width
    height: parent.height
    color: "#f5f7fa"
    
    property int selectedIndex: 0
    
    RowLayout {
        anchors.fill: parent
        spacing: 0
        
        Rectangle {
            id: leftPanel
            Layout.preferredWidth: 250
            Layout.fillHeight: true
            color: "#ffffff"
            
            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: "#20000000"
                shadowBlur: 0.3
                shadowHorizontalOffset: 2
                autoPaddingEnabled: true
            }
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 10
                
                Text {
                    text: "设置"
                    font.pointSize: 24
                    font.weight: Font.Bold
                    color: "#2c3e50"
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
                            name: "外观设置"
                            icon: "🎨"
                            description: "主题和界面样式"
                        }
                        ListElement {
                            name: "通知设置"
                            icon: "🔔"
                            description: "消息和提醒配置"
                        }
                        ListElement {
                            name: "隐私设置"
                            icon: "🔒"
                            description: "数据和安全选项"
                        }
                        ListElement {
                            name: "账户设置"
                            icon: "👤"
                            description: "用户账户管理"
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
                        color: index === root.selectedIndex ? "#e3f2fd" : "transparent"
                        
                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                                easing.type: Easing.InOutQuad
                            }
                        }
                        
                        Rectangle {
                            anchors.fill: parent
                            radius: 12
                            color: "transparent"
                            border.width: index === root.selectedIndex ? 2 : 0
                            border.color: "#2196f3"
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
                                    color: index === root.selectedIndex ? "#1976d2" : "#34495e"
                                    Layout.fillWidth: true
                                }
                                
                                Text {
                                    text: description
                                    font.pointSize: 10
                                    color: "#95a5a6"
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
                                    parent.color = "#f8f9fa"
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
            color: "#ffffff"
            
            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: "#20000000"
                shadowBlur: 0.3
                shadowHorizontalOffset: -2
                autoPaddingEnabled: true
            }
            
            ScrollView {
                anchors.fill: parent
                anchors.margins: 30
                clip: true
                
                ColumnLayout {
                    width: parent.width
                    spacing: 20
                    
                    Text {
                        id: titleText
                        text: settingsModel.get(root.selectedIndex).name
                        font.pointSize: 28
                        font.weight: Font.Bold
                        color: "#2c3e50"
                        Layout.alignment: Qt.AlignLeft
                    }
                    
                    Rectangle {
                        Layout.fillWidth: true
                        height: 2
                        color: "#e0e0e0"
                        Layout.bottomMargin: 20
                    }
                    
                    Loader {
                        id: contentLoader
                        Layout.fillWidth: true
                        Layout.preferredHeight: implicitHeight
                        
                        sourceComponent: {
                            switch(root.selectedIndex) {
                                case 0: return generalSettingsComponent
                                case 1: return appearanceSettingsComponent
                                case 2: return notificationSettingsComponent
                                case 3: return privacySettingsComponent
                                case 4: return accountSettingsComponent
                                case 5: return aboutComponent
                                default: return generalSettingsComponent
                            }
                        }
                    }
                    
                    Item {
                        Layout.fillHeight: true
                    }
                }
            }
        }
    }
    
    Component {
        id: generalSettingsComponent
        
        ColumnLayout {
            width: parent.width
            spacing: 15
            
            Repeater {
                model: [
                    { title: "启动时自动运行", description: "应用启动时自动打开" },
                    { title: "最小化到托盘", description: "关闭时最小化到系统托盘" },
                    { title: "开机自启动", description: "系统启动时自动运行应用" }
                ]
                
                delegate: Rectangle {
                    Layout.fillWidth: true
                    height: 70
                    radius: 10
                    color: "#f8f9fa"
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 15
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 5
                            
                            Text {
                                text: modelData.title
                                font.pointSize: 14
                                font.weight: Font.Medium
                                color: "#2c3e50"
                            }
                            
                            Text {
                                text: modelData.description
                                font.pointSize: 11
                                color: "#7f8c8d"
                            }
                        }
                        
                        Rectangle {
                            width: 50
                            height: 26
                            radius: 13
                            color: "#2196f3"
                            
                            Rectangle {
                                width: 22
                                height: 22
                                radius: 11
                                color: "#ffffff"
                                anchors.right: parent.right
                                anchors.rightMargin: 2
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                }
            }
        }
    }
    
    Component {
        id: appearanceSettingsComponent
        
        ColumnLayout {
            width: parent.width
            spacing: 20
            
            Text {
                text: "主题选择"
                font.pointSize: 16
                font.weight: Font.Medium
                color: "#2c3e50"
                Layout.alignment: Qt.AlignLeft
            }
            
            Row {
                spacing: 15
                
                Repeater {
                    model: [
                        { name: "浅色", color: "#ffffff", border: "#e0e0e0" },
                        { name: "深色", color: "#2c3e50", border: "#34495e" },
                        { name: "自动", color: "#f5f7fa", border: "#bdc3c7" }
                    ]
                    
                    delegate: Rectangle {
                        width: 100
                        height: 100
                        radius: 12
                        color: modelData.color
                        border.width: 3
                        border.color: modelData.border
                        
                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 8
                            
                            Rectangle {
                                width: 40
                                height: 40
                                radius: 20
                                color: modelData.color === "#ffffff" ? "#e0e0e0" : "#ffffff"
                                opacity: 0.3
                                Layout.alignment: Qt.AlignHCenter
                            }
                            
                            Text {
                                text: modelData.name
                                font.pointSize: 12
                                color: modelData.color === "#ffffff" ? "#2c3e50" : "#ffffff"
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }
                }
            }
            
            Text {
                text: "字体大小"
                font.pointSize: 16
                font.weight: Font.Medium
                color: "#2c3e50"
                Layout.alignment: Qt.AlignLeft
                Layout.topMargin: 20
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 50
                radius: 8
                color: "#f8f9fa"
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 10
                    
                    Text {
                        text: "小"
                        font.pointSize: 12
                        color: "#7f8c8d"
                    }
                    
                    Rectangle {
                        Layout.fillWidth: true
                        height: 4
                        radius: 2
                        color: "#e0e0e0"
                        
                        Rectangle {
                            width: parent.width * 0.5
                            height: parent.height
                            radius: 2
                            color: "#2196f3"
                        }
                    }
                    
                    Text {
                        text: "大"
                        font.pointSize: 12
                        color: "#7f8c8d"
                    }
                }
            }
        }
    }
    
    Component {
        id: notificationSettingsComponent
        
        ColumnLayout {
            width: parent.width
            spacing: 15
            
            Repeater {
                model: [
                    { title: "桌面通知", description: "在桌面显示通知弹窗" },
                    { title: "声音提醒", description: "播放通知提示音" },
                    { title: "邮件通知", description: "发送邮件通知" },
                    { title: "震动提醒", description: "设备震动提醒" }
                ]
                
                delegate: Rectangle {
                    Layout.fillWidth: true
                    height: 70
                    radius: 10
                    color: "#f8f9fa"
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 15
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 5
                            
                            Text {
                                text: modelData.title
                                font.pointSize: 14
                                font.weight: Font.Medium
                                color: "#2c3e50"
                            }
                            
                            Text {
                                text: modelData.description
                                font.pointSize: 11
                                color: "#7f8c8d"
                            }
                        }
                        
                        Rectangle {
                            width: 50
                            height: 26
                            radius: 13
                            color: index % 2 === 0 ? "#2196f3" : "#bdc3c7"
                            
                            Rectangle {
                                width: 22
                                height: 22
                                radius: 11
                                color: "#ffffff"
                                anchors.right: parent.right
                                anchors.rightMargin: 2
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                }
            }
        }
    }
    
    Component {
        id: privacySettingsComponent
        
        ColumnLayout {
            width: parent.width
            spacing: 15
            
            Repeater {
                model: [
                    { title: "数据收集", description: "允许收集匿名使用数据" },
                    { title: "位置信息", description: "允许访问位置信息" },
                    { title: "个性化推荐", description: "基于使用习惯提供推荐" }
                ]
                
                delegate: Rectangle {
                    Layout.fillWidth: true
                    height: 70
                    radius: 10
                    color: "#f8f9fa"
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 15
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 5
                            
                            Text {
                                text: modelData.title
                                font.pointSize: 14
                                font.weight: Font.Medium
                                color: "#2c3e50"
                            }
                            
                            Text {
                                text: modelData.description
                                font.pointSize: 11
                                color: "#7f8c8d"
                            }
                        }
                        
                        Rectangle {
                            width: 50
                            height: 26
                            radius: 13
                            color: index === 0 ? "#2196f3" : "#bdc3c7"
                            
                            Rectangle {
                                width: 22
                                height: 22
                                radius: 11
                                color: "#ffffff"
                                anchors.right: parent.right
                                anchors.rightMargin: 2
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                }
            }
        }
    }
    
    Component {
        id: accountSettingsComponent
        
        ColumnLayout {
            width: parent.width
            spacing: 20
            
            Rectangle {
                Layout.fillWidth: true
                height: 120
                radius: 12
                color: "#f8f9fa"
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 20
                    
                    Rectangle {
                        width: 80
                        height: 80
                        radius: 40
                        color: "#2196f3"
                        
                        Text {
                            anchors.centerIn: parent
                            text: "👤"
                            font.pointSize: 32
                        }
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        
                        Text {
                            text: "用户名"
                            font.pointSize: 18
                            font.weight: Font.Bold
                            color: "#2c3e50"
                        }
                        
                        Text {
                            text: "user@example.com"
                            font.pointSize: 12
                            color: "#7f8c8d"
                        }
                        
                        Text {
                            text: "编辑资料"
                            font.pointSize: 12
                            color: "#2196f3"
                            font.underline: true
                        }
                    }
                }
            }
            
            Repeater {
                model: [
                    { title: "修改密码", icon: "🔑" },
                    { title: "绑定手机", icon: "📱" },
                    { title: "安全设置", icon: "🛡️" },
                    { title: "退出登录", icon: "🚪" }
                ]
                
                delegate: Rectangle {
                    Layout.fillWidth: true
                    height: 60
                    radius: 10
                    color: "#f8f9fa"
                    
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
                            color: "#2c3e50"
                            Layout.fillWidth: true
                        }
                        
                        Text {
                            text: "›"
                            font.pointSize: 20
                            color: "#bdc3c7"
                        }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        
                        onEntered: {
                            parent.color = "#e8f4fd"
                        }
                        
                        onExited: {
                            parent.color = "#f8f9fa"
                        }
                    }
                }
            }
        }
    }
    
    Component {
        id: aboutComponent
        
        ColumnLayout {
            width: parent.width
            spacing: 20
            
            Rectangle {
                Layout.fillWidth: true
                height: 150
                radius: 12
                color: "linear-gradient(135deg, #667eea 0%, #764ba2 100%)"
                
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
                    radius: 10
                    color: "#f8f9fa"
                    
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
                            color: "#2c3e50"
                            Layout.fillWidth: true
                        }
                        
                        Text {
                            text: "›"
                            font.pointSize: 20
                            color: "#bdc3c7"
                        }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        
                        onEntered: {
                            parent.color = "#e8f4fd"
                        }
                        
                        onExited: {
                            parent.color = "#f8f9fa"
                        }
                    }
                }
            }
        }
    }
}