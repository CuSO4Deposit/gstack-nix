{
  description = "gstack development shell for Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        lib = pkgs.lib;

        browserLibs = with pkgs; [
          alsa-lib
          atk
          at-spi2-atk
          cairo
          cups
          dbus
          expat
          glib
          gtk3
          libdrm
          mesa
          nspr
          nss
          pango
          udev
          libx11
          libxscrnsaver
          libxcomposite
          libxdamage
          libxext
          libxfixes
          libxi
          libxrandr
          libxtst
          libxcb
          libxkbfile
          libxshmfence
          libxkbcommon
        ];

        browserLibPath = lib.makeLibraryPath browserLibs;
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            bun
            git
            nodejs
            pkg-config
            python3
            chromium
          ] ++ browserLibs;

          shellHook = ''
            export LD_LIBRARY_PATH="${browserLibPath}:$LD_LIBRARY_PATH"
            export GSTACK_CHROMIUM_PATH="${pkgs.chromium}/bin/chromium"
            export CHROME_EXECUTABLE="$GSTACK_CHROMIUM_PATH"

            echo "gstack dev shell ready"
            echo "  bun:    $(command -v bun)"
            echo "  node:   $(command -v node)"
            echo "  git:    $(command -v git)"
            echo "  chrome: $GSTACK_CHROMIUM_PATH"
            echo ""
            echo "Next steps:"
            echo "  bun install"
            echo "  bunx playwright install chromium"
            echo "  ./setup --host codex"
          '';
        };
      });
}
