importqs.Services
importqs.Config|update
importQuickshell
importQtQuick
importQtQuick.Shapes

ShapePath{
id:root

requiredpropertyWrapperwrapper
readonlypropertyrealrounding:Config.border.rounding
readonlypropertyboolflatten:wrapper.height<rounding*2
readonlypropertyrealroundingY:flatten?wrapper.height/2:rounding

strokeWidth:-1
fillColor:Config.colours.backgroundPrimary

PathLine{
relativeX:-(root.wrapper.width+root.rounding)
relativeY:0
}
PathArc{
relativeX:root.rounding
relativeY:-root.roundingY
radiusX:root.rounding
radiusY:Math.min(root.rounding,root.wrapper.height)
direction:PathArc.Counterclockwise
}
PathLine{
relativeX:0
relativeY:-(root.wrapper.height-root.roundingY*2)
}
PathArc{
relativeX:root.rounding
relativeY:-root.roundingY
radiusX:root.rounding
radiusY:Math.min(root.rounding,root.wrapper.height)
}
PathLine{
relativeX:root.wrapper.height>0?root.wrapper.width-root.rounding*2:root.wrapper.width
relativeY:0
}
PathArc{
relativeX:root.rounding
relativeY:-root.rounding
radiusX:root.rounding
radiusY:root.rounding
direction:PathArc.Counterclockwise
}

BehavioronfillColor{
ColorAnimation{
duration:Config.animation.animDurations.normal
easing.type:Easing.BezierSpline
easing.bezierCurve:Config.animation.animCurves.standard
}
}
}
