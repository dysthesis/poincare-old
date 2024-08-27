{
  pkgs,
  configuration,
  neovim-nightly,
  nightly ? false,
  ...
}: let
  nvim =
    if nightly
    then neovim-nightly.packages.${pkgs.system}.default
    else pkgs.neovim-unwrapped;
in
  pkgs.wrapNeovimUnstable nvim configuration
