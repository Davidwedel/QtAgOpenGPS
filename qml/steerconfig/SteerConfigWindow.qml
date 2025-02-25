// Copyright (C) 2024 Michael Torrie and the QtAgOpenGPS Dev Team
// SPDX-License-Identifier: GNU General Public License v3.0 or later
//
// The window where we set WAS, Stanley, PP, PWM
import QtQuick
import QtQuick.Controls.Fusion
import QtQuick.Layouts
import Settings
import AOG


import ".."
import "../components"

MoveablePopup {
    id: steerConfigWindow
    closePolicy: Popup.NoAutoClose
    height: pwmWindow.visible ? 700 * theme.scaleHeight : 500 * theme.scaleHeight
    modal: false
    visible: false
    width:350 * theme.scaleWidth
    x: Settings.window_steerSettingsLocation.x
    y: Settings.window_steerSettingsLocation.y
    function show (){
        steerConfigWindow.visible = true
	}

	Rectangle{
		id: steerConfigFirst
        anchors.fill: parent
        border.color: aog.blackDayWhiteNight
        border.width: 1
        color: aog.backgroundColor
        visible: true
        TopLine{
			id:topLine
            onBtnCloseClicked:  steerConfigWindow.close()
            titleText: qsTr("Auto Steer Config")
        }
		Item{
			id: steerSlidersConfig
            anchors.left: parent.left
            anchors.top: topLine.bottom
            height: 475 * theme.scaleHeight
            width: steerConfigWindow.width
            ButtonGroup {
				buttons: buttonsTop.children
			}

			RowLayout{
                id: buttonsTop
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 10 * theme.scaleWidth
				IconButtonColor{
					id: steerBtn
                    checkable: true
                    checked: true
                    colorChecked: "lightgray"
                    icon.source: prefix + "/images/Steer/ST_SteerTab.png"
                    implicitHeight: 50 * theme.scaleHeight
                    implicitWidth: parent.width /3 - 5 * theme.scaleWidth
                }
				IconButtonColor{
					id: gainBtn
                    checkable: true
                    colorChecked: "lightgray"
                    icon.source: prefix + "/images/Steer/ST_GainTab.png"
                    implicitHeight: 50 * theme.scaleHeight
                    implicitWidth: parent.width /3 - 5 * theme.scaleWidth
                }
				IconButtonColor{
					id: stanleyBtn
                    checkable: true
                    colorChecked: "lightgray"
                    icon.source: prefix + "/images/Steer/ST_StanleyTab.png"
                    implicitHeight: 50 * theme.scaleHeight
                    implicitWidth: parent.width /3 - 5 * theme.scaleWidth
                    visible: !Settings.menu_isPureOn
                }
				IconButtonColor{
					id: ppBtn
                    checkable: true
                    colorChecked: "lightgray"
                    icon.source: prefix + "/images/Steer/Sf_PPTab.png"
                    implicitHeight: 50 * theme.scaleHeight
                    implicitWidth: parent.width /3 - 5 * theme.scaleWidth
                    visible: Settings.menu_isPureOn
                }
            }

            WasBar{
                id: wasbar
                wasvalue: aog.steerAngleActual*10
                width: steerConfigWindow.width - 20 * theme.scaleWidth
                visible: steerBtn.checked
                anchors.top: buttonsTop.bottom
                anchors.bottomMargin: 8 * theme.scaleHeight
                anchors.topMargin: 8 * theme.scaleHeight
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Item{
                id: slidersArea
                anchors.top: wasbar.bottom
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.bottom: angleInfo.top

                ColumnLayout{
                    id: slidersColumn
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 5 * theme.scaleHeight
                    anchors.left: parent.left
                    anchors.leftMargin: 15 * theme.scaleWidth
                    anchors.top: parent.top
                    anchors.topMargin: 5 * theme.scaleHeight
                    width: parent.width * 0.4

                    /* Here, we just set which Sliders we want to see, and the
                      ColumnLayout takes care of the rest. No need for
                      4 ColumnLayouts*/
                     //region WAStab




                    IconButtonTransparent { //was zero button
                        width: height*2
                        Layout.alignment: Qt.AlignCenter
                        icon.source: prefix + "/images/SteerCenter.png"
                        implicitHeight: parent.height /5 -20* theme.scaleHeight
                        //visible: false
                        visible: steerBtn.checked
                        onClicked:  {Settings.as_wasOffset -= cpDegSlider.value *aog.steerAngleActual;
                        if (Math.abs(Settings.as_wasOffset)< 3900){ sendUdptimer.running = true}
                        else {timedMessage.addMessage(2000, "Exceeded Range", "Excessive Steer Angle - Cannot Zero");}
                                    }
                    }

                    SteerConfigSliderCustomized {
                        property int wasOffset: Settings.as_wasOffset
                        id: wasZeroSlider
                        centerTopText: qsTr("WAS Zero")
                        width: 200 * theme.scaleWidth
                        from: -4000
                        leftText: Utils.decimalRound(value / cpDegSlider.value, 2)
                        //onValueChanged: Settings.as_wasOffset = value * cpDegSlider.value, aog.modules_send_252()
                        onValueChanged: Settings.as_wasOffset = value * cpDegSlider.value, sendUdptimer.running = true
                        to: 4000
                        value: Settings.as_wasOffset / cpDegSlider.value
                        visible: steerBtn.checked
                    }
                    SteerConfigSliderCustomized {
                        id: cpDegSlider
                        centerTopText: qsTr("Counts per Degree")
                        from: 1
                        leftText: value
                        onValueChanged: Settings.as_countsPerDegree = value, sendUdptimer.running = true
                        stepSize: 1
                        to: 255
                        value: Math.round(Settings.as_countsPerDegree, 0)
                        width: 200 * theme.scaleWidth
                        visible: steerBtn.checked
                    }
                    SteerConfigSliderCustomized {
                        id: ackermannSlider
                        centerTopText: qsTr("AckerMann")
                        from: 1
                        leftText: value
                        onValueChanged: Settings.as_ackerman = value, sendUdptimer.running = true
                        stepSize: 1
                        to: 200
                        value: Math.round(Settings.as_ackerman, 0)
                        visible: steerBtn.checked
                    }
                    SteerConfigSliderCustomized {
                        id: maxSteerSlider
                        centerTopText:qsTr("Max Steer Angle")
                        from: 10
                        leftText: value
                        onValueChanged: Settings.vehicle_maxSteerAngle= value
                        stepSize: 1
                        to: 80
                        value: Math.round(Settings.vehicle_maxSteerAngle)
                        visible: steerBtn.checked
                    }

                    //endregion WAStab

                    //region PWMtab
                    SteerConfigSliderCustomized {
                        id: propGainlider
                        centerTopText: qsTr("Proportional Gain")
                        from: 0
                        leftText: value
                        onValueChanged: Settings.as_Kp = value, sendUdptimer.running = true
                        stepSize: 1
                        to: 200
                        value: Math.round(Settings.as_Kp, 0)
                        visible: gainBtn.checked
                    }
                    SteerConfigSliderCustomized {
                        id: maxLimitSlider
                        centerTopText: qsTr("Maximum Limit")
                        from: 0
                        leftText: value
                        onValueChanged: Settings.as_highSteerPWM = value, sendUdptimer.running = true
                        stepSize: 1
                        to: 254
                        value: Math.round(Settings.as_highSteerPWM, 0)
                        visible: gainBtn.checked
                    }
                    SteerConfigSliderCustomized {
                        id: min2moveSlider
                        centerTopText: qsTr("Minimum to Move")
                        from: 0
                        leftText: value
                        onValueChanged: Settings.as_minSteerPWM = value, sendUdptimer.running = true
                        stepSize: 1
                        to: 100
                        value: Math.round(Settings.as_minSteerPWM, 0)
                        visible: gainBtn.checked
                    }

                    //endregion PWMtab

                    //region StanleyTab
                    SteerConfigSliderCustomized {
                        id: stanleyAggressivenessSlider
                        centerTopText: qsTr("Agressiveness")
                        from: .1
                        onValueChanged: Settings.vehicle_stanleyDistanceErrorGain = value
                        stepSize: .1
                        to: 4
                        leftText: Math.round(value * 10)/10
                        value: Settings.vehicle_stanleyDistanceErrorGain
                        visible: stanleyBtn.checked
                    }
                    SteerConfigSliderCustomized {
                        id: overShootReductionSlider
                        centerTopText: qsTr("OverShoot Reduction")
                        from: .1
                        onValueChanged: Settings.vehicle_stanleyHeadingErrorGain = value
                        stepSize: .1
                        to: 1.5
                        leftText: Math.round(value * 10) / 10
                        value: Settings.vehicle_stanleyHeadingErrorGain
                        visible: stanleyBtn.checked
                    }
                    SteerConfigSliderCustomized {
                        id: integralStanleySlider
                        centerTopText: qsTr("Integral")
                        from: 0
                        leftText: value
                        onValueChanged: Settings.vehicle_stanleyIntegralGainAB = value /100
                        stepSize: 1
                        to: 100
                        value: Math.round(Settings.vehicle_stanleyIntegralGainAB * 100, 0)
                        visible: stanleyBtn.checked
                    }

                    //endregion StanleyTab
                    //
                    //region PurePursuitTab
                    SteerConfigSliderCustomized {
                        id: acqLookAheadSlider
                        centerTopText: qsTr("Acquire Look Ahead")
                        from: 1
                        onValueChanged: Settings.vehicle_goalPointLookAhead = value
                        stepSize: .1
                        leftText: Math.round(value * 10) / 10
                        to: 7
                        value: Settings.vehicle_goalPointLookAhead
                        visible: ppBtn.checked
                    }
                    SteerConfigSliderCustomized {
                        id: holdLookAheadSlider
                        centerTopText: qsTr("Hold Look Ahead")
                        from: 1
                        stepSize: .1
                        leftText: Math.round(value * 10) / 10
                        onValueChanged: Settings.vehicle_goalPointLookAheadHold = Utils.decimalRound(value, 1)
                        to: 7
                        value: Settings.vehicle_goalPointLookAheadHold
                        visible: ppBtn.checked
                    }
                    SteerConfigSliderCustomized {
                        id: lookAheadSpeedGainSlider
                        centerTopText: qsTr("Look Ahead Speed Gain")
                        from: .5
                        onValueChanged: Settings.vehicle_goalPointLookAheadMult = value
                        stepSize: .1
                        to: 3
                        leftText: Math.round(value * 10) / 10
                        value: Settings.vehicle_goalPointLookAheadMult
                        visible: ppBtn.checked
                    }
                    SteerConfigSliderCustomized {
                        id: ppIntegralSlider
                        centerTopText: qsTr("Integral")
                        from: 0
                        onValueChanged: Settings.vehicle_purePursuitIntegralGainAB = value /100
                        stepSize: 1
                        to: 100
                        leftText: Math.round(value *10) / 10
                        value: Settings.vehicle_purePursuitIntegralGainAB *100
                        visible: ppBtn.checked
                    }
                    //endregion PurePursuitTab
                }
                Image {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    height: slidersColumn.height
                    source: prefix + (steerBtn.checked === true ? "/images/Steer/Sf_SteerTab.png" :
                                     gainBtn.checked === true ? "/images/Steer/Sf_GainTab.png" :
                                     stanleyBtn.checked === true ? "/images/Steer/Sf_Stanley.png" :
                                    "/images/Steer/Sf_PP.png")
                    width: parent.width
                }
            }

            Rectangle{
                id: angleInfo
                anchors.bottom: parent.bottom
                //anchors.left: parent.left
                //anchors.right: parent.right
                height: 50 * theme.scaleHeight
                width: parent.width - 10 * theme.scaleWidth
                anchors.horizontalCenter: parent.horizontalCenter

                MouseArea{
                    id: angleInfoMouse
                    anchors.fill: parent
                    onClicked: pwmWindow.visible = !pwmWindow.visible

                }
                RowLayout{
                    id: angleInfoRow
                    anchors.fill: parent
                    spacing: 10 * theme.scaleWidth

                    Text {
                        text: qsTr("Set: " + aog.steerAngleSetRounded)
                        //text: qsTr("Set: " + aog.steerAngleSet)
                        Layout.alignment: Qt.AlignCenter
                    }
                    Text {
                        text: qsTr("Act: " + aog.steerAngleActualRounded)
                        Layout.alignment: Qt.AlignCenter
                    }
                    Text {
                        property double err: aog.steerAngleActualRounded - aog.steerAngleSetRounded
                        id: errorlbl
                        Layout.alignment: Qt.AlignCenter
                        onErrChanged: err > 0 ? errorlbl.color = "red" : errorlbl.color = "darkgreen"
                        text: qsTr("Err: " + Math.round(err*10)/10)
                    }
                    IconButtonTransparent{
                        //show angle info window
                        Layout.alignment: Qt.AlignRight
                        icon.source: prefix + "/images/ArrowRight.png"
                        implicitHeight: parent.height
                        implicitWidth: parent.width/4
                        onClicked: steerConfigSettings.show()
                    }
                }
            }
        }
        Rectangle{
            id: pwmWindow
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8 * theme.scaleHeight
            //anchors.left: steerSlidersConfig.left
            anchors.top: steerSlidersConfig.bottom
            anchors.topMargin: 8 * theme.scaleHeight
            visible: false
            height: children
            width: steerConfigWindow.width-10 * theme.scaleWidth
            anchors.horizontalCenter: parent.horizontalCenter

            RowLayout{
                id: pwmRow
                anchors.bottomMargin: 10 * theme.scaleHeight
                //anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 10 * theme.scaleHeight
                height: 50 * theme.scaleHeight
                width: parent.width - 10 * theme.scaleWidth
                anchors.horizontalCenter: parent.horizontalCenter

                IconButton{
                    id: btnFreeDrive
                    border: 2
                    color3: "white"
                    icon.source: prefix + "/images/SteerDriveOff.png"
                    iconChecked: prefix + "/images/SteerDriveOn.png"
                    implicitHeight: parent.height
                    implicitWidth:  parent.width /4 - 4
                    isChecked: false
                    checkable: true
                    onClicked: aog.btnFreeDrive()
                }
                IconButton{
                    //id: btnSteerAngleDown
                    border: 2
                    color3: "white"
                    icon.source: prefix + "/images/SnapLeft.png"
                    implicitHeight: parent.height
                    implicitWidth:  parent.width /4 - 5 * theme.scaleWidth
                    onClicked: aog.btnSteerAngleDown()
                    enabled: btnFreeDrive.checked
                }
                IconButton{
                    //id: btnSteerAngleUp
                    border: 2
                    color3: "white"
                    icon.source: prefix + "/images/SnapRight.png"
                    implicitHeight: parent.height
                    implicitWidth:  parent.width /4 - 5 * theme.scaleWidth
                    onClicked: aog.btnSteerAngleUp()
                    enabled: btnFreeDrive.checked
                }
                IconButton{
                    //id: btnFreeDriveZero
                    border: 2
                    color3: "white"
                    icon.source: prefix + "/images/SteerZeroSmall.png"
                    implicitHeight: parent.height
                    implicitWidth:  parent.width /4 - 5 * theme.scaleWidth
                    onClicked: aog.btnFreeDriveZero()
                }
            }
            Text{
                anchors.left: pwmRow.left
                anchors.top: pwmRow.bottom
                text: qsTr("PWM: "+ aog.lblPWMDisplay)
            }
            Text{
                anchors.right: pwmRow.right
                anchors.rightMargin: 50 * theme.scaleWidth
                anchors.top: pwmRow.bottom
                font.pixelSize: 15
                text: qsTr("0r +5")
            }
            IconButton{
                id: btnStartSA
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                border: 2
                color3: "white"
                height: 75 * theme.scaleHeight
                icon.source: prefix + "/images/BoundaryRecord.png"
                iconChecked: prefix + "/images/Stop.png"
                isChecked: aog.startSA
                checkable: true
                width: 75 * theme.scaleWidth
                onClicked: aog.btnStartSA()
            }
            Text{
                anchors.top: btnStartSA.top
                anchors.left: btnStartSA.right
                anchors.leftMargin: 5 * theme.scaleWidth
                text: qsTr("Steer Angle: "+ aog.lblCalcSteerAngleInner)
                Layout.alignment: Qt.AlignCenter
            }
            Text{
                anchors.bottom: btnStartSA.bottom
                anchors.left: btnStartSA.right
                anchors.leftMargin: 5 * theme.scaleWidth
                text: qsTr("Diameter: " + aog.lblDiameter)
                Layout.alignment: Qt.AlignCenter
            }
        }
    }
    Timer {
        id: sendUdptimer
        interval: 1000;
        onTriggered:  aog.modules_send_252()
    }
}
