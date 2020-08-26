require("zui/Z_ui")

--if not CFG.COMPATIBLE then
--	return
--end


--功能字符串，--只允许whiteList的功能出现
local funcStr = ""
--[[for _, v in pairs(CFG.SCRIPT_FUNC.funcList) do
	local limit = false
	for _, _v in pairs(CFG.SCRIPT_FUNC.whiteList) do
		if _v.scriptid == CFG.ScriptInfo.id and #_v.func > 0 then
			limit = true
			for _, __v in pairs(_v.func) do
				if __v == v then
					limit = false
					break
				end
			end
			break
		end
	end
	if not limit then
		funcStr = funcStr..v..","
	end
end
if funcStr ~= "" then
	funcStr = string.sub(funcStr, 1, -2)
end]]

if frontAppName() == "jp.konami.pesam" then
	local intStr = ""
	for _, v in pairs(CFG.SCRIPT_FUNC.funcList) do
		if string.find(v, "国际服") then
			intStr = intStr..v..","
		else
			funcStr = funcStr..v..","
		end
	end
	funcStr = intStr..funcStr
else
	for _, v in pairs(CFG.SCRIPT_FUNC.funcList) do
		funcStr = funcStr..v..","
	end
end

if funcStr ~= "" then
	funcStr = string.sub(funcStr, 1, -2)
end

local feildPositionStr = "不换,位置1,位置2,位置3,位置4,位置5,位置6,位置7,位置8,位置9,位置10,位置11"
local feildPositionSubstituteCondition = "主力红才换,好一档就换,好两档才换"


local DevScreen={--开发设备的参数
	Width=CFG.DEV_RESOLUTION.width,--注意Width要大于Height,开发机分辨率是啥就填啥
	Height=CFG.DEV_RESOLUTION.height, --注意Width要大于Height,开发机分辨率是啥就填啥
}

local myui=ZUI:new(DevScreen,{align="left",w=90,h=90,size=40,cancelname="取消",okname="OK",countdown=(PREV.restarted == true and 3 or 0),config="zui.dat",bg="bk.png"})--在page中传入的size会成为所有page中所有控件的默认字体大小,同时也会成为所有page控件的最小行距
local pageBaseSet = Page:new(myui,{text = "基本设置", size = 24})
--[[local dispStr =  "欢迎使用"..CFG.SCRIPT_NAME
for _, v in pairs(CFG.SCRIPT_FUNC.whiteList) do 
	if v.scriptid == CFG.ScriptInfo.id then
		dispStr = dispStr.."-"..v.distributions
		break
	end
end]]
pageBaseSet:addLabel({text=dispStr,size=18,w=90,align="center"})

--pageBaseSet:nextLine()
pageBaseSet:nextLine()
pageBaseSet:addLabel({text="任务选择",size=32})
pageBaseSet:addComboBox({id="comboBoxTask",list = funcStr,select=0,w=40,h=12, size = 30})

pageBaseSet:nextLine()
pageBaseSet:nextLine()
pageBaseSet:addLabel({text="通用功能",size=30})
pageBaseSet:addCheckBoxGroup({id="checkBoxFunc", list = "开场换人,自动续约",select="1",w=80,h=12,size=30})

pageBaseSet:nextLine()
pageBaseSet:addLabel({text="自动重启",size=30})
pageBaseSet:addRadioGroup({id="radioRestart",list="开启,关闭",select=0,w=80,h=12,size=30})

pageBaseSet:nextLine()
pageBaseSet:addLabel({text="循环场数",size=30})
pageBaseSet:addEdit({id="editerCircleTimes",prompt="提示文本1",text=tostring(CFG.DEFAULT_REPEAT_TIMES),color="0,0,255",w=30,h=10,align="right",size=24})



local pageSubstituteSet = Page:new(myui,{text = "换人设置",size = 24})
--pageSubstituteSet:addLabel({text="    替补席按从上到下分别编号为1-7号位，球场上11个球员按从上到下，从左到右为1-11号为，可",size=15})
pageSubstituteSet:nextLine()
pageSubstituteSet:nextLine()
pageSubstituteSet:addLabel({text="替补1 ->",size=32})
pageSubstituteSet:addComboBox({id="comboBoxBench1",list=feildPositionStr,select=0,w=17,h=10, size = 18})
pageSubstituteSet:addLabel({text=" ",size=24})
pageSubstituteSet:addComboBox({id="comboBoxBenchCondition1",list=feildPositionSubstituteCondition,select=0,w=24,h=10, size = 18})
pageSubstituteSet:addLabel({text="                  换人说明",size=24})
pageSubstituteSet:nextLine()
pageSubstituteSet:addLabel({text="替补2 ->",size=32})
pageSubstituteSet:addComboBox({id="comboBoxBench2",list=feildPositionStr,select=0,w=17,h=10, size = 18})
pageSubstituteSet:addLabel({text=" ",size=24})
pageSubstituteSet:addComboBox({id="comboBoxBenchCondition2",list=feildPositionSubstituteCondition,select=0,w=24,h=10, size = 18})
pageSubstituteSet:addLabel({text="            对位换人，替补席从上到下",size=20})
pageSubstituteSet:nextLine()
pageSubstituteSet:addLabel({text="替补3 ->",size=32})
pageSubstituteSet:addComboBox({id="comboBoxBench3",list=feildPositionStr,select=0,w=17,h=10, size = 18})
pageSubstituteSet:addLabel({text=" ",size=24})
pageSubstituteSet:addComboBox({id="comboBoxBenchCondition3",list=feildPositionSubstituteCondition,select=0,w=24,h=10, size = 18})
pageSubstituteSet:addLabel({text="        依次为替补1-7号，场上球员严",size=20})
pageSubstituteSet:nextLine()
pageSubstituteSet:addLabel({text="替补4 ->",size=32})
pageSubstituteSet:addComboBox({id="comboBoxBench4",list=feildPositionStr,select=0,w=17,h=10, size = 18})
pageSubstituteSet:addLabel({text=" ",size=24})
pageSubstituteSet:addComboBox({id="comboBoxBenchCondition4",list=feildPositionSubstituteCondition,select=0,w=24,h=10, size = 18})
pageSubstituteSet:addLabel({text="        格按照从左到右（请参考编号",size=20})
pageSubstituteSet:nextLine()
pageSubstituteSet:addLabel({text="替补5 ->",size=32})
pageSubstituteSet:addComboBox({id="comboBoxBench5",list=feildPositionStr,select=0,w=17,h=10, size = 18})
pageSubstituteSet:addLabel({text=" ",size=24})
pageSubstituteSet:addComboBox({id="comboBoxBenchCondition5",list=feildPositionSubstituteCondition,select=0,w=24,h=10, size = 18})
pageSubstituteSet:addLabel({text="        图示），从上到下的顺序编为",size=20})
pageSubstituteSet:nextLine()
pageSubstituteSet:addLabel({text="替补6 ->",size=32})
pageSubstituteSet:addComboBox({id="comboBoxBench6",list=feildPositionStr,select=0,w=17,h=10, size = 18})
pageSubstituteSet:addLabel({text=" ",size=24})
pageSubstituteSet:addComboBox({id="comboBoxBenchCondition6",list=feildPositionSubstituteCondition,select=0,w=24,h=10, size = 18})
pageSubstituteSet:addLabel({text="        1-11号位置，自行对应，可设",size=20})
pageSubstituteSet:nextLine()
pageSubstituteSet:addLabel({text="替补7 ->",size=32})
pageSubstituteSet:addComboBox({id="comboBoxBench7",list=feildPositionStr,select=0,w=17,h=10, size = 18})
pageSubstituteSet:addLabel({text=" ",size=24})
pageSubstituteSet:addComboBox({id="comboBoxBenchCondition7",list=feildPositionSubstituteCondition,select=0,w=24,h=10, size = 18})
pageSubstituteSet:addLabel({text="        置每个位置的换人条件。",size=20})


local pageSubstitutePic = Page:new(myui,{text = "编号图示",size = 24})
pageSubstitutePic:addLabel({text="        ",size=20})
pageSubstitutePic:addImage({src="substitute.jpg",w=70,h=100,xpos=0,align="center"})


--[[local pageScout = Page:new(myui,{text = "筛选球探",size = 24})
pageScout:nextLine()
pageScout:nextLine()
pageScout:addLabel({text="        说明：一键卖球探请先选择“一键卖球探”任务，再根据自己的需要，选择售卖球员的组合",size=24})
pageScout:nextLine()
pageScout:addLabel({text="条件。为防止出错，建议每次只售卖一种星级的球探。",size=24})
pageScout:nextLine()
pageScout:nextLine()
pageScout:addLabel({text="球探星级  ",size=26})
pageScout:addCheckBoxGroup({id="checkBoxScoutStar", list = "一星,二星,三星,四星",select="0",w=80,h=12,size=20})
pageScout:nextLine()
pageScout:addLabel({text="球探特征  ",size=26})
pageScout:addCheckBoxGroup({id="checkBoxScoutFeature", list = "联赛,区域,位置,优异能力,擅长战术,年龄,身高,惯用脚",select="4",w=90,h=12,size=20})
]]


local pageProSet = Page:new(myui,{text = "高级设置",size = 24})
pageProSet:nextLine()
pageProSet:addLabel({text="    注：默认请保持本页选项关闭，缓存模式测试中，请谨慎使用！",size=22, color="255,0,0"})
pageProSet:nextLine()
pageProSet:addLabel({text="    本脚本提供了缓存模式的高级功能（默认关闭），即将所有匹配过的界面的数据缓存在本地，",size=22})
pageProSet:nextLine()
pageProSet:addLabel({text="用于提高页面匹配效率，能显著提升脚本运行速度，同时降低手机发热。如经常出现脚本停止或未知",size=22})
pageProSet:nextLine()
pageProSet:addLabel({text="问题请关闭此功能。",size=22})
pageProSet:nextLine()
pageProSet:addLabel({text="    安全重启是指在开启“自动重启”功能后，只会尝试重启脚本而不会重启游戏，国服天梯怕掉星的推",size=22})
pageProSet:nextLine()
pageProSet:addLabel({text="荐使用。",size=22})
pageProSet:nextLine()
pageProSet:addLabel({text="    日志功能只有当开发者需要调试错误时，主动让用户提供运行日志时才需要开启，开启时如果发生",size=22})
pageProSet:nextLine()
pageProSet:addLabel({text="了脚本或游戏自动重启，会进行截图以供BUG分析。",size=22})
pageProSet:nextLine()
pageProSet:nextLine()

pageProSet:addLabel({text="安全重启",size=30})
pageProSet:addRadioGroup({id="radioSafeRestart",list="关闭,开启",select=0,w=25,h=12})
pageProSet:nextLine()
pageProSet:addLabel({text="缓存模式",size=30})
pageProSet:addRadioGroup({id="radioCachingMode",list="关闭,开启",select=0,w=25,h=12})
pageProSet:nextLine()
pageProSet:addLabel({text="记录日志",size=30})
pageProSet:addRadioGroup({id="radioLog",list="关闭,开启",select=0,w=25,h=12})

--[[
local pageBuyCDKEY = Page:new(myui,{text = "脚本购买",size = 24})
pageBuyCDKEY:nextLine()
pageBuyCDKEY:addLabel({text="  收费标准(国服/国际服):日卡(新人进群免费送)、月卡30/20、年卡120/100、永久卡200/180",size=18, align="center"})
pageBuyCDKEY:nextLine()
pageBuyCDKEY:addLabel({text="  购买方式:",size=22, align="center"})
pageBuyCDKEY:nextLine()
pageBuyCDKEY:addLabel({text="      方式一，叉叉小精灵(群里的脚本文件)用户，直接点击右上角的“激活码”，然后根据情况选择在线支付(直接授",size=20, align="left"})
pageBuyCDKEY:nextLine()
pageBuyCDKEY:addLabel({text="      权无需激活码)，或购买激活码激活(“使用激活码”一栏下有激活码购买链接，本页面最下方也有购买链接)",size=20, align="left"})
pageBuyCDKEY:nextLine()
pageBuyCDKEY:addLabel({text="      方式二，叉叉助手用户，请直接使用叉叉助手购买，或购买激活码进行激活，购买链接同上",size=20, align="left"})
pageBuyCDKEY:nextLine()
pageBuyCDKEY:addLabel({text="      方式三，苹果IPA精灵用户，请直接使用IPA精灵购买，或购买激活码进行激活，购买链接同上",size=20, align="left"})
pageBuyCDKEY:nextLine()

pageBuyCDKEY:nextLine()
pageBuyCDKEY:nextLine()
pageBuyCDKEY:addLabel({text="      注意：购买激活码时请注意选择对应的版本！",size=20, align="left"})
pageBuyCDKEY:nextLine()
pageBuyCDKEY:addUrl({text="购买激活码",url="http://cndy1860.jslee.top/"})
pageBuyCDKEY:addLabel({text="  (链接 http://cndy1860.jslee.top/)",size=20, align="left"})
]]


local pageTestting = Page:new(myui,{text = "脚本说明",size = 24})
pageTestting:nextLine()
pageTestting:addLabel({text="    注意：本脚本旨在为实况手游爱好者提供简化操作，不提供任何修改、破解等违规功能，本脚本禁止任何盈利行",size=20, align="left", color="255,0,0"})
pageTestting:nextLine()
pageTestting:addLabel({text="    为，如有任何侵权或违规行为请及时联系作者删除。用户使用脚本产生的任何后果与作者无关。",size=20, align="left", color="255,0,0"})
pageTestting:nextLine()
pageTestting:addLabel({text="------------------------脚本特性说明------------------------",size=20, align="center"})
pageTestting:nextLine()
pageTestting:addLabel({text="    注:安卓10以上的系统有可能不能正常运行，请使用虚拟大师vmos之类的软件运行。",size=20, align="left"})
pageTestting:nextLine()
pageTestting:addLabel({text="    1.一定要原版背景才能使用，换了背景或者打了补丁会导致有些界面不能识别。",size=20, align="left"})
pageTestting:nextLine()
pageTestting:addLabel({text="    2.手动巡回赛只支持经典按键模式，不要选划屏模式，建议使用默认按键透明度。",size=20, align="left"})
pageTestting:nextLine()
pageTestting:addLabel({text="    3.开启脚本的小球请拖到【右边正中间】部分，或最好在设置里关闭'运行时仍显示悬浮窗'功能，避免干扰。",size=20, align="left"})
pageTestting:nextLine()
pageTestting:addLabel({text="    4.刘海屏不要留黑边，不要有导航栏，让游戏铺满整个屏幕。",size=20, align="left"})
pageTestting:nextLine()
pageTestting:addLabel({text="    5.HOME键(导航栏)放在右边，运行过程中不要让手机旋转方向。",size=20, align="left"})
pageTestting:nextLine()
pageTestting:addLabel({text="    6.脚本操作的过程中，尽量不要手动操作，或先使用音量键停止脚本运行后再行操作，操作完成后直接重开脚本。",size=20, align="left"})
pageTestting:nextLine()
pageTestting:addLabel({text="    7.按照稳定性，优先使用手机，其次是云手机，模拟器长时间运行崩溃(闪退)概率较高。",size=20, align="left"})
pageTestting:nextLine()
pageTestting:addLabel({text="    8.脚本自动重启是指在脚本或者游戏卡死的情况下将进行重启来继续任务，默认情况下，脚本提示超时后，会首",size=20, align="left"})
pageTestting:nextLine()
pageTestting:addLabel({text="      先重启脚本自身尝试解决问题，如果重启后依然超时，便会同时重启游戏和脚本(高级设置中的安全重启将限制",size=20, align="left"})
pageTestting:nextLine()
pageTestting:addLabel({text="      为只重启脚本而不重启游戏，国服天梯推荐)。重启功能仅安卓有效。",size=20, align="left"})
pageTestting:nextLine()
pageTestting:addLabel({text="    9.游戏不稳定可能会卡死(模拟器更不稳定)，别问为什么会卡死，绝大多数情况下开自动重启能自己解决。",size=20, align="left"})
pageTestting:nextLine()
pageTestting:addLabel({text="    10.打开时如提示'Message: Failed to open...'，请给应用开放存储权限。",size=20, align="left"})
pageTestting:nextLine()
pageTestting:nextLine()
pageTestting:addLabel({text="------------------------脚本功能说明------------------------",size=20, align="center"})
pageTestting:nextLine()
pageTestting:addLabel({text="    1.脚本是模拟点击，实现比赛的自动循环挂机，但脚本不是AI也不是外挂，不能手动天梯上分的。",size=20, align="left"})
pageTestting:nextLine()
pageTestting:addLabel({text="    2.手动巡回赛主要是让简单AI混失败时的TP奖励点数，邀请赛点球一般能点赢。",size=20, align="left"})
pageTestting:nextLine()
pageTestting:addLabel({text="    3.需要开场自动按状态换人的，请在换人设置里设置好换人规则。",size=20, align="left"})
pageTestting:nextLine()
pageTestting:addLabel({text="    4.需要下半场换人体力的不足时换人的，请打开游戏自动换人。",size=20, align="left"})
pageTestting:nextLine()
pageTestting:addLabel({text="    5.建议所有模式下都关闭自动铲球防止红黄牌。",size=20, align="left"})
pageTestting:nextLine()
pageTestting:addLabel({text="    6.国服红牌是一键替换；国际服是1、2小队相互切换，请保证两队没有重复球员。",size=20, align="left"})
pageTestting:nextLine()
pageTestting:addLabel({text="    7.启动脚本前请先切换至游戏主界面-比赛(或挂机流程中的任何一个界面)。",size=20, align="left"})
pageTestting:nextLine()
--[[pageTestting:addLabel({text="    8.新手直接进群下载本脚本应用即可，本来就是XX助手的安卓用户可以在叉叉助手搜索本此脚本。",size=20, align="left"})
pageTestting:nextLine()
pageTestting:addLabel({text="    9.国际服不支持非ROOT设备(无法给沙盒共享三件套)。",size=20, align="left"})
pageTestting:nextLine()
pageTestting:addLabel({text="    10.叉叉官方暂未对IOS13进行全面适配，不建议升级IOS13。",size=20, align="left"})
pageTestting:nextLine()
pageTestting:addLabel({text="    11.国服永久卡有VIP微信群，可进Q群让管理邀请加入。",size=20, align="left"})
pageTestting:nextLine()
pageTestting:addLabel({text="    12.详细说明书请点击脚本教程。",size=20, align="left"})
pageTestting:nextLine()
pageTestting:addLabel({text="    13.安卓和IOS不通用，国服和国际服不通用，请先试用好后再购买。",size=20, align="left"})
pageTestting:nextLine()--]]
pageTestting:addLabel({text="    8.脚本只是模拟点击，无任何修改数据，风险自行衡量。",size=20, align="left"})
pageTestting:nextLine()
pageTestting:addLabel({text="    9.目前中止了国际服的脚本功能，暂时不会支持，别再问了。",size=20, align="left"})
pageTestting:nextLine()
pageTestting:addLabel({text="    10.本软件无任何收费，脚本激活码领取(免费)地址在群公告里自取，禁止贩卖！",size=20, align="left"})
pageTestting:nextLine()
pageTestting:addLabel({text="    11.有任何问题及建议请反馈给作者，Q群(加群原因请回答:实况脚本)：国服574025168",size=20, align="left"})
pageTestting:nextLine()
pageTestting:nextLine()
pageTestting:addLabel({text="------------------------问题反馈说明------------------------",size=20, align="center"})
pageTestting:nextLine()
pageTestting:addLabel({text="        出现任何问题，请一定先看脚本说明和脚本教程，能解决95%的问题，另外如果你遇到的问题处于“最新",size=20, align="left"})
pageTestting:nextLine()
pageTestting:addLabel({text="    公告”中的BugList，意味着作者正在解决中。",size=20, align="left"})
pageTestting:nextLine()
pageTestting:addLabel({text="        若依然不能解决请进群反馈，同时请一定提供以下信息:",size=20, align="left"})
pageTestting:nextLine()
pageTestting:addLabel({text="        a.手机系统、型号和分辨率：IOS/安卓/模拟器/云手机",size=20, align="left"})
pageTestting:nextLine()
pageTestting:addLabel({text="        b.服务器：国际服/国服/国服渠道服",size=20, align="left"})
pageTestting:nextLine()
pageTestting:addLabel({text="        c.运行出错的任务",size=20, align="left"})
pageTestting:nextLine()
pageTestting:addLabel({text="        d.脚本报错信息截图，关闭报错信息后的截图(点后报错信息的确认后的画面)",size=20, align="left"})
pageTestting:nextLine()
pageTestting:nextLine()
pageTestting:addLabel({text="    ",size=20, align="left"})

local pageUserInfo = Page:new(myui,{text = "用户信息",size = 24, align="right"})
pageUserInfo:nextLine()
pageUserInfo:nextLine()

pageUserInfo:addLabel({text="当前脚本：",size=25,w=14,color="25,25,112",align="right"})
pageUserInfo:addLabel({text=CFG.SCRIPT_NAME,size=25,color="0,201,87",align="left"})
pageUserInfo:nextLine()

pageUserInfo:addLabel({text="当前版本：",size=25,w=14,color="25,25,112",align="right"})
pageUserInfo:addLabel({text=CFG.VERSION.."  "..CFG.BIULD_TIME,size=25,color="0,201,87",align="left"})
pageUserInfo:nextLine()

pageUserInfo:addLabel({text="用户ID：",size=25,w=14,color="25,25,112",align="right"})
pageUserInfo:addLabel({text=userId,size=25,color="0,201,87",align="left"})
pageUserInfo:nextLine()
pageUserInfo:addLabel({text="剩余时间：",size=25,w=14,color="25,25,112",align="right"})
pageUserInfo:addLabel({text=string.format("%s天%s小时%s分",math.floor(remainingSec/86400) ,math.floor(remainingSec%86400/3600),math.floor(remainingSec%3600/60)),size=25,color="0,201,87", align="left"})
pageUserInfo:nextLine()
pageUserInfo:nextLine()
pageUserInfo:nextLine()
pageUserInfo:addLabel({text="请选用户操作 ",size=25,w=14,color="25,25,112",align="left"})
pageUserInfo:addComboBox({id="comboBoxUserInfo",list = "正常玩游戏,登录新账号,注册新账号,激活CD-KEY",select=0,w=30,h=10, size = 22})



--local pageNotice = Page:new(myui,{text = "最新公告",size = 24})
--pageNotice:addWeb({id="noticeWebView", url="http://www.zybuluo.com/cndy1860/note/1497294", xpos = 0, ypos = 0, w = 100, h = 100})


--将位置*转换成对应的数字
local function _convertIndex(posation)
	if type(posation) ~= "string" then
		return 0
	end
	
	if posation == "位置1" then
		return 1
	elseif posation == "位置2" then
		return 2
	elseif posation == "位置3" then
		return 3
	elseif posation == "位置4" then
		return 4
	elseif posation == "位置5" then
		return 5
	elseif posation == "位置6" then
		return 6
	elseif posation == "位置7" then
		return 7
	elseif posation == "位置8" then
		return 8
	elseif posation == "位置9" then
		return 9
	elseif posation == "位置10" then
		return 10
	elseif posation == "位置11" then
		return 11
	elseif posation == "不换" then
		return 0
	else
		return 0
	end
end

--将换人条件转为为数字
local function _convertCondition(condition)
	if type(condition) ~= "string" then
		return 0
	end
	
	if condition == "主力红才换" then
		return 0
	elseif condition == "好一档就换" then
		return 1
	elseif condition == "好两档才换" then
		return 2
	else
		return 0
	end
end

local function getRadioKey(tb)
	for k, v in pairs(tb) do
		if v == true then
			return k
		end
	end
end

function dispUI()
	local isInWhiteList = false
	for _, v in pairs(CFG.SCRIPT_FUNC.whiteList) do
		if v.scriptid == CFG.ScriptInfo.id then
			isInWhiteList = true
			break
		end
	end
	
	if not isInWhiteList then
		dialog("非法上线脚本，请退出！")
		xmod.exit()
	end

	local uiRet = myui:show(3)
	if uiRet._cancel then
		xmod.exit()
	end
	--prt(uiRet)
	
	if uiRet.comboBoxUserInfo == "登录新账号" then
		setAction("loginUI")
		lua_restart()
	elseif uiRet.comboBoxUserInfo == "注册新账号" then
		setAction("registUI")
		lua_restart()
	elseif uiRet.comboBoxUserInfo == "激活CD-KEY" then
		setAction("activateUI")
		lua_restart()
	end
	
	--check Todo list
	local taskName = uiRet.comboBoxTask
	for _, v in pairs(CFG.SCRIPT_FUNC.todoList) do
		if v == taskName then
			dialog("正在火急火燎的开发中\r\n请少侠稍后再来！")
			xmod.exit()
		end
	end
	USER.TASK_NAME = taskName
	USER.REPEAT_TIMES = tonumber(uiRet.editerCircleTimes or CFG.DEFAULT_REPEAT_TIMES)
	
	USER.ALLOW_SUBSTITUTE = not not uiRet.checkBoxFunc.开场换人
	
	--是否允许重启
	USER.RESTART_SCRIPT = not not uiRet.radioRestart.开启
	if xmod.PLATFORM == xmod.PLATFORM_ANDROID then		--仅安卓支持重启应用
		USER.RESTART_APP = not not uiRet.radioSafeRestart.关闭
	else
		USER.RESTART_APP = false
	end
	if not USER.RESTART_SCRIPT then
		USER.RESTART_APP = false
	end

	CFG.LOG = (not not uiRet.radioLog.开启) or CFG.DEBUG 
	if CFG.LOG ~= PREV.writeLogStatus then
		setWriteLogStatus(CFG.LOG)
		if not CFG.LOG then
			dropLog()
			Log("Drop Log yet!")
		end
	end
	
	CFG.CACHING_MODE = not not uiRet.radioCachingMode.开启
	if CFG.CACHING_MODE ~= PREV.cacheStatus then
		setCacheStatus(CFG.CACHING_MODE)
		--if not CFG.CACHING_MODE then
		--	dropCache()		--一定要保证在ProjectPage加载了之后执行才有效
		--	Log("Drop cache yet!")
		--end		
	end	
	
	

	for i = 1, 7, 1 do
		USER.SUBSTITUTE_INDEX_LIST[i].fieldIndex = _convertIndex(uiRet[string.format("comboBoxBench%d",i)])
		USER.SUBSTITUTE_INDEX_LIST[i].substituteCondition = _convertCondition(uiRet[string.format("comboBoxBenchCondition%d",i)])
	end
	
	for k, v in pairs(USER.SUBSTITUTE_INDEX_LIST) do
		for _k, _v in pairs(USER.SUBSTITUTE_INDEX_LIST) do
			if _k ~= k and v.fieldIndex ~= 0 and _v.fieldIndex ~= 0 then
				if _v.fieldIndex == v.fieldIndex then
					dialog("请将替补和场上球员一一对应")
					dispUI()
					return
				end
			end
		end
	end
	
	--[[
	USER.SCOUT_STAR_LIST[1] = not not uiRet.checkBoxScoutStar.一星
	USER.SCOUT_STAR_LIST[2] = not not uiRet.checkBoxScoutStar.二星
	USER.SCOUT_STAR_LIST[3] = not not uiRet.checkBoxScoutStar.三星
	USER.SCOUT_STAR_LIST[4] = not not uiRet.checkBoxScoutStar.四星
	
	USER.SCOUT_FEATURE_LIST[1] = not not uiRet.checkBoxScoutFeature.联赛
	USER.SCOUT_FEATURE_LIST[2] = not not uiRet.checkBoxScoutFeature.区域
	USER.SCOUT_FEATURE_LIST[3] = not not uiRet.checkBoxScoutFeature.位置
	USER.SCOUT_FEATURE_LIST[4] = not not uiRet.checkBoxScoutFeature.优异能力
	USER.SCOUT_FEATURE_LIST[5] = not not uiRet.checkBoxScoutFeature.擅长战术
	USER.SCOUT_FEATURE_LIST[6] = not not uiRet.checkBoxScoutFeature.年龄
	USER.SCOUT_FEATURE_LIST[7] = not not uiRet.checkBoxScoutFeature.身高
	USER.SCOUT_FEATURE_LIST[8] = not not uiRet.checkBoxScoutFeature.惯用脚
	]]
	
	--prt(USER.SCOUT_STAR_LIST)
	--prt(USER.SCOUT_FEATURE_LIST)
	
	--prt(USER)
end

local function showBulletin()
	--local content, err = script.getBulletinBoard(CFG.BULLETIN_KEY, CFG.BULLETIN_TOKEN)
	local content, err = getCloudContent(CFG.BULLETIN_KEY, CFG.BULLETIN_TOKEN, "fdf")
	if err ~= 0 then
		Log("getCloudContent err!")
		return
	end
	
	local index, body, res = parseBulletin(content)
	if not res then		--获取失败
		Log("abort bulletin!")
		return
	end
	
	dialog("公告\n"..body, 10)
end


--showBulletin()
dispUI()		--先设置参数，后page init