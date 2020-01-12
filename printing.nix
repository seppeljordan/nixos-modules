{ config, lib, pkgs, ... }:
with lib;
let cfg = config.customServices.printing;
in {
  options.customServices.printing.enable = mkEnableOption "printing drivers";
  config = mkIf cfg.enable {
    services = {
      printing = {
        enable = true;
        drivers = with pkgs; [ gutenprint hplip splix foomatic-filters ];
      };
    };
  };
}
