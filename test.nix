import <nixpkgs/nixos/tests/make-test.nix>
{
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
