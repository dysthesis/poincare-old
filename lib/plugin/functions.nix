# Taken from https://github.com/jordanisaacs/neovim-flake/blob/main/modules/lib/plugins.nix
lib: let
  inherit
    (lib)
    mkOption
    mapAttrs'
    nameValuePair
    removePrefix
    hasPrefix
    filterAttrs
    ;

  inherit
    (lib.types)
    bool
    ;
in {
  fromInputs = inputs: prefix:
  /*
   *
  * `mapAttrs` takes a function, which itself takes in an attribute name and its value, and maps it to a set of attributes.
  * `mapAttrs'` is like mapAttrs, but allows the name of each attribute to be changed in addition to the value.
  */
    mapAttrs'
    # This is the function to be mapped to the attribute set
    (name: value:
      # nameValuePair is a stdlib function that takes in a name (string) and a value (any), and returns a pair `{name, value}` for `builtins.listToAttrs`
        nameValuePair
        /*
         *
        * This is the name, which is the plugin name from `inputs` in flake.nix, but without the `plugins-` prefix
        * e.g.`telescope` instead of `plugins-telescope`.
        */
        (removePrefix prefix name)
        # In this context, the value is then the plugin repository in `inputs` in flake.nix
        {src = value;})
    /*
     *
    * This is the target attribute set to apply the function above to.
    *
    * `filterAttrs` is a stdlib function which:
    *
    * - takes in a predicate and an attribute set, and
    * - filters the attribute set by removing the attributes for which the predicate returns `false`.
    *
    * Here, it is used to filter out any attributes in inputs that does not have the prefix `plugins-` (i.e., is not designated as a plugin).
    */
    (filterAttrs
      (n: _:
        hasPrefix prefix n)
      inputs);

  mkPluginOpt = description: {
    enable = mkOption {
      type = bool;
      default = false;
      inherit description;
    };
    lazy = {
      enable = mkOption {
        type = bool;
        default = false;
        description = "Whether to lazy load this plugin";
      };
    };
  };
}
