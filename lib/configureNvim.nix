{
  pkgs,
  plugins,
  withPython3 ? false,
  withRuby ? false,
  withNodeJs ? false,
}:
pkgs.neovimUtils.makeNeovimConfig {
  inherit withPython3 withRuby withNodeJs plugins;
}
