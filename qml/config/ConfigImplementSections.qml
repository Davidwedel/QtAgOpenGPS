// Copyright (C) 2024 Michael Torrie and the QtAgOpenGPS Dev Team
// SPDX-License-Identifier: GNU General Public License v3.0 or later
//
// Config for sections. Actually displays a separate child window depending on if
// we are using sections or zones.
import QtQuick
import QtQuick.Controls.Fusion
import Settings
import AOG


import ".."
import "../components"

//todo: noticed % coverage was in wrong spot
Rectangle{
    id: configImplementSection
    anchors.fill: parent
    color: aog.backgroundColor
    visible: false

    Row{
        id: bottomRow
        anchors.left: parent.left
        anchors.bottom: parent.bottom
		anchors.topMargin: 5 * theme.scaleHeight
		anchors.rightMargin: 5 * theme.scaleWidth
		anchors.leftMargin: 5 * theme.scaleWidth
		anchors.bottomMargin: 5 * theme.scaleHeight
        spacing: 90 * theme.scaleWidth
        Button{
            function toggleZones(){
                if( Utils.isTrue(Settings.tool_isSectionsNotZones)){
                    Settings.tool_isSectionsNotZones = false
                }else{
                    Settings.tool_isSectionsNotZones = true
                }
            }
            width: 180 * theme.scaleWidth
            height: 130 * theme.scaleHeight
            id: chooseZones
            objectName: "zonesOrSections"
            onClicked: {
                toggleZones()
            }
            background: Rectangle{
                color: aog.backgroundColor
                border.color: aog.blackDayWhiteNight
                border.width: 1
                Image{
                    id: image

                    source: Utils.isTrue(Settings.tool_isSectionsNotZones) ? prefix + "/images/Config/ConT_Asymmetric.png" : prefix + "/images/Config/ConT_Symmetric.png"
                    anchors.fill: parent
                }
            }
        }
        SpinBoxCustomized{
            id: percentCoverage
            from: 0
            to: 100
            boundValue: Settings.vehicle_minCoverage
            anchors.bottom: parent.bottom
            text: qsTr("% Coverage")
            onValueModified: Settings.vehicle_minCoverage = value
        }
        IconButton{
            icon.source: prefix + "/images/SectionOffBoundary.png"
            iconChecked: prefix + "/images/SectionOnBoundary.png"
            anchors.bottom: parent.bottom
            implicitWidth: 100 * theme.scaleWidth
            implicitHeight: 100 * theme.scaleHeight
            border: 1
            radius: 0
            color3: "white"
            colorChecked1: "green"
            colorChecked2: "green"
            colorChecked3: "green"
            isChecked: Settings.tool_isSectionOffWhenOut
            onCheckedChanged: Settings.tool_isSectionOffWhenOut = checked
        }
        SpinBoxCustomized{
            //todo: this should be made english/metric
            decimals: 1
            id: slowSpeedCutoff
            from: Utils.speed_to_unit(0)
            to: Utils.speed_to_unit(30)
            boundValue: Utils.speed_to_unit(Settings.vehicle_slowSpeedCutoff)
            anchors.bottom: parent.bottom
            onValueModified: Settings.vehicle_slowSpeedCutoff = Utils.speed_from_unit(value)
            text: Utils.speed_unit()

            Image{
                anchors.bottom: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                source: prefix + "/images/SectionOffBelow.png"
            }
        }
    }
    ConfigImplementSectionsSection{
        id: configImplementSectionsSection
        anchors.top: parent.top
        anchors.topMargin: 80 * theme.scaleHeight
        anchors.right: parent.right
		anchors.rightMargin: 7 * theme.scaleWidth
        anchors.left: parent.left
		anchors.leftMargin: 7 * theme.scaleWidth
        anchors.bottom: bottomRow.top
        anchors.bottomMargin: 30 * theme.scaleHeight
        visible: Utils.isTrue(Settings.tool_isSectionsNotZones)
    }
    ConfigImplementSectionsZones{
        id: configImplementSectionsZones
        anchors.top: parent.top
        anchors.topMargin: 80 * theme.scaleHeight
        anchors.right: parent.right
		anchors.rightMargin: 7 * theme.scaleWidth
        anchors.left: parent.left
		anchors.leftMargin: 7 * theme.scaleWidth
        anchors.bottom: bottomRow.top
        anchors.bottomMargin: 30 * theme.scaleHeight
        visible: !Utils.isTrue(Settings.tool_isSectionsNotZones)

    }
}
