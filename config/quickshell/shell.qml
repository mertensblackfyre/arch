// shell.qml
import Quickshell
import "modules/bar"

ShellRoot {
    // This tells the QML engine: "Look in my current folder for modules"
    // This makes 'import components' work everywhere in your project.

    // Your bar or windows here
    Bar {}
}
