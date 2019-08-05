{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.customServices.games;
in
{
  options.customServices.games.enable =
    mkEnableOption "Games";
  config = mkIf cfg.enable {
    networking.firewall.allowedUDPPorts = [
      34197 # factorio
    ];
    environment.systemPackages = with pkgs; [
      dwarf-fortress
      dwarf-therapist
      keen4
      steam
      xboxdrv
      zsnes
    ];
    hardware.pulseaudio.support32Bit = true;
    hardware.opengl.driSupport32Bit = true;
  };
}
