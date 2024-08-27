{
  lib,
pkgs,
  ...
}: lib.extend (final: prev: {
    mkNeovim = pkgs.callPackage ./mkNeovim.nix { inherit pkgs; };
})
