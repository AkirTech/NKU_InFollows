import QtQuick 
import QtQuick.Window 
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Shapes

Rectangle {
	id: mainrect
	width: 640
	height: 480
	color: "transparent"
	Column {
		anchors.fill: parent
		anchors.margins: 20
		anchors.leftMargin:100
		spacing: 20
		Text {
			text: "Configure AI settings."
			font.pointSize: 20
			font.weight: Font.Medium
			color: "#e0e0e0"
			
		}
			Text {
				text: "Mode:"
				parent: modeRect
				font.pointSize: 10
				font.weight: Font.Medium
				color: "#e0e0e0"
			}
			Row {
				spacing: 20
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
		
	//  API 配置
			Text {
				text: "API url:"
				font.pointSize: 14
				font.weight: Font.Medium
				color: "#e0e0e0"
			}
			TextField {
				id: api_url_field
				width: parent.width - 60
				font.pointSize:14
				placeholderText: mode_checkbox.checked ? "(default) http://localhost:11434/v1" : "Enter your OpenAI API key"
				echoMode: TextInput.Normal
				
			}
			Text {
				text: "API key:"
				visible: mode_checkbox2.checked
				font.pointSize: 14
				font.weight: Font.Medium
				color: "#e0e0e0"
			}
			TextField {
				id: api_key_field
				visible: mode_checkbox2.checked
				width: parent.width - 60
				font.pointSize:14
				placeholderText: "Enter your OpenAI API key"
				echoMode: TextInput.Password
			}

		}
		
}
