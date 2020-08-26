local function getJson()
    local lo_json = {}
    local obj = require('Zlibs.tool.JSON')
    lo_json.decode = function(x) return obj:decode(x) end
    lo_json.encode = function(x) return obj:encode(x) end
    lo_json.encode_pretty = function(x) return obj:encode_pretty(x) end
    local json = lo_json
    return json
end

return getJson()