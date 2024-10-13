vim.opt.termguicolors = true

function SetColor(color)
    color = color or "catppuccin-mocha"
    vim.cmd.colorscheme(color)
end

SetColor("catppuccin-mocha")
