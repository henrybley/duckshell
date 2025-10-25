importqs.Components
importqs.Services
importqs.Config|update
importQuickshell
importQuickshell.Widgets
importQtQuick

Item{
id:root

anchors.top:parent.top
anchors.bottom:parent.bottom
anchors.right:parent.right

//implicitWidth:300
//implicitHeight:100

//Rectangle{
//anchors.fill:parent
//}

BehavioronimplicitHeight{
Anim{}
}

componentAnim:NumberAnimation{
duration:Config.animation.animDurations.expressiveDefaultSpatial
easing.type:Easing.BezierSpline
easing.bezierCurve:Config.animation.animCurves.expressiveDefaultSpatial
}
}
