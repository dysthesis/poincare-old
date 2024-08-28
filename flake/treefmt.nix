{
  perSystem = {
    treefmt = {
      projectRootFile = "flake.nix";

      programs = {
        alejandra.enable = true;
        deadnix.enable = false;
        shellcheck.enable = true;
        stylua.enable = true;
        shfmt = {
          enable = true;
          indent_size = 4;
        };
      };
    };
  };
}
