{ system ? builtins.currentSystem }:
with import <nixpkgs/nixos/lib/testing.nix> { inherit system; };
with import <nixpkgs/nixos/lib/qemu-flags.nix>;
with pkgs.lib;
makeTest {
  name = "overlay-test";
  nodes = {
    machine = {config, pkgs, ...}: {
      imports = [
        ./overlays.nix
      ];
      environment.systemPackages = [
        pkgs.python2Packages.hetzner
      ];
    };
  };
  testScript = ''
    startAll;

    $machine->shutdown
  '';
}
