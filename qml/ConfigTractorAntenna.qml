import QtQuick 2.0
import QtQuick.Controls 2.5

Rectangle{
    id: configTractorAntenna
    anchors.fill: parent
    color: "ghostwhite"
    visible: false
    Image {
        id: antImage
        source: "/images/AntennaTractor.png"
        width: 350
        height: 350
        anchors.centerIn: parent
    }
    SpinBoxCustomized{
        id: antForward
        anchors.bottom: antImage.top
        anchors.left: antImage.left
        anchors.leftMargin: 30
        from: -999
        value: 20
        to: 999
    }
    SpinBoxCustomized{
        id: antHeight
        anchors.top: antImage.top
        anchors.topMargin: 100
        anchors.left: antImage.right
        anchors.leftMargin: -50
        from: 0
        value: 20
        to: 1000
    }
    SpinBoxCustomized{
        id: antOffset
        anchors.bottom: antImage.bottom
        anchors.bottomMargin: 70
        anchors.left: antImage.right
        anchors.leftMargin: -25
        from: -500
        value: 20
        to: 500
    }
}