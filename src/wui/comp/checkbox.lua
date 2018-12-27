--[[
  @Author xxzhushou
  @Repo   https://github.com/xxzhushou/WUI
]]--

local wutils = require 'wui.utils'
local wcell = require 'wui.comp.cell'

local wcheckbox = {
    layout = function ()
        return {
            -- id = 'wcheckbox',
            view = 'wcheckbox_cell_1',
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
        CHECKED = 'https://gw.alicdn.com/tfs/TB14fp2pwMPMeJjy1XbXXcwxVXa-72-72.png',
        UNCHECKED = 'https://gw.alicdn.com/tfs/TB1U6SbpwMPMeJjy1XcXXXpppXa-72-72.png',
        CHECKED_DISABLED = 'https://gw.alicdn.com/tfs/TB1aPabpwMPMeJjy1XcXXXpppXa-72-72.png',
        UNCHECKED_DISABLED = 'https://gw.alicdn.com/tfs/TB1lTuzpwoQMeJjy0FoXXcShVXa-72-72.png'
    },
    propertyMap = {},
    templates = {
        function ()
            wcell.register('wcheckbox_cell_1', { hasTopBorder = false, hasBottomBorder = true })
            return 'wcheckbox_cell_1'
        end,
        function ()
            wcell.register('wcheckbox_cell_2', { hasTopBorder = true, hasBottomBorder = true })
            return 'wcheckbox_cell_2'
        end,
        function ()
            wcell.register('wcheckbox_cell_3', { hasTopBorder = false, hasBottomBorder = false })
            return 'wcheckbox_cell_3'
        end,
        function ()
            wcell.register('wcheckbox_cell_4', { hasTopBorder = true, hasBottomBorder = false })
            return 'wcheckbox_cell_4'
        end,
    }
}

function wcheckbox.createLayout(layout)
    if layout.id == nil then
        wcheckbox.instanceCount = wcheckbox.instanceCount + 1
    end
    local id = layout.id or 'wcheckbox_' .. tostring(wcheckbox.instanceCount)

    local title = layout.title or ''
    local value = layout.value or ''
    local checked = layout.checked or false
    local disabled = layout.disabled or false
    local cbconfig = layout.config or {}
    local hasTopBorder = layout.hasTopBorder or false
    local hasBottomBorder = layout.hasBottomBorder == nil and true or layout.hasBottomBorder

    local indexTop = hasTopBorder and 2 or 1
    local indexBottom = hasBottomBorder and 0 or 2
    local templateIndex = indexTop + indexBottom
    local templateName = wcheckbox.templates[templateIndex]()

    local layout = wcheckbox.layout()
    layout.id = id
    layout.view = templateName

    local slots = layout.slots

    local mergeIcon = ''
    cbconfig.checkedIcon = cbconfig.checkedIcon or wcheckbox.icon.CHECKED
    cbconfig.uncheckedIcon = cbconfig.uncheckedIcon or wcheckbox.icon.UNCHECKED
    cbconfig.checkedDisabledIcon = cbconfig.checkedDisabledIcon or wcheckbox.icon.CHECKED_DISABLED
    cbconfig.uncheckedDisabledIcon = cbconfig.uncheckedDisabledIcon or wcheckbox.icon.UNCHECKED_DISABLED

    mergeIcon = checked and (disabled and cbconfig.checkedDisabledIcon or cbconfig.checkedIcon) or (disabled and cbconfig.uncheckedDisabledIcon or cbconfig.uncheckedIcon)

    slots[2].src = mergeIcon
    cbconfig.checkedColor = cbconfig.checkedColor or '#EE9900'
    cbconfig.uncheckedColor = cbconfig.uncheckedColor or '#3D3D3D'
    local textColor = cbconfig.checkedColor
    if checked == false or disabled then
        textColor = cbconfig.uncheckedColor
    end
    slots[1].style.color = textColor
    slots[1].value = title

    wcheckbox.propertyMap[id] = { config = cbconfig, checked = checked, disabled = disabled, value = value, title = title }

    return layout
end

function wcheckbox.createView(context, layout)
    layout.config = layout.config or {}
    local layout = wcheckbox.createLayout(layout)
    return context:createView(layout)
end

function wcheckbox.setOnCheckedCallback(view, callback)
    local onClicked = function (id, action)
        disabled = wcheckbox.propertyMap[id].disabled
        if not disabled then
            wcheckbox.propertyMap[id].checked = not wcheckbox.propertyMap[id].checked
            local checked = wcheckbox.propertyMap[id].checked
            local cbconfig = wcheckbox.propertyMap[id].config

            local icon = checked and (disabled and cbconfig.checkedDisabledIcon or cbconfig.checkedIcon) or (disabled and cbconfig.uncheckedDisabledIcon or cbconfig.uncheckedIcon)
            local image = view:getSubview(2)
            image:setAttr('src', icon)

            local checkedColor = cbconfig.checkedColor
            if checked == false or disabled then
                checkedColor= cbconfig.uncheckedColor
            end
            local titleText = view:getSubview(1):getSubview(1)
            titleText:setStyle('color', checkedColor)

            if callback then
                callback(id, wcheckbox.propertyMap[id].title, wcheckbox.propertyMap[id].value, checked)
            end
        end
    end

    view:setActionCallback(UI.ACTION.CLICK, onClicked)
end

return wcheckbox