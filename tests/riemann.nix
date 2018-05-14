let
  riemannTcpPort = 5555;
  riemannWebsocketPort = 5556;
in
import <nixpkgs/nixos/tests/make-test.nix>
{
  name = "overlay-test";
  nodes = {
    machine = {config, pkgs, ...}: {
      imports = import ../modulelist.nix;
      customServices.riemann = {
        enable = true;
        websocketPort = riemannWebsocketPort;
        tcpPort = riemannTcpPort;
        bindAddress = "0.0.0.0";
      };
    };
  };
  testScript = ''
    startAll;
    $machine->waitForOpenPort(${builtins.toString riemannTcpPort});
    $machine->waitForOpenPort(${builtins.toString riemannWebsocketPort});
    $machine->shutdown
  '';
}
