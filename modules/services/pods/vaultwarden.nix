{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.pods.vaultwarden;
in {
  options.modules.services.pods.vaultwarden = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      backend = "docker";
      containers."vaultwarden" = {
        autoStart = true;
        image = "vaultwarden/server:latest";
        ports = [
          "8082:8082"
        ];
        volumes = [
          "/var/cache/vaultwarden/data:/data"
        ];
        environment = {
          WEBSOCKET_ENABLED = "true";
          ROCKET_PORT = "8082";
        };
      };
    };
    systemd.services.docker-vaultwarden.serviceConfig = {
      User = "ziedak";
      Group = "docker";
      CacheDirectory = "vaultwarden";
      CacheDirectoryMode = "0750";
    };
  };
}
