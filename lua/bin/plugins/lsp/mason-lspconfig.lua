require("mason-lspconfig").setup {
  ensure_installed = {
    "bashls",
    -- "pyright",
  },
}

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local capabilities2 = vim.lsp.protocol.make_client_capabilities()
capabilities2.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true
}

local lspconfig = require('lspconfig')

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = {
  'bashls',
  'pyright',
  'lua_ls',
  'quick_lint_js',
  -- 'rust_analyzer',
}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = {
      capabilities,
      capabilities2,
    },
  }
end

require("mason-lspconfig").setup_handlers {
  -- The first entry (without a key) will be the default handler
  -- and will be called for each installed server that doesn't have
  -- a dedicated handler.
  function(server_name) -- default handler (optional)
    require("lspconfig")[server_name].setup {}
  end,
  -- Next, you can provide a dedicated handler for specific servers.
  -- For example, a handler override for the `rust_analyzer`:
  ["lua_ls"] = function()
    lspconfig.lua_ls.setup {
      settings = {
        Lua = {
          completion = {
            callSnippet = "Replace"
          }
        }
      }
    }
  end,
  ["bashls"] = function()
    lspconfig.bashls.setup {}
  end,
  ["pyright"] = function()
    lspconfig.pyright.setup {}
  end,
}
