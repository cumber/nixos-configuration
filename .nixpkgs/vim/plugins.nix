{ vimUtils, fetchgit, fetchurl, stdenv }: super:
  let vim-hdevtools = vimUtils.buildVimPluginFrom2Nix {
        name = "vim-hdevtools-2016-11-15";
        src = fetchgit {
          url = "git://github.com/expipiplus1/vim-hdevtools.git";
          rev = "9b80351528f8c7755ea965ba8abaf9d79d90418e";
          sha256 = "0lyrh7bn0a8jyyz80akydhj8vjal7lxci218q997jg7sr81q8k88";
        };
        dependencies = [];
      };

      vim-misc = vimUtils.buildVimPluginFrom2Nix {
        name = "vim-misc-2015-05-21";
        src = fetchgit {
          url = "git://github.com/xolox/vim-misc";
          rev = "3e6b8fb6f03f13434543ce1f5d24f6a5d3f34f0b";
          sha256 = "0rd9788dyfc58py50xbiaz5j7nphyvf3rpp3yal7yq2dhf0awwfi";
        };
        dependencies = [];

      };


  in  super // {
        inherit vim-hdevtools;
        inherit vim-misc;
      }
