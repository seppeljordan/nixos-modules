{ config, lib, ... }:
with lib;
let
  cfg = config.customServices.tinc;
  tincConnect = concatMapStrings
    (name: ''
        ConnectTo = ${name}
     ''
    ) cfg.connectNames;
in
{
  options.customServices.tinc = {
    enable = mkEnableOption "tinc networking";
    hosts = mkOption {
      type = with types; attrsOf str;
      description =
        "Description of the hosts of the tinc network";
    };
    privateKey = mkOption {
      type = types.path;
      description = "The private key to use for transport encryption";
    };
    connectNames = mkOption {
      type = with types; listOf str;
      description =
        "Tinc hosts to connect with";
    };
    name = mkOption {
      type = types.str;
      description =
        "Name of the host known to the tinc network";
    };
    address = mkOption {
      type = types.str;
      description =
        "Tinc address of the machine";
    };
  };
  config = mkIf cfg.enable {
    networking.firewall.allowedUDPPorts = [ 655 ];
    networking.firewall.allowedTCPPorts = [ 655 ];
    networking.interfaces."tinc.private".ip4 = [{
      address = cfg.address;
      prefixLength = 16;
    }];
    services.tinc.networks."private" = {
      ed25519PrivateKeyFile = cfg.privateKey;
      name = cfg.name;
      chroot = false;
      listenAddress = "0.0.0.0";
      interfaceType = "tap";
      hosts = cfg.hosts;
      extraConfig = tincConnect;
    };
  };
}
