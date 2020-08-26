-- IntTourSim.lua/废弃
-- Author: cndy1860
-- Date: 2019-06-25
-- Descrip: 国际服自动刷巡回赛教练模式

local _task = {
	tag = "国际服巡回赛SIM",
	processes = {
		{tag = "俱乐部", mode = "firstRun"},
		{tag = "比赛", mode = "firstRun"},
		
		{tag = "国际服巡回赛", nextTag = "next"},
		--{tag = "阵容展示", nextTag = "next"}, 由于没有主客场球衣，直接跳过此处
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
	switchMainPage("比赛")
end
insertFunc("俱乐部", fn)

local fn = function()
	page.tapWidget("比赛", "活动模式")
	sleep(1000)
	
	local startTime = os.time()
	while true do
		if page.isExsitCommonWidget("国际服巡回赛自动比赛") then
			ratioTap(686, 66, 1000)
			ratioTap(686, 66, 200)
			sleep(1000)
		
			page.tapCommonWidget("国际服巡回赛自动比赛")
			break
		end
		
		ratioSlide(950, 640, 250, 640)
	
		if os.time() - startTime > CFG.DEFAULT_TIMEOUT then
			catchError(ERR_TIMEOUT, "异常:国际服巡回赛自动比赛!")
		end
		sleep(200)
	end
end
insertFunc("比赛", fn)

local fn = function()
	sleep(200)
	skipComfirm("国际服巡回赛")		--检测到界面后又弹出了确定提示按钮，如领取奖励，精神提升，点击所有的确定
	
	if page.isExsitCommonWidget("球队异常") and not isPlayerRedCard then
		refreshUnmetCoach("国际服巡回赛")
		if isPlayerRedCard then
			Log("有异常球员出现")
			sleep(500)
			swichTeam()
		end
	end
end
insertFunc("国际服巡回赛", fn)


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




--将任务添加至taskList
exec.loadTask(_task)