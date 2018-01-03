{ config, lib, pkgs, ... }:
let
  importOverlays = builtins.map import;
in
{
  nixpkgs.overlays = importOverlays [
    ../overlays/10-python3Packages
    ../overlays/10-python2Packages
    ../overlays/10-nixpkgs-python
    ../overlays/90-custom
  ];
}
