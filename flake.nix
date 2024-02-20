{
  description = "hashcat";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  nixConfig = {
    extra-substituters = "https://cachix.cachix.org";
    extra-trusted-public-keys =
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM=";
  };

  outputs = { nixpkgs, flake-utils, pre-commit-hooks, self, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        inherit (pkgs) callPackage;

        common = callPackage ./nix/common.nix { inherit system; };
      in with pkgs; {

        checks = import ./nix/checks.nix {
          inherit pkgs pre-commit-hooks system common;
        };

        formatter = nixfmt;

        devShells =
          import ./nix/shells.nix { inherit pkgs common self system; };

        packages = {
          default = llvmPackages_17.stdenv.mkDerivation {
            name = "hashcat";

            inherit (common)
              NIX_CFLAGS_COMPILE LDFLAGS buildInputs nativeBuildInputs;

            src = ./.;

            buildPhase = ''
              make
            '';

            installPhase = ''
              mkdir $out
              make install --dest $out
            '';

            enableParallelBuilding = true;

          };
        };

      });
}
