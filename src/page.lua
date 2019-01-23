-- config.lua
-- Author: cndy1860
-- Date: 2018-12-24
-- Descrip: 界面特征判定相关

local modName = "page"
local M = {}
_G[modName] = M
package.loaded[modName] = M

--页面列表，由task/projPage插入
M.pageList = {}

--公共导航控件，由task/projPage插入，如下一步、返回、确认、取消、通知
M.navigationList = {}

--公共导航控件优先级，由task/projPage插入
M.navigationPriorityList = {}

--根据任务设置page.enable属性，致使非任务流程的界面不参加getCurrentPage，提高效率
function M.setPageEnable(processes)
	for k, v in pairs(M.pageList) do
		v.enable = false
	end
	
	for k, v in pairs(M.pageList) do
		for _k, _v in pairs(processes) do
			if _v.tag == v.tag then
				v.enable = true
				break
			end
		end
	end
end

--匹配单个控件，不受widget.enable值影响，使用matchColors但不缓存数据
function M.matchWidget(pageTag, widgetTag)
	for _, v in pairs(M.pageList) do
		if v.tag == pageTag then
			for _, _v in pairs(v.widgetList) do
				if _v.tag == widgetTag then
					if (not CFG.ALLOW_CACHE) or _v.matchPos == nil or _v.noCache then
						local pos = screen.findColor(_v.dstArea, _v.dstPos, _v.fuzzy or CFG.DEFAULT_FUZZY)
						if pos ~= Point.INVALID then
							Log("match widget: [".._v.tag.."] success!")
							return true
						else
							Log("match widget: [".._v.tag.."] fail!")
							return false
						end
					else
						if screen.matchColors(_v.matchPos, _v.fuzzy or CFG.DEFAULT_FUZZY) then
							Log("matchPos widget: [".._v.tag.."] success!")
							return true
						else
							Log("matchPos widget: [".._v.tag.."] fail!")
							return false
						end
					end
					break
				end
			end
			break
		end
	end
	
	return false
end

--匹配控件列表，缓存
local function matchWidgets(pageTag, widgetList)
	local matchFlag = false
	local storeItems = {}
	for k, v in pairs(widgetList) do
		matchFlag = true
		if v.enable then
			--prt(v)
			if (not CFG.ALLOW_CACHE) or v.matchPos == nil or v.noCache then		--不存在缓存过的matchPos，使用找色
				local pot = screen.findColor(v.dstArea, v.dstPos, v.fuzzy or CFG.DEFAULT_FUZZY)
				if pot == Point.INVALID then
					--Log("cant find widget: "..v.tag)
					return false
				else
					--Log("----find widget: "..v.tag.."on page: "..pageTag)
					if CFG.ALLOW_CACHE and (not v.noCache) then
						table.insert(storeItems, {string.format("widget-%s-%s", pageTag, v.tag), scale.offsetPos(v.dstPos, pot)})
					end
				end
			else							--存在缓存过的matchPos，使用比色
				if not screen.matchColors(v.matchPos, v.fuzzy or CFG.DEFAULT_FUZZY) then
					--Log("cant match widget: "..v.tag)
					return false
				else
					--Log("----match widget: "..v.tag)
				end
			end
		end
	end
	
	if #storeItems > 0 then
		for k, v in pairs(storeItems) do
			storage.put(v[1], v[2])
			Log("store "..v[1])
		end
		storage.commit()
		
		for k, v in pairs(widgetList) do
			if v.matchPos == nil and not v.noCache then
				local key = string.format("widget-%s-%s", pageTag, v.tag)
				for _k, _v in pairs(storeItems) do
					if _v[1] == key then
						local pos = storage.get(key, "")
						if pos ~= "" then
							v.matchPos = pos
							Log("set new matchPos on: "..key)
						end
						break
					end
				end
			end
		end
	end
	
	return matchFlag
end

--匹配当前界面
function M.matchPage(pageTag)
	--Log("try match page : "..pageTag)
	for _, v in pairs(M.pageList) do
		if v.tag == pageTag then
			if matchWidgets(v.tag, v.widgetList) then
				Log("--------matched page: "..pageTag)
				return true
			else
				--Log("cant match page: "..pageTag)
			end
			break
		end
	end
	
	return false
end

--获取当前界面
function M.getCurrentPage(forceGlobalPage)
	if forceGlobalPage then
		for k, v in pairs(M.pageList) do
			if M.matchPage(v.tag) then
				Log("get current page: "..v.tag)
				return v.tag
			end
		end
	else
		for k, v in pairs(M.pageList) do
			if v.enable and M.matchPage(v.tag) then
				Log("get current page: "..v.tag)
				return v.tag
			end
		end
	end
end

--点击页面专属next，不缓存
function M.tapPageNext(pageTag)
	for _, v in pairs(M.pageList) do
		if v.tag == pageTag then
			local startTime = os.time()
			while true do
				local pot = screen.findColor(v.pageNext.dstArea, v.pageNext.dstPos, CFG.DEFAULT_FUZZY)
				if pot ~= Point.INVALID then
					tap(pot.x, pot.y)
					return true
				end
				
				if os.time() - startTime > CFG.DEFAULT_TIMEOUT then
					catchError(ERR_TIMEOUT, "timeout in tapPageNext")
				end
				sleep(100)
			end
		end
	end
	
	catchError(ERR_PARAM, "cant find pageNext action")
end

--点击全局next，不缓存
function M.tapNext()
	for _, v in pairs(M.navigationList) do
		if v.tag == "next" then
			local startTime = os.time()
			while true do
				local pot = screen.findColor(v.dstArea, v.dstPos, v.fuzzy or CFG.DEFAULT_FUZZY)	--高分辨率下有偏色
				--prt(v)
				if pot ~= Point.INVALID then
					Log("found next");
					tap(pot.x, pot.y)
					return
				end
				
				if os.time() - startTime > CFG.DEFAULT_TIMEOUT then
					catchError(ERR_TIMEOUT, "timeout in tapNext")
				end
				sleep(100)
			end
		end
	end
	
	catchError(ERR_PARAM, "cant find comm next action")
end

--点击控件，采用findColor，不缓存
function M.tapWidget(pageTag, widgetTag)
	Log("tapWidget: "..widgetTag.." on page: "..pageTag)
	for _, v in pairs(M.pageList) do
		if v.tag == pageTag then
			for _, _v in pairs(v.widgetList) do
				if _v.tag == widgetTag then
					if _v.dstPos == nil then
						catchError(ERR_PARAM, "nil dstPos in tapWidget")
						return false
					end
					
					--prt(_v)
					local startTime = os.time()
					while true do
						local pot = screen.findColor(_v.dstArea, _v.dstPos, CFG.DEFAULT_FUZZY)
						if pot ~= Point.INVALID then
							tap(pot.x, pot.y, 100)	--点击控件的第一个点
							return true
						end
						
						if os.time() - startTime > CFG.DEFAULT_TIMEOUT then
							catchError(ERR_TIMEOUT, "cant find tapWidget: ["..widgetTag.."] on page: ["..pageTag.."]")
						end
						sleep(100)
					end
				end
			end
		end
	end
	
	catchError(ERR_PARAM, "cant find pageTag or widgetTag")
end

--点击某一个导航控件，不缓存，可指定点击第几个点
function M.tapNavigation(navTag, potIndex)
	for _, v in pairs(M.navigationList) do
		if v.tag == navTag then
			local startTime = os.time()
			while true do
				local pot = screen.findColor(v.dstArea, v.dstPos, CFG.DEFAULT_FUZZY)
				if pot ~= Point.INVALID then
					Log("tapNavigation: "..navTag..(potIndex or ""))
					if potIndex == nil then		--点击控件的第一个点
						tap(pot.x, pot.y)
					else		--点击第potIndex个点
						local posTb = scale.toPointsTable(scale.offsetPos(v.dstPos, pot))
						if potIndex <= #posTb then
							tap(posTb[potIndex][1], posTb[potIndex][2])
						else
							catchError(ERR_PARAM, "potIndex > #posTb")
						end
					end
					return true
				end
				
				if os.time() - startTime > CFG.DEFAULT_TIMEOUT then
					catchError(ERR_TIMEOUT, "cant catch tapWidget: ["..navTag.."]")
				end
				sleep(100)
			end
		end
	end
end

--检测界面是否有导航按钮，有就执行导航动作，缓存
function M.tryNavigation()
	for _, v in pairs(M.navigationPriorityList) do
		for _, _v in pairs(M.navigationList) do
			if v == _v.tag then
				if (not CFG.ALLOW_CACHE) or _v.matchPos == nil or _v.noCache then
					local pot = screen.findColor(_v.dstArea, _v.dstPos, CFG.DEFAULT_FUZZY)
					if pot ~= Point.INVALID then
						Log("Exsit find Navigation [".._v.tag.."], execute it!")
						
						sleep(200)
						screen.keep(true)	--刷新画面，防止界面过渡时，先出现局部的导航（但getCurrentPage为nil）时直接判定为导航了
						local currentPage = page.getCurrentPage()
						if currentPage then
							Log('exsit navigation but need refresh page: '..currentPage)
							return false
						end
						
						if _v.actionFunc ~= nil then	--执行导航actionFunc
							screen.keep(false)		--执行execNavigation.actionFunc可能涉及到界面变化
							_v.actionFunc()
							--screen.keep(true)
						else
							tap(pot.x, pot.y)	--点击导航按钮
						end
						
						if CFG.ALLOW_CACHE and (not _v.noCache) then
							_v.matchPos = scale.offsetPos(_v.dstPos, pot)
							storage.put(string.format("navigation-%s", _v.tag), _v.matchPos)
							storage.commit()
							Log("store "..string.format("navigation-%s", _v.tag))
						end
						
						sleep(CFG.NAVIGATION_DELAY)
						return true
					else
						break
					end
				else
					if screen.matchColors(_v.matchPos, CFG.DEFAULT_FUZZY) then
						Log("Exsit match Navigation [".._v.tag.."], execute it!")
						
						if _v.actionFunc ~= nil then	--执行导航actionFunc
							screen.keep(false)		--执行execNavigation.actionFunc可能涉及到界面变化
							_v.actionFunc()
							--screen.keep(true)
						else
							local tmpTb = scale.toPointsTable(_v.matchPos)
							tap(tmpTb[1][1], tmpTb[1][2])	--点击导航按钮
						end
						
						sleep(CFG.NAVIGATION_DELAY)
						return true
					else
						break
					end
				end
				
			end
		end
	end
	
	return false
end

function M.isExsitNavigation(navigationTag)
	for _, v in pairs(M.navigationList) do
		if v.tag == navigationTag then
			local pot = screen.findColor(v.dstArea, v.dstPos, CFG.DEFAULT_FUZZY)
			if pot ~= Point.INVALID then
				Log("isExsit Navigation ["..v.tag.."] here")
				
				return true
			else
				break
			end	
		end
	end
	
	return false
end


--将用户界面插入当前pageList总表
local function insertPage(_pageList)
	if _pageList == nil or #_pageList == 0 then
		catchError(ERR_PARAM, "err _pageList")
	end
	
	for _, v in pairs(_pageList) do
		table.insert(M.pageList, v)
	end
	
	Log("Insert page done")
end

--将用全局导航界面插入当前navigationList总表
local function insertNavigation(_navigationList)
	if _navigationList == nil or #_navigationList == 0 then
		catchError(ERR_PARAM, "err _navigationList")
	end
	
	for _, v in pairs(_navigationList) do
		table.insert(M.navigationList, v)
	end
	
	Log("Insert navigationList done")
end

--将用全局导航界面优先级插入当前navigationPriorityList总表
local function insertNavigationPriority(_navigationPriorityList)
	if _navigationPriorityList == nil or #_navigationPriorityList == 0 then
		catchError(ERR_PARAM, "err _navigationPriorityList")
	end
	
	for _, v in pairs(_navigationPriorityList) do
		table.insert(M.navigationPriorityList, v)
	end
	
	Log("Insert navigationPriorityList done")
end


--初始化控件，将srcPos缩放至dstPos
local function initWidgets()
	if #M.pageList == 0 then
		catchError(ERR_PARAM, "no exsit pageList data")
	end
	
	for k, v in pairs(M.pageList) do
		for _k, _v in pairs(v.widgetList) do
			if _v.srcPos ~= nil and string.len(_v.srcPos) > 0 then
				if _v.dstPos == nil then
					_v.dstPos = scale.scalePos(_v.srcPos)
				end
				if _v.dstArea == nil then
					_v.dstArea = scale.getAnchorArea(_v.anchor)
				end
				if CFG.ALLOW_CACHE and _v.matchPos == nil then
					local key = string.format("widget-%s-%s", v.tag, _v.tag)
					local value = storage.get(key, "NULL")
					if value ~= "NULL" then
						prt(key)
						prt(value)
						_v.matchPos = value
						Log("load widget matchPos: "..v.tag.."-".._v.tag)
					end
				end
			end
		end
	end
	
	Log("-----------------initWidgets done-----------------")
end

--初始化导航控件，将srcPos缩放至dstPos，如下一步、确定、通知
--实况在高分辨率下的下一步按钮有偏色，取点注意偏色
local function initNavigations()
	--全局导航控件
	for _, v in pairs(M.navigationList) do
		if v.enable and v.srcPos ~= nil and string.len(v.srcPos) > 0 then
			if v.dstPos == nil then
				v.dstPos = scale.scalePos(v.srcPos)
			end
			if v.dstArea == nil then
				v.dstArea = scale.getAnchorArea(v.anchor)
			end
			if CFG.ALLOW_CACHE and v.matchPos == nil then
				local key = string.format("navigation-%s", v.tag)
				local value = storage.get(key, "NULL")
				if value ~= "NULL" then
					v.matchPos = value
					Log("load navigation matchPos: "..v.tag)
				end
			end
		end
	end
	
	Log("-----------------initNavigations done-----------------")
end

function M.dropPageCache()
	for k, v in pairs(M.pageList) do
		for _k, _v in pairs(v.widgetList) do
			_v.matchPos = nil
			local key = string.format("widget-%s-%s", v.tag, _v.tag)
			storage.put(key, "NULL")
		end
	end
	
	for k, v in pairs(M.navigationList) do
		v.matchPos = nil
		local key = string.format("navigation-%s", v.tag)
		storage.put(key, "NULL")
	end
	
	storage.commit()
end

--将pageList、navigationList和navigationPriorityList数据插入page对应表中并初始化（缩放坐标），在projPage中调用
function M.loadPage(pList, nList, npList)
	insertPage(pList)
	insertNavigation(nList)
	insertNavigationPriority(npList)
	
	--插入数据后初始化界面
	initWidgets()
	initNavigations()
end


