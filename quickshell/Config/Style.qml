import QtQuick
import Quickshell
import Quickshell.Io

Scope {

    property string configDir: ""
    
    FileView {
        id: styleFileView
        path: configDir + "Style.json"
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()
        Component.onCompleted: function() {
            reload()
        }
        onLoaded: function() {
            //WallpaperManager.setCurrentWallpaper(settings.currentWallpaper, true);
        }
        onLoadFailed: function(error) {
            console.warn("Failed to load style config, using defaults.")
            console.warn(path)
        }
        JsonAdapter {
            id: styleAdapter
            property int borderThickness: 15
            property int borderRounding: 8
            
            property int roundingSmall: 15
            property int roundingNormal: 15
            property int roundingLarge: 25
            property int roundingFull: 1000

            property int paddingSmall: 2
            property int paddingSmaller: 4
            property int paddingNormal: 8
            property int paddingLarger: 12
            property int paddingLarge: 15

            property int spacingSmall: 7
            property int spacingSmaller: 10
            property int spacingNormal: 12
            property int spacingLarger: 15
            property int spacingLarge: 20

            property int barWindowPreviewSize: 200

            property int verticalSliderWidth: 20
            property int verticalSliderHeight: 150

            property bool dimPanels: true
            
            property int sessionButtonSize: 80


            property string fontFamily: "JetBrainsMono Nerd Font" 
            property string fontFamilyIcons: "Material Symbols Rounded" 
            property int fontSizeLarge: 24         
            property int fontSizeLarger: 20
            property int fontSizeNormal: 16              
            property int fontSizeSmaller: 8
            property int fontSizeSmall: 10

        }
    }

    readonly property int borderThickness: styleAdapter.borderThickness
    readonly property int borderRounding: styleAdapter.borderRounding

    readonly property int roundingSmall: styleAdapter.roundingSmall
    readonly property int roundingNormal: styleAdapter.roundingNormal
    readonly property int roundingLarge: styleAdapter.roundingLarge
    readonly property int roundingFull: styleAdapter.roundingFull

    readonly property int paddingSmall: styleAdapter.paddingSmall
    readonly property int paddingSmaller: styleAdapter.paddingSmaller
    readonly property int paddingNormal: styleAdapter.paddingNormal
    readonly property int paddingLarger: styleAdapter.paddingLarger
    readonly property int paddingLarge: styleAdapter.paddingLarge
    
    readonly property int spacingSmall: styleAdapter.spacingSmall
    readonly property int spacingSmaller: styleAdapter.spacingSmaller
    readonly property int spacingNormal: styleAdapter.spacingNormal
    readonly property int spacingLarger: styleAdapter.spacingLarger
    readonly property int spacingLarge: styleAdapter.spacingLarge
    
    readonly property int barWindowPreviewSize: styleAdapter.barWindowPreviewSize
    readonly property int verticalSliderWidth: styleAdapter.verticalSliderWidth
    readonly property int verticalSliderHeight: styleAdapter.verticalSliderHeight

    readonly property bool dimPanels: styleAdapter.dimPanels


    readonly property int sessionButtonSize: styleAdapter.sessionButtonSize

    readonly property string fontFamily: styleAdapter.fontFamily
    readonly property string fontFamilyIcons: styleAdapter.fontFamilyIcons
    readonly property int fontSizeLarge: styleAdapter.fontSizeLarge 
    readonly property int fontSizeLarger: styleAdapter.fontSizeLarger
    readonly property int fontSizeNormal: styleAdapter.fontSizeNormal
    readonly property int fontSizeSmaller: styleAdapter.fontSizeSmaller
    readonly property int fontSizeSmall: styleAdapter.fontSizeSmall
}

