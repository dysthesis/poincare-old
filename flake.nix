{
  description = "A flake of chaos.";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = inputs @ {
    flake-parts,
    self,
    nixpkgs,
    ...
  }: let
    lib = import ./lib inputs.nixpkgs.lib;
  in
    flake-parts.lib.mkFlake {
      inherit inputs;
      specialArgs = {inherit lib;};
    } {
      imports = [
        ./flake
        inputs.treefmt-nix.flakeModule
      ];

      flake = let
        inherit (lib) mkOption;
        inherit (lib.types) bool;
      in {
        options.vim.nightly = mkOption {
          type = bool;
          default = false;
          description = "Whether to use the nightly package of Neovim.";
        };
      };

      systems = import inputs.systems;
    };
}
