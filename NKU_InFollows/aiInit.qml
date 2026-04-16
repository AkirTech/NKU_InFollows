import QtQuick 
import QtQuick.Window 
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Shapes
import QtQuick.Layouts

Rectangle {
	id: mainrect
	anchors.fill: parent
	anchors.margins: 30
	anchors.horizontalCenter: parent.horizontalCenter
	color: "transparent"
	
	ColumnLayout {
		id: ai_main_layout
		anchors.fill: parent
		anchors.margins: 30
		spacing: 15
		
		Text {
			text: "Configure AI settings."
			font.pointSize: 20
			font.weight: Font.Medium
			color: "#e0e0e0"
			Layout.alignment: Qt.AlignLeft
		}
		
		Text {
			text: "Mode:"
			font.pointSize: 14
			font.weight: Font.Medium
			color: "#e0e0e0"
			Layout.alignment: Qt.AlignLeft
		}
		
		RowLayout {
			id: ai_modeRow
			spacing: 20
			Layout.alignment: Qt.AlignLeft
			
			CheckBox {
				id: mode_checkbox
				text: "Ollama: Local"
				checked: !mode_checkbox2.checked
			}
			
			CheckBox {
				id: mode_checkbox2
				text: "Other: OpenAI API"
				checked: !mode_checkbox.checked
			}
		}
		
		// Item {
		// 	Layout.preferredHeight: 20
		// }
		
		// API 配置
		Text {
			text: "API url:"
			font.pointSize: 14
			font.weight: Font.Medium
			color: "#e0e0e0"
			Layout.alignment: Qt.AlignLeft
		}
		
		TextField {
			id: api_url_field
			Layout.fillWidth: true
			Layout.maximumWidth: 400
			font.pointSize: 14
			placeholderText: mode_checkbox.checked ? "(default) http://localhost:11434/v1" : "Enter your OpenAI API key"
			echoMode: TextInput.Normal
			Layout.alignment: Qt.AlignLeft
		}
		
		Text {
			text: "API key:"
			visible: mode_checkbox2.checked
			font.pointSize: 14
			font.weight: Font.Medium
			color: "#e0e0e0"
			Layout.alignment: Qt.AlignLeft
		}
		
		TextField {
			id: api_key_field
			visible: mode_checkbox2.checked
			Layout.fillWidth: true
			Layout.maximumWidth: 400
			font.pointSize: 14
			placeholderText: "Enter your OpenAI API key"
			echoMode: TextInput.Password
			Layout.alignment: Qt.AlignLeft
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
					try{
						maincfg.set("ai_mode", mode_checkbox.checked ? "ollama" : "openai");
						maincfg.set("api_url", api_url_field.text);
						if (mode_checkbox2.checked) { 
							maincfg.set("api_key", api_key_field.text);
						}
					}
					catch(e){
						console.log(e);
					}
					stackView.push("Collect1.qml");
				}
			}
		}
	}
}
