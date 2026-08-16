// config/Theme.qml
pragma Singleton
import QtQuick
import Quickshell.Io

Item {
    id: root

    property color background:              "#191113"
    property color backgroundOn:            "#efdfe1"
    property color error:                   "#ffb4ab"
    property color errorContainer:          "#93000a"
    property color inverseOnSurface:        "#372e30"
    property color inversePrimary:          "#8b4a61"
    property color inverseSurface:          "#efdfe1"
    property color errorOn:                 "#690005"
    property color errorContainerOn:        "#ffdad6"
    property color primaryOn:              "#541d33"
    property color primaryContainer:        "#6f3349"
    property color primaryContainerOn:     "#ffd9e3"
    property color secondaryOn:            "#422931"
    property color secondaryContainerOn:   "#ffd9e3"
    property color surface:                 "#191113"
    property color surfaceOn:              "#efdfe1"
    property color surfaceVariantOn:       "#d5c2c6"
    property color tertiaryOn:             "#48290c"
    property color tertiaryContainerOn:    "#ffdcc2"
    property color outline:                 "#9e8c90"
    property color outlineVariant:          "#514347"
    property color primary:                 "#ffb0c9"
    property color primaryFixed:            "#ffd9e3"
    property color secondary:               "#e2bdc7"
    property color secondaryContainer:      "#5a3f48"
    property color surfaceBright:           "#403739"
    property color surfaceContainer:        "#261d20"
    property color surfaceContainerHigh:    "#31282a"
    property color surfaceContainerHighest: "#3c3235"
    property color surfaceContainerLow:     "#22191c"
    property color surfaceContainerLowest:  "#140c0e"
    property color surfaceDim:              "#191113"
    property color surfaceVariant:          "#514347"
    property color tertiary:                "#efbc94"
    property color tertiaryContainer:       "#623f20"

    FileView {
        id: colorFile
        path: "/home/mertens/.cache/matugen/colors.json"
        blockLoading: true
        watchChanges: true
        onFileChanged: colorFile.reload()
    }

    readonly property var _parsed: JSON.parse(colorFile.text())

    Component.onCompleted: {
        const c = _parsed.colors
        root.background              = c.background
        root.backgroundOn            = c.on_background
        root.error                   = c.error
        root.errorContainer          = c.error_container
        root.inverseOnSurface        = c.inverse_on_surface
        root.inversePrimary          = c.inverse_primary
        root.inverseSurface          = c.inverse_surface
        root.errorOn                 = c.on_error
        root.errorContainerOn        = c.on_error_container
        root.primaryOn               = c.on_primary
        root.primaryContainer        = c.primary_container
        root.primaryContainerOn      = c.on_primary_container
        root.secondaryOn             = c.on_secondary
        root.secondaryContainerOn    = c.on_secondary_container
        root.surface                 = c.surface
        root.surfaceOn               = c.on_surface
        root.surfaceVariantOn        = c.on_surface_variant
        root.tertiaryOn              = c.on_tertiary
        root.tertiaryContainerOn     = c.on_tertiary_container
        root.outline                 = c.outline
        root.outlineVariant          = c.outline_variant
        root.primary                 = c.primary
        root.primaryFixed            = c.primary_fixed
        root.secondary               = c.secondary
        root.secondaryContainer      = c.secondary_container
        root.surfaceBright           = c.surface_bright
        root.surfaceContainer        = c.surface_container
        root.surfaceContainerHigh    = c.surface_container_high
        root.surfaceContainerHighest = c.surface_container_highest
        root.surfaceContainerLow     = c.surface_container_low
        root.surfaceContainerLowest  = c.surface_container_lowest
        root.surfaceDim              = c.surface_dim
        root.surfaceVariant          = c.surface_variant
        root.tertiary                = c.tertiary
        root.tertiaryContainer       = c.tertiary_container
    }
}
