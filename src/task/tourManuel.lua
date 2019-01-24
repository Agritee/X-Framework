-- randSim.lua
-- Author: cndy1860
-- Date: 2019-01-24
-- Descrip: 自动刷巡回手动模式

local _task = {
	tag = "手动巡回",
	processes = {
		{tag = "其他", mode = "firstRun"},
		{tag = "比赛", nextTag = "活动模式", mode = "firstRun"},
		{tag = "活动模式", nextTag = "控制球员", mode = "firstRun"},
		
		{tag = "巡回教练模式", nextTag = "next"},
		{tag = "选择电脑级别", nextTag = "超巨"},
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
	if USER.ALLOW_SUBSTITUTE then
		switchPlayer()
	end
end
insertFunc("阵容展示", fn)

local lastPlayingPageTime = 0
local lastProcessIndex = 0
local wfn = function(processIndex)
	local posTb = screen.findColors(scale.getAnchorArea("RB"), 
	scale.scalePos("1059|440|0xfafcfa,987|434|0x335a26-0x232117,1123|475|0x335a26-0x232117,1016|500|0x335a26-0x232117,1098|379|0x335a26-0x232117"),
	95)

	local buttonPot = {}
	--同样位置会有多个点，x、y坐标同时小于offset时判定为同位置的坐标，以20像素/短边750为基准
	local offset = (CFG.EFFECTIVE_AREA[4] - CFG.EFFECTIVE_AREA[2]) / 750 * 20
	for k, v in pairs(posTb) do
		local exsitFlag = false
		for _k, _v in pairs(buttonPot) do
			if math.abs(v.x - _v.x) < offset and math.abs(v.y - _v.y) < offset then
				exsitFlag = true
				break
			end
		end
		
		if not exsitFlag then
			table.insert(buttonPot, {x = v.x, y = v.y})
		end
	end
	
	local sortMethod = function(a, b)
		if a.x == nil or a.y == nil or b.x == nil or b.y == nil then
			return
		end
		
		if a.y == b.y then
			return a.x < b.x
		else
			return a.y < b.y
		end
	end
	
	sortMethod(buttonPot)
	--prt(buttonPot)
	
	if #buttonPot > 0 then
		--补足三个按钮
		if #buttonPot == 1 then
			table.insert(buttonPot, buttonPot[1])
			table.insert(buttonPot, buttonPot[1])
		elseif #buttonPot == 2 then
			table.insert(buttonPot, buttonPot[1])
		end
		
		local tmp = os.time() % 10
		if tmp == 0 or tmp == 2 or tmp == 5 or tmp == 7 or tmp == 8 then
			tap(buttonPot[2].x, buttonPot[2].y)
		else
			tap(buttonPot[3].x, buttonPot[3].y)
		end
	end
	
	if page.matchWidget("比赛中", "门球") then
		ratioSlide(800,700,850,500)
	end

	if processIndex ~= lastProcessIndex then	--当切换流程片时更新
		lastPlayingPageTime = 0
		lastProcessIndex = processIndex
	end
	
	if page.matchPage("比赛中") then
		lastPlayingPageTime = os.time()
	else
	
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