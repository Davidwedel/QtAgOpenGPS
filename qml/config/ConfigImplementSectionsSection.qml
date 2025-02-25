// Copyright (C) 2024 Michael Torrie and the QtAgOpenGPS Dev Team
// SPDX-License-Identifier: GNU General Public License v3.0 or later
//
// Displayed by ConfigImplementSections, if we are using Sections, not Zones
import QtQuick
import QtQuick.Controls.Fusion
import Settings
import AOG


import ".."
import "../components"

/*todo: sections not populated from .config yet
  also not at all sure about switching these to SpinBoxCM... Don't want to break anything
  */
Item{
    id: configImplementSectionsSection
    z: 8
    ListModel {
        id: section_model

    }

    onVisibleChanged: {
        if (visible) loadModelFromSettings()
    }

    property int totalWidth: 0

    function loadModelFromSettings() {
        if(!Utils.isTrue(Settings.tool_isSectionsNotZones))
            return

        section_model.clear()

        totalWidth = 0

        var w = Number(Settings.section_position2) - Number(Settings.section_position1)
        section_model.append({secNum: 0, width: w })
        totalWidth += w
        if(Number(Settings.vehicle_numSections < 2)) return

        w = Number(Settings.section_position3) - Number(Settings.section_position2)
        section_model.append({secNum: 1, width: w })
        totalWidth += w
        if(Number(Settings.vehicle_numSections < 3)) return

        w = Number(Settings.section_position4) - Number(Settings.section_position3)
        section_model.append({secNum: 2, width: w })
        totalWidth += w
        if(Number(Settings.vehicle_numSections < 4)) return

        w = Number(Settings.section_position5) - Number(Settings.section_position4)
        section_model.append({secNum: 3, width: w })
        totalWidth += w
        if(Number(Settings.vehicle_numSections < 5)) return

        w = Number(Settings.section_position6) - Number(Settings.section_position5)
        section_model.append({secNum: 4, width: w })
        totalWidth += w
        if(Number(Settings.vehicle_numSections < 6)) return

        w = Number(Settings.section_position7) - Number(Settings.section_position6)
        section_model.append({secNum: 5, width: w })
        totalWidth += w
        if(Number(Settings.vehicle_numSections < 7)) return

        w = Number(Settings.section_position8) - Number(Settings.section_position7)
        section_model.append({secNum: 6, width: w })
        totalWidth += w
        if(Number(Settings.vehicle_numSections < 8)) return

        w = Number(Settings.section_position9) - Number(Settings.section_position8)
        section_model.append({secNum: 7, width: w })
        totalWidth += w
        if(Number(Settings.vehicle_numSections < 9)) return

        w = Number(Settings.section_position10) - Number(Settings.section_position9)
        section_model.append({secNum: 8, width: w })
        totalWidth += w
        if(Number(Settings.vehicle_numSections < 10)) return

        w = Number(Settings.section_position11) - Number(Settings.section_position10)
        section_model.append({secNum: 9, width: w })
        totalWidth += w
        if(Number(Settings.vehicle_numSections < 11)) return

        w = Number(Settings.section_position12) - Number(Settings.section_position11)
        section_model.append({secNum: 10, width: w })
        totalWidth += w
        if(Number(Settings.vehicle_numSections < 12)) return

        w = Number(Settings.section_position13) - Number(Settings.section_position12)
        section_model.append({secNum: 11, width: w })
        totalWidth += w
        if(Number(Settings.vehicle_numSections < 13)) return

        w = Number(Settings.section_position14) - Number(Settings.section_position13)
        section_model.append({secNum: 12, width: w })
        totalWidth += w
        if(Number(Settings.vehicle_numSections < 14)) return

        w = Number(Settings.section_position15) - Number(Settings.section_position14)
        section_model.append({secNum: 13, width: w })
        totalWidth += w
        if(Number(Settings.vehicle_numSections < 15)) return

        w = Number(Settings.section_position16) - Number(Settings.section_position15)
        section_model.append({secNum: 14, width: w })
        totalWidth += w
        if(Number(Settings.vehicle_numSections < 16)) return

        w = Number(Settings.section_position17) - Number(Settings.section_position16)
        section_model.append({secNum: 15, width: w })
        totalWidth += w
    }

    function saveModelToSettings() {
        //get total width
        var w = 0.0
        for (var i=0; i < Number(Settings.vehicle_numSections) ; i ++)
            w += section_model.get(i).width

        Settings.vehicle_toolWidth = w;
        totalWidth = w
        var pos = -w/2
        var n = Number(Settings.vehicle_numSections)

        Settings.section_position1 = pos
        Settings.section_position2 = pos + section_model.get(0).width
        pos += section_model.get(0).width
        if (n < 2) {
            Settings.section_position3 = 0
        } else {
            Settings.section_position3 = pos + section_model.get(1).width
            pos += section_model.get(1).width
        }

        if (n < 3) {
            Settings.section_position4 = 0
        } else {
            Settings.section_position4 = pos + section_model.get(2).width
            pos += section_model.get(2).width
        }

        if (n < 4) {
            Settings.section_position5 = 0
        } else {
            Settings.section_position5 = pos + section_model.get(3).width
            pos += section_model.get(3).width
        }

        if (n < 5) {
            Settings.section_position6 = 0
        } else {
            Settings.section_position6 = pos + section_model.get(4).width
            pos += section_model.get(4).width
        }

        if (n < 6) {
            Settings.section_position7 = 0
        } else {
            Settings.section_position7 = pos + section_model.get(5).width
            pos += section_model.get(5).width
        }

        if (n < 7) {
            Settings.section_position8 = 0
        } else {
            Settings.section_position8 = pos + section_model.get(6).width
            pos += section_model.get(6).width
        }

        if (n < 8) {
            Settings.section_position9 = 0
        } else {
            Settings.section_position9 = pos + section_model.get(7).width
            pos += section_model.get(7).width
        }

        if (n < 9) {
            Settings.section_position10 = 0
        } else {
            Settings.section_position10 = pos + section_model.get(8).width
            pos += section_model.get(8).width
        }

        if (n < 10) {
            Settings.section_position11 = 0
        } else {
            Settings.section_position11 = pos + section_model.get(9).width
            pos += section_model.get(9).width
        }

        if (n < 11) {
            Settings.section_position12 = 0
        } else {
            Settings.section_position12 = pos + section_model.get(10).width
            pos += section_model.get(10).width
        }

        if (n < 12) {
            Settings.section_position13 = 0
        } else {
            Settings.section_position13 = pos + section_model.get(11).width
            pos += section_model.get(11).width
        }

        if (n < 13) {
            Settings.section_position14 = 0
        } else {
            Settings.section_position14 = pos + section_model.get(12).width
            pos += section_model.get(12).width
        }

        if (n < 14) {
            Settings.section_position15 = 0
        } else {
            Settings.section_position15 = pos + section_model.get(13).width
            pos += section_model.get(13).width
        }

        if (n < 15) {
            Settings.section_position16 = 0
        } else {
            Settings.section_position16 = pos + section_model.get(14).width
            pos += section_model.get(14).width
        }

        if (n < 16) {
            Settings.section_position17 = 0
        } else {
            Settings.section_position17 = w / 2
        }

        debug_sections()

    }
    function debug_sections() {
        console.debug("Sections changed")
        console.debug(Settings.section_position1)
        console.debug(Settings.section_position2)
        console.debug(Settings.section_position3)
        console.debug(Settings.section_position4)
        console.debug(Settings.section_position5)
        console.debug(Settings.section_position6)
        console.debug(Settings.section_position7)
        console.debug(Settings.section_position8)
        console.debug(Settings.section_position9)
        console.debug(Settings.section_position10)
        console.debug(Settings.section_position11)
        console.debug(Settings.section_position12)
        console.debug(Settings.section_position13)
        console.debug(Settings.section_position14)
        console.debug(Settings.section_position15)
        console.debug(Settings.section_position16)
        console.debug(Settings.section_position17)


    }

    GridView {
        id: section_width_grid
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: middleRow.top
        model: section_model
        cellWidth: 200 * theme.scaleWidth
        cellHeight: 85 * theme.scaleHeight

        clip: true


        delegate:
            SpinBoxCM {
                text: qsTr("Section", "Refers to an implement section") +
                      " " + Number(model.secNum+1).toLocaleString(Qt.locale(),"f",0)

                id: spinner
                from: 3
                to: 7000
                editable: true
                value: model.width
                onValueModified: {
                    model.width = value
                    saveModelToSettings()
                    //debug_sections()
                }
            }
    }
    Row{
        id: middleRow
        anchors.top: parent.verticalCenter
        anchors.right: parent.right
        anchors.topMargin: 40 * theme.scaleHeight
        anchors.bottomMargin: 40 * theme.scaleHeight
        anchors.leftMargin: 40 * theme.scaleWidth
        anchors.rightMargin: 40 * theme.scaleWidth
        width: children.width
        height: children.height
        spacing: 120 * theme.scaleWidth

        SpinBoxCM{
            id: defaultSectionWidth
            implicitWidth: 150 * theme.scaleWidth
            implicitHeight: 50 * theme.scaleHeight
            from: 10
            boundValue: Settings.tool_defaultSectionWidth
            to: 7000
            editable: true
            text: qsTr("Default Section Width")
            onValueModified: Settings.tool_defaultSectionWidth = value
        }

        ComboBox{
            id: numOfSections
            currentIndex: Settings.vehicle_numSections - 1

            onActivated: function(which) {
                which += 1
                if (which === Number(Settings.vehicle_numSections)) return

                var newstart = 0
                if (which > Number(Settings.vehicle_numSections)) {
                    //add on some new sections
                    newstart = Number(Settings.vehicle_numSections)
                } else {
                    Settings.vehicle_numSections = which

                    //remove all the model items past the new number of
                    //sections
                    for ( ; which < section_model.count ; ) {
                        section_model.remove(which)
                    }
                    saveModelToSettings()
                    //debug_sections()
                    return
                }

                Settings.vehicle_numSections = which

                //append new sections to the model, but don't everwrite the
                //existing ones

                for (var sn = newstart; sn < which ; sn++) {
                    section_model.append({secNum: sn, width: Number(Settings.tool_defaultSectionWidth) })
                }

                saveModelToSettings()
                //debug_sections()
            }

            model: ListModel{
                ListElement {text: qsTr("1")}
                ListElement {text: qsTr("2")}
                ListElement {text: qsTr("3")}
                ListElement {text: qsTr("4")}
                ListElement {text: qsTr("5")}
                ListElement {text: qsTr("6")}
                ListElement {text: qsTr("7")}
                ListElement {text: qsTr("8")}
                ListElement {text: qsTr("9")}
                ListElement {text: qsTr("10")}
                ListElement{text: qsTr("11")}
                ListElement{text: qsTr("12")}
                ListElement{text: qsTr("13")}
                ListElement{text: qsTr("14")}
                ListElement{text: qsTr("15")}
                ListElement{text: qsTr("16")}
            }
            implicitHeight:60 * theme.scaleHeight
            implicitWidth: 90 * theme.scaleHeight
            Text{
                anchors.bottom: parent.top
                text: qsTr("Sections")
            }
        }
        Column{
            spacing: 8
            Text {
                text: Utils.cm_to_unit_string(totalWidth,0)
            }
            Text {
                text: Utils.cm_unit()
                color: "green"
            }
        }
    }
}
