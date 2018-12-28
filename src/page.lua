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

--公共导航控件，由task/projPage插入，如返回，下一步，确认，取消
M.navigationList = {}

--匹配控件列表
local function matchWidgets(widgetList)
	local fuz = CFG.DEFAULT_FUZZY
	local matchFlag = false
	
	for k, v in pairs(widgetList) do
		matchFlag = true
		if v.enable then
			--prt(v)
			local pos = screen.findColor(v.dstArea, v.dstPos, fuz)
			if pos == Point.INVALID then
				--Log("cant match widget: "..v.tag)
				return false
			else
				Log("----matched widget: "..v.tag)
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
			if matchWidgets(v.widgetList) then
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
function M.getCurrentPage()
	screen.keep(true)
	for k, v in pairs(M.pageList) do
		if M.matchPage(v.tag) then
			Log("get current page: "..v.tag)
			return v.tag
		end
	end
	screen.keep(false)
end

--检测界面是否有下一步按钮
function M.isExsitNext()
	for _, v in pairs(M.navigationList) do
		if v.tag == "next" then
			Log("exsit next action")
			--prt(v)
			local pot = screen.findColor(v.dstArea, v.dstPos, CFG.DEFAULT_FUZZY)	--高分辨率下有偏色
			if pot ~= Point.INVALID then
				return true
			else
				return false
			end
		end
	end
	
	catchError(ERR_PARAM, "cant find comm next action")	
end

--点击页面专属next
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

--点击全局通用next
function M.tapNext()
	for _, v in pairs(M.navigationList) do
		if v.tag == "next" then
			Log("found next action")
			--prt(v)
			local startTime = os.time()
			while true do
				local pot = screen.findColor(v.dstArea, v.dstPos, CFG.DEFAULT_FUZZY)	--高分辨率下有偏色
				if pot ~= Point.INVALID then
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

--点击控件
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
					
					local startTime = os.time()
					while true do
						local pot = screen.findColor(_v.dstArea, _v.dstPos, CFG.DEFAULT_FUZZY)
						if pot ~= Point.INVALID then
							tap(pot.x, pot.y)	--点击控件的第一个点
							return true
						end
						
						if os.time() - startTime > CFG.DEFAULT_TIMEOUT then
							catchError(ERR_TIMEOUT, "timeout in tapWidget")
						end
						sleep(100)
					end
				end
			end
		end
	end
	
	catchError(ERR_PARAM, "cant find pageTag or widgetTag")
end

--将用户界面插入当前pageList总表
function M.insertPage(_pageList)
	if _pageList == nil or #_pageList == 0 then
		catchError(ERR_PARAM, "err _pageList")
	end
	
	for _, v in pairs(_pageList) do
		table.insert(M.pageList, v)
	end
	
	Log("Insert page done")
end

--将用全局导航界面插入当前navigationList总表
function M.insertNavigation(_navigationList)
	if _navigationList == nil or #_navigationList == 0 then
		catchError(ERR_PARAM, "err _navigationList")
	end
	
	for _, v in pairs(_navigationList) do
		table.insert(M.navigationList, v)
	end
	
	Log("Insert navigationList done")
end

--初始化控件，将srcPos缩放至dstPos
local function initWidgets()
	if #M.pageList == 0 then
		catchError(ERR_PARAM, "no exsit pageList data")
	end
	
	for k, v in pairs(M.pageList) do
		for _k, _v in pairs(v.widgetList) do
			if _v.enable and _v.srcPos ~= nil and string.len(_v.srcPos) > 0 then
				_v.dstPos = scale.scalePos(_v.srcPos)
				_v.dstArea = scale.getAnchorArea(_v.anchor)
			end
		end
	end
	
	Log("initWidgets done")
end

--初始化导航控件，将srcPos缩放至dstPos，如下一步、确定、通知
--实况在高分辨率下的下一步按钮有偏色，取点注意偏色
local function initNavigations()
	--全局导航控件
	for _, v in pairs(M.navigationList) do
		if v.enable and v.srcPos ~= nil and string.len(v.srcPos) > 0 then
			v.dstPos = scale.scalePos(v.srcPos)
		end
	end
	
	--页面专用导航控件
	for _, v in pairs(M.pageList) do
		if v.pageNext ~= nil and v.srcPos ~= nil and string.len(v.srcPos) > 0 then
			v.dstPos = scale.scalePos(v.srcPos)
			v.dstArea = scale.getAnchorArea(v.anchor)
		end
	end
	
	Log("initNavigations done")
end

--初始化放在task/projPage调用，因为必须保证界面数据已经插入pageList才能调用
function M.initPage()
	initWidgets()
	initNavigations()
end


