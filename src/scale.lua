-- scale.lua
-- Author: cndy1860
-- Date: 2018-12-24
-- Descrip: 负责多分辨率适配的坐标转换 
require("math")

local modName = "scale"
local M = {}
_G[modName] = M
package.loaded[modName] = M

--将{{x1, y1, c1, dif},{x2, y2, c2, dif},}转换成"x1|y1|c1-dif,x2|y2|c2-dif"格式
function M.toPointsString(pointsTable)
	local strr = ""
	for k, v in pairs(pointsTable) do
		strr = string.format("%s%s|%s|0x%06x", strr, tostring(v[1]), tostring(v[2]), tostring(v[3]))
		if v[4] ~= nil then
			strr = string.format("%s-0x%06x", strr, v[4])
		end
		strr = string.format("%s,", strr)
	end
	strr = string.sub(strr, 1, -2)
	
	return strr
end

--将"x1|y1|c1-dif,x2|y2|c2-dif"转换成{{x1, y1, c1, dif},{x2, y2, c2, dif},}格式
function M.toPointsTable(pointString)
	local posTb = {}
	for x, y, c, dif in string.gmatch(pointString, "(-?%d+)|(-?%d+)|(%w+)%-?(%w*)") do
		if string.len(dif) > 0 then
			posTb[#posTb + 1] = {tonumber(x), tonumber(y), c, dif}
		else
			posTb[#posTb + 1] = {tonumber(x), tonumber(y), c}
		end
	end
	
	return posTb
end

--线性二次插值取色，传入的为缩放后的原始坐标
--开启会增加运算量，酌情使用
function bilinearPot(point)
	local x, y = math.floor(point.x), math.floor(point.y)
	local u, v = point.x - x, point.y - y
	local r0, g0, b0 = screen.getRGB(x, y)
	local r1, g1, b1 = screen.getRGB(x + 1, y)
	local r2, g2, b2 = screen.getRGB(x, y + 1)
	local r3, g3, b3 = screen.getRGB(x + 1, y + 1)
	local r, g, b = 0, 0, 0
	local tmpColor0={
		r = (r0 * (1 - u) + r1 * u),
		g = (g0 * (1 - u) + g1 * u),
		b = (b0 * (1 - u) + b1 * u),
	}
	local tmpColor1={
		r = (r2 * (1 - u) + r3 * u),
		g = (g2 * (1 - u) + g3 * u),
		b = (b2 * (1 - u) + b3 * u),
	}
	local DstColor={
		r = tmpColor0.r * (1 - v) + tmpColor1.r * v,
		g = tmpColor0.g * (1 - v) + tmpColor1.g * v,
		b = tmpColor0.b * (1 - v) + tmpColor1.b * v,
	}
	local c3b = Color3B(DstColor.r, DstColor.g, DstColor.b)
	return c3b:toString()
end

--根据锚点位置返回一个转换后的Area(Rect格式)
--T为上半top，B为下半bottom，L为left左半，R为right右半，M为中间middle，根据组合方式返回1/4-1/2区域的Rect
function M.getAnchorArea(anchorTag)
	local x0, y0 = CFG.EFFECTIVE_AREA[1], CFG.EFFECTIVE_AREA[2]
	local w, h = CFG.EFFECTIVE_AREA[3] - CFG.EFFECTIVE_AREA[1], CFG.EFFECTIVE_AREA[4] - CFG.EFFECTIVE_AREA[2]	--有效区域
	local dx0, dy0 = 0, 0
	local dw, dh = CFG.DST_RESOLUTION.width, CFG.DST_RESOLUTION.height	--绝对区域，不考虑黑边
	
	--prt(CFG.EFFECTIVE_AREA)
	local rect = Rect(0,0,0,0)
	if anchorTag == "T" then	--上1/2
		rect.x, rect.y = x0, y0
		rect.width = w
		rect.height = math.floor(h/2)
	elseif anchorTag == "B" then	--下1/2
		rect.x, rect.y = x0, y0 + math.floor(h/2)
		rect.width = w
		rect.height = math.floor(h/2)
	elseif anchorTag == "L" then	--左1/2
		rect.x, rect.y = x0, y0
		rect.width = math.floor(w/2)
		rect.height = h
	elseif anchorTag == "R" then	--右1/2
		rect.x, rect.y = x0 + math.floor(w/2), y0
		rect.width = math.floor(w/2)
		rect.height = h
	elseif anchorTag == "TL" or anchorTag == "LT" then	--上1/2，左1/2
		rect.x, rect.y = x0, y0
		rect.width = math.floor(w/2)
		rect.height = math.floor(h/2)
	elseif anchorTag == "TM" then	--上中1/2
		rect.x, rect.y = x0 + math.floor(w/4), y0
		rect.width = math.floor(w/2)
		rect.height = math.floor(h/2)
	elseif anchorTag == "TR" or anchorTag == "RT" then	--上1/2，右1/2
		rect.x, rect.y = x0 + math.floor(w/2), y0
		rect.width = math.floor(w/2)
		rect.height = math.floor(h/2)
	elseif anchorTag == "BL" or anchorTag == "LB" then	--下1/2，左1/2
		rect.x, rect.y = x0, y0 + math.floor(h/2)
		rect.width = math.floor(w/2)
		rect.height = math.floor(h/2)
	elseif anchorTag == "BM" then	--下中1/2
		rect.x, rect.y = x0 + math.floor(w/4), y0 + math.floor(h/2)
		rect.width = math.floor(w/2)
		rect.height = math.floor(h/2)
	elseif anchorTag == "BR" or anchorTag == "RB" then	--下1/2，右1/2
		rect.x, rect.y = x0 + math.floor(w/2), y0 + math.floor(h/2)
		rect.width = math.floor(w/2)
		rect.height = math.floor(h/2)
	elseif anchorTag == "LM" then	--左中1/2
		rect.x, rect.y = x0, y0 + math.floor(h/4)
		rect.width = math.floor(w/2)
		rect.height = math.floor(h/2)
	elseif anchorTag == "RM" then	--右中1/2
		rect.x, rect.y = x0 + math.floor(w/2), y0 + math.floor(h/4)
		rect.width = math.floor(w/2)
		rect.height = math.floor(h/2)
	elseif anchorTag == "M" then	--正中1/2
		rect.x, rect.y = x0 + math.floor(w/4), y0 + math.floor(h/4)
		rect.width = math.floor(w/2)
		rect.height = math.floor(h/2)
	elseif anchorTag == "MLR" then	--水平中间1/2
		rect.x, rect.y = x0, y0 + math.floor(h/4)
		rect.width = w
		rect.height = math.floor(h/2)
	elseif anchorTag == "MTB" then	--垂直中间1/2
		rect.x, rect.y = x0 + math.floor(w/4), y0
		rect.width = math.floor(w/2)
		rect.height = h
	elseif anchorTag == "CLT" then	--左上角小区域
		rect.x, rect.y = x0, y0
		rect.width = math.floor(w/4)
		rect.height = math.floor(h/8)
	elseif anchorTag == "CLB" then	--左下角小区域
		rect.x, rect.y = x0, y0 + math.floor(h * 7/8)
		rect.width = math.floor(w/4)
		rect.height = math.floor(h/8)
	elseif anchorTag == "CRT" then	--右上角小区域
		rect.x, rect.y = x0 + math.floor(w * 7/8), y0
		rect.width = math.floor(w/4)
		rect.height = math.floor(h/8)
	elseif anchorTag == "CRB" then	--右下角小区域
		rect.x, rect.y = x0 + math.floor(w * 7/8), y0 + math.floor(h * 7/8)
		rect.width = math.floor(w/4)
		rect.height = math.floor(h/8)
	elseif anchorTag == "A" then	--整个区域
		rect.x, rect.y = x0, y0
		rect.width = w
		rect.height = h
	elseif anchorTag == "ABS" then	--整个区域(DST Area)
		rect.x, rect.y = 0, 0
		rect.width = CFG.DST_RESOLUTION.width
		rect.height = CFG.DST_RESOLUTION.height		
	elseif anchorTag == "dLT" then
		rect.x, rect.y = dx0, dy0
		rect.width = math.floor(dw/2)
		rect.height = math.floor(dh/2)
	else	--其他anchorTag按整个区域取
		rect.x, rect.y = x0, y0
		rect.width = w
		rect.height = h
	end
	
	return rect
end

--缩放点（x, y）
function M.scalePot(pot)
	if pot == nil then
		catchError(ERR_PARAM, "get a nil pot in scalePos")
	end
	
	local ratio = CFG.SCALING_RATIO
	local minX, maxX = CFG.EFFECTIVE_AREA[1], CFG.EFFECTIVE_AREA[3]
	local minY, maxY = CFG.EFFECTIVE_AREA[2], CFG.EFFECTIVE_AREA[4]
	
	local x0, y0 = pot.x, pot.y
	local x1, y1 = x0 * ratio, y0 * ratio
	
	return Point(math.floor(x1 + 0.5), math.floor(y1 + 0.5))
end

--缩放点集，颜色，pos为原点的值
function M.scalePos(pos)
	if pos == nil then
		catchError(ERR_PARAM, "get a nil pos in scalePos")
	end
	
	local srcPos = {}
	local dstPos = {}
	if type(pos) == "string" then
		srcPos = M.toPointsTable(pos)
	elseif type(pos) == "table" then
		srcPos = pos
	else
		catchError(ERR_PARAM, "get a wrong pos type in scalePos")
	end
	
	local ratio = CFG.SCALING_RATIO
	local minX, maxX = CFG.EFFECTIVE_AREA[1], CFG.EFFECTIVE_AREA[3]
	local minY, maxY = CFG.EFFECTIVE_AREA[2], CFG.EFFECTIVE_AREA[4]
	for k, v in pairs(srcPos) do
		pot = {}
		local x0, y0, c0 = v[1], v[2], v[3]
		local x1, y1 = x0 * ratio, y0 * ratio
		x1, y1 = math.floor(x1 + 0.5), math.floor(y1 + 0.5)
		
		pot[1] = x1
		pot[2] = y1
		pot[3] = c0
		if v[4] ~= nil then	--有偏色值
			pot[4] = v[4]
		end
		table.insert(dstPos, pot)
		--prt(pot)
	end
	
	--prt(dstPos)
	return M.toPointsString(dstPos)
end

--按点x, y分别占有效区的比例返回一个点
function M.getRatioPoint(x, y)
	if x == nil or y == nil then
		catchError(ERR_PARAM, "nil xy in getProportionallyPoint")
	end
	
	local devMinX, devMinY = 0, 0	--开发分辨率无黑边的情况
	local devMaxX, devMaxY = CFG.DEV_RESOLUTION.width, CFG.DEV_RESOLUTION.height
	local minX, minY = CFG.EFFECTIVE_AREA[1], CFG.EFFECTIVE_AREA[2]
	local maxX, maxY = CFG.EFFECTIVE_AREA[3], CFG.EFFECTIVE_AREA[4]
	local w, h = maxX - minX, maxY - minY
	
	local x1 = minX + (x - devMinX)/(devMaxX - devMinX) * w
	local y1 = minY + (y - devMinY)/(devMaxY - devMinY) * h
	
	x1 = math.floor(x1 + 0.5)
	y1 = math.floor(y1 + 0.5)
	
	if x1 < minX then	--超出有效区的要归置
		x1 = minX
	end
	if x1 > maxX then
		x1 = maxX
	end
	if y1 < minY then
		y1 = minY
	end
	if y1 > maxY then
		y1 = maxY
	end

	return  x1, y1
end

function M.offsetPos(pos, firstOffsetPot)
	local posTb = M.toPointsTable(pos)
	if #posTb < 1 then
		return pos
	end
	
	local offsetX = firstOffsetPot.x - posTb[1][1]
	local offsetY = firstOffsetPot.y - posTb[1][2]
	
	for k, v in pairs(posTb) do
		v[1] = v[1] + offsetX
		v[2] = v[2] + offsetY
	end
	
	return M.toPointsString(posTb)
end







