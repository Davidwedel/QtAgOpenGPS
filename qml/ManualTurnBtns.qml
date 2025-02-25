import QtQuick
import AOG
import Settings
import "components" as Comp

Grid{
    id: gridTurnBtns //lateral turn and manual Uturn
    spacing: 10
    rows: 2
    columns: 2
    flow: Grid.LeftToRight
    visible: aog.isBtnAutoSteerOn
    Comp.IconButtonTransparent{
        implicitHeight: 65 * theme.scaleHeight
        implicitWidth: 85 * theme.scaleWidth
        imageFillMode: Image.Stretch
        icon.source: prefix + "/images/qtSpecific/z_TurnManualL.png"
        onClicked: {
            if (Settings.as_functionSpeedLimit > aog.speedKph) {
                console.debug("limit ", Settings.as_functionSpeedLimit, " speed ", aog.speedKph)
                aog.uturn(false)
            } else
                timedMessage.addMessage(2000,qsTr("Too Fast"), qsTr("Slow down below") + " " +
                                        Utils.speed_to_unit_string(Settings.as_functionSpeedLimit,1) + " " + Utils.speed_unit())
        }

    }

    Comp.IconButtonTransparent{
        implicitHeight: 65 * theme.scaleHeight
        implicitWidth: 85 * theme.scaleWidth
        imageFillMode: Image.Stretch
        icon.source: prefix + "/images/qtSpecific/z_TurnManualR.png"
        onClicked: {
            if (Settings.as_functionSpeedLimit > aog.speedKph)
                aog.uturn(true)
            else
                timedMessage.addMessage(2000,qsTr("Too Fast"), qsTr("Slow down below") + " " +
                                        Utils.speed_to_unit_string(Settings.as_functionSpeedLimit,1) + " " + Utils.speed_unit())
        }
    }
    Comp.IconButtonTransparent{
        implicitHeight: 65 * theme.scaleHeight
        implicitWidth: 85 * theme.scaleWidth
        imageFillMode: Image.Stretch
        icon.source: prefix + "/images/qtSpecific/z_LateralManualL.png"
        onClicked: {
            if (Settings.as_functionSpeedLimit > aog.speedKph)
                aog.lateral(false)
            else
                timedMessage.addMessage(2000,qsTr("Too Fast"), qsTr("Slow down below") + " " +
                                        Utils.speed_to_unit_string(Settings.as_functionSpeedLimit,1) + " " + Utils.speed_unit())
        }
    }
    Comp.IconButtonTransparent{
        implicitHeight: 65 * theme.scaleHeight
        implicitWidth: 85 * theme.scaleWidth
        imageFillMode: Image.Stretch
        icon.source: prefix + "/images/qtSpecific/z_LateralManualR.png"
        onClicked: {
            if (Settings.as_functionSpeedLimit > aog.speedKph)
                aog.lateral(true)
            else
                timedMessage.addMessage(2000,qsTr("Too Fast"), qsTr("Slow down below") + " " +
                                        Utils.speed_to_unit_string(Settings.as_functionSpeedLimit,1) + " " + Utils.speed_unit())
        }
    }
}
