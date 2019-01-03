-- init.lua
-- Author: cndy1860
-- Date: 2018-12-25
-- Descrip: 负责初始化相关操作

local modName = "init"
local M = {}
_G[modName] = M
package.loaded[modName] = M

--初始化设备分辨率
local function initDstResolution()
	local size = screen.getSize()
	CFG.DST_RESOLUTION.width = size.width > size.height and size.width or size.height
	CFG.DST_RESOLUTION.height = size.width <= size.height and size.width or size.height
	
	if CFG.DST_RESOLUTION.width > CFG.SUPPORT_RESOLUTION.max.width
		or CFG.DST_RESOLUTION.width < CFG.SUPPORT_RESOLUTION.min.width 
		or CFG.DST_RESOLUTION.height > CFG.SUPPORT_RESOLUTION.max.height
		or CFG.DST_RESOLUTION.height < CFG.SUPPORT_RESOLUTION.min.height then
		dialog("分辨率不支持")
		xmod.exit()
	end	
end

--初始化黑边参数，根据黑边临界比例设置，左右相等，上下相等，优先级小于CFG.BLACK_BORDER.borderList预设值
local function initBlackBorder()
	local w = CFG.DST_RESOLUTION.width
	local h = CFG.DST_RESOLUTION.height
	
	for _, v in pairs(CFG.BLACK_BORDER.borderList) do
		if v.width == w and v.height == h then		--已经预设过此分辨率黑边
			return
		end
	end
	
	local ratioLR, ratioTB = CFG.BLACK_BORDER.limitRatio.leftRight, CFG.BLACK_BORDER.limitRatio.topBottom
	local lr, tb = 0, 0
	
	if ratioLR ~= nil then
		if w/h > ratioLR then	--超过水平黑边临界比例
			lr = math.floor((w/h - ratioLR) * h / 2 + 0.5)
		end
	end
	if ratioTB ~= nil then
		if w/h < ratioTB then	--小于竖直黑边临界比例
			tb = math.floor((w/h - ratioTB) * h / 2)
		end
	end
	
	--添加至CFG.BLACK_BORDER.borderList
	table.insert(CFG.BLACK_BORDER.borderList, {width = w, height = h, left = lr, right = lr, top = tb, bottom = tb})
end

--初始化有效区域
local function initEffectiveArea()
	local x0, y0, x1, y1 = 0, 0, CFG.DST_RESOLUTION.width, CFG.DST_RESOLUTION.height
	for k, v in pairs(CFG.BLACK_BORDER.borderList) do
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

--初始化缩放比率
local function initScalingRatio()
	local devShort = CFG.DEV_RESOLUTION.height <= CFG.DEV_RESOLUTION.width and CFG.DEV_RESOLUTION.height or CFG.DEV_RESOLUTION.width
	CFG.SCALING_RATIO = CFG.DST_RESOLUTION.height / devShort
	--prt(CFG.SCALING_RATIO)
end

local function initAppID()
	local appid = runtime.getForegroundApp()
	if appid == nil then
		dialog("未检测到任何应用")
		xmod.exit()
	else
		if string.find(appid, CFG.DEFAULT_APP_ID) == nil then	--不同渠道应用包名
			dialog("请先打开实况足球再开启脚本")
			xmod.exit()
		end
		CFG.APP_ID = appid
		Log("APP_ID:"..CFG.APP_ID)
	end
end

--初始化环境参数
local function initEnv()
	screen.init(1, 0)
	
	initAppID()
	
	initDstResolution()
	initScalingRatio()
	initBlackBorder()
	initEffectiveArea()
end

initEnv()
