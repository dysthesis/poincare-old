lib:
lib.extend (final: prev: {
  nvim = {
    configureNvim = import ./configureNvim.nix;
    dag = import ./dag final;
    helper = import ./helpers.nix;
    plugin = import ./plugin;
  };
})
