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

--排序，按从上到下，从左到右的顺序，即优先取y较小值，y相同再取x较小值
function sortPos(a, b)
	if a.x == nil or a.y == nil or b.x == nil or b.y == nil then
		return
	end
	
	--if a.y == b.y then
	--因不同状态下的首点取值位置不同，同一水平位置的y左边可能有微小区别，容错以6像素/短边750未基准
	if math.abs(a.y - b.y) <= (CFG.EFFECTIVE_AREA[4] - CFG.EFFECTIVE_AREA[2]) / 750 * 5 then
		return a.x < b.x
	else
		return a.y < b.y
	end
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

--处理初始化界面，主要用于自动重启后，跳过初始化界面的相关流程
function processInitPage()
	local pageInit = "初始化界面"
	if CFG.APP_ID == "jp.konami.pesam" then
		pageInit = "初始化界面INT"
	end

	local startTime = os.time()
	while true do
		local currentPage = page.getCurrentPage(true)
		if currentPage == pageInit then
			Log("catch init page")
			ratioTap(30, 60)
			local _startTime = os.time()
			while true do
				local _currentPage = page.getCurrentPage(true)
				if _currentPage ~= pageInit then
					sleep(2000)
					if page.getCurrentPage(true) ~= pageInit then
						Log("skiped init page")
						Log("wait main page!")
						sleep(1500)	
						while true do		--这里让等到达主界面，以防止卡在主界面得通知处
							if page.isExsitNavigation("comfirm") then			--恢复比赛提示/网络连接有问题弹出重连
								page.tapNavigation("comfirm")
								sleep(1500)
							elseif page.isExsitNavigation("next") then			--天梯比赛判负后的下一步
								page.tapNavigation("next")
								sleep(1500)
							elseif page.isExsitNavigation("notice") then		--防止通知消息
								page.tapNavigation("notice")
								sleep(1500)
							elseif page.getCurrentPage(true) == "比赛" then		--返回到主界面
								sleep(1500)
								if page.getCurrentPage(true) == "比赛" then		--稳定为主界面(notice完全关闭了)
									Log("自动重启成功返回主界面")
									return
								end
							elseif page.getCurrentPage(true) == "比赛中" then		--返回到比赛界面
								Log("自动重启成功返回比赛界面")
								return
							end
							
							sleep(200)
							
							if os.time() - _startTime > CFG.DEFAULT_TIMEOUT * 2 then
								catchError(ERR_TIMEOUT, "cant catch 比赛 page!")
							end					
						end						
						
						return
					end
				end
				
				if page.isExsitNavigation("comfirm") then		--网络连接有问题弹出重连
					page.tapNavigation("comfirm")
					sleep(500)
				end
				
				if os.time() - _startTime > CFG.DEFAULT_TIMEOUT * 2 then
					catchError(ERR_TIMEOUT, "cant catch init next page!")
				end
				
				if (os.time() - _startTime) % 2 == 0 then
					ratioTap(800, 150, 100)
				end
				
				sleep(500)
			end
		end
		
		if page.isExsitNavigation("comfirm") then		--网络连接有问题弹出重连
			page.tapNavigation("comfirm")
			sleep(500)
		end	
		
		if os.time() - startTime > CFG.DEFAULT_TIMEOUT * 3 then
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
				local function pr(tbl,tabnum)
					tabnum=tabnum or 0
					if not tbl then return end
					for k,v in pairs(tbl)do
						if type(v)=="table" then
							print(string.format("%s[%s](%s) = {",string.rep("\t",tabnum),tostring(k),"table"))
							pr(v,tabnum+1)
							print(string.format("%s}",string.rep("\t",tabnum)))
						else
							print(string.format("%s[%s](%s) = %s",string.rep("\t",tabnum),tostring(k),type(v),tostring(v)))
						end
					end
				end
				print("Print Table = {")
				pr(tbl,1)
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
	if not CFG.LOG then
		return
	end
	
	log(content)
	
	writeLog(content)
end

--清除日志文件
function dropLog()
	local logFile = xmod.getPublicPath()..CFG.LOG_FILE_NAME
	local file = io.open(logFile, "w")
	if file then
		io.close(file)
	end
end

--保存重启脚本状态，同时保存脚本重启前运行的应用ID
function setRestartedScript()
	setStringConfig("PREV_RESTARTED_SCRIPT", "TRUE")
	setStringConfig("PREV_APP_ID", CFG.APP_ID)
end

--获取重启脚本状态
function getPrevRestartedScript()
	if getStringConfig("PREV_RESTARTED_SCRIPT", "FALSE") == "TRUE" then
		Log("脚本重启状态")
		setStringConfig("PREV_RESTARTED_SCRIPT", "FALSE") 	--读取之后重置
		CFG.APP_ID = getStringConfig("PREV_APP_ID", "")		--如果有重启脚本的情况，需要重置为上一次的APP_ID
		return true
	else
		return false
	end
end

--保存重启应用状态
function setRestartedAPP()
	setStringConfig("PREV_RESTARTED_APP", "TRUE")
end

--获取重启应用状态
function getPrevRestartedAPP()
	if getStringConfig("PREV_RESTARTED_APP", "FALSE") == "TRUE" then
		Log("应用重启状态")
		setStringConfig("PREV_RESTARTED_APP", "FALSE") 	--读取之后重置
		return true
	else
		return false
	end
end

--保存当前log状态
function setWriteLogStatus(status)
	local tmp = "FALSE"
	if status == true then
		tmp = "TRUE"
	end
	
	setStringConfig("PREV_WRITE_LOG_STATUS", tmp)
end

--获取上一次log状态
function getPrevWriteLogStatus()
	local status = getStringConfig("PREV_WRITE_LOG_STATUS", "FALSE")
	if status == "TRUE" then
		return true
	end
	
	return false
end

--保存当前缓存状态
function setCacheStatus(status)
	local tmp = "FALSE"
	if status == true then
		tmp = "TRUE"
	end
	
	setStringConfig("PREV_CACHE_STATUS", tmp)
end

--获取上一次缓存状态
function getPrevCacheStatus()
	local status = getStringConfig("PREV_CACHE_STATUS", "FALSE")
	if status == "TRUE" then
		return true
	end
	
	return false
end

--重启
local function restart(errMsg)
	if USER.RESTART_APP or USER.RESTART_SCRIPT then	--允许重启
		if USER.RESTART_APP then			--激进模式，APP和script同时重启
			if PREV.restartedAPP then
				Log("重启阶段三：\n已重启过APP，未能解决，即将退出!")
				dialog("重启阶段三：\n已重启过APP，未能解决，即将退出!")
				xmod.exit()
			end
			if PREV.restartedScript then	--已单独重启过脚本
				local snapshotTime = os.date("%Y_%m_%d_%H_%M_%S", os.time())
				if CFG.LOG then
					screen.snapshot(xmod.getPublicPath().."/"..snapshotTime..".jpg")
				end
				Log("重启阶段二：\n已尝试过单独重启脚本，未能解决，即将重启应用和脚本！\n日志截图:"..snapshotTime..".jpg")
				dialog("重启阶段二：\n已尝试过单独重启脚本，未能解决，即将重启应用和脚本！", 3)
				if xmod.PROCESS_MODE == xmod.PROCESS_MODE_STANDALONE then	--极客模式需要重启应用
					Log("close app: "..CFG.APP_ID)
					runtime.killApp(CFG.APP_ID);
					sleep(1000)
					Log("restart app: "..CFG.APP_ID)
					runtime.launchApp(CFG.APP_ID)
					
					--记录重启状态，重启之后会直接读取上一次保存的设置信息和相关变量，并不会弹出UI以实现自动续接任务
					local startTime = os.time()
					while true do
						if runtime.getForegroundApp() == CFG.APP_ID then	--重启应用成功
							Log("restart app success!")
							sleep(CFG.WAIT_RESTART * 1000)
							break
						end
						
						if os.time() - startTime > CFG.DEFAULT_TIMEOUT then
							dialog("重启失败，即将退出")
							xmod.exit()
						end
					end
					setRestartedAPP()
					setRestartedScript()
					Log("restart script")
					xmod.restart()
				else		--通用模式只需关闭应用，会自动重启应用和脚本
					Log("restart app & script")
					setRestartedAPP()
					setRestartedScript()
					runtime.killApp(CFG.APP_ID);	--沙盒模式下，killApp会强行结束掉脚本，因此不能在此后做任何操作，延时放到重启中
				end
			else
				Log("重启阶段一：\n即将重启脚本")
				dialog("重启阶段一：\n即将重启脚本", 3)
				setRestartedScript()
				xmod.restart()
			end
		elseif USER.RESTART_SCRIPT	then	--安全模式，仅允许重启script
			if PREV.restartedScript then	--已重启过脚本
				Log("重启阶段二：\n已重启过脚本，仍未解决，即将退出!")
				dialog("重启阶段二：\n已重启过脚本，仍未解决，即将退出!")
				xmod.exit()
			end
			
			setRestartedScript()
			xmod.restart(errMsg)
		end
	else	--不允许重启直接退出
		dialog(errMsg.."\r\n等待超时，即将退出")
		Log("!!!not allow restart, script will exit later!!!")
		xmod.exit()
	end	
end

--捕获捕获处理函数
function catchError(errType, errMsg, forceContinueFlag)
	local etype = errType or ERR_UNKOWN
	local emsg = errMsg or "some error"
	
	--打印错误类型和具体信息
	if etype == ERR_MAIN or etype == ERR_TASK_ABORT then
		Log("CORE ERR------->> "..emsg)
	elseif etype == ERR_NORMAL then
		Log("NORMAL ERR------->> "..emsg)
	elseif etype == ERR_FILE then
		Log("FILE ERR------->> "..emsg)
	elseif etype == ERR_PARAM then
		Log("PARAM ERR------->> "..emsg)
	elseif etype == ERR_TIMEOUT then
		Log("TIME OUT ERR------->> "..emsg)
	elseif etype == ERR_WARNING then
		Log("WARNING ERR------->> "..emsg)
	else
		Log("UNKOWN ERR------->> "..emsg)
	end
	
	Log("\n--------------interrupt at time-------------->> "..os.date("%Y-%m-%d %H:%M:%S", os.time()).."\n")
	
	--强制忽略错误处理
	if forceContinueFlag then
		Log("WARNING:  ------!!!!!!!!!! FORCE CONTINUE !!!!!!!!!!------")
		return
	end
	
	--错误处理模块
	if etype == ERR_MAIN or etype == ERR_TASK_ABORT then	--核心错误仅允许exit
		dialog(emsg.."\r\n即将退出")
		Log("!!!cant recover task, program will end now!!!")
		xmod.exit()
	elseif etype == ERR_FILE or etype == ERR_PARAM then	--关键错误仅允许exit
		dialog(emsg.."\r\n即将退出")
		Log("!!!cant recover task, program will endlater!!!")
		xmod.exit()
	elseif etype == ERR_WARNING then		--警告任何时候只提示
		Log("!!!maybe some err in here, care it!!!")
	elseif etype == ERR_TIMEOUT then		--超时错误允许exit，restart
		if runtime.isAppRunning(CFG.APP_ID) then
			Log("TIME OUT BUT APP STILL RUNNING！")
			if runtime.getForegroundApp() == CFG.APP_ID then
				Log("STILL Foreground")
			else
				Log("NOT Foreground yet")
			end
		else
			Log("TIME OUT AND APP NOT RUNNING YET！")
		end
		
		restart(emsg)
	else
		Log("some err in task\r\n -----!!!program will exit later!!!-----")
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

function tapCenter()
	local d = CFG.DEFAULT_TAP_TIME
	local x = CFG.DEV_RESOLUTION.width / 2
	local y = CFG.DEV_RESOLUTION.height / 2
	
	touch.down(1, x, y)
	sleep(d)
	touch.up(1, x, y)
	
	Log("Tap Center at------ x:"..x.." y:"..y)
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
function slide(x1, y1, x2, y2, moveStep, moveInterval)
	local step = moveStep or CFG.TOUCH_MOVE_STEP
	local interval = moveInterval or 50
	if x1 ~= x2 then	--非竖直滑动
		--将x,y移动距离按移动步长CFG.TOUCH_MOVE_STEP分解为步数
		local stepX = x2 > x1 and step or -step
		local stepY = (y2 - y1) / math.abs((x2 - x1) / stepX)
		--Log("x1="..x1.." y1="..y1.." x2="..x2.." y2="..y2)
		
		touch.down(1, x1, y1)
		sleep(200)
		for i = 1, math.abs((x2 - x1) / stepX), 1 do
			touch.move(1, x1 + i * stepX, y1 + i * stepY)
			sleep(interval)
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
			sleep(interval)
		end
		touch.move(1, x2, y2)
		sleep(50)
		touch.up(1, x2, y2)
	end
end

function ratioSlide(x1, y1, x2, y2, moveStep, moveInterval)
	srcX, srcY = scale.getRatioPoint(x1, y1)
	dstX, dstY = scale.getRatioPoint(x2, y2)
	slide(srcX, srcY, dstX, dstY, moveStep, moveInterval)
end

function resetTaskData()
	lastPlayingPageTime = 0
	lastPenaltyPageTime = 0
	isPlayerRedCard = false
	
end

function resetPrevStatus()
	PREV.restartedAPP = false
	PREV.restartedScript = false
end


function execCommonWidgetQueue(list)
	local startTime = os.time()
	while true do
		for k, v in pairs(list) do
			if type(v) == "table" then
				if page.isExsitCommonWidget(v[1]) then
					Log("execCommonWidgetQueue: "..v[1])
					page.tapCommonWidget(v[1], v[2])
					sleep(800)
					if k == #list then
						return true
					end
					break
				end
			else
				if page.isExsitCommonWidget(v) then
					Log("execCommonWidgetQueue: "..v)
					page.tapCommonWidget(v)
					sleep(800)
					prt(k..#list)
					prt(list)
					if k == #list then
						return true
					end
					break
				end
			end
		end
		
		if os.time() - startTime > CFG.DEFAULT_TIMEOUT then
			catchError(ERR_TIMEOUT, 
				"time out in execCommonWidgetQueue:"..(type(list[1]) == "string" and list[1] or list[1][1]))
		end
		
		sleep(200)
	end
	
	return false
end

function execPageWidgetQueue(list)
	local startTime = os.time()
	while true do
		for k, v in pairs(list) do
			if page.matchWidget(v[1], v[2]) then
				Log("execPageWidgetQueue: "..v[1].."-"..v[2])
				page.tapWidget(v[1], v[2])
				sleep(800)
				
				if k == #list then
					return true
				end
				break
			end
		end
		
		if os.time() - startTime > CFG.DEFAULT_TIMEOUT then
			catchError(ERR_TIMEOUT, "time out in execPageWidgetQueue:"..list[1][1]..list[1][2])
		end
		
		sleep(200)
	end
	
	return false
end

function execNavigationQueue(list)
	local startTime = os.time()
	while true do
		for k, v in pairs(list) do
			if page.isExsitNavigation(v) then
				Log("execNavigationQueue: "..v)
				page.tapNavigation(v)
				
				--兼容红手指教练续约时的判定，点击第一个确定后，直接识别到了过渡期间的notice
				if xmod.PLATFORM == xmod.PLATFORM_ANDROID and xmod.PROCESS_MODE == xmod.PROCESS_MODE_STANDALONE then
					sleep(1200)
				else
					sleep(800)
				end
				
				if k == #list then
					return true
				end
				break
			end
		end
		
		if os.time() - startTime > CFG.DEFAULT_TIMEOUT then
			catchError(ERR_TIMEOUT, "time out in execNavigationQueue:"..list[1])
		end
		
		sleep(200)
	end
	
	return false
end

local function saveBulletinIndex(title)
	setStringConfig("BULLETIN_INDEX", title)
end

local function getLastBulletinIndex()
	return getStringConfig("BULLETIN_INDEX", "NULL")
end

--解析公告，每个Index的公告只展示一次，由getLastBulletinIndex控制
function parseBulletin(content)
	local i, j, index = string.find(content, "-index%-(%d+)%-")
	if i == nil or j == nil or index == nil then	--未找到Idnex
		Log("cant find index!")
		return nil, nil, false
	end
	
	if index == getLastBulletinIndex() then	--此条公告已经播报过
		Log("showed bulletin yet!")
		return
	end
	
	local m, n = string.find(content, "%-include%-[%d%-]*"..CFG.ScriptInfo.id.."%-")
	if m == nil and n == nil then					--当前脚本不在公告列表
		Log("not include current script!")
		return nil, nil, false
	end
	
	local m, n = string.find(content, "%-include[%d%-]*%-")
	if m == nil or n == nil then					--清理正文
		n = j
	end
	
	local body = string.sub(content, n + 1, -1)
	
	saveBulletinIndex(index)
	
	Log("parseBulletin: index-"..index.."  body-"..body)
	return index, body, true
end
