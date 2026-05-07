import QtQuick 
import QtQuick.Window 
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

Rectangle {
    id: mainrect
    parent: mainWindow
    width: 640
    height: 480
    anchors.fill:parent
    anchors.horizontalCenter:parent.horizontalCenter
    anchors.margins:30
    color: "transparent"
    
    Column {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20
        
        Text {
            id:titletext
            text: "最终用户协议"
            font.pointSize: 20
            font.weight: Font.Bold
            color: "#e0e0e0"
            horizontalAlignment: Text.AlignHCenter
        }
        
        Flickable {
            id: eulaContent
            anchors.top:titletext.bottom
            anchors.topMargin: 20
            width: parent.width
            height: parent.height - 150
            clip: true
            contentWidth: textItem.width
            contentHeight: textItem.height
            
            Text {
                id: textItem
                width: eulaContent.width
                text: {
                    var file = Qt.resolvedUrl("eula.txt");
                    var xhr = new XMLHttpRequest();
                    xhr.open("GET", file, false);
                    xhr.send(null);
                    return xhr.responseText;
                }
                font.pointSize: 12
                color: "#e0e0e0"
                wrapMode: Text.Wrap
                lineHeight: 1.5
            }
        }
        
        Row {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20
            
            MyButton {
                id: declineButton
                width: 140
                height: 40
                
                baseColor: "#1e1e1e"
                bordercolor: "#424242"
                textColor: "#e0e0e0"
                textPointSize: 14
                text: "拒绝并退出"
                
                onClicked: {
                    // 拒绝协议，退出应用
                    Qt.quit();
                }
            }
            
            MyButton {
                id: acceptButton
                width: 190
                height: 40
                
                baseColor: "#2196f3"
                bordercolor: "#2196f3"
                textColor: "#ffffff"
                textPointSize: 14
                text: "我已详细阅读并同意"
                
                onClicked: {
                    // 接受协议，跳转到欢迎界面
                    stackView.push("Greet.qml");
                }
            }
        }
    }
}