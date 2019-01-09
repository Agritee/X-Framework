--[[
  @Author xxzhushou
  @Repo   https://github.com/xxzhushou/XMod_WUI
]]--

local _M = {}

function _M.mergeTable(t1, t2)
    if type(t1) == 'table' and type(t2) == 'table' then
        for k, v in pairs(t2) do t1[k] = v end
    end
end

return _M
