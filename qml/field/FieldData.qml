// Copyright (C) 2024 Michael Torrie and the QtAgOpenGPS Dev Team
// SPDX-License-Identifier: GNU General Public License v3.0 or later
//
// On main GL
import QtQuick
import QtQuick.Controls.Fusion
import Settings
import AOG


import ".."
import "../components"

Rectangle {
    id: fieldData
    width: 200
    height: childrenRect.height + 30
    color: "black"
    opacity: 0.7
    border.color: "black"
    border.width: 1.5

    property double timeUntilFinished: (aog.speedKph > 1 ?
                                            (aog.areaBoundaryOuterLessInner - aog.workedAreaTotal) /
                                            Settings.vehicle_toolWidth / aog.speedKph / 1000
                                          : Number.POSITIVE_INFINITY)

    property int hoursUntilFinished: (timeUntilFinished != Number.POSITIVE_INFINITY ?
                                          Math.floor(timeUntilFinished)
                                        : Number.POSITIVE_INFINITY)

    property int minutesUntilFinished: (timeUntilFinished != Number.POSITIVE_INFINITY ?
                                            (timeUntilFinished - hoursUntilFinished) * 60
                                          : Number.POSITIVE_INFINITY)

    property string timeUntilFinishedString: timeUntilFinished != Number.POSITIVE_INFINITY ?
                                                 qsTr("%1:%2 hours")
                                                 .arg(Qt.locale().toString(hoursUntilFinished,'f',0))
                                                 .arg(Qt.locale().toString(minutesUntilFinished,'f',0))
                                               : qsTr("\u221E hours")

    property string percentLeft: aog.areaBoundaryOuterLessInner > 0 ?
                                     qsTr("%1%")
                                     .arg(Qt.locale().toString((aog.areaBoundaryOuterLessInner - aog.workedAreaTotal) / aog.areaBoundaryOuterLessInner * 100, 'f', 0))
                                   : qsTr("--")

    Column{
        id: column
        anchors.top: parent.top
        anchors.margins: 15
        anchors.horizontalCenter: parent.horizontalCenter
        TextLine{ color: "white"; text: qsTr("Total: ")+ Utils.area_to_unit_string(aog.areaBoundaryOuterLessInner, 2)}
        Spacer {}
        Rectangle{ color: "white"; height:2; width: fieldData.width * .75; anchors.horizontalCenter: parent.horizontalCenter;}
        TextLine{ color: "white"; text: qsTr("Worked")}
        TextLine{ color: "white"; text: qsTr("Applied: ")+ Utils.area_to_unit_string(aog.workedAreaTotal, 2)}
        TextLine{ color: "white"; text: qsTr("Remain: ")+ Utils.area_to_unit_string((aog.areaBoundaryOuterLessInner - aog.workedAreaTotal), 2)}
        TextLine{ color: "white"; text: fieldData.percentLeft }
        TextLine{ color: "white"; text: fieldData.timeUntilFinishedString }
        Spacer {}
        Rectangle{ color: "white"; height:2; width: fieldData.width * .75; anchors.horizontalCenter: parent.horizontalCenter;}
        TextLine{ color: "white"; text: qsTr("Actual")}
        TextLine{ color: "white"; text: qsTr("Applied: ")+ Utils.area_to_unit_string(aog.actualAreaCovered, 2)}
        TextLine{ color: "white"; text: qsTr("Remain: ") + Utils.area_to_unit_string((aog.areaBoundaryOuterLessInner - aog.actualAreaCovered), 2)}
        TextLine{ color: "white"; text: qsTr("Overlap: ") + Utils.area_to_unit_string((aog.workedAreaTotal - aog.actualAreaCovered), 2)}
        TextLine{ color: "white"; text: Utils.workRateString(aog.speedKph) }
    }
}
