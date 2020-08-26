-- api.lua
-- Author: cndy1860
-- Date: 2019-01-17
-- Descrip: 转换叉叉引擎新旧api，可以在1.9引擎上使用2.0的api接口，只封装了较为常用的一些关键接口
if not (string.sub(getEngineVersion(), 1, 3) == "1.9" and {true} or {false})[1] then
	return
end

--比较比是否相等
local function compareTable(srcTb, dstTb)
	local getAbsLen = function (tb)
		local count = 0
		for k, _ in pairs(tb) do
			count = count + 1
		end
		return count
	end
	
	if srcTb == nil or dstTb == nil then
		return false
	end
	
	if getAbsLen(srcTb) ~= getAbsLen(dstTb) then
		return false
	end
	
	equalFlag = false
	
	for k, v in pairs(srcTb) do
		if type(v) == "table" then
			local exsitFlag = false
			for _k, _v in pairs(dstTb) do
				if _k == k and type(_v) == "table" then
					exsitFlag = true
					if not compareTb(v, _v) then
						return false
					end
					break
				end
			end
			
			if not exsitFlag then
				return false
			end
		else
			if v ~= dstTb[k] then
				return false
			end
		end
	end
	
	return true
end


-------------伪类Point--------------
Point = {}

local eqPoint = {
	__eq = function(o1, o2)
		return compareTable(o1, o2)
	end
}

local mtPoint = {
	__call = function(self, ...)
		local x, y = unpack({...})
		return setmetatable({x = x, y = y}, eqPoint)
	end
}

setmetatable(Point, mtPoint)
Point.INVALID = Point(-1, -1)
Point.ZERO = Point(0, 0)


-------------伪类Rect--------------
Rect = {}

local eqRect = {
	__eq = function(o1, o2)
		return compareTable(o1, o2)
	end
}

local mtRect = {
	__call = function(self, ...)
		local x, y, width, height = unpack({...})
		return setmetatable({x = x, y = y, width = width, height = height}, eqRect)
	end
}

setmetatable(Rect, mtRect)
Rect.ZERO = Rect(0, 0, 0, 0)


-------------伪类Size--------------
Size = {}

local eqSize = {
	__eq = function(o1, o2)
		return compareTable(o1, o2)
	end
}

local mtSize = {
	__call = function(self, ...)
		local width, height = unpack({...})
		return setmetatable({width = width, height = height}, eqSize)
	end
}

setmetatable(Size, mtSize)
Size.INVALID = Size(-1, -1)
Size.ZERO = Size(0, 0)


-------------lua扩展--------------
function log(content)
	sysLog(content)
end

function sleep(ms)
	mSleep(ms)
end


-------------xmod--------------
xmod = {}

xmod.PLATFORM_IOS = 'iOS'
xmod.PLATFORM_ANDROID ='Android'
xmod.PLATFORM = (getOSType() == "android" and xmod.PLATFORM_ANDROID or xmod.PLATFORM_IOS)

xmod.PRODUCT_CODE_DEV = 1
xmod.PRODUCT_CODE_XXZS = 2
xmod.PRODUCT_CODE_IPA = 3
xmod.PRODUCT_CODE_KUWAN	= 4
xmod.PRODUCT_CODE_SPIRIT = 5

xmod.VERSION_NAME = getEngineVersion()

xmod.PROCESS_MODE_EMBEDDED = 0
xmod.PROCESS_MODE_STANDALONE = 2
xmod.PROCESS_MODE = ((xmod.PLATFORM == xmod.PLATFORM_ANDROID and  getRuntimeMode() == 2) and xmod.PROCESS_MODE_STANDALONE or xmod.PROCESS_MODE_EMBEDDED)

function xmod.getPublicPath()
	return '[public]'
end

function xmod.exit()
	lua_exit()
end

function xmod.restart()
	lua_restart()
end


-------------UI--------------
UI = {}

UI.TOAST = {}
UI.TOAST.LENGTH_SHORT = 0
UI.TOAST.LENGTH_LONG = 1
function UI.toast(msg, length)
	toast(msg)
end


-------------screen--------------
screen = {}

screen.LANDSCAPE_RIGHT = 1
screen.LANDSCAPE_LEFT = 2

function screen.init(orientation)
	init("0", orientation)
end

function screen.getOrientation()
	return getScreenDirection()
end

function screen.getSize()
	local width, height = getScreenSize()
	return Size(width, height)
end

function screen.keep(value)
	keepScreen(value)
end

function screen.snapshot(path, rect, quality)
	local height, width = getScreenSize()
	local rct = rect or Rect(0, 0, width, height)
	snapshot(path, rct.x, rct.y, rct.x + rct.width, rct.y + rct.height, quality or 1)
end

local toPointsTable = function(pos)
	local posTb = {}
	for x, y, c, dif in string.gmatch(pos, "(-?%d+)|(-?%d+)|(%w+)%-?(%w*)") do
		if string.len(dif) > 0 then
			posTb[#posTb + 1] = {tonumber(x), tonumber(y), c, dif}
		else
			posTb[#posTb + 1] = {tonumber(x), tonumber(y), c}
		end
	end
	
	return posTb
end

local getFirstPot = function(pos)
	for x, y, c, dif in string.gmatch(pos, "(-?%d+)|(-?%d+)|(%w+)%-?(%w*)") do
		return tonumber(x), tonumber(y)
	end
end

local isColor = function(x,y,c,s)
	local fl,abs = math.floor,math.abs
	local r,g,b = fl(c/0x10000),fl(c%0x10000/0x100),fl(c%0x100)
	local rr,gg,bb = getColorRGB(x,y)
	s = fl(0xff*(100-s)*0.01)
	if abs(r-rr)<s and abs(g-gg)<s and abs(b-bb)<s then
		return true
	end
	
	return false
end

local isColorDif = function(x,y,c,d)
	local fl,abs = math.floor,math.abs
	local r,g,b = fl(c/0x10000),fl(c%0x10000/0x100),fl(c%0x100)
	local rr,gg,bb = getColorRGB(x,y)
	local dr,dg,db = fl(d/0x10000),fl(d%0x10000/0x100),fl(d%0x100)
	if (r<dr and 0x000000 or r-dr) <= rr and rr <= (r+dr<0xffffff and r+dr or 0xffffff)
		and (g<dg and 0x000000 or g-dg) <= gg and gg <= (g+dg<0xffffff and g+dg or 0xffffff)
		and (b<db and 0x000000 or b-db) <= bb and bb <= (b+db<0xffffff and b+db or 0xffffff) then
		return true
	end
	
	return false
end

function screen.matchColors0(points, fuzzy)
	if points == nil or type(points) ~= "string" or string.len(points) == 0 then
		catchError(ERR_PARAM, "wrong points in matchColors")
	end
		
	local posTb = toPointsTable(points)
	
	local matchFlag = false
	for k, v in pairs(posTb) do
		if v[4] ~= nil then
			if not isColorDif(v[1], v[2], v[3], v[4]) then
				--prt(v)
				return false
			end
		else
			if not isColor(v[1], v[2], v[3], fuzzy or CFG.DEFAULT_FUZZY) then
				--prt(v)
				return false
			end
		end
	end
	
	return true
end

--直接在Lua层对比颜色效率较低，采用findColor找一个点范围来实现在C层的比较
function screen.matchColors(points, fuzzy)
	if points == nil or type(points) ~= "string" or string.len(points) == 0 then
		catchError(ERR_PARAM, "wrong points in matchColors")
	end
		
	local x, y = getFirstPot(points)
	
	local x1, y1 = findColor({x, y, x + 1, y + 1}, points, fuzzy or CFG.DEFAULT_FUZZY)
	
	if x1 == -1 or y1 == -1 then
		return false
	end
	
	return true
end

function screen.findColor(rect, color, globalFuzz, priority)
	--丢掉不常用的priority
	local x, y = findColor({rect.x, rect.y, rect.x + rect.width, rect.y + rect.height}, color, globalFuzz or CFG.DEFAULT_FUZZY)
	return Point(x, y)
end

--修复版的findColors函数,自定义返回值数量(limit参数,默认200),支持hdir,vdir,priority三个参数的全部八种搜索方式
local function RepairFindColors(rect,color,degree,hdir,vdir,priority,limit)
	local allresult={}
	local oneresult
	limit=limit or 200
	oneresult=findColors(rect,color,degree,hdir,vdir,priority)
	if #oneresult>0 then
		for i=1,#oneresult do
			table.insert(allresult,oneresult[i])
			if i>= limit then break end
		end
	end
	if #oneresult==99 then
		local result99=oneresult[99]
		if priority==0 and hdir==0 then
			oneresult=RepairFindColors({result99.x+1,result99.y,rect[3],result99.y},color,degree,hdir,vdir,priority,limit-#allresult)
		elseif priority==0 and hdir==1 then
			oneresult=RepairFindColors({rect[1],result99.y,result99.x-1,result99.y},color,degree,hdir,vdir,priority,limit-#allresult)
		elseif priority==1 and vdir==0 then
			oneresult=RepairFindColors({result99.x,result99.y+1,result99.x,rect[4]},color,degree,hdir,vdir,priority,limit-#allresult)
		elseif priority==1 and vdir==1 then
			oneresult=RepairFindColors({result99.x,rect[2],result99.x,result99.y-1},color,degree,hdir,vdir,priority,limit-#allresult)
		end
		if #oneresult>0 then
			for i=1,#oneresult do
				if #allresult>= limit then break end
				table.insert(allresult,oneresult[i])
			end
		end
		if #allresult<limit then 
			if priority==0 and vdir==0 and result99.y<rect[4] then
				oneresult=RepairFindColors({rect[1],result99.y+1,rect[3],rect[4]},color,degree,hdir,vdir,priority,limit-#allresult)
			elseif priority==0 and vdir==1 and result99.y>rect[2] then
				oneresult=RepairFindColors({rect[1],rect[2],rect[3],result99.y-1},color,degree,hdir,vdir,priority,limit-#allresult)
			elseif priority==1 and hdir==0 and result99.x<rect[3] then
				oneresult=RepairFindColors({result99.x+1,rect[2],rect[3],rect[4]},color,degree,hdir,vdir,priority,limit-#allresult)
			elseif priority==1 and hdir==1 and result99.x>rect[1] then
				oneresult=RepairFindColors({rect[1],rect[2],result99.x-1,rect[4]},color,degree,hdir,vdir,priority,limit-#allresult)
			else
				return allresult
			end
			if #oneresult>0 then
				for i=1,#oneresult do
					if #allresult>= limit then break end
					table.insert(allresult,oneresult[i])
				end
			end
		end
	end
	return allresult
end

function screen.findColors(rect, color, globalFuzz, priority, limit)
	return RepairFindColors({rect.x, rect.y, rect.x + rect.width, rect.y + rect.height},color,globalFuzz or CFG.DEFAULT_FUZZY,0,0,0,limit)
end


-------------touch--------------
touch = {}

function touch.down(index, x, y)
	if type(x) == "number" then
		touchDown(index, x, y)
	elseif type(x) == "table" then
		touchDown(index, x.x, x.y)
	end
end

function touch.move(index, x, y)
	if type(x) == "number" then
		touchMove(index, x, y)
	elseif type(x) == "table" then
		touchMove(index, x.x, x.y)
	end
end

function touch.up(index, x, y)
	if type(x) == "number" then
		touchUp(index, x, y)
	elseif type(x) == "table" then
		touchUp(index, x.x, x.y)
	end
end


-------------storage--------------
storage = {
	map = {}
}

function storage.put(key, value)
	if type(key) ~= "string" then
		Log("faild storage.put, by wrong type key")
		return
	end
	
	if type(value) ~= "string" and type(value) ~= "number" and type(value) ~= "boolean" then
		Log("faild storage.put, by wrong type value")
		return
	end
	
	storage.map[key] = value
end

function storage.get(key, defaultValue)
	if type(key) ~= "string" then
		Log("faild storage.get, by wrong type key")
		return
	end
	
	if type(defaultValue) ~= "string" and type(defaultValue) ~= "number" and type(defaultValue) ~= "boolean" then
		Log("faild storage.get, by wrong type defaultValue")
		return
	end
	
	local value = getStringConfig(key, "NO_DATA")
	
	if value == "NO_DATA" then	--无保存数据直接使用defaultValue
		return defaultValue
	end
	
	if type(defaultValue) == "number" then
		value = tonumber(value)
	elseif type(defaultValue) == "boolean" then
		if value == "true" then
			value = true
		else
			value = false
		end
	end
	
	return value
end

function storage.commit()
	for key, value in pairs(storage.map) do
		setStringConfig(key, tostring(value))
	end
end

function storage.undo()
	storage.map = {}
end

function storage.purge()
	storage.map = {}
end


-------------task--------------
task = {}

function task.execTimer(delayMs, callback, ...)
	local args = { ... }
	setTimer(delayMs,callback, unpack(args))
end


-------------runtime--------------
runtime = {}

function runtime.vibrate()
	return vibrator()
end

function runtime.readClipboard()
	return readPasteboard()
end

function runtime.writeClipboard(content)
	writePasteboard(content)
end

function runtime.inputText(content)
	inputText(content)
end

function runtime.launchApp(appID)
	runApp(appID)
end

function runtime.killApp(appID)
	closeApp(appID)
end

function runtime.isAppRunning(appID)
	if appIsRunning(appID) == 1 then
		return true
	end
	
	return false
end

function runtime.getForegroundApp()
	return frontAppName()
end


-------------script--------------
script = {}

function script.getUserInfo()
	local userInfo = {}
	userInfo.id = ""
	userInfo.membership = 0
	userInfo.expiredTime = 0
	
	local buyState, validTime, res = getUserCredit()
	if res == 0 then
		userInfo.id = getUserID()
		userInfo.membership = buyState
		userInfo.expiredTime = validTime
	end
	
	return userInfo
end

function script.getScriptInfo()
	local scriptInfo = {}
	scriptInfo.id = getScriptID()
	
	return scriptInfo
end

function script.getBulletinBoard(key, token)
	local content, err = getCloudContent(key, token, "获取公告信息失败")
	return content, err
end
 