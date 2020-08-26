-- challengeSim.lua/废弃
-- Author: cndy1860
-- Date: 2018-12-28
-- Descrip: 自动刷巡回赛教练模式

local _task = {
	tag = "自动挑战",
	processes = {
		{tag = "合同", mode = "firstRun"},
		{tag = "比赛", nextTag = "活动模式", mode = "firstRun"},
		{tag = "活动模式", nextTag = "自动比赛"},
		
		{tag = "巡回模式", nextTag = "next"},
		{tag = "阵容展示", nextTag = "next"},
		{tag = "比赛中", timeout = 60},
		{tag = "终场统计", nextTag = "next", timeout = 900, checkInterval = 1000},
		{tag = "挑战赛完成"},
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
	switchMainPage("比赛")
end
insertFunc("合同", fn)

local fn = function()
	local startTime = os.time()
	while true do
		if page.matchWidget("活动模式", "自动比赛2") then
			ratioTap(686, 66, 1000)
			ratioTap(686, 66, 200)
			sleep(1000)
			
			break
		end
		
		ratioSlide(950, 640, 250, 640)
		
		if os.time() - startTime > CFG.DEFAULT_TIMEOUT then
			catchError(ERR_TIMEOUT, "异常:自动活动!")
		end
		sleep(200)
	end
end
insertFunc("活动模式", fn)

local fn = function()
	sleep(200)
	skipComfirm("巡回模式")		--检测到界面后又弹出了确定提示按钮，如领取奖励，精神提升，点击所有的确定
	
	if page.isExsitCommonWidget("球队异常") and not isPlayerRedCard then
		refreshUnmetCoach("巡回模式")
	end
end
insertFunc("巡回模式", fn)

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
	
	if os.time() - lastPlayingPageTime > CFG.DEFAULT_TIMEOUT + 10 then		--长时间未检测到比赛界面，判定为异常
		catchError(ERR_TIMEOUT, "异常:未检测到比赛界面！")
	elseif os.time() - lastPlayingPageTime >= 3 and isAppInFront() then		--3秒内未检测到比赛界面，尝试跳过回放
		skipReplay()
	end
	
	Log("timeAfterLastPlayingPage = "..(os.time() - lastPlayingPageTime).."s yet")
end
insertWaitFunc("终场统计", wfn)

local fn = function()
	--page.tapNavigation("back")
	execNavigationQueue({"comfirm", "back"})
end
insertFunc("挑战赛完成", fn)


--将任务添加至taskList
exec.loadTask(_task)