--[[
  @Author xxzhushou
  @Repo   https://github.com/xxzhushou/WUI
]]--

local _M = {}

function _M.mergeTable(t1, t2)
    if type(t1) == 'table' and type(t2) == 'table' then
        for k, v in pairs(t2) do t1[k] = v end
    end
end

-- function _M.applyWXMetatable(t)
--     setmetatable(t, {
--         __index = function (_t, key)
--             if key == 'getID' then
--                 return function() return _t._wui:getID() end
--             elseif key == 'getType' then
--                 return function() return _t._wui:getType() end
--             elseif key == 'getAttr' then
--                 return function(k) return _t._wui:getAttr(k) end
--             elseif key == 'getAttrs' then
--                 return function() return _t._wui:getAttrs() end
--             elseif key == 'getStyle' then
--                 return function(k) return _t._wui:getStyle(k) end
--             elseif key == 'getStyles' then
--                 return function() return _t._wui:getStyles() end
--             elseif key == 'getPseudoStyle' then
--                 return function(k) return _t._wui:getPseudoStyle(k) end
--             elseif key == 'getPseudoStyles' then
--                 return function() return _t._wui:getPseudoStyles() end
--             elseif key == 'setAttr' then
--                 return function(k, v) return _t._wui:setAttr(k, v) end
--             elseif key == 'setStyle' then
--                 return function(k, v) return _t._wui:setStyle(k, v) end
--             elseif key == 'setPseudoStyle' then
--                 return function(k, v) return _t._wui:setPseudoStyle(k, v) end
--             elseif key == 'subviewsCount' then
--                 return function() return _t._wui:subviewsCount() end
--             elseif key == 'getSubview' then
--                 return function(i) return _t._wui:getSubview(i) end
--             elseif key == 'addSubview' then
--                 return function(v, i) return _t._wui:addSubview(v, i) end
--             elseif key == 'removeSubview' then
--                 return function(v) return _t._wui:removeSubview(v) end
--             elseif key == 'removeFromParent' then
--                 return function() return _t._wui:removeFromParent() end
--             end
--         end
--     })
-- end

return _M
