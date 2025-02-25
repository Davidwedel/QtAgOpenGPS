import QtQuick
import QtQuick.Effects
import QtQuick.Controls
import AOG


Item{
    id: autoTurn // where the auto turn button and distance to turn are held
    width: 100 * theme.scaleWidth
    height: 100 * theme.scaleHeight

    Image{
        id: autoTurnImage
        source: if(!aog.isYouTurnRight)
                    prefix + "/images/Images/z_TurnRight.png"
                else
                    prefix + "/images/Images/z_TurnLeft.png"
        visible: false
        anchors.fill: parent
    }
    MultiEffect{
        id: colorAutoUTurn
        anchors.fill: parent
        source: autoTurnImage
        visible: aog.autoTrackBtnState
        //color: "#E5E54B"
        colorizationColor: if(aog.distancePivotToTurnLine > 0)
                               "#4CF24C"
                           else
                               "#F7A266"
        colorization: 1.0
        MouseArea{
            anchors.fill: parent
            onClicked: aog.swapAutoYouTurnDirection()
        }
        Text{
            id: distance
            anchors.bottom: colorAutoUTurn.bottom
            color: colorAutoUTurn.colorizationColor
            anchors.horizontalCenter: parent.horizontalCenter
            text: if(aog.distancePivotToTurnLine > 0)
                      Utils.m_to_unit_string(aog.distancePivotToTurnLine, 0) + " "+Utils.m_unit_abbrev()
                  else
                      "--"
        }
    }
}
