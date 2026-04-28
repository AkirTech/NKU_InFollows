import QtQuick 
import QtQuick.Controls 
import QtQuick.Layouts
import QtQuick.Controls.Material

ApplicationWindow {
    id:qr_win
    visible: true
    width: 300
    height: 450
    title: "Scan QR Code to login"

    Component.onCompleted: {
        qr_close_btn.text = "正在获取二维码...";
        var result = webParser.wxLoginGetQR("http://localhost:8001", mptoken);
        if (result === "生成成功") {
            qr_close_btn.text = "等待扫描... (点击关闭)";
            webParser.wxLoginCheckLoop("http://localhost:8001", mptoken);
        } else {
            qr_close_btn.text = "二维码获取失败，请重试";
        }
    }

    Connections {
        target: webParser
        function onNotice(message) {
            qr_close_btn.text = message + " (点击关闭)";
        }
        function onLoginSuccess() {
            qr_close_btn.text = "登录成功！";
            qr_win.visible = false;
        }
    }

    Rectangle {
        id: qr_code
        width: 400
        height: 400
        color: "transparent"
        anchors.centerIn: parent
    

    Image {
        id:main_image
        source: "backend/we-mp-rss/static/qr_code.png"
        visible: maincfg.get("mp.mode") === "local"? true : false
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top:parent.top
        anchors.topMargin: 20

    }

    Text {
        id:tips
        anchors.centerIn: parent
        anchors.top: main_image.bottom
        anchors.topMargin: 10
        text:"You may scan the QR code to use we-mp-rss server,\nIf no QR code is displayed here,\ncheck your mp.mode settings"
        horizontalAlignment: Text.AlignHCenter
    }

    Button {
        id: qr_close_btn
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        text: "等待扫描... (点击关闭)"
        onClicked: {
            qr_win.visible = false;
        }
    }
    }
}