{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.customServices.buildworker;
in
{
  options.customServices.buildworker = {
    enable = mkEnableOption "nix build worker";
    key = mkOption {
      type = types.path;
      description = "Public ssh key for build worker";
    };
  };
  config = mkIf cfg.enable {
    nix.trustedUsers = [ "root" "buildfarm" ];
    users.extraUsers = {
      buildfarm = {
        isNormalUser = true;
        openssh.authorizedKeys.keyFiles = [
          cfg.key
        ];
      };
    };
  };
}
