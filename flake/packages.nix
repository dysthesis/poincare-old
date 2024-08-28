{inputs, ...}: {
  perSystem = {
    config,
    pkgs,
    lib,
    ...
  }: let
    plugins = with pkgs.vimPlugins; [
      lz-n
      {
        plugin = pkgs.vimPlugins.telescope-nvim;
        config =
          /*
          lua
          */
          ''
            require("lz.n").load {
              "telescope.nvim",
              keys = {
                { "<leader>ff", "<CMD>Telescope<CR>", desc = "[F]ind [F]iles" },
              },
            }
          '';
        type = "lua";
        optional = true;
      }
    ];

    nightly = true;

    nvim =
      if nightly
      then inputs.neovim-nightly.packages.${pkgs.system}.default
      else pkgs.neovim-unwrapped;

    configuration = lib.nvim.configureNvim {inherit pkgs plugins;};
  in {
    packages.default = pkgs.wrapNeovimUnstable nvim configuration;
  };
}
