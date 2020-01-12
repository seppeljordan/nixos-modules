{ config, lib, pkgs, ... }:
let
  overlays = with builtins;
    _nixpkgs.fetchFromGitHub (fromJSON (readFile ./overlay.json));
  # overlays = /home/sebastian/deployments/nix-overlay;
  importOverlays = name: import "${overlays}/${name}";
  _nixpkgs = import <nixpkgs> { };
in {
  nixpkgs.overlays = builtins.map importOverlays [
    "10-python3Packages"
    "10-custom-software"
    "90-custom"
  ];
}
