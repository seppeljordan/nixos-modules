{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.customServices.tinc;
  hostNameToConfigLine = name: "ConnectTo = ${name}";
  tincConnect = intersperse "\n" (map hostNameToConfigLine cfg.connectNames);
  tincConnectString = concatStrings tincConnect;
  networkName = "private";
in {
  options.customServices.tinc = {
    enable = mkEnableOption "tinc networking";
    hosts = mkOption {
      type = with types; attrsOf str;
      description = "Description of the hosts of the tinc network";
    };
    privateKey = mkOption {
      type = types.path;
      description = "The private key to use for transport encryption";
    };
    connectNames = mkOption {
      type = with types; listOf str;
      description = "Tinc hosts to connect with";
    };
    name = mkOption {
      type = types.str;
      description = "Name of the host known to the tinc network";
    };
    address = mkOption {
      type = types.str;
      description = "Tinc address of the machine";
    };
  };
  config = mkIf cfg.enable {
    networking.firewall.allowedUDPPorts = [ 655 ];
    networking.firewall.allowedTCPPorts = [ 655 ];
    services.tinc.networks."${networkName}" = {
      ed25519PrivateKeyFile = cfg.privateKey;
      name = cfg.name;
      chroot = false;
      hosts = cfg.hosts;
      extraConfig = tincConnectString;
      debugLevel = 1;
    };
    environment.etc."tinc/${networkName}/tinc-up" = {
      text = ''
        ${pkgs.iproute}/bin/ip address add ${cfg.address}/16 dev $INTERFACE
        ${pkgs.iproute}/bin/ip link set $INTERFACE up
      '';
      mode = "0555";
    };
  };
}
