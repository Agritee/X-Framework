-- tourSim.lua
-- Author: cndy1860
-- Date: 2018-12-28
-- Descrip: 自动刷巡回赛教练模式

local _task = {
	tag = "教练巡回",
	processes = {
		--{tag = "合同", mode = "firstRun"},
		{tag = "比赛", nextTag = "活动模式", mode = "firstRun"},
		{tag = "活动模式", mode = "firstRun"},
		{tag = "通用比赛界面", nextTag = "next"},
		{tag = "阵容展示", nextTag = "next"},
		{tag = "比赛中", timeout = 60},
		{tag = "终场统计", nextTag = "next", timeout = 900, checkInterval = 1000},
	},
}

local function insertFunc(processTag, fn)
	for _, v in pairs(_task.processes) do
		if v.tag == processTag then
			v.actionFunc = fn
			return true
		end
	end
end

local function insertWaitFunc(processTag, fn)
	for _, v in pairs(_task.processes) do
		if v.tag == processTag then
			v.waitFunc = fn
			return true
		end
	end
end

local fn = function()
	local startTime = os.time()
	while true do
		if page.matchWidget("活动模式", "教练巡回赛") then
			ratioTap(700, 700, 500)		--hold
			sleep(1000)
			page.tapWidget("活动模式", "教练巡回赛")
			sleep(1000)
			break
		end
		
		ratioSlide(950, 640, 250, 640)
		
		if os.time() - startTime > CFG.DEFAULT_TIMEOUT then
			catchError(ERR_TIMEOUT, "异常:未找到教练巡回赛!")
		end
		sleep(200)
	end
end
insertFunc("活动模式", fn)

local fn = function()
	sleep(200)
	skipComfirm("通用比赛界面")		--检测到界面后又弹出了确定提示按钮，如领取奖励，精神提升，点击所有的确定
	
	if page.isExsitCommonWidget("球队异常") and not isPlayerRedCard then
		refreshUnmetCoach("通用比赛界面")
	end
end
insertFunc("通用比赛界面", fn)

local fn = function()
	if page.matchWidget("阵容展示", "身价溢出") then
		dialog("身价溢出，精神低迷\r\n即将退出")
		xmod.exit()
	end
	
	if USER.ALLOW_SUBSTITUTE then
		switchPlayer()
	end
end
insertFunc("阵容展示", fn)

local wfn = function()
	if page.matchPage("比赛中") then
		lastPlayingPageTime = os.time()
	end
	
	if lastPlayingPageTime == 0 then	--还未检测到比赛开始过，不进入流程。注意，需每轮任务重置时清零
		return
	end
	
	if page.matchPage("点球") then
		Log("点球大战中...")
		lastPenaltyPageTime = os.time()
	end

	if lastPenaltyPageTime > 0 then		--发生了点球大战
		if os.time() - lastPenaltyPageTime > CFG.DEFAULT_TIMEOUT + 10 then	--点球大战异常
			catchError(ERR_TIMEOUT, "异常:点球大战界面中断")
		end
		
		return	--发生了点球大战，始终不继续比赛中的检测流程
	end	
	
	if os.time() - lastPlayingPageTime > CFG.DEFAULT_TIMEOUT + 10 then		--长时间未检测到比赛界面，判定为异常
		catchError(ERR_TIMEOUT, "异常:未检测到比赛界面！")
	elseif os.time() - lastPlayingPageTime >= 3 and isAppInFront() then		--3秒内未检测到比赛界面，尝试跳过回放
		skipReplay()
	end
	
	Log("timeAfterLastPlayingPage = "..(os.time() - lastPlayingPageTime).."s yet")
end
insertWaitFunc("终场统计", wfn)




--将任务添加至taskList
exec.loadTask(_task)