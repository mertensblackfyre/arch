// BatteryIndicator.qml
import QtQuick
import "../services"
import "../components/"

Item {
    id: battery_item
    width: 20
    height: 20

    property var parent_window

    Image {
        id: indicator
        source: Qt.resolvedUrl(Services.icons())
        fillMode: Image.PreserveAspectFit
        width: 24
        height: 24
    }

    MiniWindow {
        //parent_window: battery_item.parent_window
        parentItem: battery_item
        positin_x: indicator.x
        positin_y: indicator.y
    }
}
