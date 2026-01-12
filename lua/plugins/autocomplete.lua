return {
  -- Automatically install LSPs and other tools
  {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "clangd", "lua_ls" }, -- Install clangd for C/C++ projects
      })
    end,
  },

  -- LSP Configuration (nvim-lspconfig provides the configuration data)
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Configure clangd using the new built-in API
      vim.lsp.config("clangd", {
        -- clangd will automatically find compile_commands.json in the project root
        -- You can add extra options here if needed, e.g.:
        -- extra_args = { "--background-index" },
      })

      -- Enable clangd to activate for C/C++ filetypes
      vim.lsp.enable({ "clangd" })

      -- Set up keymaps after LSP client attaches to a buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf

          -- Buffer local mappings
          vim.keymap.set('n', '<leader>vd', vim.diagnostic.open_float, { buffer = bufnr })
          vim.keymap.set('n', '[d', vim.diagnostic.goto_next, { buffer = bufnr })
          vim.keymap.set('n', ']d', vim.diagnostic.goto_prev, { buffer = bufnr })
          vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, { buffer = bufnr })
        end
      })
    end,
  },

  -- Autocompletion Plugins
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip", -- Snippet engine
      "rafamadriz/friendly-snippets", -- Useful snippets
    },
    config = function()
      -- Setup LuaSnip
      require("luasnip.loaders.from_vscode").lazy_load()

      -- Setup nvim-cmp
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
            completion = cmp.config.window.bordered(),
            info = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' }, -- Source for LSP suggestions
          { name = 'luasnip' }, -- Source for snippets
          { name = 'buffer' },  -- Source for words in the current buffer
          { name = 'path' },    -- Source for file paths
        })
      })
    end,
  },
}

