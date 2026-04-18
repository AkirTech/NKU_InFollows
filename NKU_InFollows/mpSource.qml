import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

Rectangle {
	id: mainrect
	parent:mainWindow
    anchors.margins:30
    anchors.horizontalCenter:parent.horizontalCenter
	color: "transparent"
    
    ListModel {
        id: mp_sources
        
    }


    ColumnLayout {
        id: mainLayout
        anchors.fill: parent
        anchors.margins: 30
        spacing: 20

        Text {
            id: mpmode
            text: "Service mode"
            font.pointSize: 20
            font.weight: Font.Medium
            color: "#e0e0e0"
            Layout.alignment: Qt.AlignLeft
        }
        
        RowLayout {
            id: mpmode_row
            spacing: 20
            Layout.alignment: Qt.AlignLeft
            
            CheckBox {
                id: mpmode_checkbox
                text: "Local API"
                checked: true //!mpmode_checkbox2.checked 
                onCheckedChanged: {
                    update_mp_mode();
                }
                checkable:false
            }
            
            CheckBox {
                id: mpmode_checkbox2
                text: "Remote API (Currently unsupported.)"
                checked: false //!mpmode_checkbox.checked
                
                onCheckedChanged: {
                    update_mp_mode();
                }
                checkable:false
                
            }
        }

        Text {
            text: "MP Source"
            font.pointSize: 20
            font.weight: Font.Medium
            color: "#e0e0e0"
            Layout.alignment: Qt.AlignLeft
        }
        
        RowLayout {
            spacing: 20
            Layout.alignment: Qt.AlignLeft
            
            CheckBox {
                id: nku_main
                text: "南开大学"
                checked: true
            }
            
            CheckBox {
                id: nku_ty
                text: "南开体育之声"
                checked: true
            }
            
            Item {
                Layout.fillWidth: true
            }
            
            Rectangle {
                id: other_box
                Layout.preferredHeight: 40
                Layout.preferredWidth: 300
                color: "transparent"
                
                RowLayout {
                    anchors.fill: parent
                    spacing: 10
                    

                    TextField {
                        id: other_input
                        Layout.fillWidth: true
                        font.pointSize: 14
                        placeholderText: "Enter other source"
                    }
                    MyButton {
                        id: buttonadd
                        width: 60
                        height: 20
                        font.underline: true
                        baseColor: "transparent"
                        bordercolor: "transparent"
                        textColor: '#2ea5ff'
                        textPointSize: 12
                        text: "add"
                        onClicked: {
                            if (other_input.text.length > 0) {
                                var txt = other_input.text.trim();
                                var url = mpmode_checkbox.checked?"":"";
                                if (txt.length > 0 && url != "") {
                                    webParser.getMPSearchRq(txt,url,access);
                                }
                            }
                            else{
                                statustext.text = "Source cannot be empty.";
                                other_input.forceActiveFocus();
                            }
                        }
                    }
                    
                    
                }

            Text {
                id:statustext
                anchors.top : other_box.bottom
                anchors.topMargin: 20
                text:"Add more sources."  
                font.pointSize: 12
                color: "#e0e0e0"
                Layout.alignment: Qt.AlignRight
                }
            }
        }
        
        Item {
            Layout.fillHeight: true
        }
        
        RowLayout {
            Layout.alignment: Qt.AlignCenter
            spacing: 20
            
            MyButton {
                id: backButton
                width: 100
                height: 40
                
                baseColor: "#1e1e1e"
                bordercolor: "#424242"
                textColor: "#e0e0e0"
                textPointSize: 14
                text: "Back"
                
                onClicked: {
                    parent.parent.parent.stackView.pop();
                }
            }
            
            MyButton {
                id: nextButton
                width: 100
                height: 40
                
                baseColor: "#2196f3"
                bordercolor: "#2196f3"
                textColor: "#ffffff"
                textPointSize: 14
                text: "Next"
                
                onClicked: {
                    parent.parent.parent.stackView.push("Collect1.qml");
                    maincfg.set("mp_mode", mpmode_checkbox.checked ? "local" : "remote");
                }
            }
        }
    }
    
    function update_mp_mode() {
        if (mpmode_checkbox.checked){
            maincfg.set("mp.mode", "local");
        }
        else{
            maincfg.set("mp.mode", "remote");
        }
    }
    function mpBackendlogin(){
        var defaultpwd = maincfg.get("mp.pwd");
        if (defaultpwd == ""){
            defaultpwd = "admin@123";
        }
        var access = webParser.we_login(username,defaultpwd);
        maincfg.set("mp.access", access);
    }
}


