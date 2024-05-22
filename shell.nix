{ nixpkgs ? import <nixpkgs> { } }:

let
  rust_overlay = import (builtins.fetchTarball
    "https://github.com/oxalica/rust-overlay/archive/master.tar.gz");
  pkgs = import <nixpkgs> { overlays = [ rust_overlay ]; };
  rust =
    (pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml).override {
      extensions = [
        "rust-src" # for rust-analyzer
        "rust-analyzer"
        "clippy"
      ];
    };

in pkgs.mkShell {
  buildInputs = [ rust ] ++ (with pkgs; [ pkg-config lvm2 libclang ]);
  nativeBuildInputs = [ pkgs.rustPlatform.bindgenHook ];
  RUST_BACKTRACE = 1;
}
