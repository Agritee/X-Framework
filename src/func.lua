-- func.lua
-- Author: cndy1860
-- Date: 2018-12-25
-- Descrip: 功能函数

--复制表
function tbCopy(tb)
	local tmp = {}
	for k, v in pairs(tb) do
		if type(v) == "table" then
			tmp[k] = tbCopy(v)
		else
			tmp[k] = v
		end
	end
	return tmp
end

--比较比是否相等
function compareTb(srcTb, dstTb)
	local getAbsLen = function (tb)
		local count = 0
		for k, _ in pairs(tb) do
			count = count + 1
		end
		return count
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

function setValueByStrKey(keyStr, value)
	local keysTb = {}
	for keyStr, keyIndex in string.gmatch(keyStr, "([%a_]+)%[?(%d*)%]?%.?") do
		table.insert(keysTb, keyStr)
		if string.len(keyIndex) > 0 then
			table.insert(keysTb, tonumber(keyIndex))
		end
	end
	
	local iteratorTb = _G
	for k, v in pairs(keysTb) do
		if k < #keysTb then
			iteratorTb = iteratorTb[v]
		end
	end
	
	iteratorTb[keysTb[#keysTb]] = value
end

--跳过初始化界面，主要用于自动重启后，跳过初始化界面
function skipInitPage()
	local startTime = os.time()
	while true do
		local currentPage = page.getCurrentPage()
		prt(currentPage)
		if currentPage == "初始化界面" then
			Log("catch init page")
			local _startTime = os.time()
			while true do
				local _currentPage = page.getCurrentPage()
				if _currentPage ~= "初始化界面" then
					sleep(2000)
					if page.getCurrentPage() ~= "初始化界面" then
						Log("skiped init page")
						return
					end
				end
				
				if os.time() - _startTime > CFG.DEFAULT_TIMEOUT then
					catchError(ERR_TIMEOUT, "cant catch init next page!")
				end
				
				if (os.time() - _startTime) % 2 == 0 then
					ratioTap(30, 60)
				end
				
				sleep(500)
			end			
		end
		
		if os.time() - startTime > CFG.DEFAULT_TIMEOUT then
			catchError(ERR_TIMEOUT, "cant catch init page!")
		end
		
		sleep(200)
	end
end

--检测当前游戏应用是否还在前端运行中
function isAppInFront()
	local appName = runtime.getForegroundApp()
	if appName == CFG.APP_ID then
		return true
	end
	
	return false
end

--万能输出
function prt(...)
	if CFG.LOG ~= true then
		return
	end
	
	local con={...}
	for key,value in ipairs(con) do
		if(type(value)=="table")then
			--打印输出table,请注意不要传入对象,会无限循环卡死
			printTbl = function(tbl)
				local function prt(tbl,tabnum)
					tabnum=tabnum or 0
					if not tbl then return end
					for k,v in pairs(tbl)do
						if type(v)=="table" then
							print(string.format("%s[%s](%s) = {",string.rep("\t",tabnum),tostring(k),"table"))
							prt(v,tabnum+1)
							print(string.format("%s}",string.rep("\t",tabnum)))
						else
							print(string.format("%s[%s](%s) = %s",string.rep("\t",tabnum),tostring(k),type(v),tostring(v)))
						end
					end
				end
				print("Print Table = {")
				prt(tbl,1)
				print("}")
			end
			printTbl(value)
			con[key]=""
		else
			con[key]=tostring(value)
		end
	end
	sysLog(table.concat(con,"  "))
end

--将LOG信息写入日志文件,不受CFG.LOG的影响
local function writeLog(content)		--写日志文件
	if content == nil then
		return
	end
	
	local logFile = xmod.getPublicPath()..CFG.LOG_FILE_NAME
	local file = io.open(logFile, "a")
	if file then
		file:write("["..os.date("%H:%M:%S", os.time()).."]"..content.."\r\n")
		io.close(file)
	end
end

--打印LOG信息至调试信息板，允许content = nil的情况，用于排错
function Log(content)
	if CFG.WRITE_LOG == true then
		writeLog(content)
	end
	
	if CFG.LOG ~= true then
		return
	end
	
	log(content)
end

--捕获捕获处理函数
function catchError(errType, errMsg, forceContinueFlag)
	local etype = errType or ERR_UNKOWN
	local emsg = errMsg or "some error"
	local eflag = forceContinueFlag or false
	
	--catchError专用Log函数，不受CFG.LOG的影响
	local LogError = function(content)
		if CFG.WRITE_LOG == true then
			writeLog(content)
		end
		
		log(content)
	end
	
	--打印错误类型和具体信息
	if etype == ERR_MAIN or etype == ERR_TASK_ABORT then
		LogError("CORE ERR------->> "..emsg)
	elseif etype == ERR_NORMAL then
		LogError("NORMAL ERR------->> "..emsg)
	elseif etype == ERR_FILE then
		LogError("FILE ERR------->> "..emsg)
	elseif etype == ERR_PARAM then
		LogError("PARAM ERR------->> "..emsg)
	elseif etype == ERR_TIMEOUT then
		LogError("TIME OUT ERR------->> "..emsg)
	elseif etype == ERR_WARNING then
		LogError("WARNING ERR------->> "..emsg)
	else
		LogError("UNKOWN ERR------->> "..emsg)
	end
	
	LogError("Interrupt time-------------->> "..os.date("%Y-%m-%d %H:%M:%S", os.time()))
	
	--强制忽略错误处理
	if forceContinueFlag then
		LogError("WARNING:  ------!!!!!!!!!! FORCE CONTINUE !!!!!!!!!!------")
		return
	end
	
	--错误处理模块
	if etype == ERR_MAIN or etype == ERR_TASK_ABORT then	--核心错误仅允许exit
		dialog(errMsg.."\r\n即将退出")
		LogError("!!!cant recover task, program will end now!!!")
		xmod.exit()
	elseif etype == ERR_FILE or etype == ERR_PARAM then	--关键错误仅允许exit
		dialog(errMsg.."\r\n即将退出")
		LogError("!!!cant recover task, program will endlater!!!")
		xmod.exit()
	elseif etype == ERR_WARNING then		--警告任何时候只提示
		LogError("!!!maybe some err in here, care it!!!")
	elseif etype == ERR_TIMEOUT then		--超时错误允许exit，restart
		if USER.ALLOW_RESTART then	--允许重启
			dialog(errMsg.."\r\n等待超时，即将重启", 5)
			if frontAppName() == CFG.APP_ID then
				LogError("TIME OUT BUT APP STILL RUNNING！")
			else
				LogError("TIME OUT AND APP NOT RUNNING YET！")
			end
			
			LogError("!!!its will close app!!!")
			runtime.killApp(CFG.APP_ID);
			sleep(1000)
			LogError("!!!its will restart app!!!")
			if runApp(CFG.APP_ID) then
				LogError("!!!its will restart script 15s later after restart app!!!")
				--记录重启状态，重启之后会直接读取上一次保存的设置信息和相关变量，并不会弹出UI以实现自动续接任务
				exec.setExecStatus("BREAKING")
				sleep(15000)
				xmod.restart()
			else
				LogError("!!!restart app faild, script will exit!!!")
				xmod.exit()
			end
		else	--不允许重启直接退出
			dialog(errMsg.."\r\n等待超时，即将退出")
			LogError("!!!not allow restart, script will exit later!!!")
			xmod.exit()
		end
	else
		LogError("some err in task\r\n -----!!!program will exit later!!!-----")
		xmod.exit()
	end
end

--点击操作
function tap(x, y, delay)
	local d = delay or CFG.DEFAULT_TAP_TIME
	
	if x == nil or y == nil then
		x = 0
		y = 0
	end
	
	touch.down(1, x, y)
	sleep(d)
	touch.up(1, x, y)
	
	Log("Tap at------ x:"..x.." y:"..y)
end

--点击，坐标按传入坐标在有效区所占位置比例缩放
function ratioTap(x, y, delay)
	local d = delay or CFG.DEFAULT_TAP_TIME
	if x == nil or y == nil then
		catchError(ERR_PARAM, "nil xy in proportionallyTap")
	end
	local x1, y1 = scale.getRatioPoint(x, y)
	
	tap(x1, y1, d)
end

--滑动，从(x1, y1)到(x2, y2)
function slide(x1, y1, x2, y2)
	if x1 ~= x2 then	--非竖直滑动
		--将x,y移动距离按移动步长CFG.TOUCH_MOVE_STEP分解为步数
		local stepX = x2 > x1 and CFG.TOUCH_MOVE_STEP or -CFG.TOUCH_MOVE_STEP
		local stepY = (y2 - y1) / math.abs((x2 - x1) / stepX)
		--Log("x1="..x1.." y1="..y1.." x2="..x2.." y2="..y2)
		
		touch.down(1, x1, y1)
		sleep(200)
		for i = 1, math.abs((x2 - x1) / stepX), 1 do
			touch.move(1, x1 + i * stepX, y1 + i * stepY)
			sleep(50)
		end
		touch.move(1, x2, y2)
		sleep(50)
		touch.up(1, x2, y2)
	else	--竖直滑动，0不能作为除数所以单独处理
		touch.down(1, x1, y1)
		sleep(200)
		local stepY = y2 > y1 and CFG.TOUCH_MOVE_STEP or -CFG.TOUCH_MOVE_STEP
		for i = 1, math.abs((y2 - y1) / stepY), 1 do
			touch.move(1, x2, y1 + i * stepY)
			sleep(50)
		end
		touch.move(1, x2, y2)
		sleep(50)
		touch.up(1, x2, y2)
	end	
end

function ratioSlide(x1, y1, x2, y2)
	srcX, srcY = scale.getRatioPoint(x1, y1)
	dstX, dstY = scale.getRatioPoint(x2, y2)
	slide(srcX, srcY, dstX, dstY)
end

