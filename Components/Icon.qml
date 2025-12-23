import qs.Services
import qs.Config

StyledText {
    property real fill
    property int grade: Colours.light ? 0 : -25

    font.family: Config.style.fontFamilyIcons
    font.pixelSize: Config.style.fontSizeLarge

    font.variableAxes: ({
            FILL: fill.toFixed(1),
            GRAD: grade,
            opsz: fontInfo.pixelSize,
            wght: fontInfo.weight
        })
}
