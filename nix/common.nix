{ darwin, lib, lld_17, llvmPackages_17, gnumake, iconv, system, ... }:
let
  inherit (darwin.apple_sdk) frameworks;
  inherit (llvmPackages_17) libcxx libcxxabi bintools;
in rec {
  CFLAGS = lib.optionalString ("${system}" == "aarch64-darwin")
    "-mcpu=apple-m1 -flto=full";
  CXXFLAGS = "${CFLAGS}";
  LDFLAGS = "-fuse-ld=lld -flto=full";

  nativeBuildInputs = [ lld_17 gnumake bintools ];
  buildInputs = with frameworks;
    [ OpenCL IOKit Foundation Metal ] ++ [ iconv libcxx libcxxabi ];
}
