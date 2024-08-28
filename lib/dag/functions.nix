# From home-manager: https://github.com/nix-community/home-manager/blob/master/modules/lib/dag.nix
# A generalization of Nixpkgs's `strings-with-deps.nix`.
#
# The main differences from the Nixpkgs version are
#
#  - not specific to strings, i.e., any payload is OK,
#
#  - the addition of the function `entryBefore` indicating a "wanted
#    by" relationship.
{lib}: let
  inherit (lib) all filterAttrs nvim mapAttrs toposort;
in {
  # Empty DAG
  empty = {};

  # It is an entry if it has a data, and there exists a node before and after it.
  isEntry = e:
    e
    ? data
    && e ? after
    && e ? before;

  /*
   *
  * A value is a DAG if:
  *
  * - it is an attribute set, and
  * - the values of the attribute set are all entry nodes.
  */
  isDag = dag:
    builtins.isAttrs dag && all nvim.dag.isEntry (builtins.attrValues dag);

  # Takes an attribute set containing entries built by entryAnywhere,
  # entryAfter, and entryBefore to a topologically sorted list of
  # entries.
  #
  # Internally this function uses the `toposort` function in
  # `<nixpkgs/lib/lists.nix>` and its value is accordingly.
  #
  # Specifically, the result on success is
  #
  #    { result = [ { name = ?; data = ?; } … ] }
  #
  # For example
  #
  #    nix-repl> topoSort {
  #                a = entryAnywhere "1";
  #                b = entryAfter [ "a" "c" ] "2";
  #                c = entryBefore [ "d" ] "3";
  #                d = entryBefore [ "e" ] "4";
  #                e = entryAnywhere "5";
  #              } == {
  #                result = [
  #                  { data = "1"; name = "a"; }
  #                  { data = "3"; name = "c"; }
  #                  { data = "2"; name = "b"; }
  #                  { data = "4"; name = "d"; }
  #                  { data = "5"; name = "e"; }
  #                ];
  #              }
  #    true
  #
  # And the result on error is
  #
  #    {
  #      cycle = [ { after = ?; name = ?; data = ? } … ];
  #      loops = [ { after = ?; name = ?; data = ? } … ];
  #    }
  #
  # For example
  #
  #    nix-repl> topoSort {
  #                a = entryAnywhere "1";
  #                b = entryAfter [ "a" "c" ] "2";
  #                c = entryAfter [ "d" ] "3";
  #                d = entryAfter [ "b" ] "4";
  #                e = entryAnywhere "5";
  #              } == {
  #                cycle = [
  #                  { after = [ "a" "c" ]; data = "2"; name = "b"; }
  #                  { after = [ "d" ]; data = "3"; name = "c"; }
  #                  { after = [ "b" ]; data = "4"; name = "d"; }
  #                ];
  #                loops = [
  #                  { after = [ "a" "c" ]; data = "2"; name = "b"; }
  #                ];
  #              }
  #    true
  topoSort = dag: let
    # Checks if some vertex `name` comes before every other vertex in the DAG.
    dagBefore = dag: name:
      builtins.attrNames
      (filterAttrs
        # Predicate to filter with
        (n: v:
          # Returns true if `name` comes before a vertex `v`
            builtins.elem name v.before)
        # The attribute set to filter
        dag);

    # Change the attributes of the DAG such that each node contains a list of every other node that comes after it.
    normalizedDag =
      mapAttrs
      (n: v: {
        # The usual node attributes.
        name = n;
        data = v.data;
        # Create a set of vertices that comes after this one...
        after =
          # ... by prepending its direct successor...
          v.after
          # ... to the list of vertices that comes after the current node.
          ++ dagBefore dag n;
      })
      dag;
    before = a: b: builtins.elem a.name b.after;
    sorted = toposort before (builtins.attrValues normalizedDag);
  in
    if sorted ? result
    then {
      result = map (v: {inherit (v) name data;}) sorted.result;
    }
    else sorted;

  # Applies a function to each element of the given DAG.
  map = f: mapAttrs (n: v: v // {data = f n v.data;});

  entryBetween = before: after: data: {inherit data before after;};

  # Create a DAG entry with no particular dependency information.
  entryAnywhere = nvim.dag.entryBetween [] [];

  entryAfter = nvim.dag.entryBetween [];
  entryBefore = before: nvim.dag.entryBetween before [];

  # Topologically sort the DAG if possible (no cycles), or report the cycle otherwise.
  resolveDag = {
    name,
    dag,
    mapResult,
  }: let
    sortedDag = nvim.dag.topoSort dag;
    result =
      if sortedDag ? result
      then mapResult sortedDag.result
      else abort ("Dependency cycle in ${name}: " + builtins.toJSON sortedDag);
  in
    result;
}
