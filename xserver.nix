{ config, lib, pkgs, ... }:
with lib;
let cfg = config.customServices.xserver;
in {
  options.customServices.xserver.enable = mkEnableOption "xserver";

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      layout = "us";
      xkbOptions = "eurosign:e";
    };
    services.redshift = { enable = true; };
    fonts.fonts = with pkgs; [ fira-mono fira dejavu_fonts ];
    environment.systemPackages = with pkgs; [
      ario
      chromium
      evince
      firefox
      gimp
      glxinfo
      gnome3.evolution
      gnome3.file-roller
      gnome3.gnome_terminal
      gnome3.nautilus
      gparted
      hexchat
      keepassx-community
      libreoffice
      mypaint
      nextcloud-client
      owncloudclient
      picard
      plasma-workspace-wallpapers
      signal-desktop
      skype
      slack
      tdesktop
      termite
      thunderbird
      unetbootin
      vlc
      xclip
      xorg.xev
      xterm
    ];
  };
}
