{ pkgs, system, ... }:
let inherit (pkgs.darwin.apple_sdk) frameworks;

in with pkgs; rec {
  CFLAGS = lib.optionalString ("${system}" == "aarch64-darwin")
    "-mcpu=apple-m1 -fuse-ld=lld -flto=full";
  CXXFLAGS = "${CFLAGS}";
  LDFLAGS = "-fuse-ld=lld -flto=full";

  nativeBuildInputs = [ lld_17 clang-tools_17 gnumake llvm_17 ];
  buildInputs = with frameworks;
    [ OpenCL IOKit Foundation Metal ] ++ [ iconv libcxx libcxxabi ];
}
