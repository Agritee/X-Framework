-- config.lua
-- Author: cndy1860
-- Date: 2018-12-24
-- Descrip: 参数配置表，注册在_G

CFG = {}	--脚本配置表

-----------------调试参数-----------------
CFG.DEBUG = true										--影响是否联网和log
CFG.LOG = false or CFG.DEBUG 							--是否允许输出LOG信息并写入log.txt文件

-----------------版本信息-----------------
CFG.SCRIPT_NAME = "实况助手"
CFG.VERSION = "v1.2.5"
CFG.BIULD_TIME = "20200517"

-----------------脚本参数-----------------
CFG.UserInfo = script.getUserInfo()
CFG.ScriptInfo = script.getScriptInfo()
CFG.SCRIPT_ID = "pes_mobile_assistant"


-----------------引擎属性-----------------
CFG.COMPATIBLE = (string.sub(xmod.VERSION_NAME, 1, 3) == "1.9" and {true} or {false})[1]		--兼容(1.9引擎)模式
CFG.CACHING_MODE = false				--缓存模式

-----------------分辨率参数-----------------
CFG.SUPPORT_RESOLUTION = {max = {width = 5040, height = 2160}, min = {width = 600, height = 450}}	--分辨率支持范围
CFG.DEV_RESOLUTION = {width = 1334, height = 750}		--开发分辨率，开发人员设置
CFG.DST_RESOLUTION = {--[[width = w, height = h]]}		--运行设备分辨率，由init设置
CFG.SCALING_RATIO = 1									--缩放比率(短边)，由init设置
CFG.EFFECTIVE_AREA = {--[[x0, y0, x1, y1]]}				--界面有效区，由init设置
CFG.BLACK_BORDER = {									--游戏黑边参数(比例超过临界值时，游戏会自动加上黑边)
	limitRatio = {horiz = 16/9, vertical = 4/3},		--出现黑边的临界比例（大于16:9在水平的两端出现黑边）
	borderList = {										--width >= height，预设项优先级大于由imitRatio生成的项
		--{width = 2340, height = 1080, left = 210, right = 210, top = 0, bottom = 0}
	},
}

-----------------线性插值取色-----------------
CFG.BILINEAR = false					--开启线性二次插值

-----------------应用参数-----------------
CFG.APP_ID = "com.netease.pes"			--当前应用名
CFG.DEFAULT_APP_ID = "com.netease.pes"	--缺省应用名
CFG.BULLETIN_KEY = "pes_mobile_assistant_bulletin"		--公告key
CFG.BULLETIN_TOKEN = "1F8BAC847D7A32CB"					--公告token(测试环境)
CFG.HOST = CFG.DEBUG and "http://192.168.8.101:8002/" or "http://49.234.8.107:8002/"
CFG.HEART_BEAT_INTERVAL = 120

-----------------找色参数-----------------
CFG.DEFAULT_FUZZY = 95					--默认颜色模糊相似度

-----------------文件-----------------
CFG.LOG_FILE_NAME = "log.txt"			--Log文件名

-----------------任务参数-----------------
CFG.DEFAULT_REPEAT_TIMES = 50

-----------------延时参数-----------------
CFG.DEFAULT_TIMEOUT = 40				--默认超时时间/s
CFG.NAVIGATION_DELAY = 200				--导航触发延时/ms

CFG.WAIT_RESTART = 15					--重启等待时间/s

CFG.WAIT_CHECK_SKIP = 3					--进入skipCheck判定的等待时间/s
CFG.WAIT_CHECK_SKIP_NEXT = 5
CFG.WAIT_CHECK_NAVIGATION = 0 			--进入导航判定的等待时间/s

-----------------touch参数-----------------
CFG.TOUCH_MOVE_STEP = 50				--touchMoveTo的移动步长/pix
CFG.DEFAULT_TAP_TIME = 80				--默认tap延时/ms
CFG.DEFAULT_LONG_TAP_TIME = 800			--默认longtap时间/ms

CFG.DEFAULT_PAGE_CHECK_INTERVAL = 100	--默认page的检测间隔/s

CFG.SCRIPT_FUNC = {						--脚本功能列表
	--[[funcList = {
		"自动天梯",
		"自动联赛",
		--"自动巡回",
		--"手动巡回",
		"通用教练模式",
		--"自动挑战",
		--"自动冠军赛",
		--"领取奖励",
		--"国际服季节赛SIM",
		--"国际服巡回赛SIM",
		--"国际服巡回赛手动",
		--"一键卖球探",
	},]]
	funcList = {
		"教练天梯",
		"教练联赛",
		"教练单场",
		"教练巡回",
		"手动巡回",
	},
	
	whiteList = {						--功能限制列表，通过白名单形式限制个脚本的功能，用于同时维护多个脚本,func为空是代表全白名单
		--------------安卓--------------
		{scriptid = -1, distributions = "开发助手版",
			func = {}},
		{scriptid = 24520, distributions = "自测",
			func = {}},
		{scriptid = 24634, distributions = "内部测试",
			func = {}},
		{scriptid = 16489, distributions = "安卓-叉叉助手/小精灵版",
			func = {"自动天梯","自动联赛","自动巡回","手动巡回","自动挑战","自动冠军赛","一键卖球探"}},
		{scriptid = 16498, distributions = "安卓-叉叉助手/小精灵测试版", 
			func = {}},
		{scriptid = 24391, distributions = "安卓-叉叉助手(国际服)版",
			func = {"国际服季节赛SIM","国际服巡回赛SIM","国际服巡回赛手动","一键卖球探"}},
		{scriptid = 17912, distributions = "安卓-小精灵(国际服)版", 
			func = {"国际服季节赛SIM","国际服巡回赛SIM","国际服巡回赛手动","一键卖球探"}},
		--------------IOS--------------
		{scriptid = 16947, distributions = "IOS-IPA版",
			func = {"自动天梯","自动联赛","自动巡回","手动巡回","自动挑战","自动冠军赛","一键卖球探"}},
		{scriptid = 18134, distributions = "IOS-IPA测试版", 
			func = {}},
		{scriptid = 24173, distributions = "IOS-IPA(国际服)版",
			func = {"国际服季节赛SIM","国际服巡回赛SIM","国际服巡回赛手动","一键卖球探"}},
	},
	
	todoList = {						--ToDo功能列表，会提示未开放请稍后再来
		"领取奖励",
	}
}


--上一次运行的状态参数
PREV = {}

-----------------重启状态-----------------
PREV.restarted = false					--是否发生过重启
PREV.restartedScript = false			--是否发生过脚本重启
PREV.restartedAPP = false				--是否发生过应用重启

-----------------状态参数----------------
PREV.writeLogStatus = false
PREV.cacheStatus = false


--用户配置表，主要由UI设置
USER = {}

-----------------用户设置-----------------
USER.TASK_NAME = "自动联赛"				--任务名称

USER.RESTART_SCRIPT = false				--是否允许重启脚本来解决异常
USER.RESTART_APP = false				--是否允许重启应用来解决异常

USER.REFRESH_CONCTRACT = false			--自动续约合同
USER.REPEAT_TIMES = 0					--任务循环次数
USER.DEFAULT_REPEAT_TIMES = 10			--任务默认运行次数
USER.ALLOW_SUBSTITUTE = true			--是否允许开场换人

USER.SUBSTITUTE_INDEX_LIST = {			--替补席对应关系表
	{fieldIndex = 1, substituteCondition = 1},
	{fieldIndex = 2, substituteCondition = 1},
	{fieldIndex = 3, substituteCondition = 1},
	{fieldIndex = 4, substituteCondition = 1},
	{fieldIndex = 5, substituteCondition = 1},
	{fieldIndex = 9, substituteCondition = 1},
	{fieldIndex = 10, substituteCondition = 1},
}

USER.SCOUT_STAR_LIST = {}				--售卖球探的星级
USER.SCOUT_FEATURE_LIST = {}			--售卖球探的特征


