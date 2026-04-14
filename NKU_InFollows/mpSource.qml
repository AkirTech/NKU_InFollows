import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

Rectangle {
	id: mainrect
	width: 640
	height: 480
	color: "transparent"
    Column {
        anchors.centerIn: parent
        spacing: 20
        Text {
            text: "MP Source"
            font.pointSize: 20
            font.weight: Font.Medium
            color: "#e0e0e0"
        }
        Row {
            spacing: 20
            CheckBox {
                id:nku_main
                text: "南开大学"
                checked: true
            }
            CheckBox {
                id:nku_ty
                text: "南开体育之声"
                checked: true
            }
            MyButton {
                id: buttonnext
                width:60
                height:40
                anchors.verticalCenter:parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 15
                font.underline: true
                baseColor: "transparent"
                bordercolor: "transparent"
                textColor: '#2ea5ff'
                textPointSize: 20
                text: "add"
                onClicked: {
                    var nku_checked = nku_main.checked
                    var nku_ty_checked = nku_ty.checked
                    
                    if(nku_checked) {
                        nku_main.checked = false
                    }
                    if(nku_ty_checked) {
                        nku_ty.checked = false
                    }
                    nku_main.checked = nku_checked
                }
            }
        }

    }
}