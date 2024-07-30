{ ... }:
{
  programs.chromium = {
    enable = true;
    # avoids flickering on wayland
    commandLineArgs = [ "--disable-gpu-compositing" ];
  };

  programs.firefox.enable = true;
}
