--[[
  @Author xxzhushou
  @Repo   https://github.com/xxzhushou/WUI
]]--

local wutils = require 'wui.utils'

local wcell = {
    layout = function ()
        return {
            view = 'div',
            style = {},
            subviews = {
                {
                    view = 'slot',
                    name = 'label'
                },
                {
                    view = 'div',
                    style = {},
                    subviews = {
                        {
                            view = 'slot',
                            name = 'title'
                        }
                    }
                },
                {
                    view = 'slot',
                    name = 'value'
                },
                {
                    view = 'text',
                    style = {},
                    value = ''
                },
                {
                    view = 'image',
                    style = {},
                    src = 'https://gw.alicdn.com/tfs/TB11zBUpwMPMeJjy1XbXXcwxVXa-22-22.png'
                }
            }
        }
    end,
    style = {
        ['wcell'] = {
            ['flex-direction'] = 'row',
            ['align-items'] = 'center',
            ['padding-left'] = 24,
            ['padding-right'] = 24,
            ['background-color'] = '#ffffff',
            ['margin'] = 0
        },
        ['cell_margin'] = {
            ['margin-bottom'] = 24,
        },
        ['cell_title'] = {
            flex = 1,
        },
        ['cell_indent'] = {
            ['padding-bottom'] = 30,
            ['padding-top'] = 30,
        },
        ['has_desc'] = {
            ['padding-bottom'] = 18,
            ['padding-top'] = 18,
        },
        ['cell_top_border'] = {
            ['border-top-color'] = '#e2e2e2',
            ['border-top-width'] = 1,
        },
        ['cell_bottom_border'] = {
            ['border-bottom-color'] = '#ff0000',
            ['border-bottom-width'] = 1,
        },
        ['cell_label_text'] = {
            ['font-size'] = 30,
            color = '#666666',
            width = 188,
            ['margin-right'] = 10,
        },
        ['cell_arrow_icon'] = {
            width = 22,
            height = 22,
        },
        ['cell_content'] = {
            color = '#333333',
            ['font-size'] = 30,
            ['line-height'] = 40,
        },
        ['cell_desc_text'] = {
            color = '#999999',
            ['font-size'] = 24,
            ['line-height'] = 30,
            ['margin-top'] = 4,
            ['margin-right'] = 30,
        },
        ['extra_content_text'] = {
            ['font-size'] = 28,
            color = '#999999',
            ['margin-right'] = 4,
        }
    }
}

function wcell.createLayout(layout)
    local hasArrow = layout.hasArrow or false
    local hasTopBorder = layout.hasTopBorder or false
    local hasBottomBorder = layout.hasBottomBorder == nil and true or layout.hasBottomBorder
    local hasVerticalIndent = layout.hasVerticalIndent == nil and true or layout.hasVerticalIndent
    local hasMargin = layout.hasMargin or false
    local cellStyle = layout.cellStyle or {}
    local extraContent = layout.extraContent or ''
    local arrowIcon = layout.arrowIcon or ''
    local desc = layout.desc or false

    local layout = wcell.layout()
    local cell_style = layout.style;
    wutils.mergeTable(cell_style, wcell.style.wcell)
    if hasTopBorder then
        wutils.mergeTable(cell_style, wcell.style.cell_top_border)
    end
    if hasBottomBorder then
        wutils.mergeTable(cell_style, wcell.style.cell_bottom_border)
    end
    if hasMargin then
        wutils.mergeTable(cell_style, wcell.style.cell_margin)
    end
    if hasVerticalIndent then
        wutils.mergeTable(cell_style, wcell.style.cell_indent)
    end
    if desc then
        wutils.mergeTable(cell_style, wcell.style.has_desc)
    end
    wutils.mergeTable(cell_style, cellStyle)

    local subview = layout.subviews
    wutils.mergeTable(subview[2].style, wcell.style.cell_title)
    wutils.mergeTable(subview[4].style, wcell.style.extra_content_text)
    wutils.mergeTable(subview[5].style, wcell.style.cell_arrow_icon)

    if not hasArrow then
        subview[5].style.visibility = 'hidden'
    elseif arrowIcon ~= '' then
        subview[5].src = arrowIcon
    end

    if extraContent == '' then
        subview[4].style.visibility = 'hidden'
    else
        subview[4].value = extraContent
    end

    return layout
end

function wcell.register(componentName, layout)
    UI.register(componentName, wcell.createLayout(layout))
end

wcell.register('wplain_cell', {desc = true})

local wplain_cell = {
    layout = function ()
        return {
            -- id = 'wplain_cell',
            view = 'wplain_cell',
            slots = {
                {
                    view = 'div',
                    name = 'label',
                    subviews = {
                        {
                            view = 'text',
                            value = '',
                            style = {
                                ['font-size'] = 30,
                                color = '#666666',
                                width = 188,
                                ['margin-right'] = 10,
                            }

                        }
                    }
                },
                {
                    view = 'div',
                    name = 'title',
                    subviews = {
                        {
                            view = 'text',
                            value = '',
                            style = {
                                color = '#333333',
                                ['font-size'] = 30,
                                ['line-height'] = 40,
                            }

                        },
                        {
                            view = 'text',
                            value = '',
                            style = {
                                color = '#999999',
                                ['font-size'] = 24,
                                ['line-height'] = 30,
                                ['margin-top'] = 4,
                                ['margin-right'] = 30,
                            }
                        }
                    }
                }
            }
        }
    end,
    instanceCount = 0
}

function wplain_cell.createLayout(layout)
    if layout.id == nil then
        wplain_cell.instanceCount = wplain_cell.instanceCount + 1
    end
    local id = layout.id or 'wplain_cell_' .. tostring(wplain_cell.instanceCount)

    local label = layout.label or ''
    local title = layout.title or ''
    local desc = layout.desc or ''

    local layout = wplain_cell.layout()
    layout.id = id
    local slots = layout.slots


    if label ~= '' then
        slots[1].subviews[1].value = label
    end

    if title ~= '' then
        slots[2].subviews[1].value = title
    end

    if desc ~= '' then
        slots[2].subviews[2].value = desc
    end

    return layout
end

return wcell