-- init.lua
-- Author: cndy1860
-- Date: 2018-12-25
-- Descrip: 负责初始化相关操作

local modName = "init"
local M = {}
_G[modName] = M
package.loaded[modName] = M

--初始化分辨率相关参数
local function initResolution()
	--设置运行设备分辨率，保证width>=height
	local size = screen.getSize()
	CFG.DST_RESOLUTION.width = size.width > size.height and size.width or size.height
	CFG.DST_RESOLUTION.height = size.width <= size.height and size.width or size.height
	--prt(CFG.DST_RESOLUTION)
	
	--短边缩放比率
	local devShort = CFG.DEV_RESOLUTION.height <= CFG.DEV_RESOLUTION.width and CFG.DEV_RESOLUTION.height or CFG.DEV_RESOLUTION.width
	CFG.SCALING_RATIO = CFG.DST_RESOLUTION.height / devShort
	--prt(CFG.SCALING_RATIO)
	
	--设置有效区域
	local x0, y0, x1, y1 = 0, 0, CFG.DST_RESOLUTION.width, CFG.DST_RESOLUTION.height
	for k, v in pairs(CFG.BLACK_BORDER) do
		if v.width == CFG.DST_RESOLUTION.width and v.height == CFG.DST_RESOLUTION.height then	--有黑边参数
			x0, y0 = x0 + v.left, y0 + v.top
			x1, y1 = x1 - v.right, y1 - v.bottom
			break
		end
	end
	CFG.EFFECTIVE_AREA[1] = x0
	CFG.EFFECTIVE_AREA[2] = y0
	CFG.EFFECTIVE_AREA[3] = x1
	CFG.EFFECTIVE_AREA[4] = y1
	
	--prt(CFG.EFFECTIVE_AREA)
end

--检测分辨率是否在支持范围
local function checkDstResolution()
	if CFG.DST_RESOLUTION.width > CFG.SUPPORT_RESOLUTION.max.width then
		return false
	end
	
	if CFG.DST_RESOLUTION.width < CFG.SUPPORT_RESOLUTION.min.width then
		return false
	end
	
	if CFG.DST_RESOLUTION.height > CFG.SUPPORT_RESOLUTION.max.height then
		return false
	end
	
	if CFG.DST_RESOLUTION.height < CFG.SUPPORT_RESOLUTION.min.height then
		return false
	end
	
	local dstRatio = CFG.DST_RESOLUTION.width / CFG.DST_RESOLUTION.height
	local minRatio = CFG.SUPPORT_RESOLUTION.min.width / CFG.SUPPORT_RESOLUTION.min.height
	local maxRatio = CFG.SUPPORT_RESOLUTION.max.width / CFG.SUPPORT_RESOLUTION.max.height
	
	if dstRatio > maxRatio or dstRatio < minRatio then
		return false
	end
	
	return true
end

function initEnvironment()
	initResolution()
	if checkDstResolution() ~= true then
		dialog("分辨率不支持，请返回作者!")
		Log("分辨率不支持")
	end
end

initEnvironment()
