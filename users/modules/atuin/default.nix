{ ... }:
{
  # Shell history database
  programs.atuin = {
    enable = true;

    flags = [
      "--disable-up-arrow"
    ];
  };
}
