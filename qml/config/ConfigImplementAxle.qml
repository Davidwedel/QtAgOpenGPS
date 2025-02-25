// Copyright (C) 2024 Michael Torrie and the QtAgOpenGPS Dev Team
// SPDX-License-Identifier: GNU General Public License v3.0 or later
//
// Set where main axle is on implement
import QtQuick
import QtQuick.Controls.Fusion
import Settings
import AOG

import ".."
import "../components"

Rectangle{
    anchors.fill: parent
    visible: true
    color: aog.backgroundColor

    IconButtonTransparent{
        icon.source: prefix + "/images/SteerZeroSmall.png"
        onClicked: {offsetSpin.value = 0; offsetSpin.boundValue = 0}
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: forwardBackSpin.bottom
        anchors.topMargin:30 * theme.scaleHeight
    }
    SpinBoxCM{
        id: forwardBackSpin
        from: 0
        to: 2000
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        boundValue: Math.abs(Settings.tool_trailingToolToPivotLength)
        onValueChanged: {
            if(backBtn.checked){
                Settings.tool_trailingToolToPivotLength = -value
            } else {
                Settings.tool_trailingToolToPivotLength = value
            }
        }
    }
    TextLine{
        anchors.bottom: forwardBackSpin.top
        text: Utils.cm_unit_abbrev()
    }
        ButtonGroup {
            buttons: [ forwardBtn, backBtn ]
        }

    IconButtonColor{
        id: forwardBtn
        implicitWidth: 250 * theme.scaleWidth
        implicitHeight: 400 * theme.scaleHeight
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 50 * theme.scaleWidth
        checkable: true
        isChecked: (Settings.tool_trailingToolToPivotLength > 0)
        icon.source: prefix + "/images/Config/ToolHitchPivotOffsetNeg.png"
        onClicked: Settings.tool_trailingToolToPivotLength = Math.abs(Settings.tool_trailingToolToPivotLength)
    }

    IconButtonColor{
        id: backBtn
        implicitWidth: 250 * theme.scaleWidth
        implicitHeight: 400 * theme.scaleHeight
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 50 * theme.scaleWidth
        isChecked: (Settings.tool_trailingToolToPivotLength <= 0)
        checkable: true
        onClicked: Settings.tool_trailingToolToPivotLength = -Math.abs(Settings.tool_trailingToolToPivotLength)
        icon.source: prefix + "/images/Config/ToolHitchPivotOffsetPos.png"
    }
}
