{ lib, ... }:
{
  lib.local = rec {
    compose =
      f: g: x:
      f (g x);
    composeAll = lib.foldr compose lib.id;

    findAndImportOverlays = composeAll [
      (map import)
      (lib.filter (p: baseNameOf p == "overlay.nix"))
      lib.filesystem.listFilesRecursive
    ];

    readSubDirs = composeAll [
      lib.attrNames
      (lib.filterAttrs (_: type: type == "directory"))
      builtins.readDir
    ];
  };
}
