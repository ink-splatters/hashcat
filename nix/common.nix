{ pkgs, llvmPackages, system, ... }:
let
  overrideStdenv = let
    overrideStdenv = pkg:
      pkg.overrideAttrs (_: { inherit (llvmPackages) stdenv; });
  in pkgs: map overrideStdenv pkgs;

in with pkgs; rec {
  CFLAGS = "-O3"
    + lib.optionalString ("${system}" == "aarch64-darwin") " -mcpu=apple-m1";
  CXXFLAGS = "${CFLAGS}";
  LDFLAGS = "-fuse-ld=lld";

  nativeBuildInputs = overrideStdenv [ lld clang-tools ] ++ [ gnumake ];
}
