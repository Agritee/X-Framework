-- championSim.lua/废弃
-- Author: cndy1860
-- Date: 2019-06-17
-- Descrip: 自动刷冠军赛教练模式

local _task = {
	tag = "自动冠军赛",
	processes = {
		{tag = "合同", mode = "firstRun"},
		{tag = "比赛", nextTag = "活动模式", mode = "firstRun"},
		{tag = "活动模式", nextTag = "自动比赛", mode = "firstRun"},
		{tag = "决战32强", nextTag = "报名", mode = "firstRun"},
		
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
	switchMainPage("比赛")
end
insertFunc("合同", fn)

local fn = function()
	sleep(200)
	
	if page.isExsitCommonWidget("球队异常") and not isPlayerRedCard then
		refreshUnmetCoach("通用比赛界面")
	end
end
insertFunc("通用比赛界面", fn)

local wfn = function()
	if page.matchPage("冠军赛结束") then
		Log("本轮冠军赛已结束")
		dialog("本轮冠军赛已结束")
		xmod.exit()
	end
end
insertWaitFunc("阵容展示", fn)

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
	
	--Log("timeAfterLastPlayingPage = "..(os.time() - lastPlayingPageTime).."s yet")
end
insertWaitFunc("终场统计", wfn)




--将任务添加至taskList
exec.loadTask(_task)