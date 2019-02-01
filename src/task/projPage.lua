-- projPage.lua
-- Author: cndy1860
-- Date: 2018-12-28
-- Descrip: 开发项目的界面信息，初始化时将插入pageList总表

--备注:
--所有dstArea只有在dstArea == Rect.ZERO时候才会在初始化时进行getAnchorArea，否则使用预设的数据
--所有dstPos只有在dstPos == ""时候才会在初始化时进行scalePos，否则使用预设的数据
--在执行点击widgetList或者进行navigation时，存在actionFunc的时候优先执行actionFunc，否则点击dstPos的第一个点
--page.enable标识当前界面是否加入getCurrentPage判定，在exec.run里根据任务设置（丢掉所有非当前任务的界面）
--widget.enable仅仅标识在matchPage/matchWidgets时，是否作为匹配项，其他操作不受影响，如Init时的缩放、matchWidget、tapWidget

--界面
local _pageList = {
	{
		tag = "其他",
		--[[widgetList = {
			{
				tag = "玩家信息",
				enable = true,
				anchor = "LM",
				srcPos = "343|308|0xffffff,343|315|0x007aff,324|312|0x007aff,363|313|0x007aff,324|355|0x007aff,362|355|0x007aff",
				--dstPos = "",
				--dstArea = Rect.ZERO
			},
			{
				tag = "游戏帮助",
				enable = true,
				anchor = "LB",
				srcPos = "343|308|0xffffff,343|315|0x007aff,324|312|0x007aff,363|313|0x007aff,324|355|0x007aff,362|355|0x007aff",
			},
			{
				tag = "设置",
				enable = true,
				anchor = "RM",
				srcPos = "962|334|0x007aff,1009|352|0x007aff,1008|315|0x007aff,989|318|0xffffff,974|334|0xffffff,989|348|0xffffff",
			},
			{
				tag = "支持",
				enable = true,
				anchor = "RB",
				srcPos = "985|575|0x007aff,1016|575|0x007aff,1017|594|0x007aff,993|589|0xffffff,965|606|0xffffff,979|598|0x007aff",
			},
		},]]
		widgetList = {
			{
				tag = "玩家信息",
				enable = true,
				anchor = "LM",
				srcPos = "343|308|0xf7e7ca,343|315|0xbe913b,324|312|0xbe913b,363|313|0xbe913b,324|355|0xbe913b,362|355|0xbe913b",
			},
			{
				tag = "游戏帮助",
				enable = true,
				anchor = "LB",
				srcPos = "343|308|0xf7e7ca,343|315|0xbe913b,324|312|0xbe913b,363|313|0xbe913b,324|355|0xbe913b,362|355|0xbe913b",
			},
			{
				tag = "设置",
				enable = true,
				anchor = "RM",
				srcPos = "962|334|0xbe913b,1009|352|0xbe913b,1008|315|0xbe913b,989|318|0xf7e7ca,974|334|0xf7e7ca,989|348|0xf7e7ca",
			},
			{
				tag = "支持",
				enable = true,
				anchor = "RB",
				srcPos = "985|575|0xbe913b,1016|575|0xbe913b,1017|594|0xbe913b,993|589|0xf7e7ca,965|606|0xf7e7ca,979|598|0xbe913b",
			},
		},
	},
	{
		tag = "比赛",
		--[[widgetList = {
			{
				tag = "活动模式",
				enable = true,
				anchor = "LM",
				srcPos = "331|312|0x007aff,356|311|0x007aff,326|323|0xffffff,361|322|0xffffff,343|348|0x007aff,338|354|0xffffff,350|354|0xffffff,344|362|0x007aff",
			},
			{
				tag = "联赛",
				enable = true,
				anchor = "LB",
				srcPos = "327|579|0x007aff,316|569|0xffffff,358|579|0x007aff,368|569|0xffffff,336|611|0x007aff,327|619|0xffffff,361|617|0xffffff,353|609|0x007aff",
			},
			{
				tag = "线上对战",
				enable = true,
				anchor = "RM",
				srcPos = "985|310|0x007aff,987|302|0xffffff,1005|324|0xffffff,997|334|0x007aff,982|332|0x007aff,974|343|0xffffff",
			},
			{
				tag = "本地比赛",
				enable = true,
				anchor = "RB",
				srcPos = "979|581|0xffffff,991|571|0x007aff,1007|601|0xffffff,1003|614|0x007aff,989|611|0xffffff,977|614|0x007aff,992|595|0x007aff",
			},
		},]]
		widgetList = {
			{
				tag = "活动模式",
				enable = true,
				anchor = "LM",
				srcPos = "331|312|0xbe913b,356|311|0xbe913b,326|323|0xf7e7ca,361|322|0xf7e7ca,343|348|0xbe913b,338|354|0xf7e7ca,350|354|0xf7e7ca,344|362|0xbe913b",
			},
			{
				tag = "联赛",
				enable = true,
				anchor = "LB",
				srcPos = "327|579|0xbe913b,316|569|0xf7e7ca,358|579|0xbe913b,368|569|0xf7e7ca,336|611|0xbe913b,327|619|0xf7e7ca,361|617|0xf7e7ca,353|609|0xbe913b",
			},
			{
				tag = "线上对战",
				enable = true,
				anchor = "RM",
				srcPos = "985|310|0xbe913b,987|302|0xf7e7ca,1005|324|0xf7e7ca,997|334|0xbe913b,982|332|0xbe913b,974|343|0xf7e7ca",
			},
			{
				tag = "本地比赛",
				enable = true,
				anchor = "RB",
				srcPos = "979|581|0xf7e7ca,991|571|0xbe913b,1007|601|0xf7e7ca,1003|614|0xbe913b,989|611|0xf7e7ca,977|614|0xbe913b,992|595|0xbe913b",
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
			},
			{
				tag = "自动比赛",
				enable = true,
				anchor = "MTB",
				srcPos = "668|346|0x007aff,661|372|0x007aff,676|370|0x007aff,668|356|0xf8f9fb,673|408|0x007aff,551|116|0xe94269,655|391|0xf8f9fb",
			},
			{
				tag = "在线比赛",
				enable = true,
				anchor = "RM",
				srcPos = "1039|343|0xf8f9fb,1038|357|0x007bfd,1018|374|0x007bfd,1010|375|0xf8f9fb,1063|392|0x007bfd,1068|399|0xf8f9fb,1035|377|0x007bfd,1051|375|0x007bfd",
			},
		},
	},
	{
		tag = "活动模式",	--巡回赛
		widgetList = {
			{
				tag = "控制球员",
				enable = true,
				anchor = "L1/3",
				srcPos = "292|393|0x444444,292|378|0x444444,280|367|0x444444,268|366|0xf8f9fb,303|367|0x444444,314|365|0xf8f9fb,308|386|0xf8f9fb,276|386|0xf8f9fb",
			},
			{
				tag = "自动比赛",
				enable = true,
				anchor = "M1/3",
				srcPos = "292|393|0x444444,292|378|0x444444,280|367|0x444444,268|366|0xf8f9fb,303|367|0x444444,314|365|0xf8f9fb,308|386|0xf8f9fb,276|386|0xf8f9fb",
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
			},
			{
				tag = "赛季信息",
				enable = true,
				anchor = "T",
				srcPos = "280|101|0x1f1f1f,269|137|0x1f1f1f,885|99|0x1f1f1f,893|135|0x1f1f1f,792|119|0xfc3979,468|119|0x1f1f1f",
			},
			{
				tag = "奖励信息",
				enable = true,
				anchor = "R",
				srcPos = "958|103|0x1f1f1f,1286|102|0x1f1f1f,958|623|0x1f1f1f,1283|621|0x1f1f1f,980|261|0x363636,1261|134|0x363636",
			},
		},
	},
	{
		tag = "天梯巡回模式",		--教练和手动都一样
		widgetList = {
			{
				tag = "球队管理",
				enable = true,
				anchor = "LT",
				srcPos = "123|175|0x12a42b,123|167|0xffffff,102|168|0x0079fd,67|169|0x0079fd,75|133|0x0079fd,110|132|0x0079fd,94|180|0xffffff",
			},
			{
				tag = "巡回信息",
				enable = true,
				anchor = "A",
				srcPos = "515|142|0xffffff,504|108|0x153351,1270|121|0x153250,487|619|0x1f1f1f,1265|621|0x1f1f1f,1222|400|0x363636",
			},
			{
				tag = "选择电脑级别",
				enable = false,
				anchor = "B",
				srcPos = "385|607|0xff9500,366|610|0xffffff,347|607|0xff9500,322|610|0xffffff,307|609|0xff9500,187|609|0xff9500",
			},
		},
	},
	{
		tag = "选择电脑级别",		--教练和手动都一样
		widgetList = {
			{
				tag = "超巨",
				enable = true,
				anchor = "B",
				srcPos = "385|607|0xff9500,307|606|0xff9500,248|613|0xffffff,187|608|0xff9500,187|210|0xff9500,386|214|0xb2b2b2,387|370|0xb2b2b2",
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
			},
			{
				tag = "替补席",
				enable = true,
				anchor = "LM",
				srcPos = "89|405|0x0079fd,63|470|0x0079fd,112|470|0x0079fd,74|447|0xfdfdfd,76|400|0xfdfdfd,114|448|0x0079fd,122|444|0xfdfdfd",
			},
			{
				tag = "比赛设置",
				enable = true,
				anchor = "LB",
				srcPos = "96|581|0xfdfdfd,90|586|0x007aff,101|586|0x007aff,91|575|0x007aff,100|575|0x007aff,82|581|0xfdfdfd,109|580|0xfdfdfd",
			},
			{
				tag = "切换状态",
				enable = true,
				anchor = "RB",
				srcPos = "840|697|0xDDE0C3-0x221F3C,805|684|0xDDE0C3-0x221F3C,886|679|0xDDE0C3-0x221F3C",
				dstArea = Rect(		--要规避巡回赛切到声望时，对判定有干扰
					math.floor(CFG.EFFECTIVE_AREA[1] + (CFG.EFFECTIVE_AREA[3] - CFG.EFFECTIVE_AREA[1]) * 1 / 2 + 50 * (CFG.EFFECTIVE_AREA[4] - CFG.EFFECTIVE_AREA[2])/750),
					math.floor(CFG.EFFECTIVE_AREA[2] + (CFG.EFFECTIVE_AREA[4] - CFG.EFFECTIVE_AREA[2]) * 5 / 6),
					math.floor((CFG.EFFECTIVE_AREA[3] - CFG.EFFECTIVE_AREA[1]) / 4),
					math.floor((CFG.EFFECTIVE_AREA[4] - CFG.EFFECTIVE_AREA[2]) / 6)
				)
			},
			{
				tag = "身价溢出",	--用于判断是否身价溢出而精神低迷
				enable = false,
				anchor = "R1/3",
				srcPos = "1161|514|0xfd3830,1087|514|0xfd3830,1220|514|0xfd3830,1093|497|0x1f1f1f,1267|610|0x1f1f1f,1080|603|0x1f1f1f,1079|201|0x1f1f1f,1259|219|0x1f1f1f",
			},
		},
	},
	{
		tag = "比赛中",
		widgetList = {
			{
				tag = "比赛信息",
				enable = true,
				noCache = true,
				anchor = "dLT",
				srcPos = "39|64|0x1ce0dc-0x171f23,186|68|0x1ce0dc-0x171f23,223|83|0xf1fcf9-0x0c0306,237|84|0xf1fcf9-0x0c0306,275|65|0x1bd194-0x172e2a,420|67|0x1bd194-0x172e2a",
			},
			{
				tag = "门球",
				enable = false,
				noCache = true,
				anchor = "RT",
				srcPos = "1086|138|0xffffff,1086|168|0xffffff,1084|245|0xffffff,1087|273|0xffffff,1173|127|0xffffff,1175|285|0xffffff",
			},
		},
	},
	{
		tag = "终场统计",
		widgetList = {
			{
				tag = "技术统计",
				enable = true,
				anchor = "B",
				--包含了返回键的蓝色，中场统计的没有返回
				srcPos = "533|632|0x16e9da-0x090a05,562|632|0x1f3237-0x080807,773|632|0x1f3237-0x080807,800|632|0x1feda8-0x141216,\
				446|664|0x354c44-0x1f2322,886|664|0x354c44-0x1f2322,188|714|0x1270e3-0x13091a,1118|713|0x1270e3-0x13091a",
			},
		},
	},
	
	--联赛
	{
		tag = "联赛",
		widgetList = {
			{
				tag = "控制球员",
				enable = true,
				anchor = "LM",
				srcPos = "278|362|0x000000,269|352|0xf8f9fb,306|362|0x000000,315|353|0xf8f9fb,279|382|0x000000,271|392|0xf8f9fb,304|378|0x000000,312|392|0xf8f9fb",
			},
			{
				tag = "自动比赛",
				enable = true,
				anchor = "MTB",
				srcPos = "653|362|0x000000,644|352|0xf8f9fb,690|351|0xf8f9fb,680|361|0x000000,666|393|0x000000,680|401|0xf8f9fb,581|116|0xd3396a",
			},
		},
	},
	{
		tag = "联赛教练模式",
		widgetList = {
			{
				tag = "球队管理",
				enable = true,
				anchor = "LT",
				srcPos = "65|171|0x0079fd,55|169|0xffffff,65|180|0xffffff,92|172|0x0079fd,91|180|0xffffff,124|176|0x12a42b",
			},
			{
				tag = "联赛信息框",
				enable = true,
				anchor = "A",
				srcPos = "1176|145|0xfc3979,469|201|0x1f1f1f,1291|207|0x1f1f1f,1272|623|0x1f1f1f,489|622|0x1f1f1f,1223|470|0x363636",
			},
			{
				tag = "跳过余下比赛",		--仅用于跳过余下比赛，enable == false，不参与matchPage/matchWidgets
				enable = false,
				noCache = true,
				anchor = "RB",
				--srcPos = "987|719|0xcaddf0,936|725|0xcaddf0,712|700|0xcaddf0,711|722|0xcaddf0",
				srcPos = "823|694|0xc2d3e5-0x080a0b,780|698|0xc2d3e5-0x080a0b,826|685|0xc2d3e5-0x080a0b,712|690|0xc2d3e5-0x080a0b,716|703|0xc2d3e5-0x080a0b,\
				972|689|0xc2d3e5-0x080a0b,968|703|0xc2d3e5-0x080a0b",
			},
		},
	},
	{
		tag = "点球",
		widgetList = {
			{
				tag = "比分综合特征",
				enable = true,
				noCache = true,
				anchor = "A",
				srcPos = "132|621|0x1fbbbb-0x144444,133|682|0x1fbbbb-0x144444,1204|619|0x1ab981-0x19463d,1202|683|0x1ab981-0x19463d,208|698|0x2d3e40-0x171615,\
				210|717|0x2d3e40-0x171615,1118|699|0x2d3e40-0x171615,1119|712|0x2d3e40-0x171615,634|679|0xb6cbc4-0x35343a,692|680|0xb6cbc4-0x35343a",
			},
		},
	},
	{
		tag = "初始化界面",
		widgetList = {
			{
				tag = "综合特征",
				enable = true,
				anchor = "A",
				srcPos = "134|302|0xdc0014,182|352|0xdc0014,311|337|0xdc0014,413|329|0xdc0014,555|312|0xdc0014,553|345|0xdc0014,353|445|0xffffff",
			},
		},
	},
	{
		tag = "合同",
		--[[widgetList = {
			{
				tag = "经纪人",
				enable = true,
				anchor = "LM",
				srcPos = "343|337|0x007aff,335|340|0xffffff,351|340|0xffffff,357|332|0xffffff,329|332|0xffffff,343|326|0x007aff,322|354|0x007aff,360|343|0x007aff",
			},
			{
				tag = "拍卖",
				enable = true,
				anchor = "LB",
				srcPos = "339|587|0x007aff,326|587|0xffffff,339|600|0xffffff,334|580|0x007aff,345|591|0x007aff,345|581|0x007aff,319|607|0x007aff,316|594|0xffffff",
			},
			{
				tag = "球探",
				enable = true,
				anchor = "RM",
				srcPos = "979|341|0x007aff,999|341|0x007aff,969|334|0xffffff,1008|333|0xffffff,983|350|0xffffff,996|350|0xffffff,965|356|0x007aff,1006|355|0x007aff",
			},
			{
				tag = "主教练",
				enable = true,
				anchor = "RB",
				srcPos = "990|603|0xffffff,982|607|0x007aff,973|605|0x007aff,966|597|0xffffff,966|616|0x007aff,966|625|0xffffff,980|616|0x007aff,989|616|0xffffff,1014|615|0x007aff",
			},
		},]]
		widgetList = {
			{
				tag = "经纪人",
				enable = true,
				anchor = "LM",
				srcPos = "343|337|0xbe913b,335|340|0xf7e7ca,351|340|0xf7e7ca,357|332|0xf7e7ca,329|332|0xf7e7ca,343|326|0xbe913b,322|354|0xbe913b,360|343|0xbe913b",
			},
			{
				tag = "拍卖",
				enable = true,
				anchor = "LB",
				srcPos = "339|587|0xbe913b,326|587|0xf7e7ca,339|600|0xf7e7ca,334|580|0xbe913b,345|591|0xbe913b,345|581|0xbe913b,319|607|0xbe913b,316|594|0xf7e7ca",
			},
			{
				tag = "球探",
				enable = true,
				anchor = "RM",
				srcPos = "979|341|0xbe913b,999|341|0xbe913b,969|334|0xf7e7ca,1008|333|0xf7e7ca,983|350|0xf7e7ca,996|350|0xf7e7ca,965|356|0xbe913b,1006|355|0xbe913b",
			},
			{
				tag = "主教练",
				enable = true,
				anchor = "RB",
				srcPos = "990|603|0xf7e7ca,982|607|0xbe913b,973|605|0xbe913b,966|597|0xf7e7ca,966|616|0xbe913b,966|625|0xf7e7ca,980|616|0xbe913b,989|616|0xf7e7ca,1014|615|0xbe913b",
			},
		},
	},
	{
		tag = "经纪人",
		widgetList = {
			{
				tag = "特殊经纪人",
				enable = false,		--不总出现
				noCache = true,
				anchor = "A",
				srcPos = "291|374|0x007aff,285|379|0xf8f9fb,298|379|0xf8f9fb,291|385|0x007aff,291|394|0x007aff,285|400|0xf8f9fb,298|400|0xf8f9fb,314|396|0x007aff,311|381|0x007aff,321|376|0xf8f9fb",
			},
			{
				tag = "标准经纪人",
				enable = true,
				noCache = true,
				anchor = "A",
				srcPos = "667|380|0x007aff,666|392|0x007aff,666|386|0xf8f9fb,653|378|0x007aff,644|396|0x007aff,635|396|0xf8f9fb,644|404|0xf8f9fb,667|399|0xf8f9fb,690|396|0x007aff,698|397|0xf8f9fb",
			},
			{
				tag = "箱式经纪人",
				enable = false,	--不总出现
				noCache = true,
				anchor = "A",
				srcPos = "287|376|0x007aff,297|375|0x007aff,291|382|0xf8f9fb,291|388|0xf8f9fb,278|368|0xf8f9fb,306|368|0xf8f9fb,268|396|0x007aff,313|382|0x007aff,320|378|0xf8f9fb,299|396|0x007aff",
			},
			
		},
	},
	{
		tag = "箱式经纪人",
		widgetList = {
			{
				tag = "单抽",
				enable = false,		--多抽必然存在，而单抽不一定，只要能检测到连抽就算匹配
				noCache = true,
				anchor = "A",
				srcPos = "291|555|0xfee580,285|547|0xcda301,291|564|0xcda301,257|381|0x3e3d40,328|377|0x3e3d40",
			},
			{
				tag = "连抽",
				enable = true,
				noCache = true,
				anchor = "A",
				srcPos = "291|555|0xfee580,285|547|0xcda301,291|564|0xcda301,257|381|0x3e3d40,328|377|0x3e3d40,181|128|0xe38ca8-0x195e47",
			},
			{
				tag = "金币付款确认",
				enable = false,
				anchor = "A",
				srcPos = "829|393|0xfee680,808|401|0xcea402,853|400|0xcea402,697|342|0xe6e6ed,961|482|0xe6e6ed",
			},
		},
	},
	{
		tag = "标准经纪人",
		widgetList = {
			{
				tag = "前锋",
				enable = true,
				anchor = "L1/3",
				srcPos = "291|365|0xd9b800,212|548|0x1e53b1,370|547|0xcda301,153|611|0xfdfdfd",
			},
			{
				tag = "中场",
				enable = true,
				anchor = "M1/3",
				srcPos = "291|365|0xd9b800,212|548|0x1e53b1,370|547|0xcda301,153|611|0xfdfdfd",
			},
			{
				tag = "后卫",
				enable = true,
				anchor = "R1/3",
				srcPos = "291|365|0xd9b800,212|548|0x1e53b1,370|547|0xcda301,153|611|0xfdfdfd",
			},
			{
				tag = "GP付款确认",
				enable = false,
				anchor = "A",
				srcPos = "500|393|0x1e54b2,517|392|0x9ec2ff,372|346|0xe6e6ed,630|489|0xe6e6ed,828|394|0xfee680,844|375|0xcea402",
			},
		},
	},
	{
		tag = "抽球界面",
		widgetList = {
			{
				tag = "综合特征",
				enable = true,
				anchor = "B",
				srcPos = "205|679|0x1b1719-0x1b171a,467|678|0x1b1719-0x1b171a,907|675|0x1b1719-0x1b171a,1298|677|0x1b1719-0x1b171a,110|713|0x1b1719-0x1b171a,337|708|0x1b1719-0x1b171a,930|713|0x1b1719-0x1b171a,1271|710|0x1b1719-0x1b171a",
			},
		},
	},
}

--公共导航控件，如下一步、返回、确认、取消、通知
local _navigationList = {
	{
		tag = "next",
		enable = true,
		noCache = true,
		anchor = "CRB",
		srcPos = "1130|732|0x1F74CC-0x202331,1127|702|0x1F74CC-0x202331,1102|703|0x1F74CC-0x202331,1088|733|0x1F74CC-0x202331,1235|733|0x1F74CC-0x202331",
		dstArea = Rect(
			math.floor(CFG.EFFECTIVE_AREA[1] + (CFG.EFFECTIVE_AREA[3] - CFG.EFFECTIVE_AREA[1]) * 3 / 4),
			math.floor(CFG.EFFECTIVE_AREA[2] + (CFG.EFFECTIVE_AREA[4] - CFG.EFFECTIVE_AREA[2]) * 7 / 8),
			math.floor(CFG.DST_RESOLUTION.width - (CFG.EFFECTIVE_AREA[1] + (CFG.EFFECTIVE_AREA[3] - CFG.EFFECTIVE_AREA[1]) * 3 / 4)),
			math.floor(CFG.DST_RESOLUTION.height - (CFG.EFFECTIVE_AREA[2] + (CFG.EFFECTIVE_AREA[4] - CFG.EFFECTIVE_AREA[2]) * 7 / 8))
		)
	},
	{
		tag = "comfirm",
		enable = true,
		noCache = true,
		anchor = "MTB",
		--srcPos = "843|449|0xcaddf0,884|405|0xcaddf0,507|457|0xcaddf0,409|407|0xcaddf0,487|379|0xf5f5f5,804|491|0xf5f5f5,328|436|0xf5f5f5,1007|435|0xf5f5f5",
		--兼容手机联赛界面的确定按钮过小的问题
		srcPos = "864|497|0xcaddf0,861|467|0xcaddf0,415|475|0xcaddf0,554|499|0xcaddf0,329|486|0xf5f5f5,997|481|0xf5f5f5,502|549|0xf5f5f5,831|427|0xf5f5f5",
	},
	{
		tag = "notice",
		enable = true,
		anchor = "RT",
		srcPos = "1279|54|0x55a4f9-0x562b06,1269|45|0x55a4f9-0x562b06,1289|44|0x55a4f9-0x562b06,1268|65|0x55a4f9-0x562b06,1288|64|0x55a4f9-0x562b06,\
		1268|55|0xccdff2,1278|44|0xccdff2,1289|54|0xccdff2,1198|66|0xffffff",
	},
	{
		tag = "球员续约-球员列表",
		enable = true,
		anchor = "A",
		srcPos = "235|197|0xff3b2f,258|198|0xff3b2f,394|129|0x205080,865|132|0x205080,400|708|0xc5c5c7,928|709|0xc5c5c7,1137|716|0x0079fd",
		actionFunc = refreshContract	--续约合同,
	},
	{
		tag = "球员续约-点击签约",
		enable = true,
		anchor = "A",
		--srcPos = "884|720|0xcaddf0,703|695|0xcaddf0,984|728|0xcaddf0,406|709|0xcaddf0,1137|714|0x0079fd,213|130|0x205080,1064|120|0x205080",
		srcPos = "884|720|0xcaddf0,703|695|0xcaddf0,984|728|0xcaddf0,406|709|0xcaddf0,213|130|0x205080,1064|120|0x205080",
	},
	{
		tag = "球员续约-续约",
		enable = true,
		anchor = "A",
		srcPos = "638|388|0x3e99fd-0x3f2101,339|256|0xdedede,998|440|0xdedede,339|497|0xcaddf0,981|543|0xcaddf0,513|131|0x13304d,855|132|0x13304d",
	},
	{
		tag = "球员续约-付款确认",
		enable = true,
		anchor = "A",
		srcPos = "500|392|0x1e54b2,517|393|0x9ec2ff,812|398|0xcea402,830|394|0xfee680,376|346|0xe6e6ed,625|485|0xe6e6ed,626|528|0xf5f5f5,565|589|0xcaddf0",
	},
	{
		tag = "能量不足",
		enable = true,
		anchor = "A",
		srcPos = "712|530|0xcaddf0,764|391|0xffffff,330|494|0xcaddf0,1000|541|0xcaddf0,353|256|0xdedede,628|438|0xdedede,630|459|0xf5f5f5,1005|191|0xf5f5f5",
		actionFunc = chargeEnergy
	},
	{
		tag = "恢复100",
		enable = true,
		anchor = "A",
		srcPos = "1117|219|0xebf7e6,1064|218|0xebf7e6,1024|218|0xebf7e6,992|217|0x97d880,967|218|0x2fb100,1007|379|0x2bb544,1038|373|0xffffff,1072|380|0x2bb544",
	},
	{
		tag = "教练续约-合同用完",
		enable = true,
		anchor = "A",
		srcPos = "699|703|0xcaddf0,521|688|0xcaddf0,809|707|0xcaddf0,1154|690|0x5c5c5c,1101|290|0x4cd964,1106|132|0x205080,943|290|0x4cd964,202|135|0x205080",
	},

}

--全局导航优先级
local _navigationPriorityList = {
	"球员续约-球员列表",
	"comfirm",
	"next",
	"notice",
	"能量不足",
	"教练续约-合同用完",
}


--将项目的pageList、navigationList和_navigationPriorityList插入page总表
page.loadPage(_pageList, _navigationList, _navigationPriorityList)

