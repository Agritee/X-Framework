--[[
  @Author xxzhushou
  @Repo   https://github.com/xxzhushou/WUI
]]--

local wutils = require 'wui.utils'

local wgrid_option = {
    layout = function ()
        return {
            view = 'div',
            style = {},
            subviews = {
                {
                    view = 'text',
                    style = {},
                    value = ''
                },
                {
                    view = 'image',
                    style = {},
                    src = ''
                }
            }
        }
    end,
    style = {
        ['grid-option'] = {
            ['justify-content'] = 'center',
            ['border-radius'] = 8,
            ['border-width'] = 2,
            ['padding-left'] = 6,
            ['padding-right'] = 6
        },
        ['text-title'] = {
            lines = 2,
            ['line-height'] = 30,
            ['text-overflow'] = 'ellipsis',
            ['text-align'] = 'center',
            ['font-size'] = 26
        },
        ['image-checked'] = {
            position = 'absolute',
            right = 0,
            bottom = 0,
            width = 38,
            height = 34
        }
    },
    instanceCount = 0,
    propertyMap = {},
}

function wgrid_option.createLayout(layout)
    if layout.id == nil then
        wgrid_option.instanceCount = wgrid_option.instanceCount + 1
    end
    local id = layout.id or 'wgrid_option_' .. tostring(wgrid_option.instanceCount)
    local index = layout.index or -1
    local checked = layout.checked or false
    local disabled = layout.disabled or false
    local titleValue = layout.title or ''
    local width = layout.width or 166
    local height = layout.height or 72
    local fontSize = layout.fontSize or 26
    local icon = layout.icon or 'https://gw.alicdn.com/tfs/TB1IAByhgMPMeJjy1XdXXasrXXa-38-34.png'
    local color = layout.color or '#3d3d3d'
    local checkedColor = layout.checkedColor or '#3d3d3d'
    local disabledColor = layout.disabledColor or '#9b9b9b'
    local borderColor = layout.borderColor or 'transparent'
    local checkedBorderColor = layout.checkedBorderColor or '#ffb200'
    local disabledBorderColor = layout.disabledBorderColor or 'transparent'
    local backgroundColor = layout.backgroundColor or '#f6f6f6'
    local checkedBackgroundColor = layout.checkedBackgroundColor or '#ffffff'
    local disabledBackgroundColor = layout.disabledBackgroundColor or '#f6f6f6'

    local layout = wgrid_option.layout()
    layout.id = id
    wutils.mergeTable(layout.style, wgrid_option.style['grid-option'])
    layout.style.width = width
    layout.style.height = height
    layout.style['border-color'] = disabled and disabledBorderColor or (checked and checkedBorderColor or borderColor)
    layout.style['background-color'] = disabled and disabledBackgroundColor or (checked and checkedBackgroundColor or backgroundColor)

    local title = layout.subviews[1]
    title.value = titleValue
    wutils.mergeTable(title.style, wgrid_option.style['text-title'])
    title.style['font-size'] = fontSize
    title.style.color = disabled and disabledColor or (checked and checkedColor or color)
    if title == '' then
        title.style.visibility = 'hidden'
    end

    local image = layout.subviews[2]
    wutils.mergeTable(image.style, wgrid_option.style['image-checked'])
    image.src = disabled and '' or icon
    if not checked or icon == '' then
        image.style.visibility = 'hidden'
    end


    wgrid_option.propertyMap[id] = { index = index, checked = checked, disabled = disabled }
    wgrid_option.propertyMap[id].config = { checkedBorderColor = checkedBorderColor, borderColor = borderColor,
                                            checkedBackgroundColor = checkedBackgroundColor, backgroundColor = backgroundColor,
                                            checkedColor = checkedColor, color = color }
    return layout
end

function wgrid_option.createView(context, layout)
    layout.config = layout.config or {}
    local layout = wgrid_option.createLayout(layout)
    return context:createView(layout)
end

function wgrid_option.updateCheckState(view, checked)
    local id = view:getID()
    if not wgrid_option.propertyMap[id].disabled then
        wgrid_option.propertyMap[id].checked = checked

        local checkedBorderColor = wgrid_option.propertyMap[id].config.checkedBorderColor
        local borderColor = wgrid_option.propertyMap[id].config.borderColor
        local checkedBackgroundColor = wgrid_option.propertyMap[id].config.checkedBackgroundColor
        local backgroundColor = wgrid_option.propertyMap[id].config.backgroundColor
        local checkedColor = wgrid_option.propertyMap[id].config.checkedColor
        local color = wgrid_option.propertyMap[id].config.color

        view:setStyle('border-color', checked and checkedBorderColor or borderColor)
        view:setStyle('background-color', checked and checkedBackgroundColor or backgroundColor)

        view:getSubview(1):setStyle('color', checked and checkedColor or color)

        if not checked then
            view:getSubview(2):setStyle('visibility', 'hidden')
        else
            view:getSubview(2):setStyle('visibility', 'visible')
        end
    end

end

function wgrid_option.setOnSelectedCallback(view, callback)
    local onClicked = function (id, action)
        if callback then
            callback(id, wgrid_option.propertyMap[id].index)
        end
    end
    view:setActionCallback(UI.ACTION.CLICK, onClicked)
end

local wgrid_select = {
    layout = function ()
        return {
            view = 'div',
            style = {
                ['flex-direction'] = 'row',
                ['justify-content'] = 'space-between',
                ['flex-wrap'] = 'wrap'
            },
            subviews = {

            }
        }
    end,
    instanceCount = 0,
    propertyMap= {},
}

function wgrid_select.createLayout(layout)
    if layout.id == nil then
        wgrid_select.instanceCount = wgrid_select.instanceCount + 1
    end
    local id = layout.id or 'wgrid_select_' .. tostring(wgrid_select.instanceCount)

    local list = layout.list or {}
    local config = layout.config or {}
    local single = config.single or false
    local limit = config.limit or 9999
    local containerWidth = config.totalWidth or 750
    local gridStyle = config.gridStyle or {}
    local lineSpacing = gridStyle.lineSpacing or 12
    gridStyle.width = gridStyle.width or 166
    local cols = containerWidth / gridStyle.width

    local layout = wgrid_select.layout()
    layout.id = id
    layout.style.width = containerWidth

    local options = {}
    local checkedCount = 0
    for index, item in ipairs(list) do
        local optConfig = {}
        wutils.mergeTable(optConfig, gridStyle)
        optConfig.index = index
        optConfig.title = item.title or ''
        optConfig.disabled = item.disabled or false

        --disabled为true时认为checked无效，同时单选模式下只认为第一个checked为true的为有效值
        optConfig.checked = not item.disabled and item.checked and (not single or checkedCount == 0) or false
        if optConfig.checked then
            checkedCount = checkedCount + 1
        end

        optConfig.id = id .. '_option_' .. tostring(index)
        local optLayout = wgrid_option.createLayout(optConfig)
        optLayout.style['margin-top'] = index > cols and lineSpacing or 0
        options[index] = optLayout
    end

    --Hack options
    local remainder = #list % cols;
    local len = remainder ~= 0 and cols - remainder or 0

    local index = #options + 1
    for i = 1, len do
        local optLayout = wgrid_option.createLayout({ id = id .. '_option_' .. tostring(index), width = gridStyle.width, height = gridStyle.height })
        optLayout.style['margin-top'] = #list > cols and lineSpacing or 0
        optLayout.style.opacity = 0

        options[index] = optLayout
        index = index + 1
    end

    layout.subviews = options
    wgrid_select.propertyMap[id] = { single = single, limit = limit, checkedCount = checkedCount }
    return layout
end

function wgrid_select.createView(context, layout)
    layout.config = layout.config or {}
    local layout = wgrid_select.createLayout(layout)
    return context:createView(layout)
end

function wgrid_select.setOnSelectedCallback(view, selectCallback, overLimitCallback)
    local parentId = view:getID()

    local subviewsCount = view:subviewsCount()
    local checkedCount = wgrid_select.propertyMap[parentId].checkedCount

    local onSelect = function (id, index)
        local checked = wgrid_option.propertyMap[id].checked
        if wgrid_select.propertyMap[parentId].limit <= checkedCount and not checked then
            if overLimitCallback then
                overLimitCallback(parentId, wgrid_select.propertyMap[parentId].limit)
            end
        else
            checkedCount = 0
            local checkedList = {}
            for i = 1, subviewsCount do
                local option = view:getSubview(i)
                id = option:getID()
                local checkedTmp = wgrid_option.propertyMap[id].checked

                if wgrid_select.propertyMap[parentId].single then
                    checkedTmp = index == i and not checkedTmp;
                elseif index == i then
                    checkedTmp = not checkedTmp
                end

                wgrid_option.updateCheckState(option, checkedTmp)

                if checkedTmp then
                    checkedCount = checkedCount + 1
                    checkedList[checkedCount] = i
                end
            end
            wgrid_select.propertyMap[parentId].checkedCount = checkedCount

            if selectCallback then
                selectCallback(parentId, index, not checked, checkedList)
            end
        end
    end

    for i = 1, subviewsCount do
        local option = view:getSubview(i)
        wgrid_option.setOnSelectedCallback(option, onSelect)
    end
end

return wgrid_select