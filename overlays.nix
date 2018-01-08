{ config, lib, pkgs, ... }:
let
  importOverlays = name: import "${overlays}/${name}";
  _nixpkgs = import <nixpkgs> {};
  overlays = with builtins;
    _nixpkgs.fetchgit (fromJSON (readFile ./overlay.json));
in
{
  nixpkgs.overlays = builtins.map
  importOverlays [
    "10-python3Packages"
    "10-python2Packages"
    "90-custom"
  ];
}
