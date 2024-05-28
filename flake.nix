{
  description = "golang-nix-sample";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ] (system: let
      pkgs = (import nixpkgs) {
        inherit system;
      };

    in rec {
      # for `nix build` & `nix run`
      defaultPackage = pkgs.stdenv.mkDerivation {
        name = "hello";
        src = self;
        buildInputs = with pkgs; [ go ];
        buildPhase = ''
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