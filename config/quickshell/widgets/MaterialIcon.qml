import "../config" as Config

StyledText {
    property real fill

    font.family: Config.Appearance.font.family.material
    color:Config.Theme.inverseOnSurface
    font.pixelSize: Config.Appearance.font.size.larger
    font.variableAxes: ({
            FILL: fill.toFixed(1),
            opsz: fontInfo.pixelSize,
            wght: fontInfo.weight
        })
}
