import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import AOG
import Settings
import "components" as Comp

ColumnLayout {
    id: leftColumn
    onHeightChanged: {
        theme.btnSizes[2] = height / (children.length)
        theme.buttonSizesChanged()
    }
    onVisibleChanged: if(visible === false)
                          width = 0
                      else
                          width = children.width
    Button {
        id: btnAcres
        implicitWidth: theme.buttonSize
        implicitHeight: theme.buttonSize
        Layout.alignment: Qt.AlignCenter
        onClicked: {
            aog.distanceUser = "0"
            aog.workedAreaTotalUser = "0"
        }

        background: Rectangle{
            anchors.fill: parent
            color: aog.backgroundColor
            radius: 10
            Text{
                anchors.top: parent.top
                anchors.bottom: parent.verticalCenter
                anchors.margins: 5
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                text: Utils.m_to_unit_string(aog.distanceUser, 2)
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: parent.height * .33
            }
            Text{
                anchors.top: parent.verticalCenter
                anchors.bottom: parent.bottom
                anchors.margins: 5
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                text: Utils.area_to_unit_string(aog.workedAreaTotalUser, 2)
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: parent.height * .33
            }
        }
    }
    Comp.MainWindowBtns {
        id: btnnavigationSettings
        buttonText: qsTr("Display")
        icon.source: prefix + "/images/NavigationSettings.png"
        onClicked: displayButtons.visible = !displayButtons.visible
    }
    Comp.MainWindowBtns {
        id: btnSettings
        buttonText: qsTr("Settings")
        icon.source: prefix + "/images/Settings48.png"
        onClicked: config.open()
    }
    Comp.MainWindowBtns {
        id: btnTools
        buttonText: qsTr("Tools")
        icon.source: prefix + "/images/SpecialFunctions.png"
        onClicked: toolsMenu.visible = true
    }
    Comp.MainWindowBtns{
        id: btnFieldMenu
        buttonText: qsTr("Field")
        icon.source: prefix + "/images/JobActive.png"
        onClicked: fieldMenu.visible = true
    }
    Comp.MainWindowBtns{
        id: btnFieldTools
        buttonText: qsTr("Field Tools")
        icon.source: prefix + "/images/FieldTools.png"
        onClicked: fieldTools.visible = true
        enabled: aog.isJobStarted ? true : false
    }

    Comp.MainWindowBtns {
        id: btnAgIO
        buttonText: qsTr("AgIO")
        icon.source: prefix + "/images/AgIO.png"
    }
    Comp.MainWindowBtns {
        id: btnautoSteerConf
        buttonText: qsTr("Steer config")
        icon.source: prefix + "/images/AutoSteerConf.png"
        onClicked: {
            steerConfigWindow.visible = true
            steerConfigWindow.show()
        }
    }
}
