{ config, lib, pkgs, ... }:
with lib;
let cfg = config.customServices.pulseaudio;
in {
  options.customServices.pulseaudio.enable = mkEnableOption "pulseaudio";
  config = mkIf cfg.enable {
    hardware.pulseaudio.enable = true;
    hardware.pulseaudio.package = pkgs.pulseaudioFull;
  };
}
