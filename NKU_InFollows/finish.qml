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
                text: "NKU_InFollows\n服务已运行"
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
                    confirmDialog.open()
                }
            }
            Button {
                id: open_qr_scan
                text:"登录微信公众平台"
                onClicked: {
                    open_qr_scan.enabled = false;
                    open_qr_scan.text = "正在获取二维码...";
                    var result = webParser.wxLoginGetQR("http://localhost:8001", mptoken);
                    console.log(result);
                    if (result === "生成成功") {
                        qrTimer.start();
                        open_qr_scan.text = "二维码已生成，即将打开...";
                    } else {
                        open_qr_scan.text = "获取二维码失败，请重试";
                        open_qr_scan.enabled = true;
                    }
                }
            }
        }
    }

    Timer {
        id: qrTimer
        interval: 3000
        repeat: false
        onTriggered: {
            var qrPath = appDirPath + "../../NKU_InFollows/backend/we-mp-rss/static/wx_qrcode.png";
            Qt.openUrlExternally("file:///" + qrPath);
            open_qr_scan.text = "登录微信公众平台";
            open_qr_scan.enabled = true;
        }
    }
}