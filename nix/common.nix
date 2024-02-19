{ pkgs, lib, llvmPackages, system, ... }:
let replaceStdenv = pkg: pkg.overrideAttrs (_: { inherit stdenv; });
in rec {
  inherit (llvmPackages) stdenv;

  CFLAGS = "-O3"
    + lib.optionalString ("${system}" == "aarch64-darwin") " -mcpu=apple-m1";
  CXXFLAGS = "${CFLAGS}";
  LDFLAGS = "-fuse-ld=lld";

  nativeBuildInputs =
    [ pkgs.gnumake (map replaceStdenv (with pkgs; [ lld clang-tools ])) ];
}
