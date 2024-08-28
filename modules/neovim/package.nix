{
  config,
  pkgs,
  neovim-nightly,
  lib,
  ...
}: let
  inherit (lib) mkOption;
  inherit (lib.types) bool package;
in {
  options.vim = {
    package = mkOption {
      type = package;
      default =
        if config.vim.nightly
        then neovim-nightly.packages.${pkgs.system}.default
        else pkgs.neovim-unwrapped;
      description = "Which Neovim package to wrap";
    };
    nightly = mkOption {
      type = bool;
      default = false;
      description = "Whether to use the nightly package of Neovim.";
    };
  };
}
