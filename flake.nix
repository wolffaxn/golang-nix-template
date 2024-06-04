{
  description = "golang-nix-template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "arm64-linux" ] (system:
      let
        pkgs = (import nixpkgs) {
          inherit system;
        };
        version = pkgs.lib.versions.majorMinor (builtins.readFile ./VERSION);
      in
      rec {
        # for `nix build` & `nix run`
        defaultPackage = pkgs.stdenv.mkDerivation {
          name = "hello";
          version = version;

          src = ./.;

          buildInputs = with pkgs; [ go ];

          buildPhase = ''
            echo "Building Hello World version ${version}"
            export GOCACHE=$(mktemp -d)
            go build -o hello main.go
          '';

          installPhase = ''
            mkdir -p $out/bin
            install -t $out/bin hello
          '';
        };

        # for `nix develop`
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [ go ];
        };
      }
    );
}
