-- projFunc.lua
-- Author: cndy1860
-- Date: 2018-12-26
-- Descrip: 任务通用函数

--在主界面4个子界面切换
function switchMainPage(pageName)
	Log("swich to "..pageName)
	sleep(300)
	if pageName == "比赛" then
		ratioTap(179, 115)
	elseif pageName == "俱乐部" then
		ratioTap(490, 115)
	elseif pageName == "合同" then
		ratioTap(828, 115)
	elseif pageName == "其他" then
		ratioTap(1148, 115)
	else
		catchError(ERR_PARAM, "swich a wrong page")
	end
end

--获取一个区域内某种状态的所有球员位置信息
local function getFixStatusPlayers(area, status)
	local colorStr = ""
	local fuzzy = CFG.DEFAULT_FUZZY
	
	if status == "excellent" then	--状态极好
		colorStr = "467|452|0x003b2c,492|452|0x003b2c,492|477|0x003b2c,468|477|0x003b2c,480|465|0x00ffc2,480|462|0x00ffc2"--480|465|0x00ffc2
	elseif status == "good" then	--状态较好
		--colorStr = "467|452|0x263900,492|452|0x263900,492|477|0x263900,476|469|0x97dc00,456|487|0xeeeeee,480|465|0x97dc00"
		colorStr = "467|453|0x263900,468|476|0x263900,491|476|0x263900,491|453|0x263900,480|465|0x97dc00,484|460|0x97dc00,479|446|0xf7f7f7,476|483|0xe0e0e0"
		fuzzy = 99		--颜色相近的点实在太多，超过了99点不好区分
	elseif status == "bad" then		--状态较差
		colorStr = "467|452|0x3c2200,492|452|0x3c2200,492|477|0x3c2200,468|477|0x3c2200,481|465|0xb36600,484|469|0xb36600"--480|465|0xb36600"
	elseif status == "worse" then	--状态极差
		colorStr = "467|452|0x3c0e0e,492|452|0x3c0e0e,492|477|0x3c0e0e,468|477|0x3c0e0e,480|465|0xb90000,480|468|0xb90000"
	elseif status == "normal" then	--状态一般
		colorStr = "467|452|0x363000,492|452|0x363000,492|477|0x363000,468|477|0x363000,487|465|0xc4bc00"
	else
		catchError(ERR_PARAM, "get a worong status in getFixStatusPlayers")
	end
	
	local points = findColors(area, colorStr, fuzzy, 0, 0, 0)
	
	if #points == 0 then
		Log("cant find point on: "..status)
		return points
	end
	
	if #points >= 99 then	--超过points最大容量99个点意味着可能没有找完所有位置的状态
		prt(points)
		dialog("get more than 99 point, maybe not cath all posation")
		catchError(ERR_PARAM, "get more than 99 point, maybe not cath all posation")
		return nil
	end
	
	--prt("status: "..status.."  points count: "..#points)
	
	return points
end

--获取所有场上球员的状态信息，包括状态和排布位置，分场上球员和替补席位
local function getPlayerStatusInfo(seats)
	local players = {}	--球员的坐标及状态,可能包含重复的
	local validPlayers = {}	--不包含重复的球员
	local searchArea = {}
	if seats == "field" then	--场上球员分4块，防止findColors的点超过99炸了
		searchArea = {{125,53,440,278}, {440,53,755,278}, {125,278,440,503}, {440,278,755,503}}
	elseif seats == "benchFirstHalf" then		--替补席前半部分
		searchArea = {{25,48,132,480}}
	elseif seats == "benchLatterHalf" then		--替补席后半部分
		searchArea = {{25,200,132,480}}
	else
		catchError(ERR_PARAM, "get a worong seats in getPlayerStatusInfo")
	end
	
	--状态根据箭头方向分为5种，下，斜下，平，斜上，上，分别对应：极差，差，一般，好，极好
	local statusList = {"worse", "bad", "normal", "good", "excellent"}
	for k, v in pairs(statusList) do
		for _k, _v in pairs(searchArea) do
			local fixStatusPlayers = getFixStatusPlayers(_v, v)
			if #fixStatusPlayers > 0 then
				for __k, __v in pairs(fixStatusPlayers) do
					__v.status = k	--将状态写入对应的球员,用数值表示便于比较
					table.insert(players, __v)	--加入到球员总表
				end
			end
		end
	end
	
	--去除findColor导致的一个球员有多个点对应的情况，一个球员只保留一个点
	for k, v in pairs(players) do
		local exsitFlag = false
		for _k, _v in pairs(validPlayers) do
			if math.abs(v.x - _v.x) < 20 and math.abs(v.y - _v.y) < 20 then
				exsitFlag = true
				break
			end
		end
		
		if exsitFlag == false then
			table.insert(validPlayers, v)
		end
	end
	
	--排序，按从上到下，从左到右的顺序，即优先取y较小值，y相同再取x较小值
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
	
	table.sort(validPlayers, sortMethod)
	
	--Log("get "..#players.." players points")
	
	--prt(validPlayers)
	--统计各状态并打印，用于调试
	local worse, bad, mormal, good, excellent = 0, 0, 0, 0, 0
	for k, v in pairs(validPlayers) do
		if v.status == 1 then
			worse = worse + 1
		elseif v.status == 2 then
			bad = bad + 1
		elseif v.status == 3 then
			mormal = mormal + 1
		elseif v.status == 4 then
			good = good + 1
		elseif v.status == 5 then
			excellent = excellent + 1
		end
		if k == #validPlayers then
			Log("worse="..worse)
			Log("bad="..bad)
			Log("mormal="..mormal)
			Log("good="..good)
			Log("excellent="..tostring(excellent))
			Log("get "..#validPlayers.." valid players at last")
		end
	end
	
	return validPlayers
end

--换人
function switchPlayer()
	tap(609,491)	--切换状态界面
	sleep(1000)	--会有"状态"二字出现，挡住球员，等待消失，一定要留够时间
	local fieldPlayers = getPlayerStatusInfo("field")	--获取场上球员信息
	if fieldPlayers == nil then		--出现超过99点直接放弃换人，等2.0更新
		return
	end
	if #fieldPlayers ~= 11 then 	--未找到全部11个换人
		sleep(1000)
		fieldPlayers = getPlayerStatusInfo("field")	--再次获取场上球员信息，防止因为切换时“状态”二字挡住影响
		if #fieldPlayers ~= 11 then
			--catchError(ERR_PARAM, "did not get 11 fiedl player, just "..#fieldPlayers)
			catchError(ERR_WARNING, "did not get 11 fiedl player, just "..#fieldPlayers)
			return
		end
	end
	
	tap(68,314)		--打开替补席
	sleep(500)
	
	local benchPlayersFirstHalf = getPlayerStatusInfo("benchFirstHalf")	--获取替补席球员信息，显现出的前半部分
	if #CFG.SUBSTITUTE_INDEX_LIST > 0 then		--将用户的对应关系写入benchPlayersInfo
		for k, v in pairs(benchPlayersFirstHalf) do
			v.fieldIndex = CFG.SUBSTITUTE_INDEX_LIST[k].fieldIndex
			v.substituteCondition = CFG.SUBSTITUTE_INDEX_LIST[k].substituteCondition
		end
	else	--将默认的对应关系写入benchPlayersInfo
		for k, v in pairs(benchPlayersFirstHalf) do
			v.fieldIndex = k
			v.substituteCondition = 0
		end
	end
	
	touchMoveTo(20, 500, 20, 110) --滑动替补至下半部分
	sleep(300)
	
	local benchPlayersLatterHalf = getPlayerStatusInfo("benchLatterHalf")	--获取替补席球员信息，未显示的后半部分
	if #CFG.SUBSTITUTE_INDEX_LIST > 0 then		--将用户的对应关系写入benchPlayersInfo
		for k, v in pairs(benchPlayersLatterHalf) do
			v.fieldIndex = CFG.SUBSTITUTE_INDEX_LIST[k + #benchPlayersFirstHalf].fieldIndex
			v.substituteCondition = CFG.SUBSTITUTE_INDEX_LIST[k + #benchPlayersFirstHalf].substituteCondition
		end
	else	--将默认的对应关系写入benchPlayersInfo
		for k, v in pairs(benchPlayersLatterHalf) do
			v.fieldIndex = k + #benchPlayersFirstHalf
			v.substituteCondition = 0
		end
	end
	
	for k, v in pairs(benchPlayersLatterHalf) do	--先换下半部分的
		local substituteFlag = false	--是否换过人标志
		if v.fieldIndex ~= 0 then
			if v.substituteCondition == 0 then	--主力为极差的时候才换
				if fieldPlayers[v.fieldIndex].status == 1 and v.status > 1 then
					substituteFlag = true
					touchMoveTo(v.x, v.y, fieldPlayers[v.fieldIndex].x, fieldPlayers[v.fieldIndex].y)
				end
			else	--根据状态档次替换
				--Log("v.status="..v.status.."  fieldPlayers.status="..fieldPlayers[v.fieldIndex].status)
				if v.status - fieldPlayers[v.fieldIndex].status >= v.substituteCondition then
					substituteFlag = true
					touchMoveTo(v.x, v.y, fieldPlayers[v.fieldIndex].x, fieldPlayers[v.fieldIndex].y)
				end
			end
			
			if substituteFlag then	--换人了需要再次调出替补名单
				--sleep(200)
				page.goNextByCatchPoint({5, 238, 146, 390}, "63|316|0x0079fd,53|322|0xfdfdfd,88|320|0xfdfdfd,61|345|0xfdfdfd")
				sleep(500)
			end
		end
	end
	sleep(200)
	
	touchMoveTo(20, 110, 20, 500) --滑滑动替补回到上半部分
	sleep(500)
	
	for k, v in pairs(benchPlayersFirstHalf) do		--换上半部分
		local substituteFlag = false	--是否换过人标志
		if v.fieldIndex ~= 0 then
			if v.substituteCondition == 0 then	--主力为极差的时候才换
				if fieldPlayers[v.fieldIndex].status == 1 and v.status > 1 then
					substituteFlag = true
					touchMoveTo(v.x, v.y, fieldPlayers[v.fieldIndex].x, fieldPlayers[v.fieldIndex].y)
				end
			else	--根据状态档次替换
				if v.status - fieldPlayers[v.fieldIndex].status >= v.substituteCondition then
					substituteFlag = true
					touchMoveTo(v.x, v.y, fieldPlayers[v.fieldIndex].x, fieldPlayers[v.fieldIndex].y)
				end
			end
			
			if k < #benchPlayersFirstHalf and substituteFlag then	--换人了需要再次调出替补名单, 除开最后一次
				--sleep(200)
				page.goNextByCatchPoint({5, 238, 146, 390}, "63|316|0x0079fd,53|322|0xfdfdfd,88|320|0xfdfdfd,61|345|0xfdfdfd")
				sleep(500)
			end
		end
		
		if k == #benchPlayersFirstHalf and substituteFlag == false then	--最后一次没换过人需要退出替补名单
			tap(480, 465)
		end
	end
end

--续约
function selectExpiredPlayer()
	sleep(200)
	
	local expiredPlayerFirstHalf = {}
	local expiredPlayerLatterHalf = {}
	
	local posTb = screen.findColors(
		scale.getAnchorArea("A"),
		"245|190|0xffffff,230|194|0xff3b2f,245|180|0xff3b2f,261|197|0xff3b2f,245|214|0xff3b2f",
		CFG.DEFAULT_FUZZY,
		screen.PRIORITY_DEFAULT,
		999)
	if #posTb >= 999 then
		catchError(ERR_PARAM, "more than 999 point, cant find all point")
	end
	
	for _, v in pairs(posTb) do
		local exsitFlag = false
		for _, _v in pairs(expiredPlayerFirstHalf) do
			if math.abs(v.x - _v.x) < 20 and math.abs(v.y - _v.y) < 20 then
				exsitFlag = true
				break
			end
		end
		
		if exsitFlag == false then
			table.insert(expiredPlayerFirstHalf, v)
			tap(v.x, v.y)
			sleep(200)				
		end
	end
	prt(expiredPlayerFirstHalf)
	
	if #expiredPlayerFirstHalf == 3 or #expiredPlayerFirstHalf == 6 then
		ratioSlide(20, 620, 20, 120) --滑动替补至下半部分
		sleep(200)
		local posTb = screen.findColors(
			scale.getAnchorArea("A"),
			"245|190|0xffffff,230|194|0xff3b2f,245|180|0xff3b2f,261|197|0xff3b2f,245|214|0xff3b2f",
			CFG.DEFAULT_FUZZY,
			screen.PRIORITY_DEFAULT,
			999)
		if #posTb >= 999 then
			catchError(ERR_PARAM, "more than 999 point, cant find all point 2")
		end
		
		for _, v in pairs(posTb) do
			local exsitFlag = false
			for _, _v in pairs(expiredPlayerLatterHalf) do
				if math.abs(v.x - _v.x) < 20 and math.abs(v.y - _v.y) < 20 then
					exsitFlag = true
					break
				end
			end
			
			if exsitFlag == false then
				table.insert(expiredPlayerLatterHalf, v)
				tap(v.x, v.y)
				sleep(200)	
			end
		end
		prt(expiredPlayerLatterHalf)
	end
	Log("selected all players")
end

--处理能量不足
function waitEnergy()
	if USER.RESTORED_ENERGY then
		dialog("能量不足100分钟内后继续，请勿操作", 5)
		page.tapNavigation("能量不足")		--点击取消
		
		local startTime = os.time()
		while true do
			--if os.time() - startTime > 110 * 60 then
			if os.time() - startTime > 5 then
				dialog("已续足能量，即将继续任务", 5)
				startTime = os.time()	--重置startTime
				break
			end
			sleep(60 * 1000)	--每分钟检测一次
		end
	else
		Log("能量不足，请退出")
		dialog("能量不足，请退出")
		xmod.exit()
	end
	
	--联赛教练模式执行点击后，出现等待能量的情况，需重新执行联赛教练模式流程片
	exec.execPrevProcess()
end

