-- func.lua
-- Author: cndy1860
-- Date: 2018-12-25
-- Descrip: 功能函数

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
		if CFG.ALLOW_RESTART == true then	--允许重启
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
				task.setCurrentTaskStatus("restart")
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
end

--通过传入点的比例点击
function ratioTap(x, y, delay)
	local d = delay or CFG.DEFAULT_TAP_TIME
	if x == nil or y == nil then
		catchError(ERR_PARAM, "nil x y in proportionallyTap")
	end
	local x1, y1 = scale.getRatioPoint(x, y)
	Log("````````"..x1.."  "..y1)
	
	touch.down(1, x1, y1)
	sleep(d)
	touch.up(1, x1, y1)
end