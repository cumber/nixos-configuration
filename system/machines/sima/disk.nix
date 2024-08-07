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
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

    "/boot" = {
      device = "/dev/disk/by-label/ESP";
      fsType = "vfat";
      options = [ "umask=0022" ];
    };
  };

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];
}
