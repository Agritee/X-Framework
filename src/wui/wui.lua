--[[
  @Author xxzhushou
  @Repo   https://github.com/xxzhushou/WUI
]]--

local wui = {}

local moduleNames = {
    Radio = 'wui.comp.radio',
    Button = 'wui.comp.button',
    TabBar = 'wui.comp.tab_bar',
    TabPage = 'wui.comp.tab_page',
    GridSelect = 'wui.comp.grid_select',
    Checkbox = 'wui.comp.checkbox',
    CheckboxList = 'wui.comp.checkbox_list',
}

local aliasNames = {
    radio = 'Radio',
    button = 'Button',
    tab_bar = 'TabBar',
    tab_page = 'TabPage',
    grid_select = 'GridSelect',
    checkbox = 'Checkbox',
    checkbox_list = 'CheckboxList',
}

for k, v in pairs(aliasNames) do
    if moduleNames[v] then
        moduleNames[k] = moduleNames[v]
    end
end

for k, v in pairs(moduleNames) do
    if wui[k] == nil then
        wui[k] = require(v)
    end
end

return wui
