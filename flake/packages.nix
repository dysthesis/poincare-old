{
  inputs,
  config,
  ...
}: {
  perSystem = {
    pkgs,
    lib,
    ...
  }: let
    plugins = with pkgs.vimPlugins; [
      lz-n
      telescope-nvim
    ];

    package =
      if config.vim.nightly
      then inputs.neovim-nightly.packages.${pkgs.system}.default
      else pkgs.neovim-unwrapped;

    configuration = lib.nvim.configureNvim {inherit pkgs plugins;};

    nvim-wrapped = pkgs.wrapNeovimUnstable package configuration;
  in {
    packages.default = nvim-wrapped;
  };
}
