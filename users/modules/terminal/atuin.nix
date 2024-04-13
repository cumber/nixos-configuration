{ ... }:
{
  # Shell history database
  programs.atuin = {
    enable = false;

    flags = [
      "--disable-up-arrow"
    ];
  };
}
