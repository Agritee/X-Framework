-- IntTourManuel.lua/废弃
-- Author: cndy1860
-- Date: 2019-07-01
-- Descrip: 国际服自动刷巡回手动模式

local _task = {
	tag = "国际服巡回赛手动",
	processes = {
		{tag = "俱乐部", mode = "firstRun"},
		{tag = "比赛", mode = "firstRun"},
		
		{tag = "国际服巡回赛", nextTag = "next"},
		{tag = "选择电脑级别", nextTag = "超巨"},
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
		if page.isExsitCommonWidget("国际服巡回赛手动比赛") then
			ratioTap(686, 66, 1000)
			ratioTap(686, 66, 200)
			sleep(1000)
			
			page.tapCommonWidget("国际服巡回赛手动比赛")
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

local bottonStiacPos = {}
local wfn = function()		--主场开球，先发球后才能进入“比赛中”界面
	sleep(200)
	local posTb = screen.findColors(scale.getAnchorArea("R/4B/2"),
		scale.scalePos("1059|440|0xd0e2cf-0x2f1d30,987|434|0x335a26-0x232117,1123|475|0x335a26-0x232117,1016|500|0x335a26-0x232117,1098|379|0x335a26-0x232117"),
		95)
	if #posTb ~= 0 then
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
			Log("选择电脑级别开球--------------------")
			if #buttonPot == 1 then
				tap(buttonPot[1].x, buttonPot[1].y)
			elseif #buttonPot == 2 or #buttonPot == 3 then
				local rnd = os.time() % 2
				if rnd == 0 then
					tap(buttonPot[#buttonPot - 1].x, buttonPot[#buttonPot - 1].y)	--直塞
				else
					tap(buttonPot[#buttonPot].x, buttonPot[#buttonPot].y)			--传球
				end
			else			--大于三个按钮，有干扰点
				Log("有干扰点")
				if #bottonStiacPos > 0 then		--有缓存点,点击缓存点
					local rnd = os.time() % 2
					if rnd == 0 then
						tap(bottonStiacPos[#bottonStiacPos - 1].x, bottonStiacPos[#bottonStiacPos - 1].y)	--直塞
					else
						tap(bottonStiacPos[#bottonStiacPos].x, bottonStiacPos[#bottonStiacPos].y)			--传球
					end					
				else		--无缓存点，依次点击buttonPot首中尾点
					Log("无缓存点")
					tap(buttonPot[1].x, buttonPot[1].y)
					sleep(500)
					tap(buttonPot[math.floor(#buttonPot/2)].x, buttonPot[math.floor(#buttonPot/2)].y)
					sleep(500)
					tap(buttonPot[#buttonPot].x, buttonPot[#buttonPot].y)
				end
			end
			sleep(500)		--限制频率
		else
			catchError(ERR_NORMAL, "未检测到传球按钮")
		end
	end
end
insertWaitFunc("选择电脑级别", wfn)

local wfn = function()		--主场开球，先发球后才能进入“比赛中”界面
	sleep(200)
	local posTb = screen.findColors(scale.getAnchorArea("R/4B/2"),
		scale.scalePos("1059|440|0xd0e2cf-0x2f1d30,987|434|0x335a26-0x232117,1123|475|0x335a26-0x232117,1016|500|0x335a26-0x232117,1098|379|0x335a26-0x232117"),
		95)
	if #posTb ~= 0 then
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
			Log("主场开球--------------------")
			if #buttonPot == 1 then
				tap(buttonPot[1].x, buttonPot[1].y)
			elseif #buttonPot == 2 or #buttonPot == 3 then
				local rnd = os.time() % 2
				if rnd == 0 then
					tap(buttonPot[#buttonPot - 1].x, buttonPot[#buttonPot - 1].y)	--直塞
				else
					tap(buttonPot[#buttonPot].x, buttonPot[#buttonPot].y)			--传球
				end
			else			--大于三个按钮，有干扰点
				Log("有干扰点")
				if #bottonStiacPos > 0 then		--有缓存点,点击缓存点
					local rnd = os.time() % 2
					if rnd == 0 then
						tap(bottonStiacPos[#bottonStiacPos - 1].x, bottonStiacPos[#bottonStiacPos - 1].y)	--直塞
					else
						tap(bottonStiacPos[#bottonStiacPos].x, bottonStiacPos[#bottonStiacPos].y)			--传球
					end					
				else		--无缓存点，依次点击buttonPot首中尾点
					Log("无缓存点")
					tap(buttonPot[1].x, buttonPot[1].y)
					sleep(500)
					tap(buttonPot[math.floor(#buttonPot/2)].x, buttonPot[math.floor(#buttonPot/2)].y)
					sleep(500)
					tap(buttonPot[#buttonPot].x, buttonPot[#buttonPot].y)
				end
			end
			sleep(500)		--限制频率
		else
			catchError(ERR_NORMAL, "未检测到传球按钮")
		end
	end
end
insertWaitFunc("比赛中", wfn)

local wfn = function()
	if page.matchPage("比赛中") then
		lastPlayingPageTime = os.time()
	end
	
	if lastPlayingPageTime == 0 then	--未检测到起始playing界面，跳过
		return
	end
	
	if page.matchPage("点球") then
		lastPenaltyPageTime = os.time()
		local posTb = screen.findColors(scale.getAnchorArea("A"),
			scale.scalePos("934|331|0x00f8ff,930|325|0x00f8ff,938|325|0x00f8ff"),
			95)
		if #posTb ~= 0 then		--正处于罚球或守门控制阶段
			local rnd = os.time() % 4
			if math.abs(CFG.DST_RESOLUTION.width / 2 - posTb[1].x) > (CFG.EFFECTIVE_AREA[4] - CFG.EFFECTIVE_AREA[2]) / 750 * 100 then --100像素/短边750为基准
				Log("罚球")
				if rnd == 0 then		--左角
					slide(667,485,410,370)
				elseif rnd == 1 then	--左上角
					slide(667,485,410,190)
				elseif rnd == 2 then	--右上角
					slide(667,485,920,190)
				else		--右角
					slide(667,485,920,370)
				end
			else
				Log("守门")
				if rnd == 1 or rnd == 2 then	--左扑
					slide(667,280,432,280)
				else 		--右扑
					slide(667,280,900,280)
				end
			end
			sleep(3000)
		end
	end
	
	if lastPenaltyPageTime > 0 then		--发生了点球大战
		if os.time() - lastPenaltyPageTime > CFG.DEFAULT_TIMEOUT + 10 then	--点球大战异常
			catchError(ERR_TIMEOUT, "异常:手动巡回点球大战界面中断")
		end
		
		return	--发生了点球大战，始终不继续比赛中的检测流程
	end
	
	local posTb = screen.findColors(scale.getAnchorArea("R/4B/2"),
		--scale.scalePos("1059|440|0xfafcfa,987|434|0x335a26-0x232117,1123|475|0x335a26-0x232117,1016|500|0x335a26-0x232117,1098|379|0x335a26-0x232117"),
		scale.scalePos("1059|440|0xd0e2cf-0x2f1d30,987|434|0x335a26-0x232117,1123|475|0x335a26-0x232117,1016|500|0x335a26-0x232117,1098|379|0x335a26-0x232117"),
		95)
	if #posTb ~= 0 then
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
		
		if #buttonPot == 3 and #bottonStiacPos == 0 then	--缓存按钮
			for _, v in pairs(buttonPot) do
				table.insert(bottonStiacPos, v)
			end
		end
		
		if #buttonPot > 0 then
			if #buttonPot == 1 then
				tap(buttonPot[1].x, buttonPot[1].y)
			elseif #buttonPot == 2 or #buttonPot == 3 then
				local rnd = os.time() % 2
				if rnd == 0 then
					tap(buttonPot[#buttonPot - 1].x, buttonPot[#buttonPot - 1].y)	--直塞
				else
					tap(buttonPot[#buttonPot].x, buttonPot[#buttonPot].y)			--传球
				end
			else			--大于三个按钮，有干扰点
				Log("有干扰点")
				if #bottonStiacPos > 0 then		--有缓存点,点击缓存点
					local rnd = os.time() % 2
					if rnd == 0 then
						tap(bottonStiacPos[#bottonStiacPos - 1].x, bottonStiacPos[#bottonStiacPos - 1].y)	--直塞
					else
						tap(bottonStiacPos[#bottonStiacPos].x, bottonStiacPos[#bottonStiacPos].y)			--传球
					end					
				else		--无缓存点，依次点击buttonPot首中尾点
					Log("无缓存点")
					tap(buttonPot[1].x, buttonPot[1].y)
					sleep(500)
					tap(buttonPot[math.floor(#buttonPot/2)].x, buttonPot[math.floor(#buttonPot/2)].y)
					sleep(500)
					tap(buttonPot[#buttonPot].x, buttonPot[#buttonPot].y)
				end
			end
			sleep(100)		--限制频率
		end
	end
	
	if page.matchWidget("比赛中", "门球") then
		ratioSlide(800,700,850,500)
		sleep(1000)
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