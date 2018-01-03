{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.kubernetes_1_6;

{
  # interface
  options.services.kubernetes_1_6 = {

    kube-apiserver = {
      enabled = mkOption {
        description = "Whether to enable kube-apiserver";
        type = types.bool;
        default = false;
      };
    };

  };
  # implementation
  config =
  let
    kube-apiserver-options = ''
      --allow-privileged
    '';
  in
    mkIf cfg.enabled {
      systemd.services."kube-apiserver-1.6" = {
        description = "kubernetes api webserver";
        wanted-by = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          type = "notify";
          ExecStart = "${pkgs.kubernetes}/bin/kube-apiserver ${kube-apiserver-options}"
        };
      };
  };
}
