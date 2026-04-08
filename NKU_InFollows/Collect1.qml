import QtQuick 
import QtQuick.Window 
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Shapes

Rectangle {
    id: mainrect
    width: 640
    height: 400
    anchors.top : parent.top
    
    anchors.horizontalCenter:parent.horizontalCenter
    anchors.topMargin: 30
    color: "transparent"

    Text {
        id: testtag
        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 20
        font.weight: Font.Medium
        color: "#e0e0e0"
        text: "Tag yourself!"
    }

Rectangle {
    id: tagContainer
    border.color: tagModel.count > 0 ? "#424242" : "#37474f"
    border.width: 1
    radius: 8
    anchors.top : testtag.bottom
    anchors.centerIn: parent
    anchors.topMargin: 20
    width: 400
    height: 220
    color: "#1e1e1e"

    ListModel { id: tagModel
    }   

    // 正常显示的 ListView
    ListView {
        id: tagList
        anchors.fill: parent
        model: tagModel
        visible: tagModel.count > 0
        delegate: Item {

            Rectangle {
                anchors.top :innerText.bottom
                anchors.topMargin:15
                anchors.left: parent.left
                anchors.leftMargin: 25
                width: parent.width - 50
                height: 1
                color: "#37474f"
            }
            width: tagList.width
            height: 30
            Text {
                id:innerText
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.top : parent.top
                anchors.topMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                text: model.text
                font.pointSize: 14
                color: "#e0e0e0"
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: tagModel.remove(index)
                
                onEntered: {
                    innerText.color = "#2196f3"
                }
                
                onExited: {
                    innerText.color = "#e0e0e0"
                }
            }
        }
    }

    // 空状态占位框架
    Rectangle {
        anchors.fill: parent
        visible: tagModel.count === 0
        color: "#1e1e1e"
        border.color: "#37474f"
        border.width: 1
        radius: 8

        Text {
            anchors.centerIn: parent
            text: "暂无标签，点击下方添加"
            color: "#757575"
            font.pointSize: 12
        }

        MouseArea {
            anchors.fill: parent
            onClicked: tagInput.forceActiveFocus()
        }
    }
}
/*

Rectangle {
    id: tagInputRect
    width: 400
    height: 40
    anchors.top: tagContainer.bottom
    anchors.topMargin: 20
    anchors.horizontalCenter: parent.horizontalCenter
    color: "#2d2d2d"
    border.color: "#424242"
    border.width: 1
    radius: 8

    Text {
        id:textPlaceholder
        anchors.fill : parent
        anchors.top : parent.top
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
        visible: !tagInput.activeFocus
        font.pointSize: 12
        font.italic: true
        text : "Enter a tag and press Enter"
        color:"#757575"
    }
} */


TextField {
        id: tagInput
         width: 400
        height: 40
        anchors.top: tagContainer.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        verticalAlignment: TextField.AlignVCenter
        placeholderText: "Enter a tag and press Enter"
        font.pointSize: 12
        color: "#ffffff"
        selectionColor: "#2196f3"
        selectedTextColor: "#ffffff"
        onAccepted: addTag()
    }
Row{
    anchors.top: tagInput.bottom
     anchors.topMargin: 10
     anchors.horizontalCenter: parent.horizontalCenter
     spacing: 20
    MyButton {
        id: addButton
        baseColor: "#1e1e1e"
        bordercolor: "#424242"
        textColor: "#e0e0e0"
        guideColor:"#2196f3"
        height: 40
        radius:10
        textPointSize: 12
        font.weight: Font.Medium
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 100
        font.family: "Segoe UI"
        text: "   Add   "
        onClicked: {
            addTag()
            tagInput.forceActiveFocus()
        }
    }
    MyButton {
        id: saveButton
        baseColor: "#1e1e1e"
        bordercolor: "#2196f3"
        textColor: "#2196f3"
        guideColor:"#2196f3"
        height:40
        radius:10
        textPointSize: 12
        font.weight: Font.Medium
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 100
        font.family: "Segoe UI"
        text: " Save "
        onClicked: saveTags()
    }
}

function addTag() {
    var text = tagInput.text.trim()
    if (text !== "") {
        tagModel.append({"text": text});
        tagInput.text = "";
    }
}
function saveTags() {
    if (tagModel.count === 0) {
        console.log("No tags to save.");
        return;
    }
    else{
         var jsonString = modelToJson(tagModel);
         FileIO.save(jsonString,"/u_interests.json")
    
        }
}
function modelToJson(model) {
    var array = [];
    for (var i = 0; i < model.count; i++) {
        var item = model.get(i); // 返回 { role1: value1, role2: value2, ... }
        // 如果需要，可以在这里添加额外的处理或过滤
        console.log(item.text);
        array.push(item.text);
    }
    return JSON.stringify(array, null, 0);
}

}
