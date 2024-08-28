# Design

This documents my research on Neovim and Neovim flakes, and my understanding of how they are created and structured.

## Wrapper

`neovim-unwrapped` provides a barebones Neovim package.

We can then wrap them using `neovimUtils.makeNeovimConfig`, which is provided by nixpkgs.

Wrapping involves bundling Neovim with

- its configuration files,
- plugins, and
- utilities, such as LSPs, formatters, linters, _etc._

## Lazy loading

We want to lazy load plugins whenever appropriate in order to amortise the load times. Individually, plugins only take miliseconds to load. However, when they are all loaded on startup, these startup times add up and becomes more noticeable. Furthermore, since we do not know which plugins will be used by the user whenever Neovim is started up, loading all of the plugins at startup risks incurring unnecessary costs. Lazy loading spreads these startup times out by only loading a plugin when they are needed, and hence keeps these startup times unnoticeable for the average person.

Neovim has a built-in command called `:packadd` to manually lazy-load plugins.

However, we want to automate this on certain triggers. [lz.n](https://github.com/nvim-neorocks/lz.n) is used to achieve this. As per its README, it has:

> API for lazy-loading plugins on:
>
> - Events (`:h autocmd-events`)
> - `FileType` events
> - Key mappings
> - User commands
> - Colorscheme events

I have no idea what 'colorscheme events' refer to here, but everything else in the list is exactly what I'm looking for.

It even has [examples](https://github.com/nvim-neorocks/lz.n#examples) for Nix.

## Modularity

There are two possible routes I could take:

- creating a regular Neovim configuration inside the flake, or
- splitting them up into modules.

The former would provide more portability (you can use it without Nix), while the latter would provide more modularity (you can toggle sections of the configuration on or off depending on the needs).

I will choose to go down the latter route, as

- it would let me easily load only the necessary parts of the configuration (_e.g._ it is possible to mix-and-match on different devShells), and
- I'm not sure how I would go about adding an alternative plugin manager for non-Nix uses if I were to go with the former.

The [module system](https://nix.dev/tutorials/module-system/a-basic-module/index.html) will be used to abstract the configuration of the flake. [notashelf/nvf](https://github.com/notashelf/nvf) is an excellent example of how this works.
