{ lib, ... }:
{
  imports = lib.filesystem.listFilesRecursive ./cachix;
}
