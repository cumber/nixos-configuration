{ config, pkgs, ... }:
  {
    nix.settings = {
      substituters = [
        "https://cache.iog.io"
        "https://cache.zw3rk.com"
      ];

      trusted-public-keys = [
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
        "loony-tools:pr9m4BkM/5/eSTZlkQyRt57Jz7OMBxNSUiMC4FkcNfk="
      ];
    };
  }
