vim.lsp.config('luals', {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { '.luarc.json', '.luarc.jsonc' },
})


vim.lsp.config('clangd', {
    root_markers = { '.clang-format', 'compile_commands.json' },
    capabilities = {
        textDocument = {
            completion = {
                completionItem = {
                    snippetSupport = true,
                }
            }
        }
    }
})

vim.diagnostic.config({
  virtual_text = {
    prefix = "●",  -- symbol before text
    spacing = 2,
  },
  signs = false,  -- show in sign column (gutter)
  underline = true,
  update_in_insert = false, -- don’t spam in insert mode
  severity_sort = true, -- sort by severity
})


vim.cmd[[set completeopt+=menuone,noselect,popup]]
vim.lsp.buf.implementation()

--vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
vim.lsp.enable('pyright')
vim.lsp.enable('gopls')
vim.lsp.enable('clangd')
vim.lsp.enable('luals')
