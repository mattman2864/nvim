return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  opts = {
    preview = {
      modes = { "n", "no", "c", "i" },
      hybrid_modes = { "n", "i" },
      linewise_hybrid_mode = true,
    },
    markdown = {
      list_items = {
        indent_size = 2,
        shift_width = 0,
        marker_minus = { add_padding = false, text = "●", hl = "MarkviewListItemMinus" },
        marker_plus = { add_padding = false, text = "◈", hl = "MarkviewListItemPlus" },
        marker_star = { add_padding = false, text = "◇", hl = "MarkviewListItemStar" },
        marker_dot = { add_padding = false },
        marker_parenthesis = { add_padding = false },
      }
    }
  }
}
