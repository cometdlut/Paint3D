import QtQuick 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import luyiming 1.0

Rectangle {
    id: panel
    width: 264
    color: "#f0f2f3"

    property ParallelAnimation titleAnimation: titleAnimation
    property int instrument: DrawingBoard.INSTRUMENT_NONE
    property int thickness: thicknessSlider.value
    property int opaqueness: opaquenessSlider.value
    property color brushColor: currentColorBlock.color

    onVisibleChanged: {
        if (visible) {
            titleAnimation.start()
            popupAnimation.start()
        }
    }

    ColorDialog {
        id: colorDialog
//        showAlphaChannel: true
        onAccepted: {
            currentColorBlock.color = colorDialog.color
        }
    }

    ParallelAnimation {
        id: titleAnimation
        NumberAnimation {
            target: bigTitle
            property: "Layout.leftMargin"
            duration: 250
            easing.type: Easing.InOutQuad
            from: 30
            to: 0
        }
        NumberAnimation {
            target: bigTitle
            property: "opacity"
            duration: 250
            easing.type: Easing.InOutQuad
            from: 0
            to: 1
        }
    }

    ParallelAnimation {
        id: popupAnimation
        NumberAnimation {
            target: brushes
            property: "y"
            duration: 250
            easing.type: Easing.InOutQuad
            from: 10
            to: 0
        }
        NumberAnimation {
            target: brushes
            property: "opacity"
            duration: 250
            easing.type: Easing.InOutQuad
            from: 0
            to: 1
        }
    }

    ColumnLayout {
        anchors.top: panel.top
        anchors.topMargin: 12
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 12

        Text {
            id: bigTitle
            width: 220
            color: "#0064b6"
            font.pixelSize: 18
            font.family: "Microsoft Yahei UI"
            text: qsTr('画笔')
        }

        ExclusiveGroup { id: shapeGroup }

        Item {
            width: 220
            height: 85
            Grid {
                id: brushes
                width: 220
                spacing: 5
                columns: 5

                property variant brushIconName: ["marker", "pen", "oil-brush", "watercolor", "pixel", "pencil", "eraser", "crayon", "spray-can", "fill"]
                property variant brushTitleName: [qsTr("马克笔(TODO)"), qsTr("钢笔(TODO)"), qsTr("油画笔(TODO)"), qsTr("水彩笔刷(TODO)"), qsTr("像素笔"),
                    qsTr("铅笔(TODO)"), qsTr("橡皮擦"), qsTr("蜡笔(TODO)"), qsTr("喷雾罐(TODO)"), qsTr("填充")]
                property variant brushType: [DrawingBoard.INSTRUMENT_NONE, DrawingBoard.INSTRUMENT_NONE, DrawingBoard.INSTRUMENT_NONE, DrawingBoard.INSTRUMENT_NONE,
                                         DrawingBoard.BRUSH_PIXEL, DrawingBoard.INSTRUMENT_NONE, DrawingBoard.BRUSH_ERASER, DrawingBoard.INSTRUMENT_NONE,
                                         DrawingBoard.INSTRUMENT_NONE, DrawingBoard.BRUSH_FILL]
                Repeater {
                    model: 10

                    CheckableButton {
                        width: 40
                        height: 40

                        exclusiveGroup: shapeGroup

                        source: 'qrc:/icon/brush/' + brushes.brushIconName[index] + '.png'

                        on_img: 'qrc:/icon/brush/' + brushes.brushIconName[index] + '-on.png'
                        on_hover_img: 'qrc:/icon/brush/' + brushes.brushIconName[index] + '-on.png'
                        on_pressed_img: 'qrc:/icon/brush/' + brushes.brushIconName[index] + '-on.png'
                        off_img: 'qrc:/icon/brush/' + brushes.brushIconName[index] + '.png'
                        off_hover_img: 'qrc:/icon/brush/' + brushes.brushIconName[index] + '-hover.png'
                        off_pressed_img: 'qrc:/icon/brush/' + brushes.brushIconName[index] + '-hover.png'

                        onCheckedChanged: {
                            if (checked && bigTitle.text !== brushes.brushTitleName[index]) {
                                bigTitle.text = brushes.brushTitleName[index]
                                titleAnimation.start()
                                panel.instrument = brushes.brushType[index]
                            }
                        }
                    }
                }

            }
        }

        SliderWithBox {
            id: thicknessSlider
            Layout.topMargin: 10
            width: 220
            title: qsTr('粗细')
            postfixText: qsTr('像素')
            minimumValue: 1
            maximumValue: 100
            stepSize: 1
            value: 1
        }

        SliderWithBox {
            id: opaquenessSlider
            width: 220
            title: qsTr('不透明度')
            postfixText: '%'
            minimumValue: 1
            maximumValue: 100
            stepSize: 1
            value: 100
        }
    }

    ColumnLayout {
        anchors.bottom: panel.bottom
        anchors.bottomMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 20
        Image {
            source: 'qrc:/icon/line.png'
        }

        Text {
            width: 220
            Layout.topMargin: 3
            color: "#4d4d75"
            font.pixelSize: 13
            font.family: "Microsoft Yahei UI"
            text: qsTr('笔刷颜色')
        }

        Rectangle {
            id: currentColorBlock
            width: 140
            height: 44
            color: "#000000"
            border.width: 1
            border.color: "#f0f2f3"
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onContainsMouseChanged: {
                    if(containsMouse) {
                        parent.border.color = "#305ccc"
                    }
                    else {
                        parent.border.color = "#f0f2f3"
                    }
                }
                onClicked: {
                    colorDialog.open()
                }
            }
        }

        Grid {
            id: colorPanel
            width: 220
            columns: 6

            property variant colorArray: ["#ffffff", "#c3c3c3", "#585858", "#000000", "#88001b", "#ec1c24",
                "#ff7f27", "#ffca18", "#fdeca6", "#fff200", "#c4ff0e", "#0ed145",
                "#8cfffb", "#00a8f3", "#3f48cc", "#b83dba", "#ffaec8", "#b97a56"]

            Repeater {
                model: 18
                Rectangle {
                    width: 36; height: 36
                    color: colorPanel.colorArray[index]
                    border.color: Qt.darker(color)
                    border.width: 0
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onHoveredChanged: parent.border.width = containsMouse ? 2 : 0
                        onClicked: currentColorBlock.color = colorPanel.colorArray[index]
                    }
                }
            }
        }
    }
}
