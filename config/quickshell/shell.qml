import Quickshell
import "modules/bar"
import "modules/popup"
import "modules/wifi"
import "services" as Services
import "config" as Config
import QtQuick

ShellRoot {
    Bar {
        id:bar

    }


    Popup{
        id:pop
    }

    Component.onCompleted: {
        Qt.callLater(() => console.log(Config.Theme.background))
    }


}
