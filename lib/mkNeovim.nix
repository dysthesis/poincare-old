{
  pkgs,
  withPython3 ? false,
  withRuby ? false,
  withNodeJs ? false,
  ...
}: let
  nvimConfig = pkgs.neovimUtils.makeNeovimConfig {
    inherit withPython3 withRuby withNodeJs;
    plugins = with pkgs.vimPlugins; [
      nvim-autopairs
      fzf-lua
    ];
  };
in
  pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped nvimConfig
