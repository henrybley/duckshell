import QtQuick
import Quickshell
import Quickshell.Io
import qs.Config

Scope {
    id: colours

    readonly property Transparency transparency: Transparency {}


    function applyOpacity(color, opacity) {
        return color.replace("#", "#" + opacity);
    } 

    function alpha(c: color, layer: bool): color {
        if (!transparency.enabled)
            return c;
        c = Qt.rgba(c.r, c.g, c.b, layer ? transparency.layers : transparency.base);
        if (layer)
            c.hsvValue = Math.max(0, Math.min(1, c.hslLightness + (light ? -0.2 : 0.2))); // TODO: edit based on colours (hue or smth)
        return c;
    }

    property string configDir: ""

    FileView {
        id: coloursFileView
        path: configDir + "Colours.json"
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()
        onLoadFailed: function(error) {
            console.warn("Failed to load Colours config, using defaults.")
            console.warn(path)
        }
        JsonAdapter {
            id: coloursAdapter
            
            // Backgrounds
            property string backgroundPrimary: "#0C0D11"
            property string backgroundDark: "#151720"
            property string backgroundLight: "#1D202B"
            
            // Surfaces & Elevation
            property string surface: "#545C7E"
            property string surfaceVariant: "#2A2D3A"
            
            // Text Colors
            property string textPrimary: "#CACEE2"
            property string textSecondary: "#B7BBD0"
            property string textDisabled: "#6B718A"
            
            // Accent Colors
            property string accentPrimary: "#A8AEFF"
            property string accentSecondary: "#9EA0FF"
            property string accentTertiary: "#8EABFF"
            
            // Error/Warning
            property string error: "#FF6B81"
            property string warning: "#FFBB66"
            
            // Highlights & Focus
            property string highlight: "#E3C2FF"
            property string rippleEffect: "#F3DEFF"
            
            // Additional Config.colours Properties
            property string onAccent: "#1A1A1A"
            property string outline: "#44485A"
            
            // Shadows & Overlays
            property string shadow: "#000000"
            property string overlay: "#11121A"
        }
    }
    
    component Transparency: QtObject {
        readonly property bool enabled: false
        readonly property real base: 0.78
        readonly property real layers: 0.58
    }

    // Backgrounds
    readonly property color backgroundPrimary: coloursAdapter.backgroundPrimary
    readonly property color backgroundDark: coloursAdapter.backgroundDark
    readonly property color backgroundLight: coloursAdapter.backgroundLight

    // Surfaces & Elevation
    readonly property color surface: coloursAdapter.surface
    readonly property color surfaceVariant: coloursAdapter.surfaceVariant

    // Text Colors
    readonly property color textPrimary: coloursAdapter.textPrimary
    readonly property color textSecondary: coloursAdapter.textSecondary
    readonly property color textDisabled: coloursAdapter.textDisabled

    // Accent Colors
    readonly property color accentPrimary: coloursAdapter.accentPrimary
    readonly property color accentSecondary: coloursAdapter.accentSecondary
    readonly property color accentTertiary: coloursAdapter.accentTertiary

    // Error/Warning
    readonly property color error: coloursAdapter.error
    readonly property color warning: coloursAdapter.warning

    // Highlights & Focus
    readonly property color highlight: coloursAdapter.highlight
    readonly property color rippleEffect: coloursAdapter.rippleEffect

    // Additional Config.colours Properties
    readonly property color onAccent: coloursAdapter.onAccent
    readonly property color outline: coloursAdapter.outline

    // Shadows & Overlays
    readonly property color shadow: applyOpacity(coloursAdapter.shadow, "B3")
    readonly property color overlay: applyOpacity(coloursAdapter.overlay, "66")

}
/*
tokyonight -storm for reference
---@class Palette
local ret = {
  bg = "#24283b",
  bg_dark = "#1f2335",
  bg_dark1 = "#1b1e2d",
  bg_highlight = "#292e42",
  blue = "#7aa2f7",
  blue0 = "#3d59a1",
  blue1 = "#2ac3de",
  blue2 = "#0db9d7",
  blue5 = "#89ddff",
  blue6 = "#b4f9f8",
  blue7 = "#394b70",
  comment = "#565f89",
  cyan = "#7dcfff",
  dark3 = "#545c7e",
  dark5 = "#737aa2",
  fg = "#c0caf5",
  fg_dark = "#a9b1d6",
  fg_gutter = "#3b4261",
  green = "#9ece6a",
  green1 = "#73daca",
  green2 = "#41a6b5",
  magenta = "#bb9af7",
  magenta2 = "#ff007c",
  orange = "#ff9e64",
  purple = "#9d7cd8",
  red = "#f7768e",
  red1 = "#db4b4b",
  teal = "#1abc9c",
  terminal_black = "#414868",
  yellow = "#e0af68",
  git = {
    add = "#449dab",
    change = "#6183bb",
    delete = "#914c54",
  },
}
night overrides
local ret = vim.deepcopy(require("tokyonight.colors.storm"))

---@type Palette
return vim.tbl_deep_extend("force", ret, {
  bg = "#1a1b26",
  bg_dark = "#16161e",
  bg_dark1 = "#0C0E14",
}) */

