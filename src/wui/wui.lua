--[[
  @Author xxzhushou
  @Repo   https://github.com/xxzhushou/XMod_WUI
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
    DropDown = 'wui.comp.dropdown',
}

local aliasNames = {
    radio = 'Radio',
    button = 'Button',
    tab_bar = 'TabBar',
    tab_page = 'TabPage',
    grid_select = 'GridSelect',
    checkbox = 'Checkbox',
    checkbox_list = 'CheckboxList',
    dropdown = 'DropDown',
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

wui._VERSION = '1.1.0'

return wui
