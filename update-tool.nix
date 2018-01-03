{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.customServices.updateTool;
  jobType = with types; submodule { options = {
    jobset = mkOption {
      type = path;
      description = "Path to the the jobset that should be performed";
    };
    repoPath = mkOption {
      type = path;
      description = "The path of the repository";
    };
  };};
  update-tool-script = pkgs.writeScript "update-tool-script"
    (concatStringsSep "\n"
      ( [ "#!${pkgs.stdenv.shell}" ] ++
        builtins.map
        ({ jobset, repoPath, ...}:
          "${pkgs.haskellPackages.update-tool}/bin/update-tool ${repoPath} ${jobset}"
        )
        cfg.jobs
      )
    );
in
{
  options.customServices.updateTool = {
    enable = mkEnableOption "update-tool";
    jobs = with types; mkOption {
      type = listOf jobType;
      default = [];
      description = "Jobs to perform";
    };
  };
  config = mkIf cfg.enable {
    systemd.timers."update-tool" = {
      wantedBy = [ "multi-user.target" ];
      timerConfig = {
        "OnBootSec" = "10min";
        "OnActiveSec" = "1h";
      };
    };
    systemd.services."update-tool" = {
      path = with pkgs;
        [ nix gnutar gzip ];
      environment = {
        "NIX_PATH" = "nixpkgs=https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz";
      };
      serviceConfig = {
        ExecStart="${update-tool-script}";
      };
    };
  };
}
