import QtQuick
import QtQuick.Window
import QtQuick.Layouts

Window {
    id: splashWindow
    width: 400
    height: 200
    flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    visible: true
    color: "#121212"
    
    property string statusText: "正在启动..."
    property real progress: 0
    
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20
        
        Text {
            text: "NKU_InFollows"
            font.pointSize: 28
            font.weight: Font.Bold
            color: "#6200ee"
            Layout.alignment: Qt.AlignHCenter
        }
        
        Text {
            id: statusLabel
            font.pointSize: 14
            color: "#aaaaaa"
            Layout.alignment: Qt.AlignHCenter
        }
        
        Rectangle {
            id: progressBar
            Layout.preferredWidth: 200
            Layout.preferredHeight: 4
            radius: 2
            color: "#2d2d2d"
            
            Rectangle {
                id: progressFill
                width: 0
                height: parent.height
                radius: 2
                color: "#6200ee"
            }
        }
    }
    
    function updateStatus(text) {
        var progressStr = " (" + Math.round(progress) + "%)"
        statusLabel.text = text + progressStr
    }
    
    function setProgress(value) {
        progress = value
        progressFill.width = progressBar.width * (progress / 100)
        var currentText = statusLabel.text
        var lastParen = currentText.lastIndexOf(" (")
        if (lastParen !== -1) {
            currentText = currentText.substring(0, lastParen)
        }
        statusLabel.text = currentText + " (" + Math.round(progress) + "%)"
    }
    
    function closeSplash() {
        splashWindow.close()
    }
}