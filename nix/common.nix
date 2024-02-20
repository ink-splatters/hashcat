{ pkgs, system, ... }:
let inherit (pkgs.darwin.apple_sdk) frameworks;

in with pkgs; rec {
  NIX_CFLAGS_COMPILE =
    lib.optionalString ("${system}" == "aarch64-darwin") "-mcpu=apple-m1";
  LDFLAGS = "-fuse-ld=lld";

  nativeBuildInputs = [ lld_17 clang-tools_17 gnumake ];
  buildInputs = with frameworks;
    [ OpenCL IOKit Foundation Metal ] ++ [ iconv libcxx libcxxabi ];
}
