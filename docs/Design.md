# Design

This documents my research on Neovim and Neovim flakes, and my understanding of how they are created and structured.

## Wrapper

## Lazy loading

Neovim has a built-in command called `:packadd!` to manually lazy-load plugins.

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