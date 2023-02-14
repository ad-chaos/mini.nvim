-- MIT License Copyright (c) 2023 Evgeni Chasnovski

-- To study source behind presets, search for:
-- - `-- Options ---` for `config.options`.
-- - `-- Mappings ---` for `config.mappings`.
-- - `-- Autocommands ---` for `config.autocommands`.

-- Documentation ==============================================================
--- Common configuration presets
---
--- Install, create 'init.lua', add `require('mini.basics').setup()` and you
--- are good to go.
---
--- Features:
--- - Presets for common options. It will only change option if it wasn't
---   manually set before. See more in |MiniBasics.config.options|.
--- - Presets for common mappings. It will only add a mapping if it wasn't
---   manually created before. See more in |MiniBasics.config.mappings|.
--- - Presets for common autocommands. See more in |MiniBasics.config.autocommands|.
--- - Reverse compatibility is a high priority. Any decision to change already
---   present behavior will be made with great care.
---
--- Notes:
--- - Main goal of this module is to provide a relatively easier way for
---   new-ish Neovim users to have better "works out of the box" experience
---   while having documented relevant options/mappings/autocommands to study.
---   It is based partially on survey among Neovim users and partially is
---   coming from personal preferences.
---
---   However, more seasoned users almost surely will find something useful.
---
---   Still, it is recommended to read about used options/mappings/autocommands
---   and decide if they are needed. The main way to do that is by reading
---   Neovim's help pages (linked in help file) and this module's source code
---   (thoroughly documented for easier comprehension).
---
--- # Setup ~
---
--- This module needs a setup with `require('mini.basics').setup({})` (replace
--- `{}` with your `config` table). It will create global Lua table `MiniBasics`
--- which you can use for scripting or manually (with `:lua MiniBasics.*`).
---
--- See |MiniBasics.config| for available config settings.
---
--- # Comparisons ~
---
--- - 'tpope/vim-sensible':
---     - Most of 'tpope/vim-sensible' is already incorporated as default
---       options in Neovim (see |nvim-default|). This module has a much
---       broader effect.
--- - 'tpope/vim-unimpaired':
---     - The 'tpope/vim-unimpaired' has mapping for toggling options with `yo`
---       prefix. This module implements similar functionality with `\` prefix
---       (see |MiniBasics.config.mappings|).
---@tag mini.basics
---@tag Minibasics

---@diagnostic disable:undefined-field

-- Module definition ==========================================================
local MiniBasics = {}
local H = {}

--- Module setup
---
---@param config table|nil Module config table. See |MiniBasics.config|.
---
---@usage `require('mini.basics').setup({})` (replace `{}` with your `config` table)
MiniBasics.setup = function(config)
  -- TODO: Remove after Neovim<=0.6 support is dropped
  if vim.fn.has('nvim-0.7') == 0 then
    vim.notify(
      '(mini.basics) Neovim<0.7 is soft deprecated (module works but not supported).'
        .. ' It will be deprecated after Neovim 0.9.0 release (module will not work).'
        .. ' Please update your Neovim version.'
    )
  end

  -- Export module
  _G.MiniBasics = MiniBasics

  -- Setup config
  config = H.setup_config(config)

  -- Apply config
  H.apply_config(config)
end

--- Module config
---
--- Default values:
---@eval return MiniDoc.afterlines_to_code(MiniDoc.current.eval_section)
---@text                                                      *MiniBasics.config.options*
--- # Options ~
---
--- Usage example: >
---   require('mini.basics').setup({
---     options = {
---       basic = true,
---       extra_ui = true,
---       win_borders = 'double',
---     }
---   })
---
--- ## options.basic ~
---
--- The `config.options.basic` sets certain options to values which are quite
--- commonly used (judging by study of available Neovim pre-configurations,
--- public dotfiles, and surveys).
--- Any option is changed only if it was not set manually beforehand.
--- For exact changes, please see source code ('lua/mini/basics.lua').
---
--- Here is the list of affected options (put cursor on it and press |CTRL-]|):
--- - General:
---     - Sets |<Leader>| key to |<Space>|. Be sure to make all Leader mappings
---       after this (otherwise they are made with default <Leader>).
---     - Runs `:filetype plugin indent on` (see |:filetype-overview|)
---     - |backup|
---     - |mouse|
---     - |undofile|
---     - |writebackup|
--- - Appearance
---     - |breakindent|
---     - |cursorline|
---     - |fillchars|
---     - |linebreak|
---     - |number|
---     - |ruler|
---     - |showmode|
---     - |signcolumn|
---     - |shortmess|
---     - |splitbelow|
---     - |splitkeep| (on Neovim>=0.9)
---     - |splitright|
---     - |termguicolors|
---     - |wrap|
--- - Editing
---     - |completeopt|
---     - |formatoptions|
---     - |ignorecase|
---     - |incsearch|
---     - |infercase|
---     - |smartcase|
---     - |smartindent|
---     - |virtualedit|
---
--- ## options.extra_ui ~
---
--- The `config.options.extra_ui` sets certain options for visual appearance
--- which might not be aligned with common preferences, but still worth trying.
--- Any option is changed only if it was not set manually beforehand.
--- For exact changes, please see source code ('lua/mini/basics.lua').
---
--- List of affected options:
--- - |list|
--- - |listchars|
--- - |pumblend|
--- - |pumheight|
--- - |winblend|
--- - Runs `:syntax on` (see |:syntax-on|)
---
--- ## options.win_borders
---
--- The `config.options.win_borders` updates |fillchars| to have a consistent set of
--- characters for window border (`vert`, `horiz`, etc.).
---
--- Available values:
--- - `'bold'` - bold lines.
--- - `'dot'` - dot in every cell.
--- - `'double'` - double line.
--- - `'single'` - single line.
--- - `'solid'` - no symbol, only background.
---
---                                                     *MiniBasics.config.mappings*
--- # Mappings ~
---
--- Usage example: >
---   require('mini.basics').setup({
---     mappings = {
---       basic = true,
---       option_toggle_prefix = [[\]],
---       windows = true,
---       move_with_alt = true,
---     }
---   })
---
--- If you don't want only some mappings to be made at all, use |vim.keymap.del()|
--- after calling |MiniMisc.setup()|. For example, to delete `<C-w>` mapping in
--- |Terminal-mode| (as it conflicts with `<C-w>` usage in terminal emulators)
--- use this code: >
---
---   vim.keymap.del('t', '<C-w>').
---
--- ## mappings.basic ~
---
--- The `config.mappings.basic` creates mappings for certain commonly mapped actions
--- (judging by study of available Neovim pre-configurations and public dotfiles).
---
--- Some of the mappings override built-in ones to either improve their
--- behavior or override its default not very useful action.
--- It will only add a mapping if it wasn't manually created before.
---
--- Here is a table with created mappings (see |[count]| for its meaning;): >
---
---  |Keys   |     Modes       |                  Description                  |
---  |-------|-----------------|-----------------------------------------------|
---  | j     | Normal, Visual  | Move down by visible lines with no [count]    |
---  | k     | Normal, Visual  | Move up by visible lines with no [count]      |
---  | go    | Normal          | Add [count] empty lines after cursor          |
---  | gO    | Normal          | Add [count] empty lines before cursor         |
---  | gy    | Normal, Visual  | Copy to system clipboard                      |
---  | gp    | Normal, Visual  | Paste from system clipboard                   |
---  | gV    | Normal          | Visually select latest changed or yanked text |
---  | g/    | Visual          | Search inside current visual selection        |
---  | *     | Visual          | Search forward for current visual selection   |
---  | #     | Visual          | Search backward for current visual selection  |
---  | <C-s> | Normal, Visual, | Save and go to Normal mode                    |
---  |       |     Insert      |                                               |
---  | <C-z> | Normal, Insert  | Correct latest misspelled word                |
--- <
---
--- ## mappings.option_toggle_prefix ~
---
--- The `config.mappings.option_toggle_prefix` defines a prefix used for
--- creating mappings that toggle common options. The result mappings will be
--- `<prefix> + <suffix>`. For example, with default value, `\w` will toggle |wrap|.
---
--- Other viable choices for prefix are
--- - `,` (as a mnemonic for several values to toggle).
--- - `|` (as a same mnemonic).
--- - `yo` (used in 'tpope/vim-unimpaired')
--- - Something with |<Leader>| key, like `<Leader>t` (`t` for "toggle"). Note:
---   if your prefix contains `<Leader>` key, make sure to set it before
---   calling |MiniBasics.setup()| (as is done with default `basic` field of
---   |MiniBasics.config.options|).
---
--- After toggling, there will be a feedback about the current option value.
---
--- It will only add a mapping if it wasn't manually created before.
---
--- Here is a list of suffixes for created toggling mappings (all in Normal mode):
---
--- - `b` - |'background'|.
--- - `c` - |'cursorline'|.
--- - `C` - |'cursorcolumn'|.
--- - `d` - diagnostic (via |vim.diagnostic.enable()| and |vim.diagnostic.disable()|).
--- - `h` - |'hlsearch'| (or |v:hlsearch| to be precise).
--- - `i` - |'ignorecase'|.
--- - `l` - |'list'|.
--- - `n` - |'number'|.
--- - `r` - |'relativenumber'|.
--- - `s` - |'spell'|.
--- - `w` - |'wrap'|.
---
--- ## mappings.windows ~
---
--- The `config.mappings.windows` creates mappings for easiere window manipulation.
---
--- It will only add a mapping if it wasn't manually created before.
---
--- Here is a list with created Normal mode mappings (all mappings respect |[count]|):
--- - Window navigation:
---     - `<C-h>` - focus on left window (see |CTRL-W_H|).
---     - `<C-j>` - focus on below window (see |CTRL-W_J|).
---     - `<C-k>` - focus on above window (see |CTRL-W_K|).
---     - `<C-l>` - focus on right window (see |CTRL-W_L|).
--- - Window resize (all use arrow keys; variants of |resize|; all respect |[count]|):
---     - `<C-left>`  - decrease window width.
---     - `<C-down>`  - decrease window height.
---     - `<C-up>`    - increase window height.
---     - `<C-right>` - increase window width.
---
--- It also creates a `<C-w>` mapping in |Terminal-mode| for easier window
--- navigation inside builtin |terminal-emulator|. Tip: use `<C-w><Esc>` for
--- easier Terminal mode exit than |CTRL-\_CTRL-N|.
---
--- ## mappings.move_with_alt
---
--- The `config.mappings.move_with_alt` creates mappings for a more consistent
--- cursor move in Insert, Command, and Terminal modes. For example, it proves
--- useful in combination of autopair plugin (like |MiniPairs|) to move right
--- outside of inserted pairs (no matter what the pair is).
---
--- It will only add a mapping if it wasn't manually created before.
---
--- Here is a list of created mappings (`<M-x>` means `Alt`/`Meta` plus `x`):
--- - `<M-h>` - move cursor left.  Modes: Insert, Terminal, Command.
--- - `<M-h>` - move cursor down.  Modes: Insert, Terminal.
--- - `<M-h>` - move cursor up.    Modes: Insert, Terminal.
--- - `<M-h>` - move cursor right. Modes: Insert, Terminal, Command.
---
---                                                 *MiniBasics.config.autocommands*
--- # Autocommands ~
---
--- Usage example: >
---   require('mini.basics').setup({
---     autocommands = {
---       basic = true,
---       relnum_in_visual_mode = true,
---     }
---   })
---
--- ## autocommands.basic ~
---
--- The `config.autocommands.basic` creates some common autocommands:
---
--- - Starts insert mode when opening terminal (see |startinsert| and |TermOpen|).
--- - Highlights yanked text for a brief period of time (see
---   |vim.highlight.on_yank()| and |TextYankPost|).
---
--- ## autocommands.relnum_in_visual_mode ~
---
--- The `config.autocommands.relnum_in_visual_mode` creates autocommands that
--- enable |relativenumber| in linewise and blockwise Visual modes and disable
--- otherwise. See |ModeChanged|.
MiniBasics.config = {
  -- Options. Set to `false` to disable.
  options = {
    -- Basic options ('termguicolors', 'number', 'ignorecase', and many more)
    basic = true,

    -- Extra UI features ('winblend', 'cmdheight=0', ...)
    extra_ui = false,

    -- Presets for window borders ('single', 'double', ...)
    win_borders = 'default',
  },

  -- Mappings. Set to `false` to disable.
  mappings = {
    -- Basic mappings (better 'jk', save with Ctrl+S, ...)
    basic = true,

    -- Prefix for mappings that toggle common options ('wrap', 'spell', ...).
    -- Supply empty string to not create these mappings.
    option_toggle_prefix = [[\]],

    -- Window navigation with <C-hjkl>, resize with <C-arrow>
    windows = false,

    -- Move cursor in Insert, Command, and Terminal mode with <M-hjkl>
    move_with_alt = false,
  },

  -- Autocommands. Set to `false` to disable
  autocommands = {
    -- Basic autocommands (highlight on yank, start Insert in terminal, ...)
    basic = true,

    -- Set 'relativenumber' only in linewise and blockwise Visual mode
    relnum_in_visual_mode = false,
  },
}
--minidoc_afterlines_end

--- Toggle diagnostic for current buffer
---
--- This uses |vim.diagnostic.enable()| and |vim.diagnostic.disable()| on
--- per buffer basis.
---
---@return string String indicator for new state. Similar to what |:set| `{option}?` shows.
MiniBasics.toggle_diagnostic = function()
  local buf_id = vim.api.nvim_get_current_buf()
  local buf_state = H.buffer_diagnostic_state[buf_id]
  if buf_state == nil then buf_state = true end

  if buf_state then
    vim.diagnostic.disable(buf_id)
  else
    vim.diagnostic.enable(buf_id)
  end

  local new_buf_state = not buf_state
  H.buffer_diagnostic_state[buf_id] = new_buf_state

  return new_buf_state and '  diagnostic' or 'nodiagnostic'
end

-- Helper data ================================================================
-- Module default config
H.default_config = MiniBasics.config

-- Diagnostic state per buffer
H.buffer_diagnostic_state = {}

-- Helper functionality =======================================================
-- Settings -------------------------------------------------------------------
H.setup_config = function(config)
  -- General idea: if some table elements are not present in user-supplied
  -- `config`, take them from default config
  vim.validate({ config = { config, 'table', true } })
  config = vim.tbl_deep_extend('force', H.default_config, config or {})

  vim.validate({
    options = { config.options, 'table' },
    mappings = { config.mappings, 'table' },
    autocommands = { config.autocommands, 'table' },
  })

  vim.validate({
    ['options.basic'] = { config.options.basic, 'boolean' },
    ['options.extra_ui'] = { config.options.extra_ui, 'boolean' },
    ['options.win_borders'] = { config.options.win_borders, 'string' },

    ['mappings.basic'] = { config.mappings.basic, 'boolean' },
    ['mappings.option_toggle_prefix'] = { config.mappings.option_toggle_prefix, 'string' },
    ['mappings.windows'] = { config.mappings.windows, 'boolean' },
    ['mappings.move_with_alt'] = { config.mappings.move_with_alt, 'boolean' },

    ['autocommands.basic'] = { config.autocommands.basic, 'boolean' },
    ['autocommands.relnum_in_visual_mode'] = { config.autocommands.relnum_in_visual_mode, 'boolean' },
  })

  return config
end

H.apply_config = function(config)
  MiniBasics.config = config

  H.apply_options(config)
  H.apply_mappings(config)
  H.apply_autocommands(config)
end

-- Options --------------------------------------------------------------------
--stylua: ignore
H.apply_options = function(config)
  -- Use `local o, opt = vim.o, vim.opt` to copy lines as is.
  -- Or use `vim.o` and `vim.opt` directly.
  local o, opt = H.vim_o, H.vim_opt

  -- Basic options
  if config.options.basic then
    -- Leader key
    if vim.g.mapleader == nil then
      vim.g.mapleader = ' ' -- Use space as the one and only true Leader key
    end

    -- General
    o.undofile    = true  -- Enable persistent undo (see also `:h undodir`)

    o.backup      = false -- Don't store backup while overwriting the file
    o.writebackup = false -- Don't store backup while overwriting the file

    o.mouse       = 'a'   -- Enable mouse for all available modes

    vim.cmd('filetype plugin indent on') -- Enable all filetype plugins

    -- Appearance
    o.breakindent   = true    -- Indent wrapped lines to match line start
    o.cursorline    = true    -- Highlight current line
    o.linebreak     = true    -- Wrap long lines at 'breakat' (if 'wrap' is set)
    o.number        = true    -- Show line numbers
    o.splitbelow    = true    -- Horizontal splits will be below
    o.splitright    = true    -- Vertical splits will be to the right
    o.termguicolors = true    -- Enable gui colors

    o.ruler         = false   -- Don't show cursor position in command line
    o.showmode      = false   -- Don't show mode in command line
    o.wrap          = false   -- Display long lines as just one line

    o.signcolumn    = 'yes'   -- Always show sign column (otherwise it will shift text)
    o.fillchars     = 'eob: ' -- Don't show `~` outside of buffer

    -- Editing
    o.ignorecase  = true -- Ignore case when searching (use `\C` to force not doing that)
    o.incsearch   = true -- Show search results while typing
    o.infercase   = true -- Infer letter cases for a richer built-in keyword completion
    o.smartcase   = true -- Don't ignore case when searching if pattern has upper case
    o.smartindent = true -- Make indenting smart

    o.completeopt   = 'menuone,noinsert,noselect' -- Customize completions
    o.virtualedit   = 'block'                     -- Allow going past the end of line in visual block mode
    o.formatoptions = 'qjl1'                      -- Don't autoformat comments

    -- Neovim version dependent
    if vim.fn.has('nvim-0.9') == 1 then
      opt.shortmess:append('WcC') -- Reduce command line messages
      o.splitkeep = 'screen'      -- Reduce scroll during window split
    else
      opt.shortmess:append('Wc')  -- Reduce command line messages
    end
  end

  -- Some opinioneted extra UI options
  if config.options.extra_ui then
    o.pumblend  = 10 -- Make builtin completion menus slightly transparent
    o.pumheight = 10 -- Make popup menu smaller
    o.winblend  = 10 -- Make floating windows slightly transparent

    o.listchars = 'extends:…,precedes:…,nbsp:␣' -- Define which helper symbols to show
    o.list      = true                          -- Show some helper symbols

    -- Enable syntax highlighing if it wasn't already (as it is time consuming)
    if vim.fn.exists("syntax_on") ~= 1 then vim.cmd([[syntax enable]]) end
  end

  -- Use some common window borders presets
  local fillchars = H.win_borders_fillchars[config.options.win_borders]
  if fillchars ~= nil then
    local chars = fillchars.vert .. (vim.fn.has('nvim-0.7') == 1 and fillchars.rest or '')
    vim.opt.fillchars:append(chars)
  end
end

H.vim_o = setmetatable({}, {
  __newindex = function(_, name, value)
    local was_set = vim.api.nvim_get_option_info(name).was_set
    if was_set then return end

    vim.o[name] = value
  end,
})

H.vim_opt = setmetatable({}, {
  __index = function(_, name)
    local was_set = vim.api.nvim_get_option_info(name).was_set
    if was_set then return { append = function() end, remove = function() end } end

    return vim.opt[name]
  end,
})

--stylua: ignore
H.win_borders_fillchars = {
  bold    = { vert = 'vert:┃', rest = ',horiz:━,horizdown:┳,horizup:┻,,verthoriz:╋,vertleft:┫,vertright:┣' },
  dot     = { vert = 'vert:·', rest = ',horiz:·,horizdown:·,horizup:·,,verthoriz:·,vertleft:·,vertright:·' },
  double  = { vert = 'vert:║', rest = ',horiz:═,horizdown:╦,horizup:╩,,verthoriz:╬,vertleft:╣,vertright:╠' },
  single  = { vert = 'vert:│', rest = ',horiz:─,horizdown:┬,horizup:┴,,verthoriz:┼,vertleft:┤,vertright:├' },
  solid   = { vert = 'vert: ', rest = ',horiz: ,horizdown: ,horizup: ,,verthoriz: ,vertleft: ,vertright: ' },
}

-- Mappings -------------------------------------------------------------------
--stylua: ignore
H.apply_mappings = function(config)
  -- Use `local map = vim.keymap.set` to copy lines as is. Or use it directly.
  local map = H.keymap_set

  if config.mappings.basic then
    -- Move by visible lines. Notes:
    -- - Don't map in Operator-pending mode because it severely changes behavior:
    --   like `dj` on non-wrapped line will not delete it.
    -- - Condition on `v:count == 0` to allow easier use of relative line numbers.
    map({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
    map({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })

    -- Add empty lines before and after cursor line
    map('n', 'gO', "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>", { desc = 'Put empty line above' })
    map('n', 'go', "<Cmd>call append(line('.'),     repeat([''], v:count1))<CR>", { desc = 'Put empty line below' })

    -- Copy/paste with system clipboard
    map({ 'n', 'x' }, 'gy', '"+y', { desc = 'Copy to system clipboard' })
    map(  'n',        'gp', '"+p', { desc = 'Paste from system clipboard' })
    -- - Paste in Visual with `P` to not copy selected text (`:h v_P`)
    map(  'x',        'gp', '"+P', { desc = 'Paste from system clipboard' })

    -- Reselect latest changed, put, or yanked text
    map('n', 'gV', '"`[" . strpart(getregtype(), 0, 1) . "`]"', { expr = true, desc = 'Visually select changed text' })

    -- Search inside visually highlighted text. Use `silent = false` for it to
    -- make effect immediately.
    map('x', 'g/', '<esc>/\\%V', { silent = false, desc = 'Search inside visual selection' })

    -- Search visually selected text (slightly better than builtins in Neovim>=0.8)
    map('x', '*', [[y/\V<C-R>=escape(@", '/\')<CR><CR>]])
    map('x', '#', [[y?\V<C-R>=escape(@", '?\')<CR><CR>]])

    -- Alternative way to save and exit in Normal mode.
    -- NOTE: Adding `redraw` helps with `cmdheight=0` if buffer is not modified
    map(  'n',        '<C-s>', '<Cmd>silent! update | redraw<CR>',      { desc = 'Save' })
    map({ 'i', 'x' }, '<C-s>', '<Esc><Cmd>silent! update | redraw<CR>', { desc = 'Save and go to Normal mode' })

    -- Correct latest misspelled word by taking first suggestion.
    -- Use `<C-g>u` in Insert mode to mark this as separate undoable action.
    -- Source: https://stackoverflow.com/a/16481737
    -- NOTE: this remaps `<C-z>` in Normal mode (completely stops Neovim), but
    -- it seems to be too harmful anyway.
    map('n', '<C-z>', '[s1z=',                     { desc = 'Correct latest misspelled word' })
    map('i', '<C-z>', '<C-g>u<Esc>[s1z=`]a<C-g>u', { desc = 'Correct latest misspelled word' })
  end

  local toggle_prefix = config.mappings.option_toggle_prefix
  if type(toggle_prefix) == 'string' and toggle_prefix ~= '' then
    local map_toggle = function(lhs, rhs, desc) map('n', toggle_prefix .. lhs, rhs, { desc = desc }) end

    -- NOTE: showing current option value after toggling it is very useful but
    -- might not play nicely with `cmdheight=0` causing `hit-enter-prompt`.
    -- If it is crucial for you, consider doing one of these:
    -- - Copy this code without showing part: `xxx?` for most, similar for others.
    -- - Use `cmdheight=1`.
    -- - Use 'folke/noice.nvim'.
    -- - Help fixing https://github.com/neovim/neovim/issues/20673 .
    map_toggle('b', '<Cmd>lua vim.o.bg = vim.o.bg == "dark" and "light" or "dark"; print(vim.o.bg)<CR>',       "Toggle 'background'")
    map_toggle('c', '<Cmd>setlocal cursorline! cursorline?<CR>',                                               "Toggle 'cursorline'")
    map_toggle('C', '<Cmd>setlocal cursorcolumn! cursorcolumn?<CR>',                                           "Toggle 'cursorcolumn'")
    map_toggle('d', '<Cmd>lua print(MiniBasics.toggle_diagnostic())<CR>',                                      'Toggle diagnostic')
    map_toggle('h', '<Cmd>let v:hlsearch = 1 - v:hlsearch | echo (v:hlsearch ? "  " : "no") . "hlsearch"<CR>', 'Toggle search highlight')
    map_toggle('i', '<Cmd>setlocal ignorecase! ignorecase?<CR>',                                               "Toggle 'ignorecase'")
    map_toggle('l', '<Cmd>setlocal list! list?<CR>',                                                           "Toggle 'list'")
    map_toggle('n', '<Cmd>setlocal number! number?<CR>',                                                       "Toggle 'number'")
    map_toggle('r', '<Cmd>setlocal relativenumber! relativenumber?<CR>',                                       "Toggle 'relativenumber'")
    map_toggle('s', '<Cmd>setlocal spell! spell?<CR>',                                                         "Toggle 'spell'")
    map_toggle('w', '<Cmd>setlocal wrap! wrap?<CR>',                                                           "Toggle 'wrap'")
  end

  if config.mappings.windows then
    -- Window navigation
    map('n', '<C-h>', '<C-w>h', { desc = 'Focus on left window' })
    map('n', '<C-j>', '<C-w>j', { desc = 'Focus on below window' })
    map('n', '<C-k>', '<C-w>k', { desc = 'Focus on above window' })
    map('n', '<C-l>', '<C-w>l', { desc = 'Focus on right window' })

    map('t', '<C-w>', [[<C-\><C-N><C-w>]], { desc = 'Focus other window' })

    -- Window resize (respecting `v:count`)
    map('n', '<C-Left>',  '"<Cmd>vertical resize -" . v:count1 . "<CR>"', { expr = true, desc = 'Decrease window width' })
    map('n', '<C-Down>',  '"<Cmd>resize -"          . v:count1 . "<CR>"', { expr = true, desc = 'Decrease window height' })
    map('n', '<C-Up>',    '"<Cmd>resize +"          . v:count1 . "<CR>"', { expr = true, desc = 'Increase window height' })
    map('n', '<C-Right>', '"<Cmd>vertical resize +" . v:count1 . "<CR>"', { expr = true, desc = 'Increase window width' })
  end

  if config.mappings.move_with_alt then
    -- Move only sideways in command mode. Using `silent = false` makes movements
    -- to be immediately shown.
    map('c', '<M-h>', '<Left>',  { silent = false, desc = 'Left' })
    map('c', '<M-l>', '<Right>', { silent = false, desc = 'Right' })

    -- Don't `noremap` in insert mode to have these keybindings behave exactly
    -- like arrows (crucial inside TelescopePrompt)
    map('i', '<M-h>', '<Left>',  { noremap = false, desc = 'Left' })
    map('i', '<M-j>', '<Down>',  { noremap = false, desc = 'Down' })
    map('i', '<M-k>', '<Up>',    { noremap = false, desc = 'Up' })
    map('i', '<M-l>', '<Right>', { noremap = false, desc = 'Right' })

    map('t', '<M-h>', '<Left>',  { desc = 'Left' })
    map('t', '<M-j>', '<Down>',  { desc = 'Down' })
    map('t', '<M-k>', '<Up>',    { desc = 'Up' })
    map('t', '<M-l>', '<Right>', { desc = 'Right' })
  end
end

H.keymap_set = function(modes, lhs, rhs, opts)
  if type(modes) == 'string' then modes = { modes } end

  for _, mode in ipairs(modes) do
    -- Don't map if mapping was already set
    local map = vim.fn.maparg(lhs, mode)
    local is_default = map == ''
      -- Some mappings are set by default in Neovim
      or (mode == 'n' and lhs == '<C-l>' and map:find('nohl') ~= nil)
      or (mode == 'x' and lhs == '*' and map == [[y/\V<C-R>"<CR>]])
      or (mode == 'x' and lhs == '#' and map == [[y?\V<C-R>"<CR>]])
    if not is_default then return end

    -- Map
    H.map(mode, lhs, rhs, opts)
  end
end

-- Autocommands ---------------------------------------------------------------
H.apply_autocommands = function(config)
  -- TODO: use `nvim_create_autocmd()` after Neovim<=0.6 support is dropped

  vim.cmd([[augroup MiniBasicsAutocommands]])
  vim.cmd([[autocmd!]])

  if config.autocommands.basic then
    -- Highlight yanked text
    vim.cmd([[autocmd TextYankPost * silent! lua vim.highlight.on_yank()]])

    -- Start builtin terminal in Insert mode
    vim.cmd([[autocmd TermOpen * startinsert]])
  end

  if config.autocommands.relnum_in_visual_mode and vim.fn.exists('##ModeChanged') == 1 then
    -- Show relative line numbers only when they matter (linewise and blockwise
    -- selection) and 'number' is set (avoids horizontal flickering)
    vim.cmd([[autocmd ModeChanged *:[V\x16]* let &l:relativenumber = &l:number == 1]])
    -- - Using `mode () =~#...` handles switching between linewise and blockwise mode.
    vim.cmd([[autocmd ModeChanged [V\x16]*:* let &l:relativenumber = mode() =~# '^[V\x16]']])
  end

  vim.cmd([[augroup END]])
end

-- Utilities ------------------------------------------------------------------
H.map = function(mode, key, rhs, opts)
  if key == '' then return end

  opts = vim.tbl_deep_extend('force', { noremap = true, silent = true }, opts or {})

  -- Use mapping description only in Neovim>=0.7
  if vim.fn.has('nvim-0.7') == 0 then opts.desc = nil end

  vim.api.nvim_set_keymap(mode, key, rhs, opts)
end

return MiniBasics