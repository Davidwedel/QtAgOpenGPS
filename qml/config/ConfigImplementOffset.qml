// Copyright (C) 2024 Michael Torrie and the QtAgOpenGPS Dev Team
// SPDX-License-Identifier: GNU General Public License v3.0 or later
//
// Config page for offset+overlap/gap
import QtQuick
import QtQuick.Controls.Fusion
import QtQuick.Layouts
//import QtQuick.Extras 1.4
import QtQuick.Dialogs
import Qt.labs.folderlistmodel
import Settings
import AOG


import ".."
import "../components"

Rectangle{
    anchors.fill: parent
    visible: true
    color: aog.backgroundColor
    TitleFrame{
        id: offset
        title: qsTr("Tool Offset Direction")
        font.bold: true
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 30 * theme.scaleWidth
        anchors.bottomMargin: 100 * theme.scaleHeight
        height: leftBtn.height + (70 * theme.scaleHeight)
        width: leftBtn.width*2+ (45 * theme.scaleWidth)
        border.width: 1
        Row{
            id: offsetBns
            anchors.bottom: parent.top
            anchors.bottomMargin: 50 * theme.scaleHeight
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10 * theme.scaleWidth
            IconButtonTransparent{
                icon.source: prefix + "/images/SteerZeroSmall.png"
                onClicked: {offsetSpin.value = 0; offsetSpin.boundValue = 0}
                anchors.verticalCenter: parent.verticalCenter
            }
            SpinBoxCM{
                id: offsetSpin
                from: 0
                to: 2500
                anchors.verticalCenter: parent.verticalCenter
                boundValue: Math.abs(Settings.vehicle_toolOffset)
                onValueChanged: {
                    if(leftBtn.checked){
                        Settings.vehicle_toolOffset = -value
                    } else {
                        Settings.vehicle_toolOffset = value
                    }
                }
            }
            TextLine{
                anchors.horizontalCenter: undefined;
                anchors.verticalCenter: parent.verticalCenter
                text: Utils.cm_unit_abbrev()
            }
        }
        Item{
            ButtonGroup {
                buttons: [ leftBtn, rightBtn ]
            }
        }

        IconButtonColor{
            id: leftBtn
            implicitWidth: 130 * theme.scaleWidth
            implicitHeight: 170 * theme.scaleHeight
            anchors.left: parent.left
            anchors.top: parent.top
			anchors.topMargin: 7 * theme.scaleHeight
			anchors.leftMargin: 7 * theme.scaleWidth
			anchors.rightMargin: 7 * theme.scaleWidth
			anchors.bottomMargin: 7 * theme.scaleHeight
            checkable: true
            isChecked: (Settings.vehicle_toolOffset < 0)
            property string offsetNum: Settings.vehicle_toolOffset
            icon.source: prefix + "/images/Config/ToolOffsetNegativeLeft.png"
            onClicked: Settings.vehicle_toolOffset = -Math.abs(Settings.vehicle_toolOffset)
        }

        IconButtonColor{
            id: rightBtn
            implicitWidth: 130 * theme.scaleWidth
            implicitHeight: 170 * theme.scaleHeight
            anchors.left: leftBtn.right
            anchors.right: parent.right
            anchors.top: parent.top
			anchors.topMargin: 7 * theme.scaleHeight
			anchors.leftMargin: 7 * theme.scaleWidth
			anchors.rightMargin: 7 * theme.scaleWidth
			anchors.bottomMargin: 7 * theme.scaleHeight
            isChecked: (Settings.vehicle_toolOffset >= 0)
            checkable: true
            onClicked: Settings.vehicle_toolOffset = Math.abs(Settings.vehicle_toolOffset)
            icon.source: prefix + "/images/Config/ToolOffsetPositiveRight.png"
            TextLine{ text: qsTr("Tool Right"); anchors.top: right.bottom}
        }
    }
    TitleFrame{
        id: gapOverlap
        title: qsTr("Overlap / Gap")
        font.bold: true
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 30 * theme.scaleWidth
        anchors.bottomMargin: 100 * theme.scaleHeight
        height: leftBtn.height + (70 * theme.scaleHeight)
        width: leftBtn.width*2+ (45 * theme.scaleWidth)
        border.width: 1
        Row{
            id: overlapGapBns
            anchors.bottom: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10 * theme.scaleWidth
            anchors.bottomMargin: 50 * theme.scaleHeight
            IconButtonTransparent{
                icon.source: prefix + "/images/SteerZeroSmall.png"
                onClicked: overlapGapSpin.value = 0
                anchors.verticalCenter: parent.verticalCenter
            }
            SpinBoxCM{
                anchors.verticalCenter: parent.verticalCenter
                id: overlapGapSpin
                from: 0
                to: 2500
                boundValue: Math.abs(Settings.vehicle_toolOverlap)
                onValueChanged: {
                    if(overlap.checked){
                        Settings.vehicle_toolOverlap = -value
                    } else {
                        Settings.vehicle_toolOverlap = value
                    }
                }
            }
            TextLine{
                anchors.horizontalCenter: undefined;
                anchors.verticalCenter: parent.verticalCenter
                text: Utils.cm_unit_abbrev()
            }

        }
        Item{
            ButtonGroup {
                buttons: [ overlap, gap ]
            }
        }
        IconButtonColor{
            id: overlap
            implicitWidth: 130 * theme.scaleWidth
            implicitHeight: 170 * theme.scaleHeight
            anchors.left: parent.left
            anchors.top: parent.top
			anchors.topMargin: 7 * theme.scaleHeight
			anchors.leftMargin: 7 * theme.scaleWidth
			anchors.rightMargin: 7 * theme.scaleWidth
			anchors.bottomMargin: 7 * theme.scaleHeight
            checkable: true
            isChecked: (Settings.vehicle_toolOverlap >= 0)
            onClicked: Settings.vehicle_toolOverlap = Math.abs(Settings.vehicle_toolOverlap)
            icon.source: prefix + "/images/Config/ToolOverlap.png"
            TextLine{ text: qsTr("Overlap"); anchors.top: left.bottom}
        }

        IconButtonColor{
            id: gap
            implicitWidth: 130 * theme.scaleWidth
            implicitHeight: 170 * theme.scaleHeight
            anchors.left: left.right
            anchors.right: parent.right
            anchors.top: parent.top
			anchors.topMargin: 7 * theme.scaleHeight
			anchors.leftMargin: 7 * theme.scaleWidth
			anchors.rightMargin: 7 * theme.scaleWidth
			anchors.bottomMargin: 7 * theme.scaleHeight
            isChecked: (Settings.vehicle_toolOverlap < 0)
            onClicked: Settings.vehicle_toolOverlap = -Math.abs(Settings.vehicle_toolOverlap)
            checkable: true
            icon.source: prefix + "/images/Config/ToolGap.png"
            TextLine{
                anchors.horizontalCenter: undefined;
                anchors.verticalCenter: parent.verticalCenter
                text: Utils.cm_unit_abbrev()
            }
        }
    }
}
