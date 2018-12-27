-- config.lua
-- Author: cndy1860
-- Date: 2018-12-24
-- Descrip: 界面特征与判定

local modName = "page"
local M = {}
_G[modName] = M
package.loaded[modName] = M

M.pageList = {
	{
		tag = "其他",
		widgetList = {
			{
				tag = "玩家信息",
				enable = true,
				anchor = "LM",
				srcPos = "343|308|0xffffff,343|315|0x007aff,324|312|0x007aff,363|313|0x007aff,324|355|0x007aff,362|355|0x007aff",
				dstPos = "",
				dstArea = Rect(0, 0, 0, 0)
			},
			{
				tag = "游戏帮助",
				enable = true,
				anchor = "LB",
				srcPos = "343|308|0xffffff,343|315|0x007aff,324|312|0x007aff,363|313|0x007aff,324|355|0x007aff,362|355|0x007aff",
				dstPos = "",
				dstArea = Rect(0, 0, 0, 0)
			},
			{
				tag = "设置",
				enable = true,
				anchor = "RM",
				srcPos = "962|334|0x007aff,1009|352|0x007aff,1008|315|0x007aff,989|318|0xffffff,974|334|0xffffff,989|348|0xffffff",
				dstPos = "",
				dstArea = Rect(0, 0, 0, 0)
			},
			{
				tag = "支持",
				enable = true,
				anchor = "RB",
				srcPos = "985|575|0x007aff,1016|575|0x007aff,1017|594|0x007aff,993|589|0xffffff,965|606|0xffffff,979|598|0x007aff",
				dstPos = "",
				dstArea = Rect(0, 0, 0, 0)
			},
		},
		--pageNext = {
		--	srcPos = "",
		--	dstPos = "",
		--	dstArea = Rect(0, 0, 0, 0),
		--	},
	},
	{
		tag = "比赛",
		widgetList = {
			{
				tag = "活动模式",
				enable = true,
				anchor = "LM",
				srcPos = "331|312|0x007aff,356|311|0x007aff,326|323|0xffffff,361|322|0xffffff,343|348|0x007aff,338|354|0xffffff,350|354|0xffffff,344|362|0x007aff",
				dstPos = "",
				dstArea = Rect(0, 0, 0, 0)
			},
			{
				tag = "联赛",
				enable = true,
				anchor = "LB",
				srcPos = "327|579|0x007aff,316|569|0xffffff,358|579|0x007aff,368|569|0xffffff,336|611|0x007aff,327|619|0xffffff,361|617|0xffffff,353|609|0x007aff",
				dstPos = "",
				dstArea = Rect(0, 0, 0, 0)
			},
			{
				tag = "线上对战",
				enable = true,
				anchor = "RM",
				srcPos = "985|310|0x007aff,987|302|0xffffff,1005|324|0xffffff,997|334|0x007aff,982|332|0x007aff,974|343|0xffffff",
				dstPos = "",
				dstArea = Rect(0, 0, 0, 0)
			},
			{
				tag = "本地比赛",
				enable = true,
				anchor = "RB",
				srcPos = "979|581|0xffffff,991|571|0x007aff,1007|601|0xffffff,1003|614|0x007aff,989|611|0xffffff,977|614|0x007aff,992|595|0x007aff",
				dstPos = "",
				dstArea = Rect(0, 0, 0, 0)
			},
		},
	},
	{
		tag = "线上对战",
		widgetList = {
			{
				tag = "控制球员",
				enable = true,
				anchor = "LM",
				srcPos = "293|346|0x007aff,297|408|0x007aff,285|371|0x007aff,300|371|0x007aff,292|357|0xf8f9fb,277|390|0xf8f9fb,308|389|0xf8f9fb",
				dstPos = "",
				dstArea = Rect(0, 0, 0, 0)
			},
			{
				tag = "自动比赛",
				enable = true,
				anchor = "MTB",
				srcPos = "668|346|0x007aff,661|372|0x007aff,676|370|0x007aff,668|356|0xf8f9fb,673|408|0x007aff,551|116|0xe94269,655|391|0xf8f9fb",
				dstPos = "",
				dstArea = Rect(0, 0, 0, 0)
			},
			{
				tag = "在线比赛",
				enable = true,
				anchor = "RM",
				srcPos = "1039|343|0xf8f9fb,1038|357|0x007bfd,1018|374|0x007bfd,1010|375|0xf8f9fb,1063|392|0x007bfd,1068|399|0xf8f9fb,1035|377|0x007bfd,1051|375|0x007bfd",
				dstPos = "",
				dstArea = Rect(0, 0, 0, 0)
			},
		},
	},
	{
		tag = "天梯教练模式",
		widgetList = {
			{
				tag = "球队管理",
				enable = true,
				anchor = "LB",
				srcPos = "71|406|0x0079fd,63|406|0xffffff,103|405|0x0079fd,109|402|0xffffff,111|438|0x12a42b,111|442|0x12a42b",
				dstPos = "",
				dstArea = Rect(0, 0, 0, 0)
			},
			{
				tag = "赛季信息",
				enable = true,
				anchor = "T",
				srcPos = "280|101|0x1f1f1f,269|137|0x1f1f1f,885|99|0x1f1f1f,893|135|0x1f1f1f,792|119|0xfc3979,468|119|0x1f1f1f",
				dstPos = "",
				dstArea = Rect(0, 0, 0, 0)
			},
			{
				tag = "奖励信息",
				enable = true,
				anchor = "R",
				srcPos = "958|103|0x1f1f1f,1286|102|0x1f1f1f,958|623|0x1f1f1f,1283|621|0x1f1f1f,980|261|0x363636,1261|134|0x363636",
				dstPos = "",
				dstArea = Rect(0, 0, 0, 0)
			},
		},
	},	
	{
		tag = "匹配对手",
		widgetList = {
			{
				tag = "特征",
				enable = true,
				anchor = "B",
				srcPos = "272|468|0xff9500,920|468|0xff9500,658|607|0xffffff,644|612|0x7fa7bb-0x644535,701|612|0x9a6751-0x223135,1131|708|0x1270e3-0x13091a",
				dstPos = "",
				dstArea = Rect(0, 0, 0, 0)
			},
		},
	},
	{
		tag = "阵容展示",
		widgetList = {
			{
				tag = "球队信息框",
				enable = true,
				anchor = "R",
				srcPos = "1112|384|0xff9500,1069|114|0x1f1f1f,1281|115|0x1f1f1f,1073|624|0x1f1f1f,1276|621|0x1f1f1f",
				dstPos = "",
				dstArea = Rect(0, 0, 0, 0)
			},
			{
				tag = "替补席",
				enable = true,
				anchor = "LM",
				srcPos = "89|405|0x0079fd,63|470|0x0079fd,112|470|0x0079fd,74|447|0xfdfdfd,76|400|0xfdfdfd,114|448|0x0079fd,122|444|0xfdfdfd",
				dstPos = "",
				dstArea = Rect(0, 0, 0, 0)
			},
			{
				tag = "比赛设置",
				enable = true,
				anchor = "LB",
				srcPos = "96|581|0xfdfdfd,90|586|0x007aff,101|586|0x007aff,91|575|0x007aff,100|575|0x007aff,82|581|0xfdfdfd,109|580|0xfdfdfd",
				dstPos = "",
				dstArea = Rect(0, 0, 0, 0)
			},
		},
	},
	{
		tag = "比赛中",
		widgetList = {
			{
				tag = "比赛信息",
				enable = true,
				anchor = "LT",
				srcPos = "39|64|0x1ce0dc-0x171f23,186|68|0x1ce0dc-0x171f23,223|83|0xf1fcf9-0x0c0306,237|84|0xf1fcf9-0x0c0306,275|65|0x1bd194-0x172e2a,420|67|0x1bd194-0x172e2a",
				dstPos = "",
				dstArea = Rect(0, 0, 0, 0)
			},
		},
	},
	{
		tag = "全场统计",
		widgetList = {
			{
				tag = "技术统计",
				enable = true,
				anchor = "B",
				--包含了返回键的蓝色，中场统计的没有返回
				srcPos = "533|632|0x16e9da-0x090a05,562|632|0x1f3237-0x080807,773|632|0x1f3237-0x080807,800|632|0x1feda8-0x141216,\
				446|664|0x354c44-0x1f2322,886|664|0x354c44-0x1f2322,188|714|0x1270e3-0x13091a,1118|713|0x1270e3-0x13091a",
				dstPos = "",
				dstArea = Rect(0, 0, 0, 0)
			},
		},
	},
	{
		tag = "终场比分",
		widgetList = {
			{
				tag = "六子选项",
				enable = true,
				anchor = "A",
				srcPos = "49|296|0xffffff,50|635|0xffffff,1277|625|0xffffff,1231|301|0xffffff,553|340|0x0079fd,956|543|0x12a42b,948|342|0x12a42b,513|545|0x12a42b",
				dstPos = "",
				dstArea = Rect(0, 0, 0, 0)
			},
		},
	},
	{
		tag = "段位变化",
		widgetList = {
			{
				tag = "3/5&下一步",
				enable = true,
				anchor = "B",
				srcPos = "904|593|0xffffff,902|599|0x4c4c4b-0x4d4c4b,897|647|0xffffff,899|637|0x3d531c-0x080b05,1108|707|0x0079fd,1133|707|0x0079fd",
				dstPos = "",
				dstArea = Rect(0, 0, 0, 0)
			},
		},
	},
}

--公共导航控件，如返回，下一步，确认，取消
M.navigationList = {
	{
		tag = "next",
		enable = true,
		anchor = "CRB",
		srcPos = "1130|732|0x1270e3-0x13091a,1127|702|0x1270e3-0x13091a,1102|703|0x1270e3-0x13091a,1088|733|0x1270e3-0x13091a",
		dstPos = "",
		dstArea = Rect(
			CFG.EFFECTIVE_AREA[1] + (CFG.EFFECTIVE_AREA[3] - CFG.EFFECTIVE_AREA[1]) * 3 / 4,
			CFG.EFFECTIVE_AREA[2] + (CFG.EFFECTIVE_AREA[4] - CFG.EFFECTIVE_AREA[2]) * 7 / 8,
			CFG.EFFECTIVE_AREA[3] - (CFG.EFFECTIVE_AREA[1] + (CFG.EFFECTIVE_AREA[3] - CFG.EFFECTIVE_AREA[1]) * 3 / 4),
			CFG.EFFECTIVE_AREA[4] - (CFG.EFFECTIVE_AREA[2] + (CFG.EFFECTIVE_AREA[4] - CFG.EFFECTIVE_AREA[2]) * 7 / 8)
		),
	},
}


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
	Log("try match page : "..pageTag)
	for _, v in pairs(M.pageList) do
		if v.tag == pageTag then
			if matchWidgets(v.widgetList) then
				Log("--------matched page: "..pageTag)
				return true
			else
				Log("cant match page: "..pageTag)
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

function M.tapNext()
	for _, v in pairs(M.navigationList) do
		if v.tag == "next" then
			Log("found next action")
			prt(v)
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

local function initWidgets()
	for k, v in pairs(M.pageList) do
		for _k, _v in pairs(v.widgetList) do
			if _v.enable and _v.srcPos ~= nil and string.len(_v.srcPos) > 0 then
				_v.dstPos = scale.scalePos(_v.srcPos)
				_v.dstArea = scale.getAnchorArea(_v.anchor)
			end
		end
	end
end

local function initNavigations()
	for _, v in pairs(M.navigationList) do
		if v.enable and v.srcPos ~= nil and string.len(v.srcPos) > 0 then
			v.dstPos = scale.scalePos(v.srcPos)
		end
	end
	
	for _, v in pairs(M.pageList) do
		if v.pageNext ~= nil and v.srcPos ~= nil and string.len(v.srcPos) > 0 then
			v.dstPos = scale.scalePos(v.srcPos)
			v.dstArea = scale.getAnchorArea(v.anchor)
		end
	end
end

initWidgets()
initNavigations()
