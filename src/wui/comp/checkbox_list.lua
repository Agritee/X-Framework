--[[
  @Author xxzhushou
  @Repo   https://github.com/xxzhushou/WUI
]]--

local wutils = require 'wui.utils'
local wcheckbox = require 'wui.comp.checkbox'

local wcheckbox_list = {
    layout = function ()
        return {
            -- id = 'wcheckbox_list',
            view = 'div',
            subviews = {
            }
        }
    end,
    instanceCount = 0
}

function wcheckbox_list.createLayout(layout)
    if layout.id == nil then
        wcheckbox_list.instanceCount = wcheckbox_list.instanceCount + 1
    end
    local id = layout.id or 'wcheckbox_list_' .. tostring(wcheckbox_list.instanceCount)
    local cblconfig = layout.config or {}
    local list = layout.list or {}

    local layout = wcheckbox_list.layout()
    layout.id = id
    local subviews = layout.subviews

    for i, v in ipairs(list) do
        v.config = {}
        wutils.mergeTable(v.config, cblconfig)
        local cblayout = wcheckbox.createLayout(v)
        subviews[i] = cblayout
    end

    return layout
end

function wcheckbox_list.createView(context, layout)
    layout.config = layout.config or {}
    local layout = wcheckbox_list.createLayout(layout)
    return context:createView(layout)
end

function wcheckbox_list.setOnCheckedCallback(view, callback)
    local parentId = view:getID()
    local checkboxList = {}

    local onCheckBoxClicked = function (id, title, value, checked)
        checkboxList[id].checked = checked
        local checkedList = {}
        local index = 1
        for k, v in pairs(checkboxList) do
            if v.checked then
                table.insert(checkedList, { index = index, title = v.title, value = v.value })
            end
            index = index + 1
        end
        if callback then
            callback(parentId, checkedList)
        end
    end

    local subviewsCount = view:subviewsCount()
    for i = 1, subviewsCount do
        local subview = view:getSubview(i)
        local id = subview:getID()
        if wcheckbox.propertyMap[id] then
            local title = wcheckbox.propertyMap[id].title
            local value = wcheckbox.propertyMap[id].value
            local checked = wcheckbox.propertyMap[id].checked
            checkboxList[id] = { title = title, value = value, checked = checked }
        end
        wcheckbox.setOnCheckedCallback(subview, onCheckBoxClicked)
    end
end

return wcheckbox_list