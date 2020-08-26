-- login.lua
-- Author: cndy1860
-- Date: 2019-07-25
-- Descrip: 在线验证
if PREV.restarted then return end
require("zui/Z_ui")
local json = require("Zlibs/class/Json")
local exstring = require("Zlibs/class/string")


----------------------------------UI-----------------------------
local DevScreen={--开发设备的参数
	Width=CFG.DEV_RESOLUTION.width,--注意Width要大于Height
	Height=CFG.DEV_RESOLUTION.height, --注意Width要大于Height
}

---------激活授权---------
local activateUI=ZUI:new(DevScreen,{align="left",w=90,h=90,size=40,cancelname="取消",okname="激活",countdown=0,config="zui.dat",bg="bk.png"})
local pageActivate = Page:new(activateUI,{text = "默认", size = 24, align="center"})
pageActivate:addLabel({text="当前用户：",size=25,w=14,color="25,25,112",align="left"})
pageActivate:addLabel({text=getStringConfig("UID", "NULL"),size=25,color="0,201,87",align="left"})
pageActivate:nextLine()
pageActivate:nextLine()
pageActivate:nextLine()
pageActivate:nextLine()
pageActivate:nextLine()
pageActivate:addLabel({text="请输入激活码",w=90,h=20,align="center",color="25,25,112",size=40})
pageActivate:nextLine()
pageActivate:addLabel({text="",w=15,h=20,align="center",size=30})
pageActivate:addEdit({id="editerActivate",color="255,0,0",w=60,h=15,align="center",size=30})

local activateUIData = {}
local function showActivateUI()
	activateUIData = {}
	local uiRet = activateUI:show(3)
	if uiRet._cancel then
		xmod.exit()
	end
	
	activateUIData.cdkey = string.upper(exstring.trim(tostring(uiRet.editerActivate)))
end

---------登录账户---------
local loginUI=ZUI:new(DevScreen,{align="left",w=90,h=90,size=40,cancelname="取消",okname="登录",countdown=0,config="zui.dat",bg="bk.png"})
local pageLogin = Page:new(loginUI,{text = "登录", size = 24, align="center"})
pageLogin:nextLine()
pageLogin:nextLine()
pageLogin:nextLine()
pageLogin:addLabel({text="用户登录",w=90,h=20,color="25,25,112",align="center",size=40})
pageLogin:nextLine()
pageLogin:addLabel({text="",w=15,h=20,align="center",size=28})
pageLogin:addLabel({text="用户名",w=10,h=20,align="center",size=28})
pageLogin:addEdit({id="editerUid",color="0,0,255",w=40,h=15,align="left",size=26})
pageLogin:nextLine()
pageLogin:addLabel({text="",w=15,h=20,align="center",size=28})
pageLogin:addLabel({text="密  码",w=10,h=20,align="center",size=28})
pageLogin:addEdit({id="editerPwd",color="0,0,255",w=40,h=15,align="left",size=26})

local loginUIData = {}
local function showLoginUI()
	while true do
		loginUIData = {}
		local uiRet = loginUI:show(3)
		if uiRet._cancel then
			xmod.exit()
		end
		loginUIData.UID = string.lower(exstring.trim(tostring(uiRet.editerUid)))
		loginUIData.pwd = exstring.trim(tostring(uiRet.editerPwd))
		
		if string.len(loginUIData.UID) < 6 or string.len(loginUIData.pwd) < 6 then
			dialog("用户名和密码不能小6位！")
		elseif exstring.utf8len(loginUIData.UID) ~= string.len(loginUIData.UID)
		or exstring.utf8len(loginUIData.pwd) ~= string.len(loginUIData.pwd) then
			dialog("不能使用中文！")
		else
			break
		end
	end
end

---------注册账户---------
local registUI=ZUI:new(DevScreen,{align="left",w=90,h=90,size=40,cancelname="取消",okname="注册",countdown=0,config="zui.dat",bg="bk.png"})
local pageRegist = Page:new(registUI,{text = "默认", size = 24, align="center"})
pageRegist:addLabel({text="当前版本：",size=25,w=14,color="25,25,112",align="right"})
pageRegist:addLabel({text=CFG.VERSION,size=25,color="0,201,87",align="left"})
pageRegist:nextLine()
pageRegist:nextLine()
pageRegist:addLabel({text="注册账号",w=90,h=20,color="25,25,112",align="center",size=40})
pageRegist:nextLine()
pageRegist:addLabel({text="",w=15,h=20,align="center",size=28})
pageRegist:addLabel({text="用户名",w=10,h=20,align="center",size=28})
pageRegist:addEdit({id="editerRegistUid",color="0,0,255",w=40,h=15,align="left",size=26})
pageRegist:nextLine()
pageRegist:addLabel({text="",w=15,h=20,align="center",size=28})
pageRegist:addLabel({text="密  码",w=10,h=20,align="center",size=28})
pageRegist:addEdit({id="editerRegistPwd",color="0,0,255",w=40,h=15,align="left",size=26})
pageRegist:nextLine()
pageRegist:addLabel({text="",w=15,h=20,align="center",size=28})
pageRegist:addLabel({text="推荐人",w=10,h=20,align="center",size=28})
pageRegist:addEdit({id="editerRegistAgent",color="0,0,255",w=40,h=15,align="left",size=26})

local registUIData = {}
local function showRegistUI()
	while true do
		registUIData = {}
		local uiRet = registUI:show(3)
		if uiRet._cancel then
			xmod.exit()
		end
		registUIData.UID = string.lower(exstring.trim(tostring(uiRet.editerRegistUid), "[%s\n]"))
		registUIData.pwd = exstring.trim(tostring(uiRet.editerRegistPwd), "[%s\n]")
		registUIData.agent = string.lower(exstring.trim(tostring(uiRet.editerRegistAgent), "[%s\n]"))
		if string.len(registUIData.UID) < 6 or string.len(registUIData.pwd) < 6 then
			dialog("用户名和密码不能小6位！")
		elseif exstring.utf8len(registUIData.UID) ~= string.len(registUIData.UID)
		or exstring.utf8len(registUIData.pwd) ~= string.len(registUIData.pwd)
		or exstring.utf8len(registUIData.agent) ~= string.len(registUIData.agent) then
			dialog("不能使用中文！")
		else
			break
		end
	end
end

----------------------------------UI-----------------------------

--保存用户ID
function setUID(UID)
	return setStringConfig("UID", UID)
end

--获取用户ID
function getUID()
	return getStringConfig("UID", "NULL")
end

--保存用户密码
local function setPwd(pwd)
	return setStringConfig("PWD", pwd)
end

--获取用户密码
local function getPwd()
	return getStringConfig("PWD", "NULL")
end

--保存登陆码
local function setToken(code)
	setStringConfig("TOKEN", code)
end

--获取用户ID登陆码
local function getToken()
	return getStringConfig("TOKEN", "NULL")
end

--保存登录时间
local function setLogonDate()
	setStringConfig("LOGON_DATE", os.time())
end

--获取上一次登录时间
local function getLogonDate()
	return getStringConfig("LOGON_DATE", "NULL")
end

--保存action
function setAction(action)
	setStringConfig("ACTION", action)
end

--获取action
function getAction()
	local act = getStringConfig("ACTION", "login")
	if act ~= "login" then
		setStringConfig("ACTION", "login")
	end
	
	return act
end

--获取本地公告版本号
local function getBulletinVersion()
	return getStringConfig("BULLETIN_VERSION", "NULL")
end

--保存本地公告版本号
function setBulletinVersion(ver)
	setStringConfig("BULLETIN_VERSION", ver)
end

--心跳包
local  heartBeatFaildTimes = 0
function onlineHeartBeat()
	local send = {}
	
	send.ReqType = "heartBeat"
	send.UID = loginUIData.UID or getUID()
	send.DeviceID = getDeviceIMEI()..getDeviceIMSI()
	send.ScriptName = CFG.SCRIPT_ID
	send.Token = getToken()
	send.ReqTime = tostring(os.time())
	
	local http = require("Zlibs/class/Http")
	local rspData = http.Post.tableByJson(CFG.HOST, send)
	if rspData == "" then
		--dialog("链接到服务器出错！")
		heartBeatFaildTimes = heartBeatFaildTimes + 1
		if heartBeatFaildTimes >= 3 then		--连续3次链接失败则视为心跳失败
			dialog("认证失败，请重新登录！")
			setAction("login")
			lua_restart()
		end
		
		return true
	else
		heartBeatFaildTimes = 0		--只要成功链接就清零
	end
	
	Log("heart beat recv:"..rspData)
	
	local recv = json.decode(rspData)
	--[[recv = {
	RspType,
	UID,
	RspTime,
	RspCode
	RspMsg,
	}]]
	--prt(recv)
	if recv.RspType ~= send.ReqType or recv.UID ~= send.UID then
		dialog("认证失败，请重新登录！")
		setAction("loginUI")
		lua_restart()
	end
	
	if recv.RspCode ~= "success" then
		if recv.RspCode == "err_relogin" then
			dialog(recv.RspMsg or "重复登录，请重新登录！")
			setUID("NULL")
			setAction("loginUI")
			lua_restart()
		elseif recv.RspCode == "err_expired" then
			dialog(recv.RspMsg or "授权已过期，请重新使用激活码激活！")
			setAction("activateUI")
			lua_restart()
		else
			dialog("认证失败，请重新登录！\r\n"..recv.RspMsg)
			setAction("loginUI")
			lua_restart()
		end
		
		return false
	end
	
	Log("心跳成功")
	return true
end

--在线登录
local function onlineLogin()
	local send = {}
	
	send.ReqType = "login"
	send.UID = loginUIData.UID or getUID()
	send.Pwd = loginUIData.pwd or getPwd()
	
	send.DeviceID = getDeviceIMEI()..getDeviceIMSI()
	send.ScriptName = CFG.SCRIPT_ID
	send.ScriptVersion = CFG.VERSION
	send.Token = getToken()
	send.BulletinVersion = getBulletinVersion()
	send.ReqTime = tostring(os.time())
	
	local http = require("Zlibs/class/Http")
	local rspData = http.Post.tableByJson(CFG.HOST, send)
	if rspData == "" then
		dialog("链接到服务器出错！")
		return "loginUI"
	end
	
	Log("login recv:"..rspData)
	
	local recv = json.decode(rspData)
	--[[recv = {
	RspType,
	UID,
	RspTime,
	RspCode
	RspMsg,
	Token,
	LicenseType,
	LicenseRemaining,
	BulletinVersion,
	Bulletin,
	}]]
	--prt(recv)
	if recv.RspType ~= send.ReqType then
		dialog("返回数据校验失败！")
		return "loginUI"
	end
	
	if recv.UID ~= send.UID then
		dialog("账户校验失败！")
		return "loginUI"
	end
	
	if math.abs(tonumber(recv.RspTime) - os.time()) > 60 * 30 then		--服务器时间与本地相差不超过30分钟
		dialog("本地时间和服务器时间不符，请同步本地时间！")
		return "exit"
	end
	
	if loginUIData.UID and loginUIData.pwd then 	--更新输入的用户信息
		setUID(loginUIData.UID)
		setPwd(loginUIData.pwd)
		setAction("loginUI")		--还未验证通过前终止，返回loginUI
	end
	
	if recv.RspCode ~= "success" then
		Log("recv.RspCode="..recv.RspCode)
		if string.find(recv.RspCode, "err_uid") then
			local ret = dialogRet(recv.RspMsg, "重新登录", "注册账号", "", 0)
			if ret == 0 then
				return "loginUI"
			elseif ret == 1 then
				return "registUI"
			end
		elseif recv.RspCode == "err_version_unkown" or  recv.RspCode == "err_version_update" then
			dialog(recv.RspMsg)
			return "exit"
		elseif recv.RspCode == "err_auth_unkown" or recv.RspCode == "err_expired" then
			local ret = dialogRet(recv.RspMsg, "使用激活码激活", "登录其他账号", "", 0)
			if ret == 0 then
				return "activateUI"
			elseif ret == 1 then
				return "loginUI"
			end
		elseif string.find(recv.RspCode, "err_db") then
			dialog("数据库错误！\r\n"..recv.RspMsg)
			return "exit"
		else
			dialog(recv.RspMsg)
			return "exit"
		end
	end
	
	if recv.LicenseType == "trial" or recv.LicenseType == "day" or recv.LicenseType == "week" then
		if tonumber(recv.LicenseRemaining) < 60 * 60 then
			dialog("授权即将结束，请尽快购买激活码激活！", 5)
		end
	elseif recv.LicenseType == "month" or recv.LicenseType == "sezon" or recv.LicenseType == "year" then
		if tonumber(recv.LicenseRemaining) < 24 * 60 * 60 then
			dialog("授权即将结束，请尽快购买激活码激活！", 5)
		end
	end
	
	if recv.Token then		--更新Token
		setToken(recv.Token)
		setLogonDate()
	end
	
	remainingSec = tonumber(recv.LicenseRemaining)
	userId = recv.UID
	
	if recv.BulletinVersion and recv.Bulletin then
		dialog(recv.Bulletin)
		setBulletinVersion(recv.BulletinVersion)
		print(recv.BulletinVersion)
	end
	
	return "authorized"
end

local function onlineRegist()
	if not registUIData.UID or not registUIData.pwd then
		dialog("输入的注册账号信息异常！")
		return "registUI"
	end
	
	local send = {}
	
	send.ReqType= "regist"
	send.UID = registUIData.UID
	send.Pwd = registUIData.pwd
	send.DeviceID = getDeviceIMEI()..getDeviceIMSI()
	send.ScriptName = CFG.SCRIPT_ID
	send.Recommended = registUIData.agent or "NULL"
	send.ReqTime = tostring(os.time())
	
	local http = require("Zlibs/class/Http")
	local rspData = http.Post.tableByJson(CFG.HOST, send)
	if rspData == "" then
		dialog("链接到服务器出错！")
		return "registUI"
	end
	
	local recv = json.decode(rspData)
	--[[recv = {
	RspType,
	UID,
	RspTime,
	RspCode
	RspMsg,
	}]]
	
	if recv.RspType ~= send.ReqType then
		dialog("返回数据校验失败！")
		return "exit"
	end
	
	if recv.UID ~= send.UID then
		dialog("账户校验失败！")
		return "exit"
	end
	
	if math.abs(tonumber(recv.RspTime) - os.time()) > 60 * 30 then		--服务器时间与本地相差不超过30分钟
		dialog("本地时间和服务器时间不符，请同步本地时间！")
		return "exit"
	end
	
	if recv.RspCode ~= "success" then
		Log("recv.RspCode="..recv.RspCode)
		if recv.RspCode == "err_uid_existed" then
			dialog(recv.RspMsg)
			return "registUI"
		elseif string.find(recv.RspCode, "err_db") then
			dialog("数据库错误！\r\n"..recv.RspMsg)
			return "exit"
		elseif string.find(recv.RspCode, "err_time") then
			dialog(recv.RspMsg)
			return "exit"
		else
			local ret = dialogRet(recv.RspMsg, "重新注册", "登录其他账号", "退出", 0)
			if ret == 0 then
				return "registUI"
			elseif ret == 1 then
				return "loginUI"
			elseif ret == 2 then
				return "exit"
			end
		end
	end
	
	dialog("恭喜，注册成功！")
	setUID(registUIData.UID)
	setPwd(registUIData.pwd)
	
	return "login"
end

local function onlineActivate()
	if not activateUIData.cdkey or activateUIData.cdkey == "NULL" then
		dialog("输入的激活码异常！")
		return "activateUI"
	end
	
	local send = {}
	
	send.ReqType = "activate"
	send.UID = getUID()
	send.Pwd = getPwd()
	send.DeviceID = getDeviceIMEI()..getDeviceIMSI()
	send.ScriptName = CFG.SCRIPT_ID
	send.ReqTime = tostring(os.time())
	send.Cdkey = activateUIData.cdkey
	
	local http = require("Zlibs/class/Http")
	local rspData = http.Post.tableByJson(CFG.HOST, send)
	if rspData == "" then
		dialog("链接到服务器出错！")
		return "activateUI"
	end
	
	local recv = json.decode(rspData)
	--[[recv = {
	RspType,
	UID,
	RspTime,
	RspCode
	RspMsg,
	Token,
	LicenseType,
	LicenseRemaining,
	}]]
	
	if recv.RspType ~= send.ReqType then
		dialog("返回数据校验失败！")
		return "exit"
	end
	
	if recv.UID ~= send.UID then
		dialog("账户校验失败！")
		return "exit"
	end
	
	if math.abs(tonumber(recv.RspTime) - os.time()) > 60 * 30 then		--服务器时间与本地相差不超过30分钟
		dialog("本地时间和服务器时间不符，请同步本地时间！")
		return "exit"
	end
	
	if recv.RspCode ~= "success" then
		Log("recv.RspCode="..recv.RspCode)
		if string.find(recv.RspCode, "err_uid") then
			dialog(recv.RspMsg)
			return "loginUI"
		elseif string.find(recv.RspCode, "err_cdkey") then
			dialog(recv.RspMsg)
			return "activateUI"
		elseif string.find(recv.RspCode, "err_db") then
			dialog("数据库错误！\r\n"..recv.RspMsg)
			return "exit"
		else
			dialog(recv.RspMsg)
			return "exit"
		end
	end
	
	dialog("恭喜，激活成功!")
	
	return "login"
end

function login()
	local action = getAction()
	Log("action="..action)
	
	if getUID() == "NULL" or getPwd() == "NULL" then		--检测账户信息是否存在
		Log("not exsit user info!")
		local ret = dialogRet("欢迎使用萝卜脚本！", "登录账号", "注册账号", "", 0)
		if ret == 0 then
			action = "loginUI"
		elseif ret == 1 then
			action = "registUI"
		end
	elseif getToken() == "NULL" or getLogonDate() == "NULL" then		--检测登录码是否存在
		Log("not exsit Token or logonDate!")
		action = "loginUI"
	elseif math.abs(os.time() - tonumber(getLogonDate())) > 30 * 24 * 60 * 60 then		--检测登录码是否过期
		Log("Logged expired!")
		action = "loginUI"
	end
	
	while true do
		if action == "loginUI" then
			showLoginUI()
			action = "login"
		elseif action == "login" then
			action = onlineLogin()
		elseif action == "registUI" then
			showRegistUI()
			action = "regist"
		elseif action == "regist" then
			action = onlineRegist()
		elseif action == "activateUI" then
			showActivateUI()
			action = "activate"
		elseif action == "activate" then
			action = onlineActivate()
		elseif action == "exit" then
			lua_exit()
		elseif action == "authorized" then
			break
		end
	end
	
	setAction("login")
	Log("login success!")
end

--setUID("NULL")
--setPwd("NULL")
--setToken("NULL")
--setLogonDate()
--setBulletinVersion("NULL")
--setBulletinVersion("NULL")

if not CFG.DEBUG then
	login()
else
	Log("DEBUG MODE!")
end




