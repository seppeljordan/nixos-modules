{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.customServices.gnome;
in
{
  options.customServices.gnome.enable =
    mkEnableOption "gnome3";
  config = mkIf cfg.enable {
    customServices.xserver.enable = true;
    services.xserver = {
      desktopManager = {
        default = "gnome3";
        gnome3 = {
          enable = true;
        };
      };
    };
  };
}
