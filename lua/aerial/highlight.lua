local config = require("aerial.config")
local M = {}

---@param group1 string
---@param group2 string
local function link(group1, group2)
  vim.api.nvim_set_hl(0, group1, { link = group2, default = true })
end

local symbol_kinds = {
  "Array",
  "Boolean",
  "Class",
  "Constant",
  "Constructor",
  "Enum",
  "EnumMember",
  "Event",
  "Field",
  "File",
  "Function",
  "Interface",
  "Key",
  "Method",
  "Module",
  "Namespace",
  "Null",
  "Number",
  "Object",
  "Operator",
  "Package",
  "Property",
  "String",
  "Struct",
  "TypeParameter",
  "Variable",
}

---@param symbol aerial.Symbol
---@param is_icon boolean
---@param is_collapsed boolean
---@return nil|string
M.get_highlight = function(symbol, is_icon, is_collapsed)
  local hl_group = config.get_highlight(symbol, is_icon, is_collapsed)
  if hl_group then
    return hl_group
  end

  -- If the symbol has a non-public scope, use that as the highlight group (e.g. AerialPrivate)
  if symbol.scope and not is_icon and symbol.scope ~= "public" then
    return string.format("Aerial%s", symbol.scope:gsub("^%l", string.upper))
  end

  return string.format("Aerial%s%s", symbol.kind, is_icon and "Icon" or "")
end

M.create_highlight_groups = function()
  -- The line that shows where your cursor(s) are
  link("AerialLine", "QuickFixLine")
  link("AerialLineNC", "AerialLine")

  -- Highlight groups for private and protected functions/fields/etc
  link("AerialPrivate", "Comment")
  link("AerialProtected", "Comment")

  -- Use Comment colors for AerialGuide, while stripping bold/italic/etc
  local comment_defn = vim.api.nvim_get_hl_by_name("Comment", true)
  -- The guides when show_guide = true
  vim.api.nvim_set_hl(0, "AerialGuide", {
    fg = comment_defn.foreground,
    bg = comment_defn.background,
    ctermfg = comment_defn.ctermfg,
    ctermbg = comment_defn.ctermbg,
    blend = comment_defn.blend,
    default = true,
  })
  for i = 1, 9 do
    link(string.format("AerialGuide%d", i), "AerialGuide")
  end

  -- The name of the symbol
  for _, symbol_kind in ipairs(symbol_kinds) do
    link(string.format("Aerial%s", symbol_kind), "NONE")
  end

  -- The icon displayed to the left of the symbol
  link("AerialArrayIcon", "Identifier")
  link("AerialBooleanIcon", "Identifier")
  link("AerialClassIcon", "Type")
  link("AerialConstantIcon", "Constant")
  link("AerialConstructorIcon", "Special")
  link("AerialEnumIcon", "Type")
  link("AerialEnumMemberIcon", "Identifier")
  link("AerialEventIcon", "Identifier")
  link("AerialFieldIcon", "Identifier")
  link("AerialFileIcon", "Identifier")
  link("AerialFunctionIcon", "Function")
  link("AerialInterfaceIcon", "Type")
  link("AerialKeyIcon", "Identifier")
  link("AerialMethodIcon", "Function")
  link("AerialModuleIcon", "Include")
  link("AerialNamespaceIcon", "Include")
  link("AerialNullIcon", "Identifier")
  link("AerialNumberIcon", "Identifier")
  link("AerialObjectIcon", "Identifier")
  link("AerialOperatorIcon", "Identifier")
  link("AerialPackageIcon", "Include")
  link("AerialPropertyIcon", "Identifier")
  link("AerialStringIcon", "Identifier")
  link("AerialStructIcon", "Type")
  link("AerialTypeParameterIcon", "Identifier")
  link("AerialVariableIcon", "Identifier")
end

return M
