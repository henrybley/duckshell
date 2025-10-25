{
  description = "Quickshell packages and configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    quickshell.url = "github:quickshell-mirror/quickshell";
  };

  outputs =
    {
      self,
      quickshell,
    }:
    {
      # Expose the config path
      configPath = ./duckshell;

      homeManagerModules.default =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        {
          home.packages = with pkgs; [
            quickshell.packages.${pkgs.system}.default
            app2unit
            qt5.qtsvg
            qt5.qtimageformats
            qt5.qtmultimedia
            qt5.qtquickcontrols2
            qt6Packages.qt5compat
            libsForQt5.qt5.qtgraphicaleffects
            kdePackages.qtbase
            kdePackages.qtdeclarative
          ];

          # Copy entire duckshell directory to ~/.config/duckshell
          xdg.configFile."duckshell" = {
            source = self.configPath;
            recursive = true;
          };
        };
    };
}
