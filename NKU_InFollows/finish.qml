import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import QtQuick.Controls.Material
import QtQuick.Dialogs
import QtQuick.Layouts
ApplicationWindow {
    id: finishWindow
    Material.theme: Material.Dark
    Material.accent: Material.Purple
    visible: true
    width: 986
    height: 768
    title: "NKU_InFollows"
    color: "#121212"

    property string wx_status: "未登录"
    property string wx_expire: "未知"
    property string button_text: "登录微信公众平台"
    property bool button_enabled: true
    
    property bool syncInProgress: false
    property string syncStatus: ""
    property int syncProgress: 0
    property bool syncCompleted: false
    property var recommendations: []
    
    property var settingsWindow: null
    property var resultsWindow: null

    Connections {
        target: webParser
        function onLoginSuccess(){
            button_text = "登录成功！";
            wx_status = "已登录";
            var wx_expire = webParser.getWxExpireTime();
            finishWindow.wx_expire = wx_expire;
        }
        function onSyncProgressUpdated(message, progress) {
            syncStatus = message;
            syncProgress = progress;
        }
        function onSyncCompleted(result) {
            syncInProgress = false;
            syncCompleted = true;
            syncStatus = "同步完成！";
            console.log("Sync result:", result);
            // 尝试加载最新的推荐文件
            loadRecommendations();
        }
        function onSyncError(error) {
            syncInProgress = false;
            syncStatus = "同步失败：" + error;
            showMessageDialog("同步失败", error);
        }
    }

    MessageDialog {
        id: infoDialog
        title: ""
        text: ""
        buttons: MessageDialog.Ok
    }

    function showMessageDialog(title, text) {
        infoDialog.title = title;
        infoDialog.text = text;
        infoDialog.open();
    }

    function loadRecommendations() {
        // 查找最新的 recommend 文件
        var files = FileIO.listFiles(appDirPath);
        var latestFile = "";
        var latestTime = 0;
        
        for (var i = 0; i < files.length; i++) {
            var file = files[i];
            if (file.startsWith("recommend_") && file.endsWith(".json")) {
                var timeStr = file.replace("recommend_", "").replace(".json", "");
                var time = parseInt(timeStr);
                if (time > latestTime) {
                    latestTime = time;
                    latestFile = file;
                }
            }
        }
        
        if (latestFile !== "") {
            var filePath = appDirPath + "/" + latestFile;
            var content = FileIO.read(filePath);
            if (content) {
                var json = JSON.parse(content);
                // 解析 AI 返回的格式
                if (json.choices && json.choices.length > 0) {
                    var message = json.choices[0].message;
                    if (message.content) {
                        // 尝试解析 message.content 中的 JSON
                        try {
                            recommendations = JSON.parse(message.content);
                        } catch(e) {
                            console.error("Failed to parse AI response:", e);
                            recommendations = [];
                        }
                    }
                } else {
                    // 直接是数组
                    recommendations = json;
                }
            }
        }
    }

    Rectangle {
        id:mainrect
        width: 640
        height: 500
        anchors.top : parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 30
        color: "transparent"

        MessageDialog {
            id: confirmDialog
            title: "打开Github页面"
            text: "即将在Github打开本项目，是否继续？"
            buttons: MessageDialog.Ok | MessageDialog.Cancel
            onAccepted: {
                Qt.openUrlExternally("https://github.com/AkirTech/NKU_InFollows")
            }
            onRejected: {
                console.log("用户取消了操作")
            }
        }

        ColumnLayout {
            anchors.centerIn: parent
            anchors.topMargin: 30
            spacing: 30

            Image {
                id: iconImage
                source: "NKU_InFollows_icon.png"
                width: 120
                height: 120
                visible: false
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: "NKU_InFollows\n服务已运行"
                font.family: "Consolas"
                font.pixelSize: 28
                color: Material.foreground
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 20

                Button {
                    text: "设置"
                    Layout.preferredWidth: 120
                    onClicked: {
                        if (settingsWindow) {
                            settingsWindow.visible = true;
                            settingsWindow.raise();
                        } else {
                            var component = Qt.createComponent("Settings.qml");
                            if (component.status === Component.Ready) {
                                settingsWindow = component.createObject(finishWindow, {
                                    "width": 1000,
                                    "height": 800,
                                    "visible": true
                                });
                            } else {
                                console.error("Failed to load Settings.qml:", component.errorString());
                            }
                        }
                    }
                }

                Button {
                    text: "关于"
                    Layout.preferredWidth: 120
                    onClicked: {
                        confirmDialog.open()
                    }
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 20

                Button {
                    id: syncButton
                    text: syncInProgress ? "同步中..." : "立即同步"
                    Layout.preferredWidth: 160
                    enabled: !syncInProgress
                    onClicked: {
                        syncInProgress = true;
                        syncCompleted = false;
                        syncProgress = 0;
                        syncStatus = "准备同步...";
                        webParser.startSync();
                    }
                }

                Button {
                    id: viewResultsButton
                    text: "查看推荐"
                    Layout.preferredWidth: 160
                    enabled: syncCompleted
                    onClicked: {
                        // 每次点击都重新加载最新的推荐文件
                        loadRecommendations();
                        
                        if (recommendations.length === 0) {
                            showMessageDialog("提示", "暂无推荐内容，请先进行同步");
                            return;
                        }
                        
                        if (resultsWindow) {
                            // 更新已存在窗口的推荐数据
                            resultsWindow.recommendations = recommendations;
                            resultsWindow.visible = true;
                            resultsWindow.raise();
                        } else {
                            var component = Qt.createComponent("ResultsView.qml");
                            if (component.status === Component.Ready) {
                                resultsWindow = component.createObject(finishWindow, {
                                    "width": 800,
                                    "height": 600,
                                    "visible": true,
                                    "recommendations": recommendations
                                });
                            } else {
                                console.error("Failed to load ResultsView.qml:", component.errorString());
                            }
                        }
                    }
                }
            }

            // 进度条区域
            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 10
                visible: syncInProgress || syncStatus !== ""

                Text {
                    text: syncStatus
                    color: Material.foreground
                    font.pixelSize: 14
                    Layout.alignment: Qt.AlignHCenter
                }

                ProgressBar {
                    Layout.preferredWidth: 400
                    from: 0
                    to: 100
                    value: syncProgress
                    visible: syncInProgress
                }
            }

            Button {
                id: open_qr_scan
                text: button_text
                Layout.preferredWidth: 240
                enabled: button_enabled
                Layout.alignment: Qt.AlignHCenter
                onClicked: {
                    button_enabled = false;
                    button_text = "正在获取二维码...";
                    var result = webParser.wxLoginGetQR("http://localhost:8001", mptoken);
                    console.log(result);
                    if (result === "生成成功") {
                        qrTimer.start();
                        button_text = "二维码已生成，即将打开...";
                    } else {
                        button_text = "获取二维码失败，请重试";
                        button_enabled = true;
                    }
                }
            }

            ColumnLayout {
                id:debugInfo
                Layout.alignment: Qt.AlignHCenter
                spacing: 10
                Text {
                    text: "当前微信公众平台登录状态：" + finishWindow.wx_status
                    font.pixelSize: 16
                    color: Material.foreground
                }
                Text {
                    text: "过期时间：" + finishWindow.wx_expire
                    font.pixelSize: 16
                    color: Material.foreground
                }
            }
        }
    }

    Timer {
        id: qrTimer
        interval: 3000
        repeat: false
        onTriggered: {
            var qrPath = appDirPath + "/backend/we-mp-rss/static/wx_qrcode.png";
            Qt.openUrlExternally("file:///" + qrPath);
            button_text = "等待扫描... (点击关闭)";
            button_enabled = true;
            webParser.wxLoginCheckLoop("http://localhost:8001", mptoken);
        }
    }

    Timer {
        id: statusTimer
        interval: 15000
        repeat: true
        onTriggered: {
            var wx_status = webParser.checkCurrentWxLogin();
            finishWindow.wx_status = wx_status ? "已登录" : "未登录";
            var wx_expire = webParser.getWxExpireTime();
            finishWindow.wx_expire = wx_expire;
        }
    }

    Component.onCompleted: {
        statusTimer.start();
    }
}
