import QtQuick 
import QtQuick.Window 
import QtQuick.Controls
import QtQuick.Controls.Material

Rectangle {
    id: mainrect
    width: 640
    height: 400
    color: "#fefefe"

    Text {
        id: testtag
        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 20
        color: "#000000"
        text: "Tag yourself!"
    }

Rectangle {
    id: tagContainer
    border.color: tagModel.count > 0 ? "#000000" : "#ccc"   
    // 有数据时使用黑色边框，无数据时使用灰色边框
    border.width: 2
    radius: 5
    anchors.top : testtag.bottom
    anchors.centerIn: parent
    anchors.topMargin: 20
    width: 400   // 与 ListView 宽度一致
    height: 220  // 与 ListView 高度一致



    ListModel { id: tagModel
    }   


    // 正常显示的 ListView
    ListView {
        id: tagList
        anchors.fill: parent
        model: tagModel
        visible: tagModel.count > 0   // 有数据时显示
        delegate: Item {

            


            Rectangle {
                anchors.top :innerText.bottom
                anchors.topMargin:15
                anchors.left: parent.left
                anchors.leftMargin: 25
                width: parent.width - 50
                height: 1
                color: "#eee"   // 浅灰色分割线
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
                color: "#333"
            }
            MouseArea {
                anchors.fill: parent
                onClicked: tagModel.remove(index)
            }
        }
    }

    // 空状态占位框架
    Rectangle {
        anchors.fill: parent
        visible: tagModel.count === 0   // 无数据时显示
        color: "transparent"
        border.color: "#ccc"
        border.width: 2
        radius: 5

        Text {
            anchors.centerIn: parent
            text: "暂无标签，点击下方添加"
            color: "#999"
            font.pointSize: 12
        }

        // 可选：让占位框也能响应点击，比如聚焦到输入框
        MouseArea {
            anchors.fill: parent
            onClicked: tagInput.forceActiveFocus()
        }
    }
}

    Rectangle {
        id: tagInputRect
        width: 400
        height: 40
        anchors.top: tagContainer.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#fefefe"
        border.color: "#000000"
        border.width: 1
        radius: 5

        Text {
            id:textPlaceholder
            anchors.fill : parent
            anchors.top : parent.top
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
            visible: !tagInput.activeFocus  // 输入框为空时显示
            font.pointSize: 12
            font.italic: true
            text : "Enter a tag and press Enter"
            color:"#ccc"
        }

        TextInput {
            id: tagInput
            anchors.fill: parent
            anchors.leftMargin: 5
            anchors.rightMargin: 5
            verticalAlignment: TextInput.AlignVCenter
            font.pointSize: 12
            color: "#000000"
            onAccepted: addTag()   // 回车键添加
        }
    }

    MyButton {
        id: addButton
        bordercolor: "#4c6ef5"
        guideColor:"transparent"
        radius:10
        textPointSize: 15
        anchors.top: tagInputRect.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        text: "   Add   "
        onClicked: saveTags()
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
        return JSON.stringify(array, null, 2);
    }


}
