pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: themeManager

    property bool showPreview
    property string wallpaperPath: "file:///home/mertens/Pictures/assets/wallpapers/cosmic.jpg"

    readonly property bool light: showPreview ? previewLight : currentLight
    property bool currentLight
    property bool previewLight

    readonly property real wallLuminance: getAverageLuminance()
    property var process: Process {
        id: hyprQuery
        command: ["sh", "-c", "hyprctl hyprpaper listactive | cut -d ' ' -f 3"]
        running: true
    }

    property var _internal: Item {
        Image {
            id: wallImage
            source: themeManager.wallpaperPath
        }
        ColorQuantizer {
            id: quantizer
            source: wallImage.source
            depth: 8 // Will produce 8 colors (2³)
            rescaleSize: 64 // Rescale to 64x64 for faster processing
        }
    }

    component Transparency: QtObject {
        property bool enabled: true
        property real base: 1
        property real layers: 0.5
    }

    property Transparency transparency: Transparency {}

    function getAverageLuminance() {
        let totalLum = 0;
        let colorList = quantizer.colors;
        let total = 0;
        let count = 0;

        for (const hex of colorList) {
            if (!hex)
                continue;

            let r, g, b, a = 255;

            if (hex.length === 7) { // #RRGGBB
                r = parseInt(hex.slice(1, 3), 16);
                g = parseInt(hex.slice(3, 5), 16);
                b = parseInt(hex.slice(5, 7), 16);
            } else if (hex.length === 9) { // #AARRGGBB
                a = parseInt(hex.slice(1, 3), 16);
                r = parseInt(hex.slice(3, 5), 16);
                g = parseInt(hex.slice(5, 7), 16);
                b = parseInt(hex.slice(7, 9), 16);
            } else {
                continue;
            }

            if (a === 0)
                continue;

            const rn = r / 255;
            const gn = g / 255;
            const bn = b / 255;

            total += 0.299 * rn * rn + 0.587 * gn * gn + 0.114 * bn * bn;

            count++;
        }

        return 0.8;
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
        property color m3primary: "#FFD4B1"
        property color m3surfaceTint: "#FDB879"
        property color m3onPrimary: "#3C1E00"
        property color m3primaryContainer: "#DF9E61"
        property color m3onPrimaryContainer: "#351A00"
        property color m3secondary: "#FCD5B6"
        property color m3onSecondary: "#36210C"
        property color m3secondaryContainer: "#AB8A6F"
        property color m3onSecondaryContainer: "#000000"
        property color m3tertiary: "#DBE290"
        property color m3onTertiary: "#242800"
        property color m3tertiaryContainer: "#AAB164"
        property color m3onTertiaryContainer: "#202300"
        property color m3error: "#FFD2CC"
        property color m3onError: "#540003"
        property color m3errorContainer: "#FF5449"
        property color m3onErrorContainer: "#000000"
        property color m3background: "#18120E"
        property color m3onBackground: "#ECE0D9"
        property color m3surface: "#18120E"
        property color m3onSurface: "#FFFFFF"
        property color m3surfaceVariant: "#51443A"
        property color m3onSurfaceVariant: "#EDD9CA"
        property color m3outline: "#C1AFA1"
        property color m3outlineVariant: "#9E8D80"
        property color m3shadow: "#000000"
        property color m3scrim: "#000000"
        property color m3inverseSurface: "#ECE0D9"
        property color m3inverseOnSurface: "#2F2924"
        property color m3inversePrimary: "#6B3D06"
        property color m3primaryFixed: "#FFDCC0"
        property color m3onPrimaryFixed: "#1E0D00"
        property color m3primaryFixedDim: "#FDB879"
        property color m3onPrimaryFixedVariant: "#532D00"
        property color m3secondaryFixed: "#FFDCC0"
        property color m3onSecondaryFixed: "#1E0D00"
        property color m3secondaryFixedDim: "#E4C0A1"
        property color m3onSecondaryFixedVariant: "#49311B"
        property color m3tertiaryFixed: "#E1E995"
        property color m3onTertiaryFixed: "#101300"
        property color m3tertiaryFixedDim: "#C5CC7C"
        property color m3onTertiaryFixedVariant: "#343900"
        property color m3surfaceDim: "#18120E"
        property color m3surfaceBright: "#4A433E"
        property color m3surfaceContainerLowest: "#0B0704"
        property color m3surfaceContainerLow: "#221C18"
        property color m3surfaceContainer: "#2D2722"
        property color m3surfaceContainerHigh: "#38312C"
        property color m3surfaceContainerHighest: "#433C37"
    }

    property M3RawData rawData: M3RawData {}

    property QtObject palette: QtObject {
        readonly property color m3primary_paletteKeyColor: themeManager.layer(themeManager.rawData.m3primary_paletteKeyColor)
        readonly property color m3secondary_paletteKeyColor: themeManager.layer(themeManager.rawData.m3secondary_paletteKeyColor)
        readonly property color m3tertiary_paletteKeyColor: themeManager.layer(themeManager.rawData.m3tertiary_paletteKeyColor)
        readonly property color m3neutral_paletteKeyColor: themeManager.layer(themeManager.rawData.m3neutral_paletteKeyColor)
        readonly property color m3neutral_variant_paletteKeyColor: themeManager.layer(themeManager.rawData.m3neutral_variant_paletteKeyColor)

        // Surfaces
        readonly property color m3background: themeManager.layer(themeManager.rawData.m3background, 2)
        readonly property color m3onBackground: themeManager.layer(themeManager.rawData.m3onBackground)
        readonly property color m3surface: themeManager.layer(themeManager.rawData.m3surface, 2)
        readonly property color m3surfaceDim: themeManager.layer(themeManager.rawData.m3surfaceDim, 2)
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
        readonly property color m3primary: themeManager.layer(themeManager.rawData.m3primary, 1)
        readonly property color m3onPrimary: themeManager.layer(themeManager.rawData.m3onPrimary, 2)
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
