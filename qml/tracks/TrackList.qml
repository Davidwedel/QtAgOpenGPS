// Copyright (C) 2024 Michael Torrie and the QtAgOpenGPS Dev Team
// SPDX-License-Identifier: GNU General Public License v3.0 or later
//
// The window where we select which track we want
import QtQuick
import QtQuick.Controls
//import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQml.Models
import Interface
import AOG
import "../components"
import ".."

MoveablePopup {
    //AOGInterface {
    //    id: aog //temporary
    //}
    id: trackPickerDialog

    width: 600
    height: 450

    modal: true

	function show() {
		trackPickerDialog.visible = true
	}

    onVisibleChanged:  {
        //when we show or hide the dialog, ask the main
        //program to update our lines list in the
        //AOGInterface object
        //linesInterface.abLine_updateLines()
        trackView.currentIndex = TracksInterface.idx
        //preselect first AB line if none was in use before
        //to make it faster for user
        if (trackView.currentIndex < 0)
            if (TracksInterface.model.count > 0)
                trackView.currentIndex = 0
    }

    TrackNewButtons {
        id: trackNewButtons
        visible: false
    }

    Rectangle{
        anchors.fill: parent
        border.width: 1
        border.color: aog.blackDayWhiteNight
        color: aog.backgroundColor
        TopLine{
            id: topLine
            titleText: qsTr("Tracks")

            onBtnCloseClicked: {
                trackPickerDialog.close()
            }
        }
        ColumnLayout{
            id: leftColumn
            anchors.top: topLine.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.rightMargin: 1
            anchors.bottomMargin: 1
            width: childrenRect.width
            IconButtonTransparent{
				icon.source: prefix + "/images/Trash.png"
				onClicked: {
                    if (trackView.currentIndex > -1) {
                        TracksInterface.delete_track(trackView.currentIndex)
					}
				}
            }
            IconButtonTransparent{
                icon.source: prefix + "/images/FileEditName.png"
                onClicked: {
                    if (trackView.currentIndex > -1) {
                        editLineName.set_name(linesInterface.abLinesList[trackView.currentIndex].name)
                        editLineName.visible = true
                    }
                }
            }
            IconButtonTransparent{
                objectName: "btnLineCopy"
                icon.source: prefix + "/images/FileCopy.png"
                onClicked: {
                    if(trackView.currentIndex > -1) {
                        var name = TracksInterface.getTrackName(trackView.currentIndex)
                        if (name) {
                            name = "Copy of " + name

                            TracksInterface.copy(trackView.currentIndex, name)
                        }
                    }
                }
            }
            IconButtonTransparent{
                objectName: "btnLineSwapPoints"
                icon.source: prefix + "/images/ABSwapPoints.png"
                onClicked: {
                    if(trackView.currentIndex > -1)
                        linesInterface.abLine_swapHeading(trackView.currentIndex);
                }
            }
            IconButtonTransparent{
				icon.source: prefix + "/images/Cancel64.png"
				onClicked: {
					trackPickerDialog.visible = false
				}
			}
		}
		ColumnLayout{
			id: rightColumn
			anchors.top: topLine.bottom
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.rightMargin: 1
            anchors.bottomMargin: 1
            width: childrenRect.width
            IconButtonTransparent{ //not sure what this does in aog--doesn't work on wine
                icon.source: prefix + "/images/UpArrow64.png"
            }
            IconButtonTransparent{
                icon.source: prefix + "/images/DnArrow64.png"
            }
            IconButtonTransparent{
                icon.source: prefix + "/images/ABLinesHideShow.png"

                onClicked: {
                    TracksInterface.setVisible(trackView.currentIndex, !TracksInterface.getTrackVisible(trackView.currentIndex))
                }
            }
			IconButtonTransparent{
				icon.source: prefix + "/images/AddNew.png"
				onClicked: {
                    trackNewButtons.show()
                    trackPickerDialog.visible = false
				}
			}
            IconButtonTransparent{
                objectName: "btnLineExit" //this is not cancel, rather, save and exit
                icon.source: prefix + "/images/OK64.png"
                onClicked: {
                    trackPickerDialog.visible = false
                    if (trackView.currentIndex > -1) {
                        if (TracksInterface.getTrackVisible(trackView.currentIndex)) {
                            console.debug("Activating track ", trackView.currentIndex)
                            TracksInterface.select(trackView.currentIndex)
                        } else {
                            timedMessage.addMessage(2000, qsTr("Track not visible!"), qsTr("Cannot Desired because it is not marked as visible."))
                        }
                    }
                    trackPickerDialog.visible = false
                }
            }
        }
        Rectangle{
            id: listrect
            anchors.left: leftColumn.right
            anchors.top:topLine.bottom
            anchors.right: rightColumn.left
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.margins: 10

            //ListModel { //this will be populated by the backend cpp code
              //  id: trackModel
                //objectName: "trackModel"
			//}

            //See MockTrack.qml for static test model

            TracksListView {
                id: trackView
                anchors.fill: parent
                model: TracksInterface.model
                //property int currentIndex: -1

                clip: true
            }
        }
    }
}

