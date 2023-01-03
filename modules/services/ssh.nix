{ options, config, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.ssh;
in {
  options.modules.services.ssh = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      sshpass
    ];

    services.openssh = {
      enable = true;
      kbdInteractiveAuthentication = false;
      passwordAuthentication = false;
    };

    user.openssh.authorizedKeys.keys =
      if config.user.name == "zied"
      then [
      #  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM6pxS+faVh8CTTHw2ZZwnm9s54xNpDC6RJzxg43452g ziedak@purple"
        ]
      else [];
  };
}
