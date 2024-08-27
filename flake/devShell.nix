{
  perSystem = {
    self',
    config,
    pkgs,
    ...
  }: {
    devShells = {
      default = self'.devShells.lsp;
      nvim-nix = pkgs.mkShell {
          packages = [
            config.packages.nix
          ];
        };
      lsp = pkgs.mkShell {
        packages = with pkgs; [
          nil
          statix
          deadnix
          alejandra
        ];
      };
    };
  };
}
