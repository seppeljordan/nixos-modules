{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.customServices.xserver;
in
{
  options.customServices.xserver.enable =
    mkEnableOption "xserver";

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      layout = "us";
      xkbOptions = "eurosign:e";
    };
    services.redshift = {
      enable = true;
      latitude = "52.4584";
      longitude = "13.438";
    };
    fonts.fonts = with pkgs;
      [ fira-mono fira dejavu_fonts ];
    environment.systemPackages = with pkgs; [
      ario
      chromium
      display-config
      evince
      firefox
      gimp
      glxinfo
      gnome3.evolution
      gnome3.file-roller
      gnome3.gnome_terminal
      gparted
      hexchat
      keepassx-community
      libreoffice
      meld
      mypaint
      owncloudclient
      picard
      plasma-workspace-wallpapers
      tdesktop
      termite
      thunderbird
      vlc
      xclip
      xorg.xev
      xterm
    ];
  };
}
