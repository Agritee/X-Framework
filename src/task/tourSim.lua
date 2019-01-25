-- randSim.lua
-- Author: cndy1860
-- Date: 2018-12-28
-- Descrip: 自动刷联赛赛教练模式

local _task = {
	tag = "自动巡回",
	processes = {
		{tag = "其他", mode = "firstRun"},
		{tag = "比赛", nextTag = "活动模式", mode = "firstRun"},
		{tag = "活动模式", nextTag = "自动比赛", mode = "firstRun"},
		
		{tag = "巡回教练模式", nextTag = "next"},
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
insertFunc("其他", fn)

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

local lastPlayingPageTime = 0
local lastTaskIndex = 0
local wfn = function(taskIndex)
	if taskIndex ~= lastTaskIndex then	--当切换流程片时更新
		lastPlayingPageTime = 0
		lastTaskIndex = taskIndex
	end
	
	if page.matchPage("比赛中") then
		lastPlayingPageTime = os.time()
	end
	
	if lastPlayingPageTime == 0 then	--未检测到起始playing界面，跳过
		return
	end
	
	local timeAfterLastPlayingPage = os.time() - lastPlayingPageTime	--距离最后一个playing界面的时间间隔
	
	--跳过进球回放什么的,--游戏崩溃的情况下不点击
	if timeAfterLastPlayingPage >= 3 and timeAfterLastPlayingPage <= 20 and isAppInFront() then
		Log("skip replay")
		ratioTap(10, 60)
		sleep(500)
	end
	
	if lastPlayingPageTime > 0 then Log("timeAfterLastPlayingPage = "..timeAfterLastPlayingPage.."s yet")	 end
	
	--因为半场为超长时间等待，如果长时间不在playing判定为异常,因为有精彩回放所以超时为两倍(还有点球)
	if timeAfterLastPlayingPage > math.floor(CFG.DEFAULT_TIMEOUT * 1.5) then
		catchError(ERR_TIMEOUT, "cant check playing at wait PAGE_INTERVAL")
	end
end
insertWaitFunc("终场统计", wfn)




--将任务添加至taskList
exec.loadTask(_task)