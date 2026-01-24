local M = {}

local ls = require("luasnip")
local sn = ls.snippet_node
local i = ls.insert_node

function M.get_visual(_, parent)
  if #parent.snippet.env.SELECT_RAW > 0 then
    return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
  else
    return sn(nil, i(1))
  end
end

function M.in_mathzone()
  return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

function M.in_text()
  return vim.fn["vimtex#syntax#in_mathzone"]() == 0
end

return M
