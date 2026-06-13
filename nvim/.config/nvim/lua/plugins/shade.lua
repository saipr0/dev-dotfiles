return {
  {
    'sunjon/Shade.nvim',
    event = 'VeryLazy',
    opts = {
      overlay_opacity = 20,
      opacity_step = 5,
      keys = {
        brightness_up = '<C-Up>',
        brightness_down = '<C-Down>',
        toggle = '<leader>us',
      },
    },
    config = function(_, opts)
      require('shade').setup(opts)
    end,
  },
}
