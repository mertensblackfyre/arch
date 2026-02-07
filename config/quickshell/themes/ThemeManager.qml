pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: themeManager

    property bool showPreview
    property string wallpaperPath: "file:///home/mertens/Pictures/assets/wallpapers/raa.png"

    readonly property bool light: showPreview ? previewLight : currentLight
    property bool currentLight
    property bool previewLight

    readonly property real wallLuminance: getAverageLuminance()
    property var process: Process {
        id: hyprQuery
        command: ["sh", "-c", "hyprctl hyprpaper listactive | cut -d ' ' -f 3"]
        running: true
    }

    Component.onCompleted: {
        hyprQuery.exec();
    }

    property var _internal: Item {
        Image {
            id: wallImage
            source: themeManager.wallpaperPath
        }
        ColorQuantizer {
            id: quantizer
            source: wallImage.source
            depth: 5 // Will produce 8 colors (2³)
            rescaleSize: 64 // Rescale to 64x64 for faster processing
        }
    }

    component Transparency: QtObject {
        property bool enabled: false
        property real base: 1
        property real layers: 0.5
    }

    property Transparency transparency: Transparency {}

    function getAverageLuminance() {
        let totalLum = 0;
        let colorList = quantizer.colors;

        if (colorList.length === 0)
            return 0.5; // Default fallback

        for (let i = 0; i < colorList.length; i++) {
            let c = colorList[i];
            // Standard Luminance Formula
            let lum = (0.2126 * c.r) + (0.7152 * c.g) + (0.0722 * c.b);
            totalLum += lum;
        }

        return totalLum / colorList.length;
    }

    function getLuminance(c: color): real {
        if (c.r == 0 && c.g == 0 && c.b == 0)
            return 0;
        return Math.sqrt(0.299 * (c.r ** 2) + 0.587 * (c.g ** 2) + 0.114 * (c.b ** 2));
    }

    function alterColour(c: color, a: real, layer: int): color {
        const luminance = getLuminance(c);

        const offset = (!light || layer == 1 ? 1 : -layer / 2) * (light ? 0.2 : 0.3) * (1 - transparency.base) * (1 + wallLuminance * (light ? (layer == 1 ? 3 : 1) : 2.5));
        const scale = (luminance + offset) / luminance;
        const r = Math.max(0, Math.min(1, c.r * scale));
        const g = Math.max(0, Math.min(1, c.g * scale));
        const b = Math.max(0, Math.min(1, c.b * scale));

        return Qt.rgba(r, g, b, a);
    }

    function layer(c: color, layer: var): color {
        if (!transparency.enabled)
            return c;

        return layer === 0 ? Qt.alpha(c, transparency.base) : alterColour(c, transparency.layers, layer ?? 1);
    }

    // 1. First, define the raw hex data component
    component M3RawData: QtObject {
        property color m3primary_paletteKeyColor: "#a8627b"
        property color m3secondary_paletteKeyColor: "#8e6f78"
        property color m3tertiary_paletteKeyColor: "#986e4c"
        property color m3neutral_paletteKeyColor: "#807477"
        property color m3neutral_variant_paletteKeyColor: "#837377"

        property color m3background: "#191114"
        property color m3onBackground: "#efdfe2"

        property color m3surface: "#191114"
        property color m3surfaceDim: "#191114"
        property color m3surfaceBright: "#403739"
        property color m3surfaceContainerLowest: "#130c0e"
        property color m3surfaceContainerLow: "#22191c"
        property color m3surfaceContainer: "#261d20"
        property color m3surfaceContainerHigh: "#31282a"
        property color m3surfaceContainerHighest: "#3c3235"
        property color m3onSurface: "#efdfe2"
        property color m3surfaceVariant: "#514347"
        property color m3onSurfaceVariant: "#d5c2c6"
        property color m3inverseSurface: "#efdfe2"
        property color m3inverseOnSurface: "#372e30"

        property color m3outline: "#9e8c91"
        property color m3outlineVariant: "#514347"
        property color m3shadow: "#000000"
        property color m3scrim: "#000000"
        property color m3surfaceTint: "#ffb0ca"

        property color m3primary: "#ffb0ca"
        property color m3onPrimary: "#541d34"
        property color m3primaryContainer: "#6f334a"
        property color m3onPrimaryContainer: "#ffd9e3"
        property color m3inversePrimary: "#8b4a62"

        property color m3secondary: "#e2bdc7"
        property color m3onSecondary: "#422932"
        property color m3secondaryContainer: "#5a3f48"
        property color m3onSecondaryContainer: "#ffd9e3"

        property color m3tertiary: "#f0bc95"
        property color m3onTertiary: "#48290c"
        property color m3tertiaryContainer: "#b58763"
        property color m3onTertiaryContainer: "#000000"

        property color m3error: "#ffb4ab"
        property color m3onError: "#690005"
        property color m3errorContainer: "#93000a"
        property color m3onErrorContainer: "#ffdad6"

        property color m3success: "#B5CCBA"
        property color m3onSuccess: "#213528"
        property color m3successContainer: "#374B3E"
        property color m3onSuccessContainer: "#D1E9D6"

        property color m3primaryFixed: "#ffd9e3"
        property color m3primaryFixedDim: "#ffb0ca"
        property color m3onPrimaryFixed: "#39071f"
        property color m3onPrimaryFixedVariant: "#6f334a"

        property color m3secondaryFixed: "#ffd9e3"
        property color m3secondaryFixedDim: "#e2bdc7"
        property color m3onSecondaryFixed: "#2b151d"
        property color m3onSecondaryFixedVariant: "#5a3f48"

        property color m3tertiaryFixed: "#ffdcc3"
        property color m3tertiaryFixedDim: "#f0bc95"
        property color m3onTertiaryFixed: "#2f1500"
        property color m3onTertiaryFixedVariant: "#623f21"
    }

    property M3RawData rawData: M3RawData {}

    property QtObject palette: QtObject {
        // Key Colors
        readonly property color m3primary_paletteKeyColor: themeManager.layer(themeManager.rawData.m3primary_paletteKeyColor)
        readonly property color m3secondary_paletteKeyColor: themeManager.layer(themeManager.rawData.m3secondary_paletteKeyColor)
        readonly property color m3tertiary_paletteKeyColor: themeManager.layer(themeManager.rawData.m3tertiary_paletteKeyColor)
        readonly property color m3neutral_paletteKeyColor: themeManager.layer(themeManager.rawData.m3neutral_paletteKeyColor)
        readonly property color m3neutral_variant_paletteKeyColor: themeManager.layer(themeManager.rawData.m3neutral_variant_paletteKeyColor)

        // Surfaces
        readonly property color m3background: themeManager.layer(themeManager.rawData.m3background, 2)
        readonly property color m3onBackground: themeManager.layer(themeManager.rawData.m3onBackground)
        readonly property color m3surface: themeManager.layer(themeManager.rawData.m3surface, 0)
        readonly property color m3surfaceDim: themeManager.layer(themeManager.rawData.m3surfaceDim, 0)
        readonly property color m3surfaceBright: themeManager.layer(themeManager.rawData.m3surfaceBright, 0)
        readonly property color m3surfaceContainerLowest: themeManager.layer(themeManager.rawData.m3surfaceContainerLowest)
        readonly property color m3surfaceContainerLow: themeManager.layer(themeManager.rawData.m3surfaceContainerLow)
        readonly property color m3surfaceContainer: themeManager.layer(themeManager.rawData.m3surfaceContainer)
        readonly property color m3surfaceContainerHigh: themeManager.layer(themeManager.rawData.m3surfaceContainerHigh)
        readonly property color m3surfaceContainerHighest: themeManager.layer(themeManager.rawData.m3surfaceContainerHighest)
        readonly property color m3onSurface: themeManager.layer(themeManager.rawData.m3onSurface)

        readonly property color m3surfaceVariant: themeManager.layer(themeManager.rawData.m3surfaceVariant, 0)
        readonly property color m3onSurfaceVariant: themeManager.layer(themeManager.rawData.m3onSurfaceVariant)
        readonly property color m3inverseSurface: themeManager.layer(themeManager.rawData.m3inverseSurface, 0)
        readonly property color m3inverseOnSurface: themeManager.layer(themeManager.rawData.m3inverseOnSurface)

        // Brand & Accents
        readonly property color m3primary: themeManager.layer(themeManager.rawData.m3primary,2)
        readonly property color m3onPrimary: themeManager.layer(themeManager.rawData.m3onPrimary,2)
        readonly property color m3primaryContainer: themeManager.layer(themeManager.rawData.m3primaryContainer)
        readonly property color m3onPrimaryContainer: themeManager.layer(themeManager.rawData.m3onPrimaryContainer)
        readonly property color m3inversePrimary: themeManager.layer(themeManager.rawData.m3inversePrimary)

        readonly property color m3secondary: themeManager.layer(themeManager.rawData.m3secondary)
        readonly property color m3onSecondary: themeManager.layer(themeManager.rawData.m3onSecondary)
        readonly property color m3secondaryContainer: themeManager.layer(themeManager.rawData.m3secondaryContainer)
        readonly property color m3onSecondaryContainer: themeManager.layer(themeManager.rawData.m3onSecondaryContainer)

        readonly property color m3tertiary: themeManager.layer(themeManager.rawData.m3tertiary)
        readonly property color m3onTertiary: themeManager.layer(themeManager.rawData.m3onTertiary)
        readonly property color m3tertiaryContainer: themeManager.layer(themeManager.rawData.m3tertiaryContainer)
        readonly property color m3onTertiaryContainer: themeManager.layer(themeManager.rawData.m3onTertiaryContainer)

        readonly property color m3outline: themeManager.layer(themeManager.rawData.m3outline)
        readonly property color m3outlineVariant: themeManager.layer(themeManager.rawData.m3outlineVariant)
        readonly property color m3shadow: themeManager.layer(themeManager.rawData.m3shadow)
        readonly property color m3scrim: themeManager.layer(themeManager.rawData.m3scrim)
        readonly property color m3surfaceTint: themeManager.layer(themeManager.rawData.m3surfaceTint)

        readonly property color m3error: themeManager.layer(themeManager.rawData.m3error)
        readonly property color m3onError: themeManager.layer(themeManager.rawData.m3onError)
        readonly property color m3errorContainer: themeManager.layer(themeManager.rawData.m3errorContainer)
        readonly property color m3onErrorContainer: themeManager.layer(themeManager.rawData.m3onErrorContainer)

        readonly property color m3success: themeManager.layer(themeManager.rawData.m3success)
        readonly property color m3onSuccess: themeManager.layer(themeManager.rawData.m3onSuccess)
        readonly property color m3successContainer: themeManager.layer(themeManager.rawData.m3successContainer)
        readonly property color m3onSuccessContainer: themeManager.layer(themeManager.rawData.m3onSuccessContainer)

        // Fixed Colors
        readonly property color m3primaryFixed: themeManager.layer(themeManager.rawData.m3primaryFixed)
        readonly property color m3primaryFixedDim: themeManager.layer(themeManager.rawData.m3primaryFixedDim)
        readonly property color m3onPrimaryFixed: themeManager.layer(themeManager.rawData.m3onPrimaryFixed)
        readonly property color m3onPrimaryFixedVariant: themeManager.layer(themeManager.rawData.m3onPrimaryFixedVariant)

        readonly property color m3secondaryFixed: themeManager.layer(themeManager.rawData.m3secondaryFixed)
        readonly property color m3secondaryFixedDim: themeManager.layer(themeManager.rawData.m3secondaryFixedDim)
        readonly property color m3onSecondaryFixed: themeManager.layer(themeManager.rawData.m3onSecondaryFixed)
        readonly property color m3onSecondaryFixedVariant: themeManager.layer(themeManager.rawData.m3onSecondaryFixedVariant)

        readonly property color m3tertiaryFixed: themeManager.layer(themeManager.rawData.m3tertiaryFixed)
        readonly property color m3tertiaryFixedDim: themeManager.layer(themeManager.rawData.m3tertiaryFixedDim)
        readonly property color m3onTertiaryFixed: themeManager.layer(themeManager.rawData.m3onTertiaryFixed)
        readonly property color m3onTertiaryFixedVariant: themeManager.layer(themeManager.rawData.m3onTertiaryFixedVariant)
    }
}
