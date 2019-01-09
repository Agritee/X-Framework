--[[
  @Author xxzhushou
  @Repo   https://github.com/xxzhushou/XMod_WUI
]]--

local wutils = require 'wui.utils'
local wcell = require 'wui.comp.cell'

local wdropdown = {
    optLayout = function ()
        return {
            view = 'div',
            style = {},
            subviews = {
                {
                    view = 'image',
                    style = {},
                    src = ''
                },
                {
                    view = 'text',
                    style = {},
                    value = ''
                }
            }
        }
    end,
    layout = function ()
        return {
            view = 'div',
            style = {},
            subviews = {
                {
                    view = 'div',
                    style = {},
                },
                {
                    view = 'div',
                    style = {},
                    subviews = {
                        {
                            view = 'div',
                            style = {},
                        },
                        {
                            view = 'scroller',
                            style = {},
                            subviews = {}
                        },
                    }
                }
            }
        }
    end,
    style = {
        ['wrapper'] = {
            ['z-index'] = 999,
        },
        ['g-cover'] =  {
            visibility = 'hidden',
            position = 'fixed',
            top = 0,
            right = 0,
            left = 0,
            bottom = 0,
            ['background-color'] = 'rgba(0, 0, 0, 0.4)',
            ['z-index'] = 1
        },
        ['g-popover'] = {
            visibility = 'hidden',
            position = 'fixed',
            padding = 15,
            ['z-index'] = 10
        },
        ['u-popover-arrow'] = {
            position = 'absolute',
            ['border-radius'] = 4,
            width = 30,
            height = 30,
            ['background-color'] = '#ffffff'
        },
        ['u-popover-inner'] = {
            ['border-radius'] = 10,
            ['background-color'] = '#ffffff'
        },
        ['i-opt'] = {
            ['flex-direction'] = 'row',
            ['justify-content'] = 'space-between',
            ['align-items'] = 'center',
            ['margin-left'] = 20,
            ['margin-right'] = 20,
            ['padding-left'] = 20,
            ['padding-right'] = 20,
            ['border-bottom-width'] = 1,
            ['border-bottom-color'] = '#dddddd',
        },
        ['i-opt-noborder'] ={
            ['border-bottom-color'] = '#ffffff',
        },
        ['opt-icon'] = {
            width = 32,
            height = 32,
            ['margin-right'] = 16,
        },
        ['opt-text'] = {
            flex = 1,
            height = 80,
            ['font-size'] = 30,
            ['line-height'] = 80,
        },
        ['text-align-center'] ={
            ['text-align'] = 'center',
        }
    },
    instanceCount = 0,
    propertyMap = {},
}

function wdropdown.createLayout(config)
    if config.id == nil then
        wdropdown.instanceCount = wdropdown.instanceCount + 1
    end
    local id = config.id or 'wdropdown_' .. tostring(wdropdown.instanceCount)
    local position = config.position or Point(0, 0)
    local arrowPosition = config.arrowPosition or {pos='top', x=0, y=0}
    local coverColor = config.coverColor or 'rgba(0, 0, 0, 0.4)'
    local textStyle = config.textStyle or {}
    local list = config.list or {}


    local layout = wdropdown.layout()
    layout.id = id
    wutils.mergeTable(layout.style, wdropdown.style['wrapper'])

    local coverEl = layout.subviews[1]
    wutils.mergeTable(coverEl.style, wdropdown.style['g-cover'])
    coverEl.style['background-color'] = coverColor
    coverEl.style.opacity = 0

    local popoverEl = layout.subviews[2]
    wutils.mergeTable(popoverEl.style, wdropdown.style['g-popover'])
    popoverEl.style.opacity = 0

    local popoverArrowEl = popoverEl.subviews[1]
    wutils.mergeTable(popoverArrowEl.style, wdropdown.style['u-popover-arrow'])

    local popoverInnerEl = popoverEl.subviews[2]
    wutils.mergeTable(popoverInnerEl.style, wdropdown.style['u-popover-inner'])

    for index, item in ipairs(list) do
        local optLayout = wdropdown.optLayout()
        wutils.mergeTable(optLayout.style, wdropdown.style['i-opt'])
        if index == #list then
            wutils.mergeTable(optLayout.style, wdropdown.style['i-opt-noborder'])
        end

        local iconEl = optLayout.subviews[1]
        local textElIndex = 2
        wutils.mergeTable(iconEl.style, wdropdown.style['opt-icon'])
        if item.icon then
            iconEl.src = item.icon
        else
            textElIndex = 1
            table.remove(optLayout.subviews,1)
        end

        local textEl = optLayout.subviews[textElIndex]
        wutils.mergeTable(textEl.style, wdropdown.style['opt-text'])
        wutils.mergeTable(textEl.style, textStyle)
        textEl.value = item.text

        popoverInnerEl.subviews[index] = optLayout
    end
    if #list > 5 then
        local height = textStyle.height and textStyle.height or wdropdown.style['opt-text'].height
        popoverInnerEl.style.height = height * 5
    end

    wdropdown.propertyMap[id] = {data = list, position = position,
                                    arrowPosition = arrowPosition,
                                    hasCverViewClickFunc = false,
                                    hasSelectedCallback = false}

    return layout
end

function wdropdown.createView(context, layout)
    layout.config = layout.config or {}
    local layout = wdropdown.createLayout(layout)
    return context:createView(layout)
end

local function transformOrigin(arrowPosition)
    local x, y, pos = arrowPosition.x, arrowPosition.y, arrowPosition.pos
    local xAxis
    local yAxis
    if pos == 'top' or pos == 'bottom' then
        yAxis = pos
        if x < 0 then
            xAxis = 'right'
        else
            xAxis = 'left'
        end
    else
        xAxis = pos
        if y < 0 then
            yAxis = 'bottom'
        else
            yAxis = 'top'
        end
    end

    return string.format('%s %s', xAxis, yAxis)
end

local function contentTransform(arrowPosition)
    local x, y, pos = arrowPosition.x, arrowPosition.y, arrowPosition.pos
    local transformFunction1 = 'scale(0)'
    local transformFunction2

    if pos == 'top' or pos == 'bottom' then
        if x >= 0 and x < 22 then
            x = 22
        elseif x < 0 and x > -22 then
            x =-22
        end

        if x < 0 then
            x = x-15
        else
            x = x+15
        end
        transformFunction2 = string.format('translateX(%dpx)', x)
    else
        if y >= 0 and y < 22 then
            y = 22
        elseif y < 0 and y > -22 then
            y =-22
        end

        if y < 0 then
            y = y-15
        else
            y = y+15
        end
        transformFunction2 = string.format('translateY(%dpx)', y)
    end

    return string.format('%s %s', transformFunction1, transformFunction2)
end

local function arrowStyle(arrowPosition)
    local x, y, pos = arrowPosition.x, arrowPosition.y, arrowPosition.pos
    local style = {}

    if pos == 'top' or pos == 'bottom'then
        if pos == 'top' then
            style.top = 6
        else
            style.bottom = 6
        end
        style.transform = 'scaleX(0.8) rotate(45deg)'
        if x >= 0 and x < 22 then
            x = 22
        elseif x < 0 and x > -22 then
            x =-22
        end
        if x < 0 then
            style.right = math.abs(x)
        else
            style.left = x
        end
    elseif pos == 'left' or pos == 'right' then
        if pos == 'left' then
            style.left = 6
        else
            style.right = 6
        end
        style.transform = 'scaleY(0.8) rotate(45deg)'
        if y >= 0 and y < 22 then
            y = 22
        elseif y < 0 and y > -22 then
            y =-22
        end
        if y < 0 then
            style.bottom = math.abs(y)
        else
            style.top = y
        end
    end

    return style
end

function wdropdown.show(dropdownboxView, selectedCallback)
    local dropdownboxId = dropdownboxView:getID()
    local propertyMap = wdropdown.propertyMap[dropdownboxId]
    data = propertyMap.data
    position = propertyMap.position
    arrowPosition = propertyMap.arrowPosition

    local x, y = position.x, position.y

    local coverView = dropdownboxView:getSubview(1)
    coverView:setStyle('transition-property', 'opacity')
    coverView:setStyle('transition-duration', '0.25s')
    coverView:setStyle('transition-delay', '0s')
    coverView:setStyle('transition-timing-function', 'ease-out')
    coverView:setStyle('visibility', 'visible')
    coverView:setStyle('opacity', 1)

    local popoverView =  dropdownboxView:getSubview(2)
    if x < 0 then
        popoverView:setStyle('right', math.abs(x))
    else
        popoverView:setStyle('left', x)
    end

    if y < 0 then
        popoverView:setStyle('bottom', math.abs(y))
    else
        popoverView:setStyle('top', y)
    end

    popoverView:setStyle('transition-property', 'opacity,transform')
    popoverView:setStyle('transition-duration', '1s')
    popoverView:setStyle('transition-delay', '0s')
    popoverView:setStyle('transition-timing-function', 'ease-in')
    popoverView:setStyle('visibility', 'visible')
    popoverView:setStyle('opacity', 1)
    popoverView:setStyle('transform-origin', transformOrigin(arrowPosition))
    popoverView:setStyle('transform', 'scale(1)')

    local popoverArrowView = popoverView:getSubview(1)
    popoverArrowView:setStyle(arrowStyle(arrowPosition))

    if not propertyMap.hasCverViewClickFunc then
        propertyMap.hasCverViewClickFunc = true

        local onClicked = function (id, action)
            wdropdown.hide(dropdownboxView)
        end
        coverView:setActionCallback(UI.ACTION.CLICK, onClicked)
    end

    if not propertyMap.hasSelectedCallback then
        propertyMap.hasSelectedCallback = true

        local popoverInnerView = popoverView:getSubview(2)
        local subviewsCount = popoverInnerView:subviewsCount()
        for i = 1, subviewsCount do
            local optView = popoverInnerView:getSubview(i)

            local onClicked = function (id, action)
                if selectedCallback then
                    selectedCallback(data[i].text, data[i].value)
                end
                wdropdown.hide(dropdownboxView)
            end
            optView:setActionCallback(UI.ACTION.CLICK, onClicked)
        end
    end
end

function wdropdown.hide(dropdownboxView)
    local coverView = dropdownboxView:getSubview(1)
    coverView:setStyle('transition-property', 'opacity')
    coverView:setStyle('transition-duration', '0.25s')
    coverView:setStyle('transition-delay', '0s')
    coverView:setStyle('transition-timing-function', 'ease')
    coverView:setStyle('opacity', 0)
    coverView:setStyle('visibility', 'hidden')

    local popoverView =  dropdownboxView:getSubview(2)
    popoverView:setStyle('transition-property', 'opacity,transform')
    popoverView:setStyle('transition-duration', '0.25s')
    popoverView:setStyle('transition-delay', '0s')
    popoverView:setStyle('transition-timing-function', 'ease')
    popoverView:setStyle('opacity', 0)
    popoverView:setStyle('transform-origin', transformOrigin(arrowPosition))
    popoverView:setStyle('transform', contentTransform(arrowPosition))
    popoverView:setStyle('visibility', 'hidden')

end

return wdropdown