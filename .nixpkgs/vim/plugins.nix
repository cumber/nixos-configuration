{ vimUtils, fetchgit, fetchurl, stdenv }: super:
  let easytags = vimUtils.buildVimPluginFrom2Nix {
        name = "easytags-3.11";
        src = fetchurl {
          name = "easytags-3.11.tar.gz";
          url = "https://github.com/xolox/vim-easytags/archive/3.11.tar.gz";
          sha256 = "044vd8cfkl9a1r2iqw2i57g63cmr9rrxbaz9fqwzk63mzfhmwdiw";
        };
        dependencies = [ "vim-misc" ];
      };

      vim-misc = vimUtils.buildVimPluginFrom2Nix {
        name = "vim-misc-1.17.6";
        src = fetchurl {
          name = "vim-misc-1.17.6.tar.gz";
          url = "https://github.com/xolox/vim-misc/archive/1.17.6.tar.gz";
          sha256 = "1isxmxng39d869y1q1bhximkr1frnqxjyynk6cy1s6n9c88ckjb6";
        };
        dependencies = [];
      };

      rainbow-parentheses-improved = vimUtils.buildVimPluginFrom2Nix {
        name = "rainbow-parentheses-improved-2015-12-02";
        src = fetchgit {
          url = "git://github.com/luochen1990/rainbow";
          rev = "18b7bc1b721f32fcabe740e098d693eace6ad655";
          sha256 = "0wyhifdpdzbgppsq1gyh41nf2dgwcvmh29qc69r0akphpqhhk3m4";
        };
        dependencies = [];
      };

  in  super // {
        inherit rainbow-parentheses-improved;
        inherit easytags;
        inherit vim-misc;
      }
