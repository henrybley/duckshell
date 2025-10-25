pragmaComponentBehavior:Bound

importqs.Components
importqs.Services
importqs.Config|update
importQuickshell.Services.UPower
importQtQuick

Column{
id:root

spacing:Config.style.spacingNormal
width:Config.bar.sizes.batteryWidth

StyledText{
text:UPower.displayDevice.isLaptopBattery?qsTr("Remaining:%1%").arg(Math.round(UPower.displayDevice.percentage*100)):qsTr("Nobatterydetected")
}

StyledText{
functionformatSeconds(s:int,fallback:string):string{
constday=Math.floor(s/86400);
consthr=Math.floor(s/3600)%60;
constmin=Math.floor(s/60)%60;

letcomps=[];
if(day>0)
comps.push(`${day}days`);
if(hr>0)
comps.push(`${hr}hours`);
if(min>0)
comps.push(`${min}mins`);

returncomps.join(",")||fallback;
}

text:UPower.displayDevice.isLaptopBattery?qsTr("Time%1:%2").arg(UPower.onBattery?"remaining":"untilcharged").arg(UPower.onBattery?formatSeconds(UPower.displayDevice.timeToEmpty,"Calculating..."):formatSeconds(UPower.displayDevice.timeToFull,"Fullycharged!")):qsTr("Powerprofile:%1").arg(PowerProfile.toString(PowerProfiles.profile))
}

Loader{
anchors.horizontalCenter:parent.horizontalCenter

active:PowerProfiles.degradationReason!==PerformanceDegradationReason.None
asynchronous:true

height:active?(item?.implicitHeight??0):0

sourceComponent:StyledRect{
implicitWidth:child.implicitWidth+Config.style.paddingNormal*2
implicitHeight:child.implicitHeight+Config.style.paddingSmaller*2

color:Config.colours.error
radius:Config.style.roundingNormal

Column{
id:child

anchors.centerIn:parent

Row{
anchors.horizontalCenter:parent.horizontalCenter
spacing:Config.style.spacingSmall

Icon{
anchors.verticalCenter:parent.verticalCenter
anchors.verticalCenterOffset:-font.pixelSize/10

text:"warning"
color:Colours.palette.m3onError
}

StyledText{
anchors.verticalCenter:parent.verticalCenter
text:qsTr("PerformanceDegraded")
color:Colours.palette.m3onError
font.family:Appearance.font.family.mono
font.weight:500
}

Icon{
anchors.verticalCenter:parent.verticalCenter
anchors.verticalCenterOffset:-font.pixelSize/10

text:"warning"
color:Colours.palette.m3onError
}
}

StyledText{
anchors.horizontalCenter:parent.horizontalCenter

text:qsTr("Reason:%1").arg(PerformanceDegradationReason.toString(PowerProfiles.degradationReason))
color:Colours.palette.m3onError
}
}
}
}

StyledRect{
id:profiles

propertystringcurrent:{
constp=PowerProfiles.profile;
if(p===PowerProfile.PowerSaver)
returnsaver.icon;
if(p===PowerProfile.Performance)
returnperf.icon;
returnbalance.icon;
}

anchors.horizontalCenter:parent.horizontalCenter

implicitWidth:saver.implicitHeight+balance.implicitHeight+perf.implicitHeight+Config.style.paddingNormal*2+Config.style.spacingLarge*2
implicitHeight:Math.max(saver.implicitHeight,balance.implicitHeight,perf.implicitHeight)+Config.style.paddingSmall*2

color:Config.colours.backgroundLight
radius:Config.style.roundingFull

StyledRect{
id:indicator

color:Config.colours.textPrimary
radius:Config.style.roundingFull
state:profiles.current

states:[
State{
name:saver.icon

Fill{
item:saver
}
},
State{
name:balance.icon

Fill{
item:balance
}
},
State{
name:perf.icon

Fill{
item:perf
}
}
]

transitions:Transition{
AnchorAnimation{
duration:Config.animation.animDurations.normal
easing.type:Easing.BezierSpline
easing.bezierCurve:Config.animation.animCurves.emphasized
}
}
}

Profile{
id:saver

anchors.verticalCenter:parent.verticalCenter
anchors.left:parent.left
anchors.leftMargin:Config.style.paddingSmall

profile:PowerProfile.PowerSaver
icon:"energy_savings_leaf"
}

Profile{
id:balance

anchors.centerIn:parent

profile:PowerProfile.Balanced
icon:"balance"
}

Profile{
id:perf

anchors.verticalCenter:parent.verticalCenter
anchors.right:parent.right
anchors.rightMargin:Config.style.paddingSmall

profile:PowerProfile.Performance
icon:"rocket_launch"
}
}

componentFill:AnchorChanges{
requiredpropertyItemitem

target:indicator
anchors.left:item.left
anchors.right:item.right
anchors.top:item.top
anchors.bottom:item.bottom
}

componentProfile:Item{
requiredpropertystringicon
requiredpropertyintprofile

implicitWidth:icon.implicitHeight+Config.style.paddingSmall*2
implicitHeight:icon.implicitHeight+Config.style.paddingSmall*2

StateLayer{
radius:Config.style.roundingFull
color:profiles.current===parent.icon?Config.colours.backgroundPrimary:Config.colours.backgroundLight

functiononClicked():void{
PowerProfiles.profile=parent.profile;
}
}

Icon{
id:icon

anchors.centerIn:parent

text:parent.icon
font.pixelSize:Config.style.fontSizeLarge
color:profiles.current===text?Config.colours.backgroundPrimary:Config.colours.backgroundLight
fill:profiles.current===text?1:0

Behavioronfill{
NumberAnimation{
duration:Config.animation.animDurations.normal
easing.type:Easing.BezierSpline
easing.bezierCurve:Config.animation.animCurves.standard
}
}
}
}
}
