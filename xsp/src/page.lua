-- page.lua
-- Author: cndy1860
-- Date: 2018-12-24
-- Descrip: 界面特征判定相关

local modName = "page"
local M = {}
_G[modName] = M
package.loaded[modName] = M

--页面列表，由project/projPage导入
M.pageList = {}

--公共导航控件，由project/projPage导入，如下一步、返回、确认、取消、通知
M.navigationList = {}

--公共导航控件优先级，由于调整navigationList中控件检测的优先级，由project/projPage导入
M.navigationPriorityList = {}

--公共控件，由project/projPage导入
M.commonWidgetList = {}

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
					if not CFG.CACHING_MODE or _v.matchPos == nil or not _v.caching then
						local pos = screen.findColor(_v.dstArea, _v.dstPos, _v.fuzzy or CFG.DEFAULT_FUZZY)
						if pos ~= Point.INVALID then
							--Log("match widget: [".._v.tag.."] success!")
							return true
						else
							--Log("match widget: [".._v.tag.."] fail!")
							return false
						end
					else
						if screen.matchColors(_v.matchPos, _v.fuzzy or CFG.DEFAULT_FUZZY) then
							--Log("matchPos widget: [".._v.tag.."] success!")
							return true
						else
							--Log("matchPos widget: [".._v.tag.."] fail!")
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

--检测当前界面匹配情况，不去重，主要用于测试界面，不缓存
function M.checkPage()
	local cnt = 0
	for _, v in pairs(M.pageList) do
		local checked = false
		--Log("try check page : "..v.tag)
		for _, _v in pairs(v.widgetList) do
			if _v.enable == true then
				local pot = screen.findColor(_v.dstArea, _v.dstPos, _v.fuzzy or CFG.DEFAULT_FUZZY)
				if pot == Point.INVALID then
					checked = false
					--Log("cant find widget: ".._v.tag)
					break
				else
					checked = true
				end
			end
		end
		
		if checked then
			Log("-------checked page: "..v.tag)
			cnt = cnt + 1
		end
	end
	
	if cnt == 0 then
		Log("not checked any page!")	
	end
end

--匹配当前界面是否为指定的page
function M.matchPage(pageTag)
	--Log("try match page : "..pageTag)
	for _, v in pairs(M.pageList) do
		if v.tag == pageTag then
			for _, _v in pairs(v.widgetList) do
				if _v.enable then
					if not CFG.CACHING_MODE or _v.matchPos == nil or not _v.caching then		--不存在缓存过的matchPos，使用找色
						local pot = screen.findColor(_v.dstArea, _v.dstPos, _v.fuzzy or CFG.DEFAULT_FUZZY)
						if pot == Point.INVALID then
							--Log("cant find widget: ".._v.tag)
							return false
						else
							--Log("----find widget: ".._v.tag.."on page: "..v.tag)
						end
					else							--存在缓存过的matchPos，使用比色
						if not screen.matchColors(_v.matchPos, _v.fuzzy or CFG.DEFAULT_FUZZY) then
							--Log("cant match widget: ".._v.tag)
							return false
						else
							--Log("----match widget: ".._v.tag)
						end
					end
				end
			end
			
			break
		end
	end
	
	return true
end

--获取当前界面，缓存
function M.getCurrentPage(forceGlobalPage)
	for _, v in pairs(M.pageList) do
		if v.enable or forceGlobalPage then
			local matched = true
			local storeItems = {}
			
			for _, _v in pairs(v.widgetList) do
				if _v.enable then
					if not CFG.CACHING_MODE or _v.matchPos == nil or not _v.caching then		--不存在缓存过的matchPos，使用找色
						local pot = screen.findColor(_v.dstArea, _v.dstPos, _v.fuzzy or CFG.DEFAULT_FUZZY)
						if pot == Point.INVALID then
							--Log("cant find widget: ".._v.tag)
							matched = false
							break
						else
							--Log("----find widget: ".._v.tag.."on page: "..v.tag)
							if CFG.CACHING_MODE and _v.caching then		--先临时缓存，确定所有控件完全匹配后再缓存
								--prt(pot)
								--prt(scale.offsetPos(_v.dstPos, pot))
								table.insert(storeItems, {string.format("page-%s-%s", v.tag, _v.tag), scale.offsetPos(_v.dstPos, pot)})
							end
						end
					else							--存在缓存过的matchPos，使用比色
						if not screen.matchColors(_v.matchPos, _v.fuzzy or CFG.DEFAULT_FUZZY) then
							--Log("cant match widget: ".._v.tag)
							matched = false
							break
						else
							--Log("----matched widget: ".._v.tag)
						end
					end
				end
			end
			
			--页面控件完全匹配，开始缓存
			if matched then
				if #storeItems > 0 then
					for k, v in pairs(storeItems) do
						storage.put(v[1], v[2])
						Log("ready storge "..v[1])
					end
					storage.commit()	--缓存
					
					for _, _v in pairs(v.widgetList) do	--copy到对应的matchPos
						if _v.matchPos == nil and _v.caching then
							local key = string.format("page-%s-%s", v.tag, _v.tag)
							for _, __v in pairs(storeItems) do
								if __v[1] == key then
									_v.matchPos = __v[2]
									--Log("set new matchPos on: "..key)
									break
								end
							end
						end
					end
				end
				
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
				
				--当在tapNext中找不到next的时候，可能是由于弹出了其他导航
				if os.time() - startTime >= 5 then
					if not M.isExsitNavigation("next") then
						M.tryNavigation()
					end
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

--检测导航控件，不去重，用于测试
function M.checkNavigation()
	local flag = false
	for _, v in pairs(M.navigationList) do
		local pot = screen.findColor(v.dstArea, v.dstPos, CFG.DEFAULT_FUZZY)
		if pot ~= Point.INVALID then
			flag = true
			Log("checked navigation: "..v.tag)
		end
	end
	
	if not flag then
		Log("not checked any navigation!")
	end
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
				if not CFG.CACHING_MODE or _v.matchPos == nil or not _v.caching then
					local pot = screen.findColor(_v.dstArea, _v.dstPos, CFG.DEFAULT_FUZZY)
					if pot ~= Point.INVALID then
						Log("Exsit find Navigation [".._v.tag.."], try execute it!")
						--dialog("test")
						screen.keep(true)	--刷新画面，防止界面过渡时，先出现局部的导航（但getCurrentPage为nil）时直接判定为导航了
						sleep(200)
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
						
						if CFG.CACHING_MODE and _v.caching then
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
						screen.keep(true)	--刷新画面，防止界面过渡时，先出现局部的导航（但getCurrentPage为nil）时直接判定为导航了
						sleep(200)
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
							local x, y = scale.getFirstPot(_v.matchPos)
							tap(x, y)	--点击导航按钮
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

--检测公共控件，不去重，用于测试
function M.checkCommonWidget()
	local flag = false
	for _, v in pairs(M.commonWidgetList) do
		local pot = screen.findColor(v.dstArea, v.dstPos, CFG.DEFAULT_FUZZY)
		if pot ~= Point.INVALID then
			flag = true
			Log("checked commonWidget: "..v.tag)
		end
	end
	
	if not flag then
		Log("not checked any commonWidget!")
	end
end

--点击某一个公共控件，不缓存，可指定点击第几个点
function M.tapCommonWidget(commTag, potIndex)
	for _, v in pairs(M.commonWidgetList) do
		if v.tag == commTag then
			local startTime = os.time()
			while true do
				local pot = screen.findColor(v.dstArea, v.dstPos, CFG.DEFAULT_FUZZY)
				if pot ~= Point.INVALID then
					Log("tapCommonWidget: "..commTag..(potIndex or ""))
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
					catchError(ERR_TIMEOUT, "cant catch tapCommonWidget: ["..commTag.."]")
				end
				sleep(100)
			end
		end
	end
end

function M.isExsitCommonWidget(commTag)
	for _, v in pairs(M.commonWidgetList) do
		if v.tag == commTag then
			local pot = screen.findColor(v.dstArea, v.dstPos, CFG.DEFAULT_FUZZY)
			if pot ~= Point.INVALID then
				Log("isExsit commTag ["..v.tag.."] here")
				
				return true
			else
				break
			end
		end
	end
	
	return false
end


--将用户界面插入当前pageList总表
local function loadPages(_pageList)
	if _pageList == nil or #_pageList == 0 then
		catchError(ERR_PARAM, "err _pageList")
	end
	
	for _, v in pairs(_pageList) do
		table.insert(M.pageList, v)
	end
	
	Log("----Load pages done!")
end

--将用全局导航界面插入当前navigationList总表
local function loadNavigations(_navigationList)
	if _navigationList == nil or #_navigationList == 0 then
		catchError(ERR_PARAM, "err _navigationList")
	end
	
	for _, v in pairs(_navigationList) do
		table.insert(M.navigationList, v)
	end
	
	Log("----Load navigationList done!")
end

--将用全局导航界面优先级插入当前navigationPriorityList总表
local function loadNavigationsPriority(_navigationPriorityList)
	if _navigationPriorityList == nil or #_navigationPriorityList == 0 then
		catchError(ERR_PARAM, "err _navigationPriorityList")
	end
	
	for _, v in pairs(_navigationPriorityList) do
		table.insert(M.navigationPriorityList, v)
	end
	
	Log("----Load navigationPriorityList done!")
end

--将公用共控件插入当前commonWidgetList总表
local function loadCommonWidgets(_commonWidgetList)
	if _commonWidgetList == nil or #_commonWidgetList == 0 then
		catchError(ERR_PARAM, "err _commonWidgetList")
	end
	
	for _, v in pairs(_commonWidgetList) do
		table.insert(M.commonWidgetList, v)
	end
	
	Log("----Load commonWidgetList done!")
end


--初始化页面控件，将srcPos缩放至dstPos
local function initPages()
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
				if _v.caching == nil then
					_v.caching = true
				end
				
				--prt(CFG.CACHING_MODE)
				--prt(CFG.matchPos)
				--prt(_v.caching)
				if CFG.CACHING_MODE and _v.matchPos == nil and _v.caching then
					local key = string.format("page-%s-%s", v.tag, _v.tag)
					local value = storage.get(key, "NULL")
			
					if value ~= "NULL" then
						--Log(key.." : "..value)
						_v.matchPos = value
						Log("load page matchPos: "..v.tag.."-".._v.tag)
						Log(_v.matchPos.."  total"..string.len(_v.matchPos))
					end
				end
			end
		end
	end
	
	Log("----initPages done!")
end

--初始化导航控件，将srcPos缩放至dstPos，如下一步、确定、通知(容易出错，禁止缓存)
local function initNavigations()
	for _, v in pairs(M.navigationList) do
		if v.srcPos ~= nil and string.len(v.srcPos) > 0 then
			if v.dstPos == nil then
				v.dstPos = scale.scalePos(v.srcPos)
			end
			if v.dstArea == nil then
				v.dstArea = scale.getAnchorArea(v.anchor)
			end
			--[[if v.caching == nil then
			v.caching = true
		end
		
		if CFG.CACHING_MODE and v.matchPos == nil and v.caching then
			local key = string.format("navigation-%s", v.tag)
			local value = storage.get(key, "NULL")
			if value ~= "NULL" then
				v.matchPos = value
				Log("load navigation matchPos: "..v.tag..":"..v.matchPos)
			end
			end]]
		end
	end
	
	Log("----initNavigations done!")
end

--初始化公共控件
local function initCommonWidgets()
	--全局导航控件
	for _, v in pairs(M.commonWidgetList) do
		if v.srcPos ~= nil and string.len(v.srcPos) > 0 then
			if v.dstPos == nil then
				v.dstPos = scale.scalePos(v.srcPos)
			end
			if v.dstArea == nil then
				v.dstArea = scale.getAnchorArea(v.anchor)
			end
			if v.caching == nil then
				v.caching = true
			end
			
			--[[if CFG.CACHING_MODE and v.matchPos == nil and v.caching then
			local key = string.format("commonWidget-%s", v.tag)
			local value = storage.get(key, "NULL")
			if value ~= "NULL" then
				v.matchPos = value
				Log("load commonWidget matchPos: "..v.tag)
			end
			end]]
		end
	end
	
	Log("----initCommonWidgets done!")
end

--清空界面缓存
function M.dropCache()
	for k, v in pairs(M.pageList) do
		for _k, _v in pairs(v.widgetList) do
			_v.matchPos = nil
			local key = string.format("page-%s-%s", v.tag, _v.tag)
			storage.put(key, "NULL")
		end
	end
	
	for k, v in pairs(M.navigationList) do
		v.matchPos = nil
		local key = string.format("navigation-%s", v.tag)
		storage.put(key, "NULL")
	end
	
	for k, v in pairs(M.commonWidgetList) do
		v.matchPos = nil
		local key = string.format("commonWidget-%s", v.tag)
		storage.put(key, "NULL")
	end
	
	storage.commit()
	Log("dropCache done!")
end

--将pageList、navigationList和navigationPriorityList、commonWidgetList数据导入page对应表中并初始化（缩放坐标），在projPage中调用
function M.loadPagesData(pList, nList, npList, commList)
	loadPages(pList)
	loadNavigations(nList)
	loadNavigationsPriority(npList)
	loadCommonWidgets(commList)
	Log(" ")
	
	if CFG.CACHING_MODE ~= PREV.cacheStatus then
		if not CFG.CACHING_MODE then
			M.dropCache()		--一定要保证在ProjectPage加载了之后执行
			Log("Drop cache yet!")
		end		
	end
	
	--导入数据后初始化界面
	initPages()
	initNavigations()
	initCommonWidgets()
end


