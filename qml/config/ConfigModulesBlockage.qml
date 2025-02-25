// Copyright (C) 2024 Michael Torrie and the QtAgOpenGPS Dev Team
// SPDX-License-Identifier: GNU General Public License v3.0 or later
//
// Pinout for hyd lift/sections
import QtQuick
import QtQuick.Controls.Fusion
import QtQuick.Layouts
import Settings
import AOG


import ".."
import "../components"

Rectangle{
    id: configModulesBlockage
    anchors.fill: parent
    color: aog.backgroundColor
    visible: false

    onVisibleChanged: {
        if (visible) load_settings()
    }


    function load_settings() {

        graincountMin.boundValue = Settings.seed_blockCountMin
        graincountMax.boundValue = Settings.seed_blockCountMax
        modulerows1.boundValue = Settings.seed_blockRow1
        modulerows2.boundValue = Settings.seed_blockRow2
        modulerows3.boundValue = Settings.seed_blockRow3
        modulerows4.boundValue = Settings.seed_blockRow4
        cboxIsBlockageOn.checked = Settings.seed_blockageIsOn


        mandatory.visible = false

    }

    function save_settings() {


        Settings.seed_blockCountMin = graincountMin.value
        Settings.seed_blockCountMax = graincountMax.value
        Settings.seed_blockRow1 = modulerows1.value
        Settings.seed_blockRow2 = modulerows2.value
        Settings.seed_blockRow3 = modulerows3.value
        Settings.seed_blockRow4 = modulerows4.value
        Settings.seed_blockageIsOn = cboxIsBlockageOn.checked
        Settings.seed_numRows = Number(Settings.seed_blockRow1 + Settings.seed_blockRow2 + Settings.seed_blockRow3 + Settings.seed_blockRow4)
        blockageRows.setSizes()
        mandatory.visible = false

        aog.doBlockageMonitoring()
    }
    Label{
        id: top
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 10
        text: qsTr("Planter Monitor")
    }

    GridLayout{
        flow: Grid.LeftToRight
        columns: 4
        rows: 5
        anchors.bottom: back.top
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 10 * theme.scaleHeight
        anchors.bottomMargin: 10 * theme.scaleHeight
        anchors.leftMargin: 10 * theme.scaleWidth
        anchors.rightMargin: 10 * theme.scaleWidth


        SpinBoxCustomized{
            id: modulerows1
            from: 0
            to:255
            editable: true
            enabled: cboxIsBlockageOn.checked
            boundValue: Settings.seed_blockRow1
            onValueModified: {
                Settings.seed_blockRow1 = value
                mandatory.visible = true
            }
            anchors.bottomMargin: 10 * theme.scaleHeight
            TextLine{
                text: qsTr("Rows on module 1: ")
                font.bold: true
                anchors.top: parent.bottom
            }
        }
        SpinBoxCustomized{
            id: modulerows2
            from: 0
            to:255
            editable: true
            enabled: cboxIsBlockageOn.checked
            boundValue: Settings.seed_blockRow2
            onValueModified: {
                Settings.seed_blockRow2 = value
                mandatory.visible = true
            }
            anchors.bottomMargin: 10 * theme.scaleHeight
            TextLine{
                text: qsTr("Rows on module 2: ")
                font.bold: true
                anchors.top: parent.bottom
            }
        }
        SpinBoxCustomized{
            id: modulerows3
            from: 0
            to:255
            editable: true
            enabled: cboxIsBlockageOn.checked
            boundValue: Settings.seed_blockRow3
            onValueModified: {
                Settings.seed_blockRow3 = value
                mandatory.visible = true
            }
            anchors.bottomMargin: 10 * theme.scaleHeight
            TextLine{
                text: qsTr("Rows on module 3: ")
                font.bold: true
                anchors.top: parent.bottom
            }
        }
        SpinBoxCustomized{
            id: modulerows4
            from: 0
            to:255
            editable: true
            enabled: cboxIsBlockageOn.checked
            boundValue: Settings.seed_blockRow4
            onValueModified:{
                Settings.seed_blockRow4 = value
                mandatory.visible = true
            }
            anchors.bottomMargin: 10 * theme.scaleHeight
            TextLine{
                text: qsTr("Rows on module 4: ")
                font.bold: true
                anchors.top: parent.bottom
            }

        }
        SpinBoxCustomized{
            id: graincountMin
            from: 0
            to:10000
            editable: true
            enabled: cboxIsBlockageOn.checked
            boundValue: Settings.seed_blockCountMin
            onValueModified: {
                Settings.seed_blockCountMin = value
                mandatory.visible = true
            }
            anchors.bottomMargin: 10 * theme.scaleHeight
            TextLine{
                text: qsTr("Minimum ")
                font.bold: true
                anchors.top: parent.bottom
            }
            Label{
                anchors.left: parent.right
                anchors.verticalCenter: parent.verticalCenter
                text: Utils.per_unit()
            }
        }
        SpinBoxCustomized{
            Layout.alignment: Qt.AlignRight
            id: graincountMax
            from: 0
            to:10000
            editable: true
            enabled: cboxIsBlockageOn.checked
            boundValue: Settings.seed_blockCountMax
            onValueModified:{
                Settings.seed_blockCountMax = value
                mandatory.visible = true
            }
            anchors.bottomMargin: 10 * theme.scaleHeight
            TextLine{
                text: qsTr("Maximum ")
                font.bold: true
                anchors.top: parent.bottom
            }
            Label{
                anchors.left: parent.right
                anchors.verticalCenter: parent.verticalCenter
                text: Utils.per_unit()
            }
        }


    }


    IconButtonTransparent{
        id: back
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.topMargin: 20 * theme.scaleHeight
        anchors.bottomMargin: 20 * theme.scaleHeight
        anchors.rightMargin: 20 * theme.scaleHeight
        anchors.leftMargin: 20 * theme.scaleHeight
        enabled: cboxIsBlockageOn.checked
        icon.source: prefix + "/images/back-button.png"
        onClicked: {
            graincountMin.boundValue = 0
            graincountMax.boundValue = 0
            modulerows1.boundValue = 0
            modulerows2.boundValue = 0
            modulerows3.boundValue = 0
            modulerows4.boundValue = 0
            crops.currentIndex[0] = 0
            mandatory.visible = true

        }
    }
    IconButtonTransparent{
        id: loadSetBlockage
        anchors.bottom: parent.bottom
        anchors.left: back.right
        anchors.topMargin: 20 * theme.scaleHeight
        anchors.bottomMargin: 20 * theme.scaleHeight
        anchors.rightMargin: 20 * theme.scaleHeight
        anchors.leftMargin: 20 * theme.scaleHeight
        enabled: cboxIsBlockageOn.checked
        icon.source: prefix + "/images/UpArrow64.png"
        onClicked: {
            load_settings()
            mandatory.visible = true
        }
    }
    IconButtonColor{
        id: cboxIsBlockageOn
        height: loadSetBlockage.height
        anchors.bottom: parent.bottom
        anchors.left: loadSetBlockage.right
        anchors.topMargin: 20 * theme.scaleHeight
        anchors.bottomMargin: 20 * theme.scaleHeight
        anchors.rightMargin: 20 * theme.scaleHeight
        anchors.leftMargin: 20 * theme.scaleHeight
        icon.source: prefix + "/images/SwitchOff.png"
        iconChecked: prefix + "/images/SwitchOn.png"
        checkable: true
        onClicked: mandatory.visible = true
        }
    IconButtonTransparent{
        id: btnPinsSave
        anchors.right: mandatory.left
        anchors.topMargin: 20 * theme.scaleHeight
        anchors.bottomMargin: 20 * theme.scaleHeight
        anchors.rightMargin: 20 * theme.scaleHeight
        anchors.leftMargin: 20 * theme.scaleHeight
        anchors.bottom: parent.bottom
        icon.source: prefix + "/images/ToolAcceptChange.png"
        Text{
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.left
            anchors.rightMargin: 5
            text: qsTr("Send + Save")
        }
        onClicked: save_settings()

    }

    Image{
        id: mandatory
        anchors.right: parent.right
        anchors.verticalCenter: btnPinsSave.verticalCenter
        anchors.rightMargin: 20 * theme.scaleWidth
        visible: false
        source: prefix + "/images/Config/ConSt_Mandatory.png"
        height: back.width
    }
}
