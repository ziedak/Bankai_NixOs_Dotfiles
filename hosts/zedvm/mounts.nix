{ config, pkgs, ... }:
{
  programs.fuse.userAllowOther = true;

  environment.systemPackages = with pkgs; [
   
  ];

  # fileSystems."/" = {
  #   device = "/dev/disk/by-label/nixos";
  #   fsType = "ext4";
  # };

  # swapDevices = [ {
  #   device = "/dev/disk/by-label/swap";
  # } ];

  # Do not start a sulogin shell if mounting a filesystem fails
  systemd.enableEmergencyMode = false;
}
