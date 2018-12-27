--[[
  @Author xxzhushou
  @Repo   https://github.com/xxzhushou/WUI
]]--

local wutils = require 'wui.utils'
local wcell = require 'wui.comp.cell'

local wradio_item = {
    layout = function ()
        return {
            -- id = 'wradio_item',
            view = 'wradio_cell',
            slots = {
                {
                    view = 'text',
                    name = 'title',
                    value = '',
                    style = {
                        color = '#3D3D3D',
                        ['font-size'] = 30;
                    }

                },
                {
                    view = 'image',
                    name = 'value',
                    style = {
                        width = 48,
                        height = 48
                    },
                    src = ''
                }
            }
        }
    end,
    instanceCount = 0,
    icon = {
        CHECKED = 'https://gw.alicdn.com/tfs/TB1Y9vlpwMPMeJjy1XcXXXpppXa-72-72.png',
        DISABLED = 'https://gw.alicdn.com/tfs/TB1PtN3pwMPMeJjy1XdXXasrXXa-72-72.png',
    },
    propertyMap= {},
}

function wradio_item.createLayout(layout)
    if layout.id == nil then
        wradio_item.instanceCount = wradio_item.instanceCount + 1
    end
    local id = layout.id or 'wradio_item_' .. tostring(wradio_item.instanceCount)

    local title = layout.title or ''
    local value = layout.value or ''
    local checked = layout.checked or false
    local disabled = layout.disabled or false
    local radioConfig = layout.config or {}

    wcell.register('wradio_cell', {})

    local layout = wradio_item.layout()
    layout.id = id
    local slots = layout.slots

    local mergeIcon = ''
    radioConfig.checkedIcon = radioConfig.checkedIcon or wradio_item.icon.CHECKED
    radioConfig.disabledIcon = radioConfig.disabledIcon or radioConfig.uncheckedIcon or wradio_item.icon.DISABLED

    mergeIcon = checked and (disabled and radioConfig.disabledIcon or radioConfig.checkedIcon) or ''

    slots[2].src = mergeIcon

    local textColor
    radioConfig.checkedColor = radioConfig.checkedColor or '#EE9900'
    radioConfig.uncheckedColor = radioConfig.uncheckedColor or '#3D3D3D'
    local textColor = radioConfig.checkedColor
    if checked == false or disabled then
        textColor= radioConfig.uncheckedColor
    end

    slots[1].style.color = textColor
    slots[1].value = title

    wradio_item.propertyMap[id] = { config = radioConfig, checked = checked, disabled = disabled, title = title, value = value }

    return layout
end

function wradio_item.createView(context, layout)
    layout.config = layout.config or {}
    local layout = wradio_item.createLayout(layout)
    return context:createView(layout)
end

function wradio_item.updateCheckState(view, checked)
    local id = view:getID()
    disabled = wradio_item.propertyMap[id].disabled
    if not disabled then
        wradio_item.propertyMap[id].checked = checked
        local radioConfig = wradio_item.propertyMap[id].config

        local icon = checked and (disabled and radioConfig.disabledIcon or radioConfig.checkedIcon) or ''
        local image = view:getSubview(2)
        image:setAttr('src', icon)

        local textColor = radioConfig.checkedColor
        if checked == false or disabled then
            textColor = radioConfig.uncheckedColor
        end
        local titleText = view:getSubview(1):getSubview(1)
        titleText:setStyle('color', textColor)
    end
end

function wradio_item.setOnCheckedCallback(view, callback)
    local onClicked = function (id, action)
        disabled = wradio_item.propertyMap[id].disabled
        if not disabled then
            local checked = not wradio_item.propertyMap[id].checked
            wradio_item.updateCheckState(view, checked)

            if callback then
                callback(id, wradio_item.propertyMap[id].title, wradio_item.propertyMap[id].value, checked)
            end
        end
    end

    view:setActionCallback(UI.ACTION.CLICK, onClicked)
end

--wradio
local wradio = {
    layout = function ()
        return {
            -- id = 'wradio',
            view = 'div',
            subviews = {
            }
        }
    end,
    instanceCount = 0,
    propertyMap = {},
}

function wradio.createLayout(layout)
    if layout.id == nil then
        wradio.instanceCount = wradio.instanceCount + 1
    end
    local id = layout.id or 'wradio_' .. tostring(wradio.instanceCount)
    local cblconfig = layout.config or {}
    local list = layout.list or {}

    local layout = wradio.layout()
    layout.id = id
    local subviews = layout.subviews

    for i, v in ipairs(list) do
        v.config = {}
        wutils.mergeTable(v.config, cblconfig)
        local cblayout = wradio_item.createLayout(v)
        subviews[i] = cblayout
    end

    return layout
end

function wradio.createView(context, layout)
    layout.config = layout.config or {}
    local layout = wradio.createLayout(layout)
    return context:createView(layout)
end

function wradio.setOnCheckedCallback(view, callback)
    local parentId = view:getID()
    local oldIndex = 0
    local items = {}

    local onRadioItemChecked = function (id, title, value, checked)
        for k, v in pairs(items) do
            if id ~= k then
                wradio_item.updateCheckState(v.view, false)
            end
        end

        if callback then
            callback(parentId, title, value, items[id].index, oldIndex)
        end
        
        oldIndex = oldIndex == items[id].index and (checked and oldIndex or 0) or items[id].index
    end

    local subviewsCount = view:subviewsCount()
    for i = 1, subviewsCount do
        local subview = view:getSubview(i)
        local id = subview:getID()

        items[id] = {index = i, view = subview}

        if wradio_item.propertyMap[id] then
            if wradio_item.propertyMap[id].checked and not wradio_item.propertyMap[id].disabled then
                oldIndex = i
            end
        end
        wradio_item.setOnCheckedCallback(subview, onRadioItemChecked)
    end
end

return wradio
