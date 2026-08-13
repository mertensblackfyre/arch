// config/Theme.qml
pragma Singleton
import QtQuick
import Quickshell.Io

Item {
    id: root

    property color primary: "#ffb3b1"
    property color primaryOn: "#571d1e"
    property color secondary: "#e6bdbb"
    property color secondaryOn: "#442928"
    property color surface: "#1a1111"
    property color surfaceOn: "#f0dedd"
    property color surfaceContainer: "#271d1d"
    property color surfaceContainerHigh: "#322827"
    property color background: "#1a1111"
    property color backgroundOn: "#f0dedd"
    property color error: "#ffb4ab"

    FileView {
        id: colorFile
        path: "/home/mertens/.cache/matugen/colors.json"
        blockLoading: true
        watchChanges: true
        onFileChanged: colorFile.reload()
    }

    readonly property var _parsed: JSON.parse(colorFile.text())

    Component.onCompleted: {
        root.primary = _parsed.colors.primary;
        root.primaryOn = _parsed.colors.on_primary;
        root.secondary = _parsed.colors.secondary;
        root.secondaryOn = _parsed.colors.on_secondary;
        root.surface = _parsed.colors.surface;
        root.surfaceOn = _parsed.colors.on_surface;
        root.surfaceContainer = _parsed.colors.surface_container;
        root.surfaceContainerHigh = _parsed.colors.surface_container_high;
        root.background = _parsed.colors.background;
        root.backgroundOn = _parsed.colors.on_background;
        root.error = _parsed.colors.error;
    }
}
