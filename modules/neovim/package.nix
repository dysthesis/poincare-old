{lib, ...}: let
  inherit (lib) mkOption;
  inherit (lib.types) bool;
in {
  options.vim.nightly = mkOption {
    type = bool;
    default = false;
    description = "Whether to use the nightly package of Neovim.";
  };
}
