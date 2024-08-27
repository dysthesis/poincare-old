lib:
lib.extend (final: prev: {
  nvim = {
    configureNvim = import ./configureNvim.nix;
    mkNvim = import ./mkNvim.nix;
  };
})
