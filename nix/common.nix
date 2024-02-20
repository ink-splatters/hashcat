{ pkgs, system, ... }:
let
  # overrideStdenv = let
  #   overrideStdenv = pkg:
  #     pkg.overrideAttrs (_: { inherit (llvmPackages) stdenv; });

  # optimizeWithFlags = pkg: flags:
  #   pkgs.lib.overrideDerivation pkg (old:
  #   let
  #     newflags = pkgs.lib.foldl' (acc: x: "${acc} ${x}") "" flags;
  #     oldflags = if (pkgs.lib.hasAttr "NIX_CFLAGS_COMPILE" old)
  #       then "${old.NIX_CFLAGS_COMPILE}"
  #       else "";
  #   in
  #   {
  #     NIX_CFLAGS_COMPILE = "${oldflags} ${newflags}";
  #   });

  # in pkgs: map overrideStdenv pkgs;

  inherit (pkgs.darwin.apple_sdk) frameworks;

in with pkgs; rec {
  CFLAGS =
    lib.optionalString ("${system}" == "aarch64-darwin") " -mcpu=apple-m1";
  LDFLAGS = "-fuse-ld=lld";

  # nativeBuildInputs = overrideStdenv [ lld clang-tools ] ++ [ gnumake ];
  nativeBuildInputs = [ lld_17 clang-tools_17 ];
  buildInputs = with frameworks; [ OpenCL IOKit Foundation Metal ];
}
