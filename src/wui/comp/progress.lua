--[[
  @Author xxzhushou
  @Repo   https://github.com/xxzhushou/WUI
]]--

local wutils = require 'wui.utils'

local wprogress = {
    layout = function ()
        return {
            id = 'wprogress',
            view = 'div',
            style = {
                width,
                height,
                ['border-radius'] = 0,
            },
            subviews = {
                {
                    view = 'div',
                    style = {
                        width,
                        height,
                        ['background-color'] = '#FFC900',
                        ['border-radius'] = 0,
                        position = 'absolute'
                    }
                }
            }
        }
    end,
    instanceCount = 0
}

function wprogress.createLayout(layout)
    if layout.id == nil then
        wprogress.instanceCount = wprogress.instanceCount + 1
    end
    local id = layout.id or 'wprogress_' .. tostring(wprogress.instanceCount)
    local value = layout.value or 0
    value = (value < 0 and 0) or (value > 100 and 100 or value)
    local barWidth = layout.barWidth or 600
    local barHeight = layout.barHeight or 8
    local barColor = layout.barColor or '#FFC900'
    local barRadius = layout.barRadius or 0

    local layout = wprogress.layout()
    layout.id = id
    layout.style.width = barWidth
    layout.style.height = barHeight
    layout.style['border-radius'] = barRadius
    layout.subviews[1].style['background-color'] = barColor
    layout.subviews[1].style['border-radius'] = barRadius
    layout.subviews[1].style.height = barHeight
    layout.subviews[1].style.width = value / 100 * barWidth

    return layout;
end

function wprogress.updateValue(view, value)
    local progressSubview = view:getSubview(1)
    value = (value < 0 and 0) or (value > 100 and 100 or value)
    progressSubview:setStyle('width', value / 100 * view:getStyle('width'))
end

return wprogress