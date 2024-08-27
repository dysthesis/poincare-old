{inputs, ...}: {
  perSystem = {
    config,
    pkgs,
    lib,
    ...
  }: let
    plugins = with pkgs.vimPlugins; [
      nvim-autopairs
      fzf-lua
    ];

    configuration = lib.nvim.configureNvim {inherit pkgs plugins;};

    neovim-nightly = inputs.neovim-nightly;
  in {
    packages.default = lib.nvim.mkNvim {inherit pkgs neovim-nightly configuration;};
  };
}
