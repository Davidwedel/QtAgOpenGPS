import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
//import QtQuick.Controls.Styles 1.4

import ".."
import "../components"

Rectangle{
	anchors.fill: parent
	visible: true
    color: aog.backgroundColor
    TextLine{
		id: text
		anchors.top: parent.top
		anchors.horizontalCenter: parent.horizontalCenter
        text: qsTr("<h1>Attachment Style</h1>")
	}
	GridLayout{
		anchors.top: text.bottom
		anchors.horizontalCenter: parent.horizontalCenter
        width: 650 * theme.scaleWidth
        height: 450 * theme.scaleHeight
		rows:2
		columns: 2
        flow:Grid.TopToBottom

        ButtonGroup {
            buttons: [ i3pt, i3ptfront, itrailed, iTBT]
        }

		IconButtonColor{
            implicitWidth:300 * theme.scaleWidth
            implicitHeight:200 * theme.scaleHeight
			id: i3pt
            icon.source: "/images/ToolChkRear.png"
            checkable: true
            isChecked: settings.setTool_isToolRearFixed
            onClicked: {
                settings.setTool_isToolRearFixed = true
                settings.setTool_isToolFront = false
                settings.setTool_isToolTrailing = false
                settings.setTool_isToolTBT = false
            }
		}

		IconButtonColor{
            implicitWidth:300 * theme.scaleWidth
            implicitHeight:200 * theme.scaleHeight
			id: i3ptfront
            icon.source: "/images/ToolChkFront.png"
            checkable: true
            isChecked: settings.setTool_isToolFront
            onClicked: {
                settings.setTool_isToolRearFixed = false
                settings.setTool_isToolFront = true
                settings.setTool_isToolTrailing = false
                settings.setTool_isToolTBT = false
            }
        }

		IconButtonColor{
            implicitWidth:300 * theme.scaleWidth
            implicitHeight:200 * theme.scaleHeight
			id: itrailed
            icon.source: "/images/ToolChkTrailing.png"
            checkable: true
            isChecked: settings.setTool_isToolTrailing && ! settings.setTool_isToolTBT
            onClicked: {
                settings.setTool_isToolRearFixed = false
                settings.setTool_isToolFront = false
                settings.setTool_isToolTrailing = true
                settings.setTool_isToolTBT = false
            }
        }
		IconButtonColor{
            implicitWidth:300 * theme.scaleWidth
            implicitHeight:200 * theme.scaleHeight
			id: iTBT
            icon.source: "/images/ToolChkTBT.png"
            checkable: true
            isChecked: settings.setTool_isToolTBT
            onClicked: {
                settings.setTool_isToolRearFixed = false
                settings.setTool_isToolFront = false
                settings.setTool_isToolTrailing = true
                settings.setTool_isToolTBT = true
            }
        }
	}
}
