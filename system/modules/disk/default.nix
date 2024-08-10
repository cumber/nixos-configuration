# NOTE: Standard disk layout module assumes that LUKS-encrypted partitions for
# root and swap are set up with the appropriate partition labels. This has to
# be done manually during system installation, but then this configuration will
# work regardless of the physical disk type and partition location.
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
        "user_subvol_rm_allowed"
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
  };

  swapDevices = [ { device = "/dev/mapper/swap"; } ];
}
