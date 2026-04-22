import QtQuick 
import QtQuick.Controls 
import QtQuick.Layouts

ApplicationWindow {
    id:qr_win
    visible: true
    width: 400
    height: 500
    title: "Scan QR Code to login"

    Rectangle {
        id: qr_code
        width: 400
        height: 400
        color: "white"
        anchors.centerIn: parent
    }

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
        text:"You may scan the QR code to use we-mp-rss server,\nIf no QR code is displayed here,\ncheck your mp.mode settings"
    }

    Button {
        id: qr_close_btn
        onClicked: {
            if (maincfg.get("mp.mode") === "local"){
                let loginStatus = webParser.getLoginStatus();
                if (loginStatus === "success"){
                    qr_win.visible = false;
                }
                else{
                    tips.text = "Login failed, please try again";
                    var oldSource = main_image.source;
                    main_image.source = "";
                    main_image.source = oldSource;
                }
            }
           
        }
    }
    
}