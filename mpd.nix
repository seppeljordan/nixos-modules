{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.customServices.mpd;
in
{
  options.customServices.mpd.enable = mkEnableOption "mpd";
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
      musicDirectory = "/home/sebastian/ownCloud/music";
      dataDir = "/home/sebastian/.mpd";
      user = "sebastian";
      group = "users";
    };
    environment.systemPackages = with pkgs; [
      chromaprint
      ncmpc
      mpc_cli
    ];
  };
}
