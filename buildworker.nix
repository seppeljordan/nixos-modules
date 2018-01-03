{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.customServices.buildworker;
in
{
  options.customServices.buildworker = {
    enable = mkEnableOption "nix build worker";
  };
  config = mkIf cfg.enable {
    nix.trustedUsers = [ "root" "buildfarm" ];
    users.extraUsers = {
      buildfarm = {
        isNormalUser = true;
        openssh.authorizedKeys.keyFiles = [
          /home/sebastian/servers/nixops/sshkeys/buildkey.pub
        ];
      };
    };
  };
}
