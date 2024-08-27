{
  perSystem = {
    self',
    config,
    pkgs,
    ...
  }: {
    devShells = {
      default = pkgs.mkShell {
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
