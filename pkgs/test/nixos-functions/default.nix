/*

This file is a test that makes sure that the `pkgs.botnix` and
`pkgs.testers.nixosTest` functions work. It's far from a perfect test suite,
but better than not checking them at all on hydra.

To run this test:

    botpkgs$ nix-build -A tests.botnix-functions

 */
{ pkgs, lib, stdenv, ... }:

let
  dummyVersioning = {
    revision = "test";
    versionSuffix = "test";
    label = "test";
  };
in lib.optionalAttrs stdenv.hostPlatform.isLinux (
  pkgs.recurseIntoAttrs {

    botnix-test = (pkgs.botnix {
      system.botnix = dummyVersioning;
      boot.loader.grub.enable = false;
      fileSystems."/".device = "/dev/null";
      system.stateVersion = lib.trivial.release;
    }).toplevel;

  }
)
