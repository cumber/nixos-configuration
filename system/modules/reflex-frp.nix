{ config, pkgs, ... }:
  {
    nix.settings = {
      substituters = [
        "https://nixcache.reflex-frp.org"
      ];

      trusted-public-keys = [
        "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
      ];
    };
  }
