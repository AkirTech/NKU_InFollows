import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import QtQuick.Dialogs

Window {
    id: resultsViewWindow
    width: 800
    height: 600
    title: "NKU_InFollows-AI推荐"
    visible: false
    Material.theme: Material.Dark
    Material.accent: Material.Purple
    color: "#121212"
    
    property var recommendations: []
    
    onRecommendationsChanged: {
        loadData()
    }
    
    ListModel {
        id: recommendationsModel
    }
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 30
        spacing: 20
        
        RowLayout {
            Layout.fillWidth: true
            
            Text {
                text: "AI为您推荐"
                font.pointSize: 24
                font.weight: Font.Bold
                color: "#ffffff"
            }
            
            Item {
                Layout.fillWidth: true
            }
            
            Button {
                text: "刷新"
                Layout.preferredWidth: 100
                onClicked: {
                    refreshData()
                }
            }
        }
        
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: "#333333"
        }
        
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            StackLayout {
                anchors.fill: parent
                
                Rectangle {
                    id: listContainer
                    anchors.fill: parent
                    radius: 10
                    color: "#1e1e1e"
                    border.color: "#333333"
                    border.width: 1
                    visible: recommendationsModel.count > 0
                    
                    ListView {
                        id: recommendationsListView
                        anchors.fill: parent
                        anchors.margins: 15
                        model: recommendationsModel
                        spacing: 10
                        clip: true
                        
                        delegate: Item {
                            width: recommendationsListView.width
                            height: 80
                            
                            Rectangle {
                                anchors.fill: parent
                                radius: 8
                                color: "#2d2d2d"
                                
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        if (model.url) {
                                            Qt.openUrlExternally(model.url)
                                        }
                                    }
                                }
                                
                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 15
                                    spacing: 5
                                    
                                    Text {
                                        text: model.title ? model.title : "无标题"
                                        font.pointSize: 14
                                        font.weight: Font.Bold
                                        color: "#ffffff"
                                        elide: Text.ElideRight
                                        Layout.fillWidth: true
                                        Layout.alignment: Qt.AlignLeft
                                    }
                                    
                                    Text {
                                        text: model.url ? model.url : ""
                                        font.pointSize: 10
                                        color: "#757575"
                                        elide: Text.ElideMiddle
                                        Layout.fillWidth: true
                                        Layout.alignment: Qt.AlignLeft
                                    }
                                }
                            }
                        }
                    }
                }
                
                Rectangle {
                    id: emptyContainer
                    anchors.fill: parent
                    radius: 10
                    color: "#1e1e1e"
                    border.color: "#333333"
                    border.width: 1
                    visible: recommendationsModel.count === 0
                    
                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 10
                        
                        Text {
                            text: "暂无推荐内容"
                            color: "#757575"
                            font.pointSize: 16
                            Layout.alignment: Qt.AlignHCenter
                        }
                        
                        Text {
                            text: "请先在主界面进行同步"
                            color: "#555555"
                            font.pointSize: 12
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }
            }
        }
        
        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignRight
            spacing: 15
            
            Button {
                text: "关闭"
                Layout.preferredWidth: 80
                onClicked: {
                    resultsViewWindow.close()
                }
            }
        }
    }
    
    function refreshData() {
        loadData()
    }
    
    function loadData() {
        recommendationsModel.clear()
        if (recommendations && recommendations.length > 0) {
            for (var i = 0; i < recommendations.length; i++) {
                var item = recommendations[i]
                recommendationsModel.append({
                    title: item.title ? item.title : "",
                    url: item.url ? item.url : ""
                })
            }
        }
    }
    
    Component.onCompleted: {
        loadData()
    }
}
