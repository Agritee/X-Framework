-- projFunc.lua
-- Author: cndy1860
-- Date: 2018-12-26
-- Descrip: 任务通用函数

--在主界面4个子界面切换
function switchMainPage(pageName)
	Log("swich to "..pageName)
	local startTime = os.time()
	while true do
		local currentPage = page.getCurrentPage(true)
		if currentPage == "比赛" or currentPage == "俱乐部" or currentPage == "其他" or currentPage == "合同" then
			Log("stay mian page")
			if currentPage ~= pageName then
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
				sleep(500)	
			end
		end
		
		if page.isExsitNavigation("notice") then
			page.tapNavigation("notice")
		end
		
		if page.matchPage(pageName) then
			break
		end
		
		if os.time() - startTime > CFG.DEFAULT_TIMEOUT then
			catchError(ERR_TIMEOUT, "异常:切换主界界面失败!")
		end
		sleep(100)
	end
	Log("end swich to "..pageName)
end

--获取某个区域内某种状态的所有球员
local function getFixStatusPlayers(area, status)
	local statusStr = ""
	
	if status == "excellent" then	--状态极好
		statusStr = "667|646|0x00F0B6-0x000F0C,667|655|0x00F0B6-0x000F0C,661|646|0x00F0B6-0x000F0C,672|646|0x00F0B6-0x000F0C,667|639|0x00F0B6-0x000F0C,\
		638|645|0xededed-0x0f0f0f,700|645|0xededed-0x0f0f0f,667|637|0x00F0B6-0x000F0C,659|655|0x0f3b28-0x0f1e1b,674|655|0x0f3b28-0x0f1e1b"
	elseif status == "good" then	--状态较好
		statusStr = "667|646|0x8CCD00-0x0B0F00,661|652|0x8CCD00-0x0B0F00,664|641|0x8CCD00-0x0B0F00,672|650|0x8CCD00-0x0B0F00,673|640|0x8CCD00-0x0B0F00,\
		638|645|0xededed-0x0f0f0f,700|645|0xededed-0x0f0f0f,675|638|0x8CCD00-0x0B0F00,657|646|0x27390f-0x161e0f,667|655|0x27390f-0x161e0f"
	elseif status == "normal" then	--状态一般
		statusStr = "666|646|0xB5AD0B-0x0F0F0B,656|646|0xB5AD0B-0x0F0F0B,673|646|0xB5AD0B-0x0F0F0B,665|639|0xB5AD0B-0x0F0F0B,665|652|0xB5AD0B-0x0F0F0B,\
		638|645|0xededed-0x0f0f0f,700|645|0xededed-0x0f0f0f,675|645|0xB5AD0B-0x0F0F0B,658|639|0x36300f-0x1e1e0f,657|653|0x36300f-0x1e1e0f"
	elseif status == "bad" then		--状态较差
		statusStr = "668|646|0xA45D00-0x0F0900,661|639|0xA45D00-0x0F0900,664|650|0xA45D00-0x0F0900,672|642|0xA45D00-0x0F0900,673|652|0xA45D00-0x0F0900,\
		638|645|0xededed-0x0f0f0f,700|645|0xededed-0x0f0f0f,675|654,0xA45D00-0x0F0900,667|636|0x3b2f0f-0x1e110f,658|646|0x3b2f0f-0x1e110f"
	elseif status == "worse" then	--状态极差
		statusStr = "666|646|0xAA0202-0x0F0202,667|636|0xAA0202-0x0F0202,660|644|0xAA0202-0x0F0202,672|645|0xAA0202-0x0F0202,667|651|0xAA0202-0x0F0202,\
		638|645|0xededed-0x0f0f0f,700|645|0xededed-0x0f0f0f,667|654|0xAA0202-0x0F0202,674|636|0x3c1b1a-0x1e1112,659|637|0x3c1b1a-0x1e1112"
	else
		catchError(ERR_PARAM, "get a worong status in getFixStatusPlayers")
	end
	
	local posTb = screen.findColors(
		area,
		scale.scalePos(statusStr),
		CFG.DEFAULT_FUZZY,
		screen.PRIORITY_DEFAULT,
		1999)
	if posTb == nil then	--兼容1.9
		catchError(ERR_PARAM, "more than 99 point, 请将出错的界面截图给作者")
	end
	
	if #posTb == 0 then
		Log("cant find point on: "..status)
		return posTb
	end
	
	if #posTb >= 1999 then	--超过points最大容量1999个点意味着可能没有找完所有位置的状态
		--prt(posTb)
		catchError(ERR_PARAM, "get more than 1999 point, maybe not cath all posation")
		return nil
	end
	
	--去除findColor导致的一个球员有多个点对应的情况，一个球员只保留一个点
	local validPlayers = {}
	for k, v in pairs(posTb) do
		local exsitFlag = false
		--同样位置会有多个点，x、y坐标同时小于offset时判定为同位置的坐标，以20像素/短边750为基准
		local offset = (CFG.EFFECTIVE_AREA[4] - CFG.EFFECTIVE_AREA[2]) / 750 * 20
		for _k, _v in pairs(validPlayers) do
			if math.abs(v.x - _v.x) < offset and math.abs(v.y - _v.y) < offset then
				exsitFlag = true
				break
			end
		end
		
		if exsitFlag == false then
			table.insert(validPlayers, {x = v.x, y = v.y})
		end
	end
	
	--prt(validPlayers)
	
	return validPlayers
end

--获取所有场上球员的状态信息，包括状态和排布位置，分场上球员和替补席位
local function getPlayerStatusInfo(seats)
	local players = {}	--球员的坐标及状态
	local searchArea = {}
	if seats == "field" then	--场上球员分4块，防止findColors的点超过99炸了
		searchArea = Rect(CFG.EFFECTIVE_AREA[1], CFG.EFFECTIVE_AREA[2],
			CFG.EFFECTIVE_AREA[3] - CFG.EFFECTIVE_AREA[1], CFG.EFFECTIVE_AREA[4] - CFG.EFFECTIVE_AREA[2])
	elseif seats == "bench" then		--替补席
		searchArea = Rect(0, 0,
			--CFG.DEV_RESOLUTION.width/4, CFG.EFFECTIVE_AREA[4] - CFG.EFFECTIVE_AREA[2])
			CFG.DST_RESOLUTION.width/4, CFG.EFFECTIVE_AREA[4] - CFG.EFFECTIVE_AREA[2])
	else
		catchError(ERR_PARAM, "get a worong seats in getPlayerStatusInfo")
	end
	
	--状态根据箭头方向分为5种，下，斜下，平，斜上，上，分别对应：极差，差，一般，好，极好，转化为数值对应1-5
	local statusList = {"worse", "bad", "normal", "good", "excellent"}
	for k, v in pairs(statusList) do
		local fixStatusPlayers = getFixStatusPlayers(searchArea, v)
		if #fixStatusPlayers > 0 then
			for _k, _v in pairs(fixStatusPlayers) do
				--prt(_v)
				_v.status = k	--将状态写入对应的球员,用数值表示便于比较
				table.insert(players, _v)	--加入到球员总表
			end
		end
	end
	
	--排序，按从上到下，从左到右的顺序，即优先取y较小值，y相同再取x较小值
	local sortMethod = function(a, b)
		if a.x == nil or a.y == nil or b.x == nil or b.y == nil then
			return
		end
		
		--if a.y == b.y then
		--因不同状态下的首点取值位置不同，同一水平位置的y左边可能有微小区别，容错以6像素/短边750未基准
		if math.abs(a.y - b.y) <= (CFG.EFFECTIVE_AREA[4] - CFG.EFFECTIVE_AREA[2]) / 750 * 5 then
			return a.x < b.x
		else
			return a.y < b.y
		end
	end
	
	table.sort(players, sortMethod)
	
	--Log("get "..#players.." players points")
	
	--统计各状态并打印，用于调试
	local worse, bad, mormal, good, excellent = 0, 0, 0, 0, 0
	for k, v in pairs(players) do
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
		if k == #players then
			Log("worse="..worse)
			Log("bad="..bad)
			Log("mormal="..mormal)
			Log("good="..good)
			Log("excellent="..tostring(excellent))
			Log("get "..#players.." valid players at last")
		end
	end
	
	--prt(players)
	return players
end

--换人
function switchPlayer()
	page.tapWidget("阵容展示", "切换状态")
	--if USER.TASK_NAME == "自动巡回" or USER.TASK_NAME == "手动巡回" then		--跳过巡回赛声望
	--	sleep(1200)
	--	page.tapWidget("阵容展示", "切换状态")
	--end
	sleep(1400)		--点击切换状态之后，会弹出“状态”提示，需等待淡出
	
	--获取场上球员状态
	local fieldPlayers = getPlayerStatusInfo("field")
	if #fieldPlayers ~= 11 then
		sleep(500)
		fieldPlayers = getPlayerStatusInfo("field")		--弹出“状态”提示未完全消失，兼容一下
		if #fieldPlayers ~= 11 then
			catchError(ERR_PARAM, "cant get 11 players in field, abort switchPlayer!")
			dialog("cant get 11 players in field, abort switchPlayer!", 5)
			return
		end
	end
	
	page.tapWidget("阵容展示", "替补席")
	sleep(500)
	
	--获取替补状态
	local benchPlayers = getPlayerStatusInfo("bench")
	if #benchPlayers ~= 7 then
		catchError(ERR_PARAM, "cant get 7 players in bench! "..#benchPlayers)
		dialog("cant get 11 players in field, abort switchPlayer!", 5)
		return
	end
	
	
	--将用户设置的换人位置对应关系写入benchPlayers
	if #USER.SUBSTITUTE_INDEX_LIST > 0 then
		for k, v in pairs(benchPlayers) do
			v.fieldIndex = USER.SUBSTITUTE_INDEX_LIST[k].fieldIndex
			v.substituteCondition = USER.SUBSTITUTE_INDEX_LIST[k].substituteCondition
		end
	else
		catchError(ERR_WARNING, "CFG.SUBSTITUTE_INDEX_LIST is nil")
		return
	end
	--prt(benchPlayers)
	
	for k, v in pairs(benchPlayers) do		--换人
		local substituteFlag = false	--是否换过人标志
		if v.fieldIndex ~= 0 then
			if v.substituteCondition == 0 then	--主力为极差的时候才换
				if fieldPlayers[v.fieldIndex].status == 1 and v.status > 1 then
					substituteFlag = true
					slide(v.x, v.y, fieldPlayers[v.fieldIndex].x, fieldPlayers[v.fieldIndex].y)
				end
			else	--根据状态档次替换
				if v.status - fieldPlayers[v.fieldIndex].status >= v.substituteCondition then
					substituteFlag = true
					slide(v.x, v.y, fieldPlayers[v.fieldIndex].x, fieldPlayers[v.fieldIndex].y)
				end
			end
			sleep(300)
			
			if k < #benchPlayers and substituteFlag then	--换人了需要再次调出替补名单, 除开最后一次
				page.tapWidget("阵容展示", "替补席")
				sleep(500)
			end
		end
		
		if k == #benchPlayers and substituteFlag == false then	--最后一次没换过人需要退出替补名单
			tap(CFG.DST_RESOLUTION.width/2, CFG.DST_RESOLUTION.height/2)
		end
	end
end

--续约
local function selectExpiredPlayer()
	sleep(400)
	
	local expiredPlayerFirstHalf = {}
	local expiredPlayerLatterHalf = {}
	
	local posTb = screen.findColors(
		scale.getAnchorArea("ABS"),
		scale.scalePos("78|242|0xffffff,89|254|0xffffff,245|190|0xffffff,245|182|0xff3b2f,233|196|0xff3b2f,258|195|0xff3b2f,245|214|0xff3b2f"),
		CFG.DEFAULT_FUZZY,
		screen.PRIORITY_DEFAULT,
		1999)
	if posTb == nil then	--兼容1.9
		catchError(ERR_PARAM, "more than 99 point, cant find all point")
	end
	
	if #posTb >= 1999 then
		catchError(ERR_PARAM, "more than 1999 point, cant find all point")
	end
	
	for _, v in pairs(posTb) do
		local exsitFlag = false
		for _, _v in pairs(expiredPlayerFirstHalf) do
			if math.abs(v.x - _v.x) < 20 * CFG.SCALING_RATIO and math.abs(v.y - _v.y) < 20 * CFG.SCALING_RATIO then
				exsitFlag = true
				break
			end
		end
		
		if exsitFlag == false then
			table.insert(expiredPlayerFirstHalf, v)
			tap(v.x, v.y, 100)
			sleep(400)
		end
	end
	--prt(expiredPlayerFirstHalf)
	
	if #expiredPlayerFirstHalf == 3 or #expiredPlayerFirstHalf == 6 then
		ratioSlide(20, 620, 20, 120) --滑动替补至下半部分
		Log("slide LatterHalf")
		sleep(1200)
		local posTb = screen.findColors(
			scale.getAnchorArea("ABS"),
			scale.scalePos("78|242|0xffffff,89|254|0xffffff,245|190|0xffffff,245|182|0xff3b2f,233|196|0xff3b2f,258|195|0xff3b2f,245|214|0xff3b2f"),
			CFG.DEFAULT_FUZZY,
			screen.PRIORITY_DEFAULT,
			999)
		if #posTb >= 999 then
			catchError(ERR_PARAM, "more than 999 point, cant find all point 2")
		end
		
		for _, v in pairs(posTb) do
			local exsitFlag = false
			for _, _v in pairs(expiredPlayerLatterHalf) do
				if math.abs(v.x - _v.x) < 20 * CFG.SCALING_RATIO and math.abs(v.y - _v.y) < 20 * CFG.SCALING_RATIO then
					exsitFlag = true
					break
				end
			end
			
			if exsitFlag == false then
				table.insert(expiredPlayerLatterHalf, v)
				tap(v.x, v.y)
				sleep(400)
			end
		end
		--prt(expiredPlayerLatterHalf)
	end
	Log("selected all players")
end

--续约球员
function refreshContract()
	sleep(200)
	if page.isExsitNavigation("comfirm") then	--可能先检测到球员合同失效，再弹出合同失效的提示
		page.tapNavigation("comfirm")
	end
	
	--已被系统整合
	--selectExpiredPlayer()
	
	sleep(500)
	execCommonWidgetQueue({"球员续约-点击签约", "球员续约-续约", "付款确认"})
	Log("done 签约")
	sleep(500)
	
	local startTime = os.time()
	while true do
		if page.isExsitNavigation("comfirm") then
			page.tapNavigation("comfirm")
		end
		
		if page.isExsitNavigation("back") then	--在比赛开始界面续约，需要返回
			page.tapNavigation("back")
			break
		end
		
		if page.isExsitNavigation("next") then	--在比赛结束后续约
			Log("exit here")
			break
		end
		
		if os.time() - startTime > CFG.DEFAULT_TIMEOUT then
			catchError(ERR_TIMEOUT, "time out in end refreshContract")
		end
		
		sleep(200)
	end
end

--遇到稳定的(500ms处于checked状态)staticPage后退出，否则遇到comfirm进行点击跳过
function skipComfirm(staticPage)
	local startTime = os.time()
	while true do
		if page.isExsitNavigation("comfirm") then
			page.tapNavigation("comfirm")
			sleep(500)
			startTime = os.time()
		end
		
		if page.matchPage(staticPage) then
			Log("checked staticPage 1st: "..staticPage)

			sleep(500)
			if page.matchPage(staticPage) then		--排除两个comfirm间过渡时出现checkedPage
				Log("checked staticPage 2rd: "..staticPage)
				break
			end
		end
		
		if os.time() - startTime > CFG.DEFAULT_TIMEOUT then
			catchError(ERR_TIMEOUT, "time out in staticPage: "..staticPage)
		end
		
		sleep(10)
	end
end

--续约未满足条件的教练(满足条件的直接在比赛结束时处理了)
function refreshUnmetCoach(taskPage)
	execCommonWidgetQueue({{"球队异常", 7}})
	
	local startTime = os.time()
	while true do
		--if page.isExsitCommonWidget("球队菜单") then
		if page.matchWidget("阵容展示", "替补席") then		--为了确认过度动画过度完成
			break
		end
		
		if os.time() - startTime > CFG.DEFAULT_TIMEOUT then
			catchError(ERR_TIMEOUT, "time out in wait 球队菜单")
		end
		sleep(200)	
	end
	
	if page.isExsitCommonWidget("教练合约失效") then
		execCommonWidgetQueue({"教练合约失效","教练续约","付款确认"})

		sleep(1200)
		execNavigationQueue({"comfirm", "notice", "back"})
	else		--如果是球员状态异常，置isPlayerRedCard为true，以防止再次进入refreshUnmetCoach流程
		isPlayerRedCard = true
		page.tapNavigation("back")
	end
	
	sleep(500)
end


--国际服不能一键换人，因此需要切换小队
function swichTeam()
	execCommonWidgetQueue({{"球队异常", 7}, "球队菜单", "切换小队"})
	
	local teamPos = {}
	
	local startTime = os.time()
	while true do
		--精神旗，小队
		local posTb = screen.findColors(
			scale.getAnchorArea("T"),
			scale.scalePos("400|172|0xc8faff,364|113|0xc8faff,399|165|0x0028b4,371|109|0x0028b4,430|107|0x0028b4"),
			CFG.DEFAULT_FUZZY
		)
		
		if #posTb > 0 then
			for _, v in pairs(posTb) do
				local exsitFlag = false
				for _, _v in pairs(teamPos) do
					if math.abs(v.x - _v.x) < 50 * CFG.SCALING_RATIO and math.abs(v.y - _v.y) < 50 * CFG.SCALING_RATIO then
						exsitFlag = true
						break
					end
				end
				
				if exsitFlag == false then
					table.insert(teamPos, v)
				end
			end
			table.sort(teamPos, sortPos)
			
			if #teamPos < 2 then
				Log("请确保至少有1，2两个小队")
				dialog("请确保至少有1，2两个小队")
				xmod.exit()
			end
			break
		end
		
		if os.time() - startTime > CFG.DEFAULT_TIMEOUT then
			catchError(ERR_TIMEOUT, "time out in 检测小队")
		end
		
		sleep(200)
	end
	
	--勾，当前选中小队
	local pot = screen.findColor(
		scale.getAnchorArea("B"),
		scale.scalePos("407|601|0x007aff,407|591|0xffffff,397|608|0xffffff,397|592|0x007aff,392|587|0xffffff,434|573|0x007aff,419|573|0xffffff"),
		CFG.DEFAULT_FUZZY
	)
	--prt(teamPos)
	--prt(pot)
	if pot ~= Point.INVALID then
		if math.abs(pot.x - teamPos[1].x) < 100 * CFG.SCALING_RATIO then	--当前选中的是teamPos[1]
			tap(teamPos[2].x, teamPos[2].y)		--切换二队
		elseif math.abs(pot.x - teamPos[2].x) < 100 * CFG.SCALING_RATIO then
			tap(teamPos[1].x, teamPos[1].y)		--切换一队
		else
			Log("当前选中不在一队二队，将切换至一队")
			dialog("当前选中不在一队二队，将切换至一队", 3)
			sleep(800)
			tap(teamPos[1].x, teamPos[1].y)		--切换一队
		end
	else
		dialog("当前选中不在一队二队，将切换至一队", 3)
		sleep(800)
		Log("当前选中不在一队二队，将切换至一队")
		tap(teamPos[1].x, teamPos[1].y)		--切换一队
	end

	execCommonWidgetQueue({"设为主力阵容"})
	
	page.tapNavigation("back")
	sleep(1000)
	local startTime = os.time()
	while true do
		if page.isExsitCommonWidget("球队菜单") then		--确保back成功
			sleep(200)
			break
		end
		
		if os.time() - startTime > CFG.DEFAULT_TIMEOUT then
			catchError(ERR_TIMEOUT, "time out in swichTeam back")
		end
		sleep(200)
	end
	
	local pot = screen.findColor(
		scale.getAnchorArea("A"),
		scale.scalePos("791|463|0xffffff,778|468|0xff3b2f,790|455|0xff3b2f,803|469|0xff3b2f,791|482|0xff3b2f"),
		CFG.DEFAULT_FUZZY
	)
	if pot ~= Point.INVALID then
		Log("切换小队成功，但切换后的小队也有禁赛的队员或者合同不足的队员，二次续约！")
		
		local prevPot = Point.INVALID
		while true do
			local pot = screen.findColor(
				scale.getAnchorArea("A"),
				scale.scalePos("791|463|0xffffff,778|468|0xff3b2f,790|455|0xff3b2f,803|469|0xff3b2f,791|482|0xff3b2f"),
				CFG.DEFAULT_FUZZY
			)
			if prevPot ~= Point.INVALID and pot == prevPot then
				dialog("切换小队成功，但切换后的小队仍然有禁赛，终止必死啊！\n请检查是否有重复球员!")
				xmod.exit()
			end
			
			if pot ~= Point.INVALID then
				tap(pot.x, pot.y)
				prevPot = pot
				sleep(200)
				execCommonWidgetQueue({"开始前续约","付款确认"})
				sleep(200)
				execNavigationQueue({"comfirm","notice"})
			else
				break
			end
			
			sleep(200)
		end
	end
	
	page.tapNavigation("back")
	sleep(500)
	--dialog("")
	Log("swiched team")
end

function skipReplay()
	local x = CFG.DST_RESOLUTION.width - 150 * CFG.SCALING_RATIO
	local y = 150 * CFG.SCALING_RATIO
	Log("try skip replay!")
	tap(x, y)
end

function genAssignScoutStr(star, feature)
	local first = "0xffffff"

	local starSelected = "0xfecb00"
	local starDeselect = "0xb1b1b1"
	
	local fColors = {}
	fColors.league = "0xf55600"
	fColors.area = "0xff9600"
	fColors.position = "0x718500"
	fColors.abilities = "0x007003"
	fColors.tactics = "0x00926a"
	fColors.age = "0x008efb"
	fColors.height = "0x4b00c6"
	fColors.foot = "0x004eff"
	
	if fColors[feature] == nil then
		return nil
	end
	
	local pos = {{116,226}, {116,244}, {105,232}, {192,197}, {208,187}, {227,183}, {246,187}, {261,197}, {311,198}, {335,224}}
	local concatColors = function(color, index)
		if index > #pos then
			return nil
		end
		
		local tmp = ""
		for k, v in pairs(pos) do
			if index == k then
				tmp = string.format("%s|%s|%s,", v[1], v[2], color)
				break
			end
		end

		return tmp
	end
	
	local colors = ""
	for i = 1, 5, 1 do
		if i <= star then
			colors = colors..concatColors(starSelected, 3 + i)
		else
			colors = colors..concatColors(starDeselect, 3 + i)
		end
	end
	
	colors = colors..concatColors(first, 1)..concatColors(first, 2)..concatColors(first, 3)
	colors = colors..concatColors(fColors[feature], 9)..concatColors(fColors[feature], 10)
	colors = string.sub(colors, 1, -2)
	
	--Log(colors)
	return colors
end

function convertScoutFeature(index)
	if index == 1 then
		return "league"
	elseif index == 2 then
		return "area"
	elseif index == 3 then
		return "position"
	elseif index == 4 then
		return "abilities"
	elseif index == 5 then
		return "tactics"
	elseif index == 6 then
		return "age"
	elseif index == 7 then
		return "height"
	elseif index == 8 then
		return "foot"
	else
		catchError(ERR_PARAM, "wrong index in convertFeature")
	end
end
