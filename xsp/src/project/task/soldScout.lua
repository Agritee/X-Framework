-- soldScout.lua/废弃
-- Author: cndy1860
-- Date: 2019-07-06
-- Descrip: 一键卖球探

local _task = {
	tag = "一键卖球探",
	processes = {
		{tag = "球探名单"},
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
	local prevScrollPot = Point.ZERO
	
	while true do
		for i = 1, 4, 1 do
			if USER.SCOUT_STAR_LIST[i] == true then
				for j = 1, 8, 1 do
					if USER.SCOUT_FEATURE_LIST[j] == true then
						local posTb = screen.findColors(scale.getAnchorArea("L1/6"), scale.scalePos(genAssignScoutStr(i, convertScoutFeature(j))), 95)
						local scoutPos = {}
						if #posTb > 0 then
							local offset = (CFG.EFFECTIVE_AREA[4] - CFG.EFFECTIVE_AREA[2]) / 750 * 20
							for k, v in pairs(posTb) do
								local exsitFlag = false
								for _k, _v in pairs(scoutPos) do
									if math.abs(v.x - _v.x) < offset and math.abs(v.y - _v.y) < offset then
										exsitFlag = true
										break
									end
								end
								
								if not exsitFlag then
									table.insert(scoutPos, {x = v.x, y = v.y})
									tap(v.x, v.y, 100)
									sleep(100)
									--Log("get star:"..i.." feature:"..convertScoutFeature(j))
								end
							end
						end
					end
				end
			end
		end
		
		ratioSlide(20, 400, 20, 320, 5, 100)
		sleep(200)
		
		local pot = screen.findColor(scale.getAnchorArea("R/8B/4"), scale.scalePos("1328|650|0xa6a6a6,1328|621|0xa6a6a6,1328|588|0xa6a6a6,1315|593|0xe3e3e5,1319|639|0xdfdfe1"))
		prt(pot)
		if pot ~= Point.INVALID then
			if pot == prevScrollPot then		--滑到底后滑块不再移动，返回固定相同坐标
				dialog("警告：已完成球探筛选，即将解约！！！", 5)
				page.tapWidget("球探名单", "解约")
				sleep(500)
				page.tapWidget("球探名单", "解约确认")
				
				xmod.exit()
			else
				prevScrollPot = pot
			end
		end
		
	end
end
insertFunc("球探名单", fn)






--将任务添加至taskList
exec.loadTask(_task)