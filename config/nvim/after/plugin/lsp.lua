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

vim.lsp.enable('pyright')
vim.lsp.enable('gopls')
vim.lsp.enable('clangd')
vim.lsp.enable('luals')
