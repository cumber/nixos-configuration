
{
  nix = {
    settings = {
      # used for https://github.com/fossar/nix-phps
      substituters = [
        "https://fossar.cachix.org"
      ];
      trusted-public-keys = [
        "fossar.cachix.org-1:Zv6FuqIboeHPWQS7ysLCJ7UT7xExb4OE8c4LyGb5AsE="
      ];
    };
  };
}
