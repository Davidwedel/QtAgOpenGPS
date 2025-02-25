import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Settings
import AOG
import "components" as Comp

RowLayout{
    property bool hydLiftIsOn: btnHydLift.isOn
    id:bottomButtons
    visible: aog.isJobStarted && leftColumn.visible

    onWidthChanged: {
        theme.btnSizes[1] = width / (children.length)
        theme.buttonSizesChanged()
    }
    onVisibleChanged: {
        if (visible === false)
            height = 0
        else
            height = children.height

    }
    ComboBox {
        id: cbYouSkipNumber
        editable: true
        Layout.alignment: Qt.AlignCenter
        implicitWidth: theme.buttonSize
        implicitHeight: theme.buttonSize
        model: ListModel {
            id: model
            ListElement {text: "1"}
            ListElement {text: "2"}
            ListElement {text: "3"}
            ListElement {text: "4"}
            ListElement {text: "5"}
            ListElement {text: "6"}
            ListElement {text: "7"}
            ListElement {text: "8"}
            ListElement {text: "9"}
            ListElement {text: "10"}
        }
        onAccepted: {
            if (cbYouSkipNumber.find(currentText) === -1){
                model.append({text: editText})
                curentIndex = cbYouSkipNumber.find(editText)
            }
        }
    }
    Comp.MainWindowBtns {
        id: btnYouSkip // the "Fancy Skip" button
        isChecked: false
        checkable: true
        icon.source: prefix + "/images/YouSkipOff.png"
        iconChecked: prefix + "/images/YouSkipOn.png"
        buttonText: qsTr("YouSkips")
    }
    Comp.MainWindowBtns { //reset trailing tool to straight back
        id: btnResetTool
        icon.source: prefix + "/images/ResetTool.png"
        buttonText: qsTr("Reset Tool")
        onClicked: aog.btnResetTool()
        visible: Settings.tool_isToolTrailing === true //hide if front or rear 3 pt
    }
    Comp.MainWindowBtns {
        id: btnSectionMapping
        icon.source: prefix + "/images/SectionMapping.png"
        onClicked: cpSectionColor.open()
    }
    Comp.MainWindowBtns {
        id: btnTramLines
        icon.source: prefix + "/images/TramLines.png"
        buttonText: qsTr("Tram Lines")
        Layout.alignment: Qt.AlignCenter
        implicitWidth: theme.buttonSize
        implicitHeight: theme.buttonSize
        visible: Settings.feature_isTramOn
    }
    Comp.MainWindowBtns {
        property bool isOn: false
        id: btnHydLift
        isChecked: isOn
        checkable: true
        disabled: btnHeadland.checked
        visible: Utils.isTrue(Settings.ardMac_isHydEnabled) && btnHeadland.visible
        icon.source: prefix + "/images/HydraulicLiftOff.png"
        iconChecked: prefix + "/images/HydraulicLiftOn.png"
        buttonText: qsTr("HydLift")
        onClicked: {
            isOn = !isOn
            aog.isHydLiftOn(isOn)
        }
    }
    Comp.MainWindowBtns {
        id: btnHeadland
        isChecked: aog.isHeadlandOn
        checkable: true
        icon.source: prefix + "/images/HeadlandOff.png"
        iconChecked: prefix + "/images/HeadlandOn.png"
        buttonText: qsTr("Headland")
        onClicked: aog.btnHeadland()
    }
    Comp.MainWindowBtns {
        id: btnFlag
        objectName: "btnFlag"
        isChecked: false
        icon.source: prefix + "/images/FlagRed.png"
        onPressAndHold: {
            if (contextFlag.visible) {
                contextFlag.visible = false;
            } else {
                contextFlag.visible = true;
            }
        }
        buttonText: qsTr("Flag")
    }

    Comp.MainWindowBtns {
        id: btnTrack
        icon.source: prefix + "/images/TrackOff.png"
        iconChecked: prefix + "/images/TrackOn.png"
        buttonText: qsTr("Track")
        onClicked: trackButtons.visible = !trackButtons.visible
    }

}
