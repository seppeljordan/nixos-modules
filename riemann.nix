{ pkgs, lib, config, ...}:

let
  cfg = config.customServices.riemann-dash;
  serviceConfig = ''
    set :port, ${builtins.toString cfg.port}
    set :bind, "${cfg.bind}"
    config[:ws_config] = '${cfg.workspaceConfig}'
  '';
in
{
  options.customServices.riemann-dash = with lib; {
    enable = mkEnableOption "Riemann dash";
    port = mkOption {
      type = types.ints.unsigned;
    };
    bind = mkOption {
      type = types.str;
      default = "127.0.0.1";
    };
    workspaceConfig = mkOption {
      type = types.path;
      default = "/var/riemann-dash/config.json";
    };
  };
  config = lib.mkIf cfg.enable {
    services.riemann-dash = {
      enable = true;
      config = serviceConfig;
    };
  };
}
