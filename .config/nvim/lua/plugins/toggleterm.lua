return {
    "akinsho/toggleterm.nvim",
    lazy = false,
    opts = {
        size = 15,
        open_mapping = [[<C-\>]],
        direction="horizontal",
        shade_terminals = false,
        persist_size = true,
        persist_mode = true,
        on_open = function(term)
            vim.cmd("wincmd k")
        end,
    },
}