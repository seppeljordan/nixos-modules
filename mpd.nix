{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.customServices.mpd;
in
{
  options.customServices.mpd = {
    enable = mkEnableOption "mpd";
    user = mkOption {
      type = types.str;
    };
  };
  config = mkIf cfg.enable {
    services.mpd = {
      enable = true;
      extraConfig=''
        audio_output {
          type        "pulse"
          name        "MPD"
          server      "/run/user/1000/pulse/native"
        }
      '';
      dataDir = "/home/${cfg.user}/.mpd";
      user = "${cfg.user}";
      group = "users";
    };
    environment.systemPackages = with pkgs; [
      chromaprint
      ncmpc
      mpc_cli
    ];
  };
}
