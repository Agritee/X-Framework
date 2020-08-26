-- rankSim.lua
-- Author: cndy1860
-- Date: 2018-12-26
-- Descrip: 自动刷天梯赛教练模式
--1.天梯赛教练模式中，替换红牌伤病球员，是通过直接点击确定进行一键替换的，因为"天梯教练模式"没有actionFunc

local _task = {
	tag = "教练天梯",
	processes = {
		--{tag = "合同", mode = "firstRun"},
		{tag = "比赛", nextTag = "线上对战", mode = "firstRun"},
		{tag = "线上对战", nextTag = "自动比赛", mode = "firstRun"},
		
		{tag = "天梯教练模式", nextTag = "next"},
		{tag = "阵容展示", nextTag = "next"},
		{tag = "比赛中", timeout = 60},
		{tag = "终场统计", nextTag = "next", timeout = 900},
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
		if os.time() - lastPenaltyPageTime > CFG.DEFAULT_TIMEOUT * 2 + 10 then	--点球大战异常，包括了多个next的时间，适当延长
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



--将任务添加至exec.taskList
exec.loadTask(_task)