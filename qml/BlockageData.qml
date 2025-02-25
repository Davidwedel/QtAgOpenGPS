// Copyright (C) 2024 Michael Torrie and the QtAgOpenGPS Dev Team
// SPDX-License-Identifier: GNU General Public License v3.0 or later
//
// Displays the GPS Data on main screen.
import QtQuick
import QtQuick.Controls.Fusion
import AOG
import "components" as Comp

Rectangle{
    id: blockageData
    width: 200* theme.scaleWidth
    height: childrenRect.height + 30 * theme.scaleHeight
    color: "#4d4d4d"
    Column{
        id: column
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 15 * theme.scaleHeight
        Comp.TextLine{ color: "white"; font.pixelSize: 30; text: qsTr("Max: ")+ Utils.area_to_unit_string(aog.blockage_max*10000, 0)}

        Comp.TextLine{ color: "white"; font.pixelSize: 30; text: qsTr("Row N max  ")+aog.blockage_max_i}
        Comp.TextLine{ color: "white"; font.pixelSize: 30; text: qsTr("Avg ")+ Utils.area_to_unit_string(aog.blockage_avg*10000, 0)}
        Comp.TextLine{ color: "white"; font.pixelSize: 30; text: qsTr("Min ")+Utils.area_to_unit_string(aog.blockage_min1*10000, 0) +(" ")+ Utils.area_to_unit_string(aog.blockage_min2*10000, 0)}
        Comp.TextLine{ color: "red"; font.pixelSize: 30; text: qsTr("Rows ")+aog.blockage_min1_i+(" ")+aog.blockage_min2_i}
        Comp.TextLine{ color: "red"; font.pixelSize: 30; text: qsTr("Blocked ")+aog.blockage_blocked}
        }
}
