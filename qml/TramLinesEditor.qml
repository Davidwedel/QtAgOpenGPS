import QtQuick 2.0
import QtQuick.Controls.Fusion
import "components"

Item {
    width: 340
    height: 550
        id: mainWindowTram
        TopLine{
            id: topLine
            titleText: "Tram Lines"
        }
    Rectangle{
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.top: topLine.bottom
        Row{
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            id: tramHalfNudge
            width: children.width
            spacing: 35
            height: children.height
            IconButtonTransparent{
                icon.source: "/images/SnapLeftHalf.png"
            }
            Text{
                text: "2.00 m"
                font.bold: true
                font.pixelSize: 15
                anchors.verticalCenter: parent.verticalCenter
            }

            IconButtonTransparent{
                icon.source: "/images/SnapRightHalf.png"
            }
        }
        Row{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: tramHalfNudge.bottom
            anchors.topMargin: 30
            id: tramSmallNudge
            width: children.width
            spacing: 25
            height: children.height
            IconButtonTransparent{
                icon.source: "/images/ArrowLeft.png"
            }
            Text{
                text: "10 cm"
                font.bold: true
                font.pixelSize: 15
                anchors.verticalCenter: parent.verticalCenter
            }

            IconButtonTransparent{
                icon.source: "/images/ArrowRight.png"
            }
        }
        IconButtonTransparent{
            id: tramSwapAB
            anchors.top: tramSmallNudge.bottom
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 60
            icon.source: "/images/ABSwapPoints.png"
        }
        IconButtonTransparent{
            id: tramSwapMode
            anchors.top: tramSmallNudge.bottom
            anchors.topMargin: 10
            anchors.left: tramSwapAB.right
            anchors.leftMargin: 60
            icon.source: "/images/TramLines.png"
        }
        Text {
            text: qsTr("Mode")
            font.pixelSize: 15
            anchors.left: tramSwapMode.right
            anchors.leftMargin: 30
            anchors.verticalCenter: tramSwapMode.verticalCenter
        }
        Row{
            id: tramPasses
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: tramSwapMode.bottom
            anchors.topMargin: 30
            height:tramPassesDown.height
            spacing: 25
            IconButtonTransparent{
                id: tramPassesDown
                icon.source: "/images/DnArrow64.png"
            }
            SpinBoxCustomized{
                id: passesRow
                width: tramPassesDown.width
                height: tramPassesDown.height
                    text: qsTr("Passes")
                    from: 1
                    value: 1
                    to: 999
            }
            IconButtonTransparent{
                icon.source: "/images/UpArrow64.png"
            }
        }

        IconButtonTransparent{
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            icon.source: "/images/SwitchOff.png"
            onClicked: tramLinesEditor.visible = false
        }
        IconButtonTransparent{
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            icon.source: "/images/VehFileSave.png"
        }
        Column{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 30
            anchors.top: tramPasses.bottom
            spacing: 10
            Text{
                text: "Seed"
            }
            Text{
                text: "Spray"
            }
            Text{
                text: "Track"
            }
        }
    }
}
