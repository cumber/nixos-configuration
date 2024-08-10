{ ... }:
{
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
      };
      efi.canTouchEfiVariables = true;
    };

    plymouth.enable = true;

    # plymouth can't show graphical luks password prompt without this
    initrd.systemd.enable = true;

    # plymouth otherwise waits for something else to time out before falling
    # back to simpledrm
    kernelParams = [ "plymouth.use-simpledrm" ];
  };
}
