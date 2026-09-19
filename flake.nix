{
  description = "Quickshell + Qt6 development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    quickshell = {
      url = "github:quickshell-mirror/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, flake-utils, quickshell }:
    {
      # System-independent, so it lives outside eachSystem
      homeManagerModules.default =
        { config, pkgs, ... }:
        {
          programs.quickshell = {
            enable = true;
            package = self.packages.${pkgs.stdenv.hostPlatform.system}.duckshell;
            systemd.enable = true;
            configs.default = config.lib.file.mkOutOfStoreSymlink
              "${config.home.homeDirectory}/.config/duckshell";
            activeConfig = "default";
          };
        };
    }
    // flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ] (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        qs = quickshell.packages.${system}.default;
      in
      {
        packages = rec {
          duckshell = pkgs.symlinkJoin {
            name = "duckshell";
            paths = [ qs ];
            nativeBuildInputs = [ pkgs.makeWrapper ];
            postBuild = ''
              wrapProgram $out/bin/quickshell \
                --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.app2unit ]}
            '';
            meta.mainProgram = "quickshell";
          };
          default = duckshell;
        };

        devShells.default = pkgs.mkShell {
          name = "duckshell-dev";
          buildInputs = [
            pkgs.qt6.qtbase
            pkgs.qt6.qtdeclarative
            pkgs.qt6.qtwayland
            qs
          ];
          shellHook = ''
            export QML_IMPORT_PATH=.:${qs}/lib/qt-6/qml:${pkgs.qt6.qtbase}/lib/qt-6/qml
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
