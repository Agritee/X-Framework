-- init.lua
-- Author: cndy1860
-- Date: 2018-12-25
-- Descrip: 负责初始化相关操作 

--初始化游戏包名
local function initAppID()
	local appid = runtime.getForegroundApp()
	if appid == nil then
		dialog("未检测到任何应用在前台运行！")
		xmod.exit()
	else
		CFG.APP_ID = appid
	end
	
	Log("----initAppID: "..CFG.APP_ID)
end

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
	
	Log("----initDstResolution: "..CFG.DST_RESOLUTION.width.."*"..CFG.DST_RESOLUTION.height)
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
	
	local ratioLR, ratioTB = CFG.BLACK_BORDER.limitRatio.horiz, CFG.BLACK_BORDER.limitRatio.vertical
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
	
	Log("----initBlackBorder: lr="..lr.." tb="..tb)
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
	
	Log("----initEffectiveArea: ("..x0..","..y0.."), ("..x1..","..y1..")")
end

--初始化缩放比率
local function initScalingRatio()
	local devShort = CFG.DEV_RESOLUTION.height <= CFG.DEV_RESOLUTION.width and CFG.DEV_RESOLUTION.height or CFG.DEV_RESOLUTION.width
	CFG.SCALING_RATIO = CFG.DST_RESOLUTION.height / devShort
	
	Log("----initScalingRatio: "..CFG.SCALING_RATIO)
end

--初始化上一次运行状态
local function initPrevStatus()
	PREV.restartedScript = getPrevRestartedScript()
	PREV.restartedAPP = getPrevRestartedAPP()
	
	if PREV.restartedScript or PREV.restartedAPP then
		PREV.restarted = true
	end
	
	PREV.writeLogStatus = getPrevWriteLogStatus()
	PREV.cacheStatus = getPrevCacheStatus()
	
	prt(PREV.cacheStatus)
	prt(PREV.writeLogStatus)
	Log("----initPrevRestartStatus: "..tostring(PREV.restarted))
end

--初始化环境参数
local function initEnv()
	screen.init(screen.getOrientation())
	screen.keep(false)
	
	initAppID()
	initPrevStatus()		--如果有重启脚本的情况，会在此处重置为上一次的APP_ID
	
	initDstResolution()
	initScalingRatio()
	initBlackBorder()
	initEffectiveArea()
	
	Log(" ")
end

initEnv()
