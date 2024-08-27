{inputs, ...}:{
  perSystem = {
    config,
    pkgs,
    lib,
    ...
  }:{
      packages.default = pkgs.callPackage ../lib/mkNeovim.nix { 
        inherit pkgs;
        inherit (inputs) neovim-nightly;
        nightly = true;
      };
    };
}
