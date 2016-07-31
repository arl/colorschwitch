# colorschwitch

**VIM plugin to easily switch vim color schemes**


Switch through your installed vim color schemes with:

| Shortcut  | Action |
| --------- | ------ |
| F6  | Previous colorscheme  |
| F7  | Next colorscheme  |

By default, `<F6>` and `<F7>` will switch through all your installed
colorschemes. If you wish to switch through a subset of colorschemes made of
your favourites ones, say it to your `.vimrc`, as follows:

```vim
let g:colorschwitch_schemes = ['delek', 'slate', 'gotham256', 'sourcerer', 'morning']
```

Original version of this script was simply copy-pasted from
[vim.wikia.com/wiki/Switch_color_schemes](http://vim.wikia.com/wiki/Switch_color_schemes).

Some things have been modified since.
