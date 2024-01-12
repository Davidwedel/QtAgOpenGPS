import QtQuick 2.0
import QtQuick.Controls 2.5

    Rectangle{
        id: configImpTimWin
        anchors.fill: parent
        color: "ghostwhite"
        visible: false
        Image{
            id: configImpImage
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottomMargin: 70
            anchors.rightMargin: 30
            anchors.leftMargin: 200
            anchors.topMargin: 100
            source: "/images/ImplementSettings.png"

            SpinBoxOneDecimal{
                anchors.right: parent.left
                anchors.top: parent.top
                from: 0
                value: 1
                to: 22
                text: qsTr("On (secs)")
            }
            SpinBoxOneDecimal{
                anchors.right: parent.left
                anchors.verticalCenter: parent.verticalCenter
                from: 0
                value:0
                to: 20
                editable: true
                text: qsTr("Off (secs)")
            }
            SpinBoxOneDecimal{
                anchors.right: parent.left
                anchors.bottom: parent.bottom
                from: 0
                value: 0
                to: 20
                editable: true
                text: qsTr("Delay (secs)")
            }
            SpinBoxCustomized{
                anchors.left: parent.left
                anchors.leftMargin: 500
                anchors.top: parent.bottom
                anchors.bottomMargin: -10
                from: -984
                value: 0
                to: 984
                editable: true
                text: qsTr("Offset")
            }
            SpinBoxCustomized{
                anchors.right: parent.right
                anchors.rightMargin: 120
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 100
                from: -1181
                value: 0
                to: 1181
                editable: true
                text: qsTr("Overlap / Gap")
            }
        }
    }