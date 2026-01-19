# Example to create a bios compatible gpt partition
{ lib, ... }:
{
  disko.devices = {
    disk.main = {
      device = "/dev/sda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "1M";
            type = "EF02"; # for grub MBR
            priority = 1; # Needs to be first partition
          };
          ESP = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          swap = {
            size = "1G";
            content = {
              type = "swap";
              randomEncryption = true;
            };
          };
          root = {
            size = "100%";
            content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
            };
          };
        };
      };
    };
  };
}