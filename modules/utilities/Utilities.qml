importqs.Config|update
importQtQuick

Item{
id:root

requiredpropertyboolvisibility

visible:height>0
implicitHeight:0
implicitWidth:content.implicitWidth

states:State{
name:"visible"
when:root.visibility

PropertyChanges{
root.implicitHeight:content.implicitHeight
}
}

transitions:[
Transition{
from:""
to:"visible"

NumberAnimation{
target:root
property:"implicitHeight"
duration:Config.animation.animDurations.expressiveDefaultSpatial
easing.type:Easing.BezierSpline
easing.bezierCurve:Config.animation.animCurves.expressiveDefaultSpatial
}
},
Transition{
from:"visible"
to:""

NumberAnimation{
target:root
property:"implicitHeight"
duration:Config.animation.animDurations.normal
easing.type:Easing.BezierSpline
easing.bezierCurve:Config.animation.animCurves.emphasized
}
}
]

Content{
id:content
}
}
