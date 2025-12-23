{
  description = "Quickshell + Qt6 development environment";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    quickshell.url = "github:quickshell-mirror/quickshell";
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      quickshell,
    }:
    {
      homeManagerModules.default = import ./modules/home-manager.nix;
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.default = quickshell.packages.${system}.default;

        packages.duckshell = pkgs.symlinkJoin {
          name = "duckshell";
          paths = [
            quickshell.packages.${system}.default
            pkgs.qt6.qtbase
            pkgs.qt6.qtdeclarative
            pkgs.qt6.qtwayland
            pkgs.app2unit
          ];
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/quickshell \
              --prefix QML_IMPORT_PATH : "${
                quickshell.packages.${system}.default
              }/lib/qt-6/qml:${pkgs.qt6.qtbase}/lib/qt-6/qml" \
              --prefix QT_PLUGIN_PATH : "${pkgs.qt6.qtbase}/lib/qt-6/plugins"
          '';
        };

        devShells.default = pkgs.mkShell {
          name = "duckshell-dev";
          buildInputs = [
            pkgs.qt6.qtbase
            pkgs.qt6.qtdeclarative
            pkgs.qt6.qtwayland
            pkgs.app2unit
            quickshell.packages.${system}.default
          ];
          shellHook = ''
            export QML_IMPORT_PATH=.:${
              quickshell.packages.${system}.default
            }/lib/qt-6/qml:${pkgs.qt6.qtbase}/lib/qt-6/qml
            export QT_PLUGIN_PATH=${pkgs.qt6.qtbase}/lib/qt-6/plugins
            printf "%s\n" \
              "[General]" \
              "importPath=$QML_IMPORT_PATH" \
              "pluginPath=$QT_PLUGIN_PATH" \
              > qmlls.ini
            echo "Quickshell + Qt6 dev environment ready!"
          '';
        };
      }
    );
}
