{ config, lib, ...}:
let

cfg = config.customServices.riemann;
riemann-config = ''
  (logging/init {:console true})
  (let [host "${cfg.bindAddress}"]
    (tcp-server {:host host :port ${builtins.toString cfg.tcpPort}})
    (ws-server {:host host :port ${builtins.toString cfg.websocketPort}}))

  (instrumentation {:enabled? false})

  (streams
   (default :ttl 60
            (index)))
'';

in

{
  options.customServices.riemann = with lib; {
    enable = mkEnableOption "riemann";
    websocketPort = mkOption {
      type = types.ints.unsigned;
    };
    tcpPort = mkOption {
      type = types.ints.unsigned;
    };
    bindAddress = mkOption {
      type = types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    services.riemann.enable = true;
    services.riemann.config = riemann-config;
    networking.firewall.allowedTCPPorts = [ cfg.tcpPort cfg.websocketPort ];
  };
}
