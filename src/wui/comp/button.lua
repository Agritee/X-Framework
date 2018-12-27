--[[
  @Author xxzhushou
  @Repo   https://github.com/xxzhushou/WUI
]]--

local wutils = require 'wui.utils'

local wbutton = {
    layout = function ()
        return {
            -- id = 'wbutton',
            view = 'div',
            style = {
                width = 720,
                height = 80,
                ['align-items'] = 'center',
                ['justify-content'] = 'center',
                ['border-radius'] = 12,
                opacity = 1;
            },
            subviews = {
                {
                    view = 'text',
                    style = {
                        ['text-overflow'] = 'ellipsis',
                        lines = 1,
                        ['font-size'] = 36,
                        color =  '#ffffff'
                    }
                }
            }
        }
    end,
    instanceCount = 0,
    propertyMap = {},

    STYLE_MAP = {
        red = {
            ['background-color'] = '#FF5000'
        },
        yellow = {
            ['background-color'] = '#FFC900'
        },
        white = {
            ['background-color'] = '#FFFFFF',
            ['border-color'] = '#A5A5A5',
            ['border-width'] = 1
        },
        blue = {
            ['background-color'] = '#0F8DE8'
        }
    },

    TEXT_STYLE_MAP = {
        red = {
            color = '#FFFFFF'
        },
        yellow = {
            color = '#FFFFFF'
        },
        blue = {
            color = '#FFFFFF'
        },
        white = {
            color = '#3D3D3D'
        }
    },

    BUTTON_STYLE_MAP = {
        full = {
            width = 702,
            height = 88
        },
        big = {
            width = 339,
            height = 70
        },
        medium = {
            width = 218,
            height = 60
        },
        small = {
            width = 157,
            height = 44
        }
    },

    TEXT_FONTSIZE_STYLE_MAP = {
        full = {
            fontSize = 36
        },
        big = {
            fontSize = 32
        },
        medium = {
            fontSize = 28
        },
        small = {
            fontSize = 24
        }
    };
}

function wbutton.createLayout(layout)
    if layout.id == nil then
        wbutton.instanceCount = wbutton.instanceCount + 1
    end
    local id = layout.id or 'wbutton_' .. tostring(wbutton.instanceCount)
    local text = layout.text or 'OK'
    local type = layout.type or 'blue'
    local size = layout.size or 'full'
    local disabled = layout.disabled or false
    local btnStyle = layout.btnStyle or {}
    local textStyle = layout.textStyle or {}

    local layout = wbutton.layout()

    layout.id = id

    local mrBtnStyle = layout.style
    wutils.mergeTable(mrBtnStyle, wbutton.STYLE_MAP[type])
    wutils.mergeTable(mrBtnStyle, wbutton.BUTTON_STYLE_MAP[size])
    wutils.mergeTable(mrBtnStyle, btnStyle)
    local disableStyle = { opacity = 0.2 };
    if type == 'white' then
        disableStyle = { ['background-color'] = 'rgba(0, 0, 0, 0.1)' };
    end
    if disabled then
        wutils.mergeTable(mrBtnStyle, disableStyle)
        mrBtnStyle['border-width'] = 0
    end

    mrTextStyle = layout.subviews[1].style
    wutils.mergeTable(mrTextStyle, wbutton.TEXT_STYLE_MAP[type])
    wutils.mergeTable(mrTextStyle, wbutton.TEXT_FONTSIZE_STYLE_MAP[size])
    wutils.mergeTable(mrTextStyle, textStyle)
    if disabled then
        mrBtnStyle['color'] = '#FFFFFF'
    end

    layout.subviews[1].value = text

    wbutton.propertyMap[id] = { type = type, disabled = disabled }

    return layout;
end

function wbutton.setOnClickedCallback(view, callback)
    local onClicked = function (id, action)
        callback(id, action)
    end
    view:setActionCallback(UI.ACTION.CLICK, onClicked)
    view:setActionCallback(UI.ACTION.LONG_PRESS, onClicked)
end

return wbutton