--[[
  @Author xxzhushou
  @Repo   https://github.com/xxzhushou/WUI
]]--

local wutils = require 'wui.utils'

local wtab_bar = {
    itemLayout = function ()
        return {
            id = '',
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
                --tab-page-wrap
                {
                    view = 'div',
                    style = {},
                    subviews = {
                        {
                            view = 'div',
                            style = {},
                            subviews = {}
                        }
                    }
                },
                --tab-title
                {
                    view = 'div',
                    style = {},
                    subviews = {}
                },

            }
        }
    end,
    style = {
        ['wui-tab-page'] = {
            width = 750,
            height = 1334
        },
        ['tab-title-list'] = {
            ['flex-direction'] = 'row',
            ['justify-content'] = 'space-around',
        },
        ['title-item'] = {
            ['justify-content'] = 'center',
            ['align-items'] = 'center',
            ['border-bottom-style'] = 'solid',
        },
        ['tab-page-wrap'] = {
            width = 750,
            flex = 1,
            overflow = 'hidden'
        },
        ['tab-container'] = {
            position = ' relative',
            width = 3750,
            flex = 1,
            ['flex-direction'] = 'row',
            ['align-items'] = 'stretch',
            ['background-color'] = '#F5F5F5',
            transition = 'left 0.2s ease-in-out'
        },
        ['tab-text'] = {
            lines = 1,
            ['text-overflow'] = 'ellipsis'
        },
        tabStyleDefault = {
            backgroundColor = '#FFFFFF',
            titleColor = '#666666',
            activeTitleColor = '#3D3D3D',
            activeBackgroundColor = '#FFFFFF',
            isActiveTitleBold = true,
            iconWidth = 70,
            iconHeight = 70,
            pageWidth = 750,
            tabWidth = 160,
            tabHeight = 120,
            fontSize = 24,
            activeBottomColor = '#FFC900',
            activeBottomWidth = 120,
            activeBottomHeight = 6,
            textPaddingLeft = 10,
            textPaddingRight = 10
        }
    },
    instanceCount = 0,
    propertyMap= {}
}

function wtab_bar.createLayout(layout)
    if layout.id == nil then
        wtab_bar.instanceCount = wtab_bar.instanceCount + 1
    end
    local id = layout.id or 'wtab_bar_' .. tostring(wtab_bar.instanceCount)
    local tabPages = layout.pages
    local tbconfig = layout.config
    local currentPage = tbconfig.currentPage or 1
    local pageWidth = tbconfig.pageWidth or 750
    local pageHeight = tbconfig.pageHeight or 1334
    local tabTitles = tbconfig.tabTitles or {}

    if #tabPages ~= #tabTitles then
        print('wtab_bar config error')
        return nil
    end

    local tabStyle = {}
    wutils.mergeTable(tabStyle, wtab_bar.style.tabStyleDefault)
    wutils.mergeTable(tabStyle, tbconfig.tabStyle)

    local layout = wtab_bar.layout()
    layout.id = id
    layout.style = wtab_bar.style['wui-tab-page']
    layout.style['background-color'] = '#f2f3f4'
    layout.style.width = pageWidth
    layout.style.height = pageHeight

    local subviews = layout.subviews
    subviews[1].style = wtab_bar.style['tab-page-wrap']
    subviews[1].style.width = pageWidth
    local tabContainer = subviews[1].subviews[1]
    tabContainer.style = wtab_bar.style['tab-container']
    tabContainer.style.width = pageWidth * #tabTitles
    tabContainer.style.left = (currentPage - 1) * (-1 * pageWidth)
    tabContainer.subviews = tabPages and tabPages or {}

    local titleItemList = subviews[2]
    wutils.mergeTable(titleItemList.style, wtab_bar.style['tab-title-list'])
    titleItemList.style['background-color'] = tabStyle.backgroundColor
    titleItemList.style.height = tabStyle.tabHeight
    titleItemList.style['padding-bottom'] = 0

    for i, v in ipairs(tabTitles) do
        local itemId = id .. '_tab_item_' .. tostring(i)
        local itemLayout = wtab_bar.itemLayout()
        itemLayout.id = itemId
        wutils.mergeTable(itemLayout.style, wtab_bar.style['title-item'])
        itemLayout.style.width = tabStyle.tabWidth
        itemLayout.style.height = tabStyle.tabHeight
        itemLayout.style['background-color'] = currentPage == i and tabStyle.activeBackgroundColor or tabStyle.backgroundColor

        local image = itemLayout.subviews[1]
        image.style.width = tabStyle.iconWidth
        image.style.height = tabStyle.iconHeight
        v.activeIcon = v.activeIcon or ''
        v.icon = v.icon or ''
        image.src = currentPage == i and v.activeIcon or v.icon

        local text = itemLayout.subviews[2]
        wutils.mergeTable(text.style, wtab_bar.style['tab-text'])
        text.style['font-size'] = tabStyle.fontSize
        text.style['font-weight'] = currentPage == i and tabStyle.isActiveTitleBold and 'bold' or 'normal'
        text.style.color = currentPage == i and tabStyle.activeTitleColor or tabStyle.titleColor
        text.style['padding-left'] = tabStyle.textPaddingLeft
        text.style['padding-right'] = tabStyle.textPaddingRight
        text.value = v.title

        titleItemList.subviews[i] = itemLayout
    end

    wtab_bar.propertyMap[id] = {}
    wtab_bar.propertyMap[id].currentPage = currentPage
    wtab_bar.propertyMap[id].tabStyle = tabStyle
    wtab_bar.propertyMap[id].tabTitles = tabTitles
    wtab_bar.propertyMap[id].pageWidth = pageWidth

    return layout
end

function wtab_bar.createView(context, layout)
    layout.config = layout.config or {}
    local layout = wtab_bar.createLayout(layout)
    if not layout then
        return nil
    end
    return context:createView(layout)
end

function wtab_bar.setOnSelectedCallback(view, callback)
    local parentId = view:getID()
    local tabContainer = view:getSubview(1):getSubview(1)
    local titleItemList = view:getSubview(2)
    local subviewsCount = titleItemList:subviewsCount()

    local indexMap = {}

    local onClickeded = function (id, action)
        local currentPage = indexMap[id]

        if wtab_bar.propertyMap[parentId].currentPage ~=  currentPage then
            wtab_bar.propertyMap[parentId].currentPage = currentPage
            local tabStyle = wtab_bar.propertyMap[parentId].tabStyle
            local tabTitles = wtab_bar.propertyMap[parentId].tabTitles

            for i = 1, subviewsCount do
                local backgroundColor = currentPage == i and tabStyle.activeBackgroundColor or tabStyle.backgroundColor
                local imageSrc = currentPage == i and tabTitles[i].activeIcon or tabTitles[i].icon
                local fontWeight = currentPage == i and tabStyle.isActiveTitleBold and 'bold' or 'normal'
                local textColor = currentPage == i and tabStyle.activeTitleColor or tabStyle.titleColor

                local itemView = titleItemList:getSubview(i)
                itemView:setStyle('background-color', backgroundColor)

                local image = itemView:getSubview(1)
                local text = itemView:getSubview(2)
                image:setAttr('src', imageSrc)
                text:setStyle('font-weight', fontWeight)
                text:setStyle('color', textColor)
            end

            tabContainer:setStyle('left', (currentPage - 1) * (-1 * wtab_bar.propertyMap[parentId].pageWidth))

            if callback then
                callback(parentId, currentPage)
            end
        end

    end

    for i = 1, subviewsCount do
        local itemView = titleItemList:getSubview(i)
        local itemId = itemView:getID()
        indexMap[itemId] = i
        itemView:setActionCallback(UI.ACTION.CLICK, onClickeded)
    end
end

return wtab_bar
