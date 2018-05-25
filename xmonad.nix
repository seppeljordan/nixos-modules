{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.customServices.xmonad;
in
{
  options.customServices.xmonad = {
    enable = mkEnableOption "xmonad";
    inactiveOpacity = mkOption {
      type = types.str;
      default = "1";
    };
  };

  config = mkIf cfg.enable {
    customServices.xserver.enable = true;
    services.xserver = {
      windowManager.default = "xmonad";
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages =
          haskellPackages: with haskellPackages;
          [ parsec
            alsa-mixer
          ];
      };
      desktopManager = {
        xterm.enable = false;
        default = "none";
      };
      # synaptics = {
      #   enable = true;
      #   twoFingerScroll = true;
      #   accelFactor = "1.2";
      #   fingersMap = [ 1 3 2];
      # };
      libinput.enable = true;
      displayManager.sessionCommands = ''
        export GTK_DATA_PREFIX=${config.system.path}
        export GTK_PATH=${config.system.path}/lib/gtk-3.0:${config.system.path}/lib/gtk-2.0
        export XCURSOR_PATH=~/.icons:~/.nix-profile/share/icons:/var/run/current-system/sw/share/icons
        ${pkgs.xorg.xset}/bin/xset r rate 220 50
        if [[ -z "$DBUS_SESSION_BUS_ADDRESS" ]]; then
          eval "$(${pkgs.dbus.out}/bin/dbus-launch --sh-syntax --exit-with-session)"
          export DBUS_SESSION_BUS_ADDRESS
        fi
      '';
    };

    environment.systemPackages = with pkgs; [
      arc-icon-theme
      display-config
      dzen2
      feh
      gnome3.defaultIconTheme
      gtk2
      haskellPackages.xmobar
      hicolor_icon_theme
      networkmanagerapplet
      pa_applet
      pavucontrol
      shared_mime_info
      tango-icon-theme
      trayer
      vanilla-dmz
      xfce.ristretto
      xorg.xbacklight
    ];
    services.compton = {
      enable = true;
      backend = "xrender";
      inactiveOpacity = "${cfg.inactiveOpacity}";
    };
  };
}
