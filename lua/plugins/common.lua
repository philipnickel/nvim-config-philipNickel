return {
  -- common dependencies
  { 'nvim-lua/plenary.nvim' },
  {
    "3rd/image.nvim",
    opts = {
      backend = "ueberzug",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki", "quarto" },
        },
      },
    },
  },
  {
    'folke/snacks.nvim',
    dev = false,
    priority = 1000,
    lazy = false,
    opts = {
      styles = {},
      bigfile = { notify = false },
      quickfile = {},
      picker = {
        -- ui_select = false, -- replace `vim.ui.select` with the snacks picker
      },
      indent = {},
    },
  },
}
