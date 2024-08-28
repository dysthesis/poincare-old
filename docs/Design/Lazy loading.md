# Lazy loading

With Nix effectively serving as the plugin manager for Neovim, we need a way to lazy-load plugins.

We want to lazy load plugins whenever appropriate in order to amortise the load times. Individually, plugins only take miliseconds to load. However, when they are all loaded on startup, these startup times add up and becomes more noticeable. Furthermore, since we do not know which plugins will be used by the user whenever Neovim is started up, loading all of the plugins at startup risks incurring unnecessary costs. Lazy loading spreads these startup times out by only loading a plugin when they are needed, and hence keeps these startup times unnoticeable for the average person.

> [!TIP]
> Neovim has a built-in command called `:packadd` to manually lazy-load plugins.

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

## lzn-auto-require

To ensure that all dependencies of a plugin are properly loaded, [lzn-auto-require](https://github.com/horriblename/lzn-auto-require) can be used.
