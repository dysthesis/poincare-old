{
  neovim-nightly,
  pkgs,
  nightly ? false,
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
  nvim =  if nightly 
          then neovim-nightly.packages.${pkgs.system}.default
          else pkgs.neovim-unwrapped;
in
  pkgs.wrapNeovimUnstable nvim nvimConfig
