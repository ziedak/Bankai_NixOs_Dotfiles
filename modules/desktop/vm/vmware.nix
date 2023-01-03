# modules/desktop/vm/vmware.nix
#
# For testing or building software on other OSes. If I find out how to get macOS
# on qemu/libvirt I'd be happy to leave vmware behind.

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.vm.vmware;
in {
  options.modules.desktop.vm.vmware = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    virtualisation.vmware.guest = {
      enable = true;
    };

    user.extraGroups = [ "vmware" ];
  };
}
