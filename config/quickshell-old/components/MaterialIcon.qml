import "../configs/" as Config
import "../themes/"

StyledText {
    property real fill
    property int grade: ThemeManager.light ? 0 : -25

    font.family: Config.Appearance.font.family.material
    font.pointSize: Config.Appearance.font.size.larger
    font.variableAxes: ({
            FILL: fill.toFixed(1),
            GRAD: grade,
            opsz: fontInfo.pixelSize,
            wght: fontInfo.weight
        })
}
