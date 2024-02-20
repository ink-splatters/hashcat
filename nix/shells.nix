{ pkgs, common, self, system, ... }:
with pkgs; rec {

  default = mkShell.override { inherit (llvmPackages_17) stdenv; } {
    name = "cpp-shell";

    inherit (common) NIX_CFLAGS_COMPILE LDFLAGS buildInputs nativeBuildInputs;

    shellHook = self.checks.${system}.pre-commit-check.shellHook + ''
      export PS1="\n\[\033[01;36m\]‹⊂˖˖› \\$ \[\033[00m\]"
      echo -e "\nto install pre-commit hooks:\n\x1b[1;37mnix develop .#install-hooks\x1b[00m"
    '';
  };

  install-hooks = mkShell.override { stdenv = stdenvNoCC; } {
    inherit (self.checks.${system}.pre-commit-check) shellHook;
  };
}
