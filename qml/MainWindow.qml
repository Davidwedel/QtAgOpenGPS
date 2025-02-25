// Copyright (C) 2024 Michael Torrie and the QtAgOpenGPS Dev Team
// SPDX-License-Identifier: GNU General Public License v3.0 or later

// Displays the main QML page. All other QML windows are children of this one.
//Loaded by formgps_ui.cpp.
import QtQuick
import QtQuick.Window
import QtQuick.Effects
import QtQuick.Dialogs
import Settings
import Interface
import AOG

import "interfaces" as Interfaces
import "boundary" as Boundary
import "steerconfig" as SteerConfig
import "config" as ConfigSettings //"Config" causes errors
import "field" as Field
import "tracks" as Tracks
import "components" as Comp

Window {


    AOGTheme{
        id: theme
        objectName: "theme"
    }
    //We draw native opengl to this root object
    id: mainWindow
    objectName: "mainWindow"

    height: theme.defaultHeight
    width: theme.defaultWidth

    onVisibleChanged: if(Settings.display_isStartFullscreen){
                          mainWindow.showMaximized()
                      }

    signal save_everything()

    function close() {
        if (areWindowsOpen()) {
            timedMessage.addMessage(2000,qsTr("Some windows are open. Close them first."))
            console.log("some windows are open. close them first")
            return
        }
        if (aog.autoBtnState + aog.manualBtnState  > 0) {
            timedMessage.addMessage(2000,qsTr("Section Control on. Shut off Section Control."))
            close.accepted = false
            console.log("Section Control on. Shut off Section Control.")
            return
        }
        if (mainWindow.visibility !== (Window.FullScreen) && mainWindow.visibility !== (Window.Maximized)){
            Settings.window_size = ((mainWindow.width).toString() + ", "+  (mainWindow.height).toString())
        }

        if (aog.isJobStarted) {
            closeDialog.visible = true
            close.accepted = false
            console.log("job is running. close it first")
            return
        }
        Qt.quit()
    }
    function areWindowsOpen() {
        if (config.visible === true) {
            console.log("config visible")
            return true
        }
        else if (headlandDesigner.visible === true) {
            console.log("headlandDesigner visible")
            return true
        }
        else if (headacheDesigner.visible === true) {
            console.log("headacheDesigner visible")
            return true
        }
        else if (steerConfigWindow.visible === true) {
            console.log("steerConfigWindow visible")
            return true
        }
        /*
        else if (abCurvePicker.visible === true) {
            console.log("abCurvePicker visible")
            return true
        }
        else if (abLinePicker.visible === true) {
            console.log("abLinePicker visible")
            return true
        }*/
        else if (tramLinesEditor.visible === true) {
            console.log("tramLinesEditor visible")
            return true
        }
        else if (lineEditor.visible === true) {
            console.log("lineEditor visible")
            return true
        }
        //if (boundaryMenu.visible == true) return false
        //if (lineDrawer.visible) return false
        //if (lineNudge.acive) return false
        //if (refNudge.acive) return false
        else if (setSimCoords.visible === true) {
            console.log("setSimCoords visible")
            return true
        }
        /* Must implement the new track dialog
        else if (trackNew.visible === true) {
            console.log("trackNew visible")
            return true
        }*/
        else if (fieldNew.visible === true) {
            console.log("FieldNew visible")
            return true
        }
        //if (fieldFromKML.visible) return false
        else if (fieldOpen.visible === true) return true
        //if (contextFlag.visible == true) return false
        else return false
    }

    AOGInterface {
        id: aog
        objectName: "aog"
    }

    Interfaces.FieldInterface {
        id: fieldInterface
        objectName: "fieldInterface"
    }

    Interfaces.BoundaryInterface {
        id: boundaryInterface
        objectName: "boundaryInterface"
    }

    Interfaces.RecordedPathInterface {
        id: recordedPathInterface
        objectName: "recordedPathInterface"
    }

    Comp.TimedMessage {
        //This is a popup message that dismisses itself after a timeout
        id: timedMessage
        objectName: "timedMessage"
    }

    SystemPalette {
        id: systemPalette
        colorGroup: SystemPalette.Active
    }

    MainTopPanel{
        id: topLine
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
    }


    AOGRenderer {
        id: glcontrolrect
        objectName: "openglcontrol"

        anchors.top: topLine.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        //for moving the center of the view around
        property double shiftX: 0 //-1 left to 1 right
        property double shiftY: 0 //-1 down to 1 up

        signal clicked(var mouse)
        signal dragged(int fromX, int fromY, int toX, int toY)
        signal zoomOut()
        signal zoomIn()

        MouseArea {
            id: mainMouseArea
            anchors.fill: parent

            property int fromX: 0
            property int fromY: 0
            property Matrix4x4 clickModelView
            property Matrix4x4 clickProjection
            property Matrix4x4 panModelView
            property Matrix4x4 panProjection

            onClicked: function(mouse) {
                parent.clicked(mouse)
            }

            onPressed: if(aog.panMode){
                           //save a copy of the coordinates
                           fromX = mouseX
                           fromY = mouseY
                       }

            onPositionChanged: if(aog.panMode){
                                   parent.dragged(fromX, fromY, mouseX, mouseY)
                                   fromX = mouseX
                                   fromY = mouseY
                               }

            onWheel:(wheel)=>{
                        if (wheel.angleDelta.y > 0) {
                            aog.zoomIn()
                        } else if (wheel.angleDelta.y <0 ) {
                            aog.zoomOut()
                        }
                    }

            Image {
                id: reverseArrow
                x: aog.vehicle_xy.x - 150
                y: aog.vehicle_xy.y - height
                width: 70 * theme.scaleWidth
                height: 70 * theme.scaleHeight
                source: prefix + "/images/Images/z_ReverseArrow.png"
                visible: VehicleInterface.isReverse || VehicleInterface.isChangingDirection
            }
            MouseArea{
                //button that catches any clicks on the vehicle in the GL Display
                id: resetDirection
                onClicked: {
                    aog.reset_direction()
                    console.log("reset direction")
                }
                propagateComposedEvents: true
                x: aog.vehicle_bounding_box.x
                y: aog.vehicle_bounding_box.y
                width: aog.vehicle_bounding_box.width
                height: aog.vehicle_bounding_box.height
                onPressed: (mouse)=>{
                               aog.reset_direction()
                               console.log("pressed")
                               mouse.accepted = false

                           }
            }
            //            Rectangle{
            //              // to show the reset vehicle direction button for testing purposes
            //                color: "blue"
            //                anchors.fill: resetDirection
            //            }
        }

    }

    Rectangle{
        id: noGPS
        anchors.fill: glcontrolrect
        color: "#0d0d0d"
        visible: aog.sentenceCounter> 29
        onVisibleChanged: if(visible){
                              console.log("no gps now visible")
                          }

        Image {
            id: noGPSImage
            source: prefix + "/images/Images/z_NoGPS.png"
            anchors.centerIn: parent
            anchors.margins: 200
            visible: noGPS.visible
            height: parent.height /2
            width: height
        }
    }

    Item {//item to hold all the main window buttons. Fills all of main screen

        id: buttonsArea
        anchors.top: parent.top
        anchors.topMargin: 2 //TODO: convert to scalable //do we need?
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        MainLeftColumn {
            id: leftColumn
            anchors.top: parent.top
            anchors.topMargin: topLine.height
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.leftMargin: 6
        }

        Speedometer {
            anchors.top: parent.top
            anchors.right: rightColumn.left
            anchors.topMargin: topLine.height + 10
            anchors.margins: 10
            visible: Settings.menu_isSpeedoOn

            speed: Utils.speed_to_unit(aog.speedKph)
        }

        SteerCircle { //the IMU indicator on the bottom right -- Called the "SteerCircle" in AOG
            anchors.bottom: bottomButtons.top
            anchors.right: rightColumn.left
            anchors.margins: 10
            visible: true
            rollAngle: aog.imuRollDegrees
            steerColor: (aog.steerModuleConnectedCounter > 30 ?
                             "#f0f218f0" :
                             (aog.steerSwitchHigh === true ?
                                  "#faf80007" :
                                  (aog.isBtnAutoSteerOn === true ?
                                       "#f80df807" : "#f0f2c007")))

        }

        MainRightColumn{
            id: rightColumn
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.topMargin: topLine.height + 6
            anchors.rightMargin: 6
        }


        Comp.IconButton {
            id: btnContourPriority
            anchors.top: parent.top
            anchors.topMargin: theme.buttonSize + 3
            anchors.right: rightColumn.left
            anchors.rightMargin: 3
            checkable: true
            isChecked: true
            visible: false
            icon.source: prefix + "/images/ContourPriorityLeft.png"
            iconChecked: prefix + "/images/ContourPriorityRight.png"
            onClicked: aog.btnContourPriority(checked)
        }

        MainBottomRow{
            id: bottomButtons
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.leftMargin: leftColumn.width + 3
            anchors.right: parent.right
            anchors.rightMargin: rightColumn.width + 3
        }

        //----------------inside buttons-----------------------
        Item{
            //plan to move everything on top of the aogRenderer that isn't
            //in one of the buttons columns
            id: inner
            anchors.left: leftColumn.right
            anchors.top: parent.top
            anchors.topMargin: topLine.height
            anchors.right: rightColumn.left
            anchors.bottom: bottomButtons.top
            visible: !noGPS.visible
            Comp.IconButtonTransparent{ //button to pan around main GL
                implicitWidth: 50
                implicitHeight: 50 * theme.scaleHeight
                checkable: true
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: 30
                icon.source: prefix + "/images/Pan.png"
                iconChecked: prefix + "/images/SwitchOff.png"
                onClicked: aog.panMode = !aog.panMode
            }
            Image{
                id: hydLiftIndicator
                property bool isDown: aog.hydLiftDown
                visible: false
                source: prefix + "/images/Images/z_Lift.png"
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: 80 * theme.scaleWidth
                height: 130 * theme.scaleHeight
                onIsDownChanged: {
                    if(!isDown){
                        hydLiftIndicatorColor.color = "#00F200"
                        hydLiftIndicatorColor.rotation = 0
                    }else{
                        hydLiftIndicatorColor.rotation = 180
                        hydLiftIndicatorColor.color = "#F26600"
                    }
                }
            }
            MultiEffect{
                id: hydLiftIndicatorColor
                anchors.fill: hydLiftIndicator
                visible: bottomButtons.hydLiftIsOn
                colorizationColor:"#F26600"
                colorization: 1.0
                source: hydLiftIndicator
            }

            Comp.OutlineText{
                id: simulatorOnText
                visible: Settings.menu_isSimulatorOn
                anchors.top: parent.top
                anchors.topMargin: lightbar.height+ 10
                anchors.horizontalCenter: lightbar.horizontalCenter
                font.pixelSize: 30
                color: "#cc5200"
                text: qsTr("Simulator On")
            }

            Comp.OutlineText{
                id: ageAlarm //Lost RTK count up display
                property int age: aog.age
                visible: Settings.gps_isRTK
                anchors.top: simulatorOnText.bottom
                anchors.topMargin: 30
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Lost RTK")
                font.pixelSize: 65
                color: "#cc5200"
                onAgeChanged: {
                    if (age < 20)
                        text = ""
                    else if (age> 20 && age < 60)
                        text = qsTr("Age: ")+age
                    else
                        text = "Lost RTK"
                }
                onTextChanged: if (text.length > 0)
                                   console.log("rtk alarm sound")

            }

            AutoUturnBtn{
                id: autoTurn // where the auto turn button and distance to turn are held
                anchors.top:gridTurnBtns.top
                anchors.right: parent.right
                anchors.rightMargin: 200
                width: 100 * theme.scaleWidth
                height: 100 * theme.scaleHeight
            }

            ManualTurnBtns{
                id: gridTurnBtns
                anchors.top: lightbar.bottom
                anchors.left: parent.left
                anchors.topMargin: 30
                anchors.leftMargin: 150
            }

            LightBar {
                id: lightbar
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: 5
                dotDistance: aog.avgPivDistance / 10 //avgPivotDistance is averaged
                visible: (aog.offlineDistance != 32000 &&
                          (Settings.menu_isLightBarOn === true ||
                           Settings.menu_isLightBarOn === "true")) ?
                             true : false
            }

            TrackNum {
                id: tracknum
                anchors.top: lightbar.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: 5

                font.pixelSize: 24

                //only use dir names for AB Lines with heading
                useDirNames: (aog.currentABLine > -1)
                currentTrack: aog.current_trackNum

                trackHeading: aog.currentABLine > -1 ?
                                  aog.currentABLine_heading :
                                  0

                visible: (Utils.isTrue(Settings.display_topTrackNum) &&
                          ((aog.currentABLine > -1) ||
                           (aog.currentABCurve > -1)))
                //TODO add contour
            }

            TramIndicators{
                id: tramLeft
                anchors.top: tracknum.bottom
                anchors.margins: 30
                anchors.left: parent.horizontalCenter
                visible: Settings.feature_isTramOn
            }
            TramIndicators{
                id: tramRight
                anchors.top: tracknum.bottom
                anchors.margins: 30
                anchors.right: parent.horizontalCenter
                visible: Settings.feature_isTramOn
            }

            //Components- this is where the windows that get displayed over the
            //ogl get instantiated.
            Field.FieldData{ //window that displays field acreage and such
                id: fieldData
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                visible: false
            }
            GPSData{ //window that displays GPS data
                id: gpsData
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                visible: false
            }
            BlockageData{ //window that displays GPS data
                id: blockageData
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                visible: (aog.blockageConnected & Settings.seed_blockageIsOn) ? true : false
            }

            SimController{
                id: simBarRect
                //z: 2
                anchors.bottom: timeText.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: 8
                visible: Utils.isTrue(Settings.menu_isSimulatorOn)
                height: 60 * theme.scaleHeight
                onHeightChanged: anchors.bottomMargin = (8 * theme.scaleHeight)
            }
            RecPath{// recorded path menu
                id: recPath
                visible: false
            }

            Comp.OutlineText{ //displays time on bottom right of GL
                id: timeText
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.rightMargin: (50 * theme.scaleWidth)
                font.pixelSize: 20
                color: "#cc5200"
                Timer{
                    interval: 100
                    repeat: true
                    running: true
                    onTriggered: timeText.text = Qt.formatTime(new Date(), "HH:mm:ss")
                }
            }
            Comp.SectionButtons {
                id: sectionButtons
                visible: aog.isJobStarted ? true : false
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: simBarRect.top
                anchors.bottomMargin: 8
                height: 40 * theme.scaleHeight
                width: 660  * theme.scaleWidth
                //onHeightChanged: anchors.bottomMargin = (bottomButtons.height + simBarRect.height + (24 * theme.scaleHeight))
            }
            Comp.BlockageRows {
                id: blockageRows
                visible: (aog.blockageConnected & Settings.seed_blockageIsOn) ? true : false  // need connect with c++ Dim
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 8
                height: 100 * theme.scaleHeight
                //width: 800  * theme.scaleWidth

            }
            DisplayButtons{ // window that shows the buttons to change display. Rotate up/down, day/night, zoom in/out etc. See DisplayButtons.qml
                id: displayButtons
                width: childrenRect.width + 10
                height: childrenRect.height + 10
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.top: parent.top
                anchors.topMargin: 20
                visible: false
                z:1
            }

            Tracks.TrackButtons{
                id: trackButtons
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 20
                visible: false
                z:1
            }
            Comp.IconButtonTransparent{ //button on bottom left to show/hide the bottom and right buttons
                id: toggleButtons
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.margins: 25
                visible: aog.isJobStarted
                width: 45 * theme.scaleWidth
                height: 25 * theme.scaleHeight
                icon.source: prefix + "/images/MenuHideShow.png"
                onClicked: if(leftColumn.visible){
                               leftColumn.visible = false
                           }else{
                               leftColumn.visible = true
                           }
            }
            Compass{
                id: compass
                anchors.top: parent.top
                anchors.right: zoomBtns.left
                heading: -Utils.radians_to_deg(aog.heading)
            }
            Column{
                id: zoomBtns
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 10
                spacing: 100
                width: children.width
                Comp.IconButton{
                    implicitWidth: 30 * theme.scaleWidth
                    implicitHeight: 30 * theme.scaleHeight
                    radius: 0
                    icon.source: prefix + "/images/ZoomIn48.png"
                    onClicked: aog.zoomIn()
                }
                Comp.IconButton{
                    implicitWidth: 30 * theme.scaleWidth
                    implicitHeight: 30 * theme.scaleHeight
                    radius: 0
                    icon.source: prefix + "/images/ZoomOut48.png"
                    onClicked: aog.zoomOut()
                }
            }
        }



        Comp.SliderCustomized { //quick dirty hack--the up and down buttons change this value, so the speed changes
            id: speedSlider
            //anchors.bottom: bottomButtons.top
            //            anchors.bottomMargin: 3
            //            anchors.left:bottomButtons.left
            //            anchors.leftMargin: 3
            from: -80
            to: 300
            value: 0
            visible: false
        }

        StartUp{ //splash we show on startup
            id: startUp
            z:10
            //visible: true
            visible: false  //no reason to look at this until release
        }


        Field.FieldToolsMenu {
            id: fieldTools
            visible: false
        }
        Field.FieldMenu {
            id: fieldMenu
            objectName: "slideoutMenu"
            visible: false
        }
        ToolsWindow {
            id: toolsMenu
            visible: false
        }
        HamburgerMenu{ // window behind top left on main GL
            id: hamburgerMenu
            visible: false
        }

        ConfigSettings.Config {
            id:config
            x: 0
            y: 0
            width: parent.width
            height: parent.height
            visible:false

            onAccepted: {
                console.debug("accepting settings and closing window.")
                aog.settings_save()
                aog.settings_reload()
            }
            onRejected: {
                console.debug("rejecing all settings changes.")
                aog.settings_revert()
                aog.settings_reload()
            }

        }
        HeadlandDesigner{
            id: headlandDesigner
            objectName: "headlandDesigner"
            //anchors.horizontalCenter: parent.horizontalCenter
            //anchors.verticalCenter: parent.verticalCenter
            visible: false
        }
        HeadAcheDesigner{
            id: headacheDesigner
            objectName: "headacheDesigner"
            //anchors.horizontalCenter: parent.horizontalCenter
            //anchors.verticalCenter: parent.verticalCenter
            visible: false
        }
        SteerConfig.SteerConfigWindow {
            id:steerConfigWindow
            visible: false
        }
        SteerConfig.SteerConfigSettings{
            id: steerConfigSettings
            visible: false
        }
        /*
        ABCurvePicker{
            id: abCurvePicker
            objectName: "abCurvePicker"
            visible: false
        }
        ABLinePicker{
            id: abLinePicker
            objectName: "abLinePicker"
            visible: false
        }*/
        TramLinesEditor{
            id: tramLinesEditor
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 150
            anchors.topMargin: 50
            visible: false
        }
        LineEditor{
            id: lineEditor
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 150
            anchors.topMargin: 50
            visible: false
        }
        Boundary.BoundaryMenu{
            id: boundaryMenu
            visible: false
        }

        Tracks.LineDrawer {//window where lines are created off field boundary/edited
            id:lineDrawer
            //anchors.horizontalCenter: parent.horizontalCenter
            //anchors.bottom: parent.bottom
            //height: 768
            //width:1024
            visible:false
        }
        Tracks.LineNudge{
            id: lineNudge
            visible: false
        }
        Tracks.RefNudge{
            id: refNudge
            visible: false
        }
        SetSimCoords{
            id: setSimCoords
            anchors.fill: parent
        }

        /*
        Tracks.TrackNewButtons{
            id: trackNewButtons
            visible: false
        }
        Tracks.TrackNewSet{
            id: trackNewSet
            anchors.fill: parent
        }
        */
        Tracks.TrackList{
            id: trackList
        }
        /*
        Tracks.TracksNewAddName{
            id: trackAddName
        }*/

        Rectangle{//show "Are you sure?" when close button clicked
            id: closeDialog
            width: 500 * theme.scaleWidth
            height: 100 * theme.scaleHeight
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            color: aog.backgroundColor
            border.color: aog.blackDayWhiteNight
            border.width: 2
            visible: false
            Comp.IconButtonText{
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                color1: "transparent"
                color2: "transparent"
                color3: "transparent"
                icon.source: prefix + "/images/back-button.png"
                onClicked: parent.visible = false
            }
            Comp.IconButtonText{
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                color1: "transparent"
                color2: "transparent"
                color3: "transparent"
                icon.source: prefix + "/images/ExitAOG.png"
                onClicked: {
                    mainWindow.save_everything()
                    Qt.quit()
                }
            }
        }
        Item{
            id: windowsArea      //container for declaring all the windows
            anchors.fill: parent //that can be displayed on the main screen
            Field.FieldFromExisting{
                id: fieldFromExisting
                x: 0
                y: 0
            }
            Field.FieldNew{
                id: fieldNew
            }
            Field.FieldFromKML{
                id: fieldFromKML
                x: 100
                y: 75
            }
            Field.FieldOpen{
                id: fieldOpen
                x: 100    }

            y: 75
        }
    }


    Rectangle {
        id: contextFlag
        objectName: "contextFlag"
        width: childrenRect.width+10
        height: childrenRect.height + 10
        color: "#bf163814"
        visible: false
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: theme.buttonSize + 10
        //anchors.topMargin: btnFlag.y
        border.color: "#c3ecc0"

        Grid {
            id: contextFlagGrid
            spacing: 5
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.left: parent.left
            anchors.leftMargin: 5

            width: childrenRect.width
            height: childrenRect.height

            columns: 5
            flow: Grid.LeftToRight

            Comp.IconButton {
                id: redFlag
                objectName: "btnRedFlag"
                icon.source: prefix + "/images/FlagRed.png";
            }
            Comp.IconButton {
                id: greenFlag
                objectName: "btnGreenFlag"
                icon.source: prefix + "/images/FlagGrn.png";
            }
            Comp.IconButton {
                id: yellowFlag
                objectName: "btnYellowFlag"
                icon.source: prefix + "/images/FlagYel.png";
            }
            Comp.IconButton {
                id: deleteFlag
                objectName: "btnDeleteFlag"
                icon.source: prefix + "/images/FlagDelete.png"
                enabled: false
            }
            Comp.IconButton {
                id: deleteAllFlags
                objectName: "btnDeleteAllFlags"
                icon.source: prefix + "/images/FlagDeleteAll.png"
                enabled: false
            }
        }
        /********************************dialogs***********************/
        ColorDialog{//color picker
            id: cpSectionColor
            onSelectedColorChanged: {

                //just use the Day setting. AOG has them locked to the same color anyways
                Settings.display_colorSectionsDay = cpSectionColor.selectedColor;

                //change the color on the fly. In AOG, we had to cycle the sections off
                //and back on. This does for us.
                if(btnSectionManual){
                    btnSectionManual.clicked()
                    btnSectionManual.clicked()
                }else if(btnSectionAuto){
                    btnSectionAuto.clicked()
                    btnSectionAuto.clicked()
                }
            }
        }
        CloseAOG{
            id: closeAOG
        }

    }
}

