{ lib, config, ... }:
with lib;
let cfg = config.customServices.bluetooth;
in {
  options.customServices.bluetooth = {
    enable = mkEnableOption "bluetooth services";
  };
  config = mkIf cfg.enable { hardware.bluetooth.enable = true; };
}
