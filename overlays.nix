{ config, lib, pkgs, ... }:
let
  importOverlays = name: import "${overlays}/${name}";
  _nixpkgs = import <nixpkgs> {};
  overlays = _nixpkgs.fetchgit {
    url = "https://github.com/seppeljordan/nix-overlay.git";
    rev = "6b13347df36bbfd20574f285713ced6962038965";
    sha256 = "15claih4931xiy32mq55k9qv4p60w5zbxjsi7awd8dy3rjcgc0kw";
  };
in
{
  nixpkgs.overlays = builtins.map
  importOverlays [
    "10-python3Packages"
    "10-python2Packages"
    "10-nixpkgs-python"
    "90-custom"
  ];
}
