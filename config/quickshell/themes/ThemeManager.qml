pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: themeManager

    // 1. Storage for the path
    property string wallpaperPath: "file:///home/mertens/Pictures/assets/wallpapers/cosmic.jpg"

    // 2. The Command Runner
    // This runs once at startup and can be triggered again manually
    property var process: Process {
        id: hyprQuery
        command: ["sh", "-c", "hyprctl hyprpaper listactive | cut -d ' ' -f 3"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                let path = this.text;
                if (path.length > 0) {

                    // Prepend file:// so the Image component can read it
                    //themeManager.wallpaperPath = "/home/mertens/" + path;
                }
            }
        }
    }

    Component.onCompleted: {
        hyprQuery.exec();
    }

    // 3. Internal processing (Hidden from UI)
    property var _internal: Item {
        Image {
            id: wallImage
            source: themeManager.wallpaperPath
        }
        ColorQuantizer {
            id: quantizer
            source: wallImage.source
            depth: 3 // Will produce 8 colors (2³)
            rescaleSize: 64 // Rescale to 64x64 for faster processing
        }
    }

    // 4. Public Colors
    readonly property color primary: quantizer.colors.length > 0 ? quantizer.colors[0] : "#1a1a1a"
    readonly property color secondary: quantizer.colors.length > 0 ? quantizer.colors[1] : "#1a1a1a"
    readonly property color tertiary: quantizer.colors.length > 0 ? quantizer.colors[2] : "#1a1a1a"
}
