import QtQuick
import QtQuick.Layouts
import Settings
import AOG
import Interface
import "components" as Comp

    Rectangle{
        id: topLine
        color: aog.backgroundColor
        height: 50 *theme.scaleHeight
        visible: true

        Comp.IconButtonTransparent {
            id: btnfileMenu
            height: parent.height
            width: 75 * theme.scaleWidth
            icon.source: prefix + "/images/fileMenu.png"
            onClicked: hamburgerMenu.visible = true
        }

        Text{
            anchors.top:parent.top
            anchors.left: parent.left
            anchors.leftMargin: leftColumn.width+20
            text: (aog.fixQuality === 0 ? "Invalid":
                   aog.fixQuality ===1 ? "GPS Single":
                   aog.fixQuality ===2 ? "DGPS":
                   aog.fixQuality ===3 ? "PPS":
                   aog.fixQuality ===4 ? "RTK Fix":
                   aog.fixQuality ===5 ? "RTK Float":
                   aog.fixQuality ===6 ? "Estimate":
                   aog.fixQuality ===7 ? "Man IP":
                   aog.fixQuality ===8 ? "Sim":
                   "Invalid") + ": Age: "+ Math.round(aog.age * 10)/ 10

            font.pixelSize: 20
            anchors.bottom: parent.verticalCenter
        }

        //        Text {
        //            anchors.top: parent.top
        //            anchors.left: parent.left
        //            anchors.leftMargin: 120
        //            text: qsTr("Field: "+ (aog.isJobStarted ? Settings.f_currentDir: "None"))
        //            anchors.bottom: parent.verticalCenter
        //            font.bold: true
        //            font.pixelSize: 15
        //        }
        Text {
            id: playText
            property string mainString: ""
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.leftMargin: 100
            text: (playTimer.running ? "■ " : "▶ ") + mainString
            anchors.top: parent.verticalCenter
            font.bold: true
            font.pixelSize: 15
        }
        MouseArea{
            anchors.top:playText.top
            anchors.left: playText.left
            height: playText.height
            width: height
            onClicked: playTimer.running = !playTimer.running
        }

        Timer{
            id: playTimer
            property int increment: -1
            /* increment:
              0: Time + Date
              1: Lat + Lon
              2: Vehicle
              3: Field
              4: App
              Else: Line*/
            running: true
            interval: 2000
            repeat: true
            onTriggered: {
                increment++
                if(increment == 0){
                    playText.mainString = Qt.formatDateTime(new Date(), "MM-dd-yyyy HH:mm:ss")
                }else if(increment == 1){
                    playText.mainString = qsTr("Lat: %1 Lon: %2")
                            .arg(Qt.locale().toString(aog.latitude,'f',7))
                            .arg(Qt.locale().toString(aog.longitude,'f',7))
                }else if(increment == 2){
                    playText.mainString = Utils.m_to_ft_string(Settings.vehicle_toolWidth) + " - " + Settings.vehicle_vehicleName
                    if(!aog.isJobStarted) //reset
                        increment = -1
                }else if(increment == 3){
                    playText.mainString = qsTr("Field: %1").arg(Settings.f_currentDir)
                }else if(increment == 4) {
                    var percentLeft = ""
                    if (aog.areaBoundaryOuterLessInner > 0) {
                        percentLeft = qsTr("%1%").arg(Qt.locale().toString((aog.areaBoundaryOuterLessInner - aog.workedAreaTotal) / aog.areaBoundaryOuterLessInner * 100, 'f', 0))
                    } else {
                        percentLeft = "--"
                    }
                    playText.mainString = qsTr("App: %1 Actual: %2 %3 %4")
                            .arg(Utils.area_to_unit_string(aog.workedAreaTotal, 2))
                            .arg(Utils.area_to_unit_string(aog.actualAreaCovered, 2))
                            .arg(percentLeft)
                            .arg(Utils.workRateString(aog.speedKph))
                }
                else {
                    if (TracksInterface.idx > -1) {
                        playText.mainString = qsTr("Track: %1").arg(TracksInterface.currentName)
                    } else {
                        playText.mainString = qsTr("Track: none active")
                    }

                    increment = -1 //reset
                }



            }
        }

        Text {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("ab")
            font.bold: true
            font.pixelSize: 15
        }
        Row{
            id: topRowWindow
            width: childrenRect.width
            height: parent.height
            anchors.top: parent.top
            anchors.right: parent.right
            spacing: 5 * theme.scaleWidth
            Comp.IconButton {
                id: btnFieldInfo
                icon.source: prefix + "/images/FieldStats.png"
                Layout.alignment: Qt.AlignCenter
                implicitWidth: theme.buttonSize
                height:parent.height
                visible: aog.isJobStarted
                onClicked: {
                    fieldData.visible = !fieldData.visible
                    gpsData.visible = false
                    blockageData.visible = false
                }
            }
            Comp.IconButtonColor{
                id: rtkStatus
                icon.source: prefix + "/images/GPSQuality.png"
                implicitWidth: 75 * theme.scaleWidth
                implicitHeight: parent.height
                color: "yellow"
                onClicked: {
                    gpsData.visible = !gpsData.visible
                    fieldData.visible = false
                    blockageData.visible = false
                }
                Connections{
                    target: aog
                    function onFixQualityChanged() {
                        if(aog.fixQuality == 4) rtkStatus.color = "green"
                        else if(aog.fixQuality == 5) rtkStatus.color = "orange"
                        else if(aog.fixQuality == 2) rtkStatus.color = "yellow"
                        else rtkStatus.color = "red"
                    }
                }

            }
            Comp.IconButton {
                id: btnBlockageInfo
                icon.source: prefix + "/images/Blockage.png"
                Layout.alignment: Qt.AlignCenter
                implicitWidth: theme.buttonSize
                height:parent.height
                visible: (aog.blockageConnected & Settings.seed_blockageIsOn) ? true : false
                onClicked: {
                    blockageData.visible = !blockageData.visible
                    gpsData.visible = false
                    fieldData.visible = false
                }
            }


            Text{
                id: speed
                anchors.verticalCenter: parent.verticalCenter
                width: 75 * theme.scaleWidth
                height:parent.height
                text: Utils.speed_to_unit_string(aog.speedKph, 1)
                font.bold: true
                font.pixelSize: 35
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            Comp.IconButtonTransparent{
                height: parent.height
                icon.source: prefix + "/images/WindowMinimize.png"
                width: 75 * theme.scaleWidth
                onClicked: mainWindow.showMinimized()
            }
            Comp.IconButtonTransparent{
                id: btnMaximize
                height: parent.height
                icon.source: prefix + "/images/WindowMaximize.png"
                width: 75 * theme.scaleWidth
                onClicked: {
                    console.debug("Visibility is " + mainWindow.visibility)
                    if (mainWindow.visibility == Window.FullScreen){
                        mainWindow.showNormal()
                    }else{
                        Settings.window_size = ((mainWindow.width).toString() + ", "+  (mainWindow.height).toString())
                        mainWindow.showFullScreen()
                    }
                }
            }
            Comp.IconButtonTransparent{
                height: parent.height
                width: 75 * theme.scaleWidth
                icon.source: prefix + "/images/WindowClose.png"
                onClicked: {
                    mainWindow.save_everything()
                    mainWindow.close()
                }
            }
        }
    }
