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

  in  super // {
        inherit vim-hdevtools;
      }
