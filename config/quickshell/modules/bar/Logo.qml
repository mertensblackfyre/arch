import QtQuick

Rectangle {
    radius: 10
    color: "#FFFFFF"

    Image {
        anchors.centerIn: parent
        source: "../assets/arch.svg"
        width: 20
        height: 20
        fillMode: Image.PreserveAspectCrop
    }
}
