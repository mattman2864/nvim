-- ~/.config/nvim/lua/plugins.lua
-- Requires Neovim 0.11+ and lazy.nvim.
-- Bootstrap lazy.nvim in your init.lua, then add:
--   require("lazy").setup("plugins")

return {

  -- ──────────────────────────────────────────────
  -- Mason: installs & manages LSP servers
  -- ──────────────────────────────────────────────
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {},
  },

  -- mason-lspconfig v2+: bridges Mason installs → vim.lsp.enable()
  -- NOTE: nvim-lspconfig is NOT listed as a dependency here.
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "clangd",         -- C / C++
        "pyright",        -- Python
        -- "jdtls",          -- Java
        "ts_ls",          -- JavaScript / TypeScript
        "lua_ls",         -- Lua
        "rust_analyzer",  -- Rust
        -- "gopls",          -- Go
        "bashls",         -- Bash / Shell
        "jsonls",         -- JSON
        "html",           -- HTML
        "cssls",          -- CSS
      },
      -- Automatically calls vim.lsp.enable(server) for every installed server.
      -- This replaces the old setup_handlers / lspconfig[server].setup() pattern.
      automatic_enable = true,
    },
  },

  -- ──────────────────────────────────────────────
  -- LSP configuration via vim.lsp.config (0.11+)
  -- ──────────────────────────────────────────────
  {
    -- nvim-lspconfig is still useful for its bundled server default
    -- cmd/filetypes/root_dir definitions — but we never call
    -- require("lspconfig")[server].setup() anymore.
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",             -- must load before capabilities are set
      { "j-hui/fidget.nvim", opts = {} }, -- LSP progress in the corner
    },
    config = function()
      -- ── 1. Global capabilities (applied to every server) ──────────
      --    The '*' wildcard is the 0.11 way to share settings without
      --    repeating yourself for each server.
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      -- ── 2. Per-server overrides ────────────────────────────────────
      --    Only servers needing non-default settings are listed here.
      --    Everything else is enabled automatically by mason-lspconfig.

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime  = { version = "LuaJIT" },
            workspace = {
              checkThirdParty = false,
              library = vim.api.nvim_get_runtime_file("", true),
            },
            diagnostics = { globals = { "vim" } },
            telemetry   = { enable = false },
          },
        },
      })

      vim.lsp.config("clangd", {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
        },
      })

      vim.lsp.config("pyright", {
        settings = {
          python = {
            analysis = {
              typeCheckingMode       = "standard",
              autoSearchPaths        = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

      -- ── 3. Keybinds (fired whenever any LSP attaches) ─────────────
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- Go-to / peek
          map("gd",         vim.lsp.buf.definition,      "Goto Definition")
          map("gD",         vim.lsp.buf.declaration,     "Goto Declaration")
          map("gi",         vim.lsp.buf.implementation,  "Goto Implementation")
          map("gr",         vim.lsp.buf.references,      "Goto References")
          map("gt",         vim.lsp.buf.type_definition, "Goto Type Definition")

          -- Hover / signature
          map("K",          vim.lsp.buf.hover,           "Hover Documentation")
          map("<C-k>",      vim.lsp.buf.signature_help,  "Signature Help")

          -- Diagnostics
          map("<leader>d",  vim.diagnostic.open_float,   "Show Line Diagnostics")
          map("[d",         vim.diagnostic.goto_prev,    "Previous Diagnostic")
          map("]d",         vim.diagnostic.goto_next,    "Next Diagnostic")
          map("<leader>dl", vim.diagnostic.setloclist,   "Diagnostics → Loclist")

          -- Actions
          map("<leader>rn", vim.lsp.buf.rename,          "Rename Symbol")
          map("<leader>ca", vim.lsp.buf.code_action,     "Code Action")
          map("<leader>f",  function()
            vim.lsp.buf.format({ async = true })
          end, "Format Buffer")
        end,
      })

      -- ── 4. Diagnostic display ──────────────────────────────────────
      vim.diagnostic.config({
        virtual_text     = true,
        signs            = true,
        underline        = true,
        update_in_insert = false,
        severity_sort    = true,
        float = {
          border = "rounded",
          source = "always",
        },
      })
    end,
  },

  -- ──────────────────────────────────────────────
  -- Autocompletion: nvim-cmp
  -- ──────────────────────────────────────────────
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
    },
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },

        -- Cap the dropdown to 10 entries
        performance = {
          max_view_entries = 10,
        },

        window = {
          completion    = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"]     = cmp.mapping.abort(),
          ["<CR>"]      = cmp.mapping.confirm({ select = false }),
          ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
          ["<C-f>"]     = cmp.mapping.scroll_docs(4),

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

        sources = cmp.config.sources({
          { name = "nvim_lsp", max_item_count = 10 },
          { name = "luasnip",  max_item_count = 5  },
          { name = "buffer",   max_item_count = 5  },
          { name = "path",     max_item_count = 5  },
        }),

        formatting = {
          format = function(entry, item)
            local labels = {
              nvim_lsp = "[LSP]",
              luasnip  = "[Snip]",
              buffer   = "[Buf]",
              path     = "[Path]",
            }
            item.menu = labels[entry.source.name] or ""
            return item
          end,
        },
      })

      -- Completions in /? search
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })

      -- Completions in : command mode
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
          { { name = "path" } },
          { { name = "cmdline" } }
        ),
      })
      cmp.setup.filetype("markdown", {
        enabled = false,
      })
    end,
  },

}
