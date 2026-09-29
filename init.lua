-- ============================================================
-- Nano-like Neovim
-- DevOps edition
-- ============================================================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================================
-- Options
-- ============================================================

local opt = vim.opt

opt.number = true
opt.relativenumber = false
opt.mouse = "a"
opt.clipboard = "unnamedplus"

opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2

opt.autoindent = true
opt.smartindent = true
opt.cindent = true

opt.wrap = false

opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.showmode = false

opt.undofile = true
opt.scrolloff = 5
opt.updatetime = 250

-- ============================================================
-- Nano keybindings
-- ============================================================

local map = vim.keymap.set

map(
  "n",
  "<leader>?",
  "<cmd>edit ~/.config/nvim/CHEATSHEET.md<CR>",
  { desc = "Open cheat sheet" }
)

-- Ctrl+O = Save
map("i", "<C-o>", "<Esc>:write<CR>a", { desc = "Save" })
map("n", "<C-o>", ":write<CR>", { desc = "Save" })

-- Ctrl+X = Exit
map("i", "<C-x>", "<Esc>:confirm quit<CR>", { desc = "Exit" })
map("n", "<C-x>", ":confirm quit<CR>", { desc = "Exit" })

-- Ctrl+K = Cut line
map("i", "<C-k>", "<Esc>dd", { desc = "Cut line" })
map("n", "<C-k>", "dd", { desc = "Cut line" })

-- Ctrl+U = Paste
map("i", "<C-u>", "<Esc>p", { desc = "Paste" })
map("n", "<C-u>", "p", { desc = "Paste" })

-- Ctrl+W = Search
map("n", "<C-w>", "/", { desc = "Search" })
map("i", "<C-w>", "<Esc>/", { desc = "Search" })

-- Alt+U = Undo
map("i", "<M-u>", "<Esc>u", { desc = "Undo" })
map("n", "<M-u>", "u", { desc = "Undo" })

-- Alt+E = Redo
map("i", "<M-e>", "<Esc><C-r>", { desc = "Redo" })
map("n", "<M-e>", "<C-r>", { desc = "Redo" })

-- Ctrl+G = Help
map("n", "<C-g>", ":help<CR>", { desc = "Help" })

-- Ctrl+/ / Ctrl+_ = Comment
map("n", "<C-_>", "gcc", { desc = "Comment line" })

-- ============================================================
-- Filetype fixes
-- ============================================================

vim.filetype.add({
  extension = {
    tf = "terraform",
    tfvars = "terraform",
  },
})

-- ============================================================
-- lazy.nvim
-- ============================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- ==========================================================
  -- Treesitter
  -- ==========================================================

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,

    config = function()
      require("nvim-treesitter").setup()

      require("nvim-treesitter").install({
        "bash",
        "json",
        "yaml",
        "hcl",
        "terraform",
        "dockerfile",
        "markdown",
        "markdown_inline",
        "lua",
        "vim",
        "git_config",
        "git_rebase",
        "gitcommit",
        "regex",
      })

      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },

  -- ==========================================================
  -- Auto pairs
  -- ==========================================================

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",

    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,
        fast_wrap = {},
      })
    end,
  },

  -- ==========================================================
  -- Commenting
  -- ==========================================================

  {
    "numToStr/Comment.nvim",

    config = function()
      require("Comment").setup()
    end,
  },

  -- ==========================================================
  -- Completion
  -- ==========================================================

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",

    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },

    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),

          ["<CR>"] = cmp.mapping.confirm({
            select = false,
          }),

          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        sources = {
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "buffer" },
        },
      })
    end,
  },

  -- ==========================================================
  -- File manager
  -- ==========================================================

  {
    "stevearc/oil.nvim",

    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    config = function()
      require("oil").setup({
        default_file_explorer = true,

        columns = {
          "icon",
        },

        view_options = {
          show_hidden = true,
        },
      })

      map(
        "n",
        "-",
        "<cmd>Oil<CR>",
        { desc = "Open file manager" }
      )
    end,
  },

  -- ==========================================================
  -- LSP
  -- ==========================================================

  {
    "neovim/nvim-lspconfig",

    config = function()
      local capabilities =
        require("cmp_nvim_lsp").default_capabilities()

      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      local servers = {
        bashls = {
          cmd = { "bash-language-server", "start" },
        },

        yamlls = {
          cmd = { "yaml-language-server", "--stdio" },
        },

        jsonls = {
          cmd = { "vscode-json-language-server", "--stdio" },
        },

        dockerls = {
          cmd = { "docker-langserver", "--stdio" },
        },

        terraformls = {
          cmd = { "terraform-ls", "serve" },
        },

        lua_ls = {
          cmd = { "lua-language-server" },
        },
      }

      for server, config in pairs(servers) do
        config.capabilities = capabilities

        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end
    end,
  },

  -- ==========================================================
  -- Formatting
  -- ==========================================================

  {
    "stevearc/conform.nvim",

    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },

          json = { "prettier" },

          yaml = { "prettier" },

          markdown = { "prettier" },

          bash = { "shfmt" },

          sh = { "shfmt" },

          terraform = { "terraform_fmt" },

          hcl = { "terraform_fmt" },
        },

        format_on_save = {
          timeout_ms = 3000,
          lsp_fallback = true,
        },
      })

      map(
        { "n", "v" },
        "<leader>f",
        function()
          require("conform").format({
            async = true,
            lsp_fallback = true,
          })
        end,
        { desc = "Format" }
      )
    end,
  },

  -- ==========================================================
  -- Telescope
  -- ==========================================================

  {
    "nvim-telescope/telescope.nvim",

    dependencies = {
      "nvim-lua/plenary.nvim",
    },

    config = function()
      local telescope = require("telescope")

      telescope.setup({})

      map(
        "n",
        "<leader>ff",
        "<cmd>Telescope find_files<CR>",
        { desc = "Find files" }
      )

      map(
        "n",
        "<leader>fg",
        "<cmd>Telescope live_grep<CR>",
        { desc = "Search text" }
      )

      map(
        "n",
        "<leader>fb",
        "<cmd>Telescope buffers<CR>",
        { desc = "Find buffers" }
      )

      map(
        "n",
        "<leader>fh",
        "<cmd>Telescope help_tags<CR>",
        { desc = "Help" }
      )
    end,
  },

  -- ==========================================================
  -- Git
  -- ==========================================================

  {
    "lewis6991/gitsigns.nvim",

    config = function()
      require("gitsigns").setup()
    end,
  },

})
