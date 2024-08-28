# TODO: Define types for plugins. If possible, expose the interface for lz.n to lazy load on events, keybinds, commands, etc. If a keybind is defined and lazy is set to true, then the keybind should also be added as a hook to lazy-load that plugin as well.
# Ideally, the type should look like:
# {
#   name = types.str;
#   package = <package name>;
#   keys = <set of keybindings>;
#   config = <some lua string here>;
#   lazy = {
#     enabled = true | false;
#     ft = <list of file types>;
#     events = <list of events>;
#     cmd = <list of commands>;
#   };
# };
{
}
