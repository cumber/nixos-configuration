{ ... }:
{
  boot.initrd.luks.devices = {
    nixos = {
      device = "/dev/disk/by-partlabel/luks-nixos";
      bypassWorkqueues = true;
    };

    swap = {
      device = "/dev/disk/by-partlabel/luks-swap";
      bypassWorkqueues = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/mapper/nixos";
      fsType = "btrfs";
      options = [
        "subvol=@"
        "noatime"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-label/ESP";
      fsType = "vfat";
      options = [
        "umask=0022"
        "noatime"
      ];
    };

    "/home/cumber" = {
      device = "/dev/mapper/nixos";
      fsType = "btrfs";
      options = [
        "subvol=@home_cumber"
        "noatime"
      ];
    };
  };

  swapDevices = [ { device = "/dev/mapper/swap"; } ];
}
