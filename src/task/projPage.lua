-- projPage.lua
-- Author: cndy1860
-- Date: 2018-12-28
-- Descrip: 开发项目的界面信息，初始化时将插入pageList总表

--备注:
--所有dstArea只有在dstArea == Rect.ZERO时候才会在初始化时进行getAnchorArea，否则使用预设的数据
--所有dstPos只有在dstPos == ""时候才会在初始化时进行scalePos，否则使用预设的数据
--在执行点击widgetList或者进行navigation时，存在actionFunc的时候优先执行actionFunc，否则点击dstPos的第一个点
--enable仅仅标识在matchPage/matchWidgets时，是否作为匹配项，其他操作不受影响，如Init时的缩放、matchWidget、tapWidget

--界面
local _pageList = {
	{
		tag = "其他",
		widgetList = {
			{
				tag = "玩家信息",
				enable = true,
				anchor = "LM",
				srcPos = "343|308|0xffffff,343|315|0x007aff,324|312|0x007aff,363|313|0x007aff,324|355|0x007aff,362|355|0x007aff",
				dstPos = "",
				dstArea = Rect.ZERO
			},
			{
				tag = "游戏帮助",
				enable = true,
				anchor = "LB",
				srcPos = "343|308|0xffffff,343|315|0x007aff,324|312|0x007aff,363|313|0x007aff,324|355|0x007aff,362|355|0x007aff",
				dstPos = "",
				dstArea = Rect.ZERO
			},
			{
				tag = "设置",
				enable = true,
				anchor = "RM",
				srcPos = "962|334|0x007aff,1009|352|0x007aff,1008|315|0x007aff,989|318|0xffffff,974|334|0xffffff,989|348|0xffffff",
				dstPos = "",
				dstArea = Rect.ZERO
			},
			{
				tag = "支持",
				enable = true,
				anchor = "RB",
				srcPos = "985|575|0x007aff,1016|575|0x007aff,1017|594|0x007aff,993|589|0xffffff,965|606|0xffffff,979|598|0x007aff",
				dstPos = "",
				dstArea = Rect.ZERO
			},
		},
		--pageNext = {
		--	srcPos = "",
		--	dstPos = "",
		--	dstArea = Rect.ZERO,
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
				dstArea = Rect.ZERO
			},
			{
				tag = "联赛",
				enable = true,
				anchor = "LB",
				srcPos = "327|579|0x007aff,316|569|0xffffff,358|579|0x007aff,368|569|0xffffff,336|611|0x007aff,327|619|0xffffff,361|617|0xffffff,353|609|0x007aff",
				dstPos = "",
				dstArea = Rect.ZERO
			},
			{
				tag = "线上对战",
				enable = true,
				anchor = "RM",
				srcPos = "985|310|0x007aff,987|302|0xffffff,1005|324|0xffffff,997|334|0x007aff,982|332|0x007aff,974|343|0xffffff",
				dstPos = "",
				dstArea = Rect.ZERO
			},
			{
				tag = "本地比赛",
				enable = true,
				anchor = "RB",
				srcPos = "979|581|0xffffff,991|571|0x007aff,1007|601|0xffffff,1003|614|0x007aff,989|611|0xffffff,977|614|0x007aff,992|595|0x007aff",
				dstPos = "",
				dstArea = Rect.ZERO
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
				dstArea = Rect.ZERO
			},
			{
				tag = "自动比赛",
				enable = true,
				anchor = "MTB",
				srcPos = "668|346|0x007aff,661|372|0x007aff,676|370|0x007aff,668|356|0xf8f9fb,673|408|0x007aff,551|116|0xe94269,655|391|0xf8f9fb",
				dstPos = "",
				dstArea = Rect.ZERO
			},
			{
				tag = "在线比赛",
				enable = true,
				anchor = "RM",
				srcPos = "1039|343|0xf8f9fb,1038|357|0x007bfd,1018|374|0x007bfd,1010|375|0xf8f9fb,1063|392|0x007bfd,1068|399|0xf8f9fb,1035|377|0x007bfd,1051|375|0x007bfd",
				dstPos = "",
				dstArea = Rect.ZERO
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
				dstArea = Rect.ZERO
			},
			{
				tag = "赛季信息",
				enable = true,
				anchor = "T",
				srcPos = "280|101|0x1f1f1f,269|137|0x1f1f1f,885|99|0x1f1f1f,893|135|0x1f1f1f,792|119|0xfc3979,468|119|0x1f1f1f",
				dstPos = "",
				dstArea = Rect.ZERO
			},
			{
				tag = "奖励信息",
				enable = true,
				anchor = "R",
				srcPos = "958|103|0x1f1f1f,1286|102|0x1f1f1f,958|623|0x1f1f1f,1283|621|0x1f1f1f,980|261|0x363636,1261|134|0x363636",
				dstPos = "",
				dstArea = Rect.ZERO
			},
		},
	},
	{
		tag = "匹配天梯对手",
		widgetList = {
			{
				tag = "特征",
				enable = true,
				anchor = "B",
				srcPos = "272|468|0xff9500,920|468|0xff9500,658|607|0xffffff,644|612|0x7fa7bb-0x644535,701|612|0x9a6751-0x223135,1131|708|0x1270e3-0x13091a",
				dstPos = "",
				dstArea = Rect.ZERO
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
				dstArea = Rect.ZERO
			},
			{
				tag = "替补席",
				enable = true,
				anchor = "LM",
				srcPos = "89|405|0x0079fd,63|470|0x0079fd,112|470|0x0079fd,74|447|0xfdfdfd,76|400|0xfdfdfd,114|448|0x0079fd,122|444|0xfdfdfd",
				dstPos = "",
				dstArea = Rect.ZERO
			},
			{
				tag = "比赛设置",
				enable = true,
				anchor = "LB",
				srcPos = "96|581|0xfdfdfd,90|586|0x007aff,101|586|0x007aff,91|575|0x007aff,100|575|0x007aff,82|581|0xfdfdfd,109|580|0xfdfdfd",
				dstPos = "",
				dstArea = Rect.ZERO
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
				dstArea = Rect.ZERO
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
				dstPos = "",
				dstArea = Rect.ZERO
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
				dstArea = Rect.ZERO
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
				dstArea = Rect.ZERO
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
				dstPos = "",
				dstArea = Rect.ZERO
			},
			{
				tag = "自动比赛",
				enable = true,
				anchor = "MTB",
				srcPos = "653|362|0x000000,644|352|0xf8f9fb,690|351|0xf8f9fb,680|361|0x000000,666|393|0x000000,680|401|0xf8f9fb,581|116|0xd3396a",
				dstPos = "",
				dstArea = Rect.ZERO
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
				dstPos = "",
				dstArea = Rect.ZERO
			},
			{
				tag = "联赛信息框",
				enable = true,
				anchor = "A",
				srcPos = "1176|145|0xfc3979,469|201|0x1f1f1f,1291|207|0x1f1f1f,1272|623|0x1f1f1f,489|622|0x1f1f1f,1223|470|0x363636",
				dstPos = "",
				dstArea = Rect.ZERO
			},
			{
				tag = "跳过余下比赛",		--仅用于跳过余下比赛，enable == false，不参与matchPage/matchWidgets
				enable = false,
				anchor = "RB",
				srcPos = "936|725|0xcaddf0,987|719|0xcaddf0,712|700|0xcaddf0,711|722|0xcaddf0",
				dstPos = "",
				dstArea = Rect.ZERO
			},
			{
				tag = "确定跳过",
				enable = false,
				anchor = "A",
				--srcPos = "794|451|0xcaddf0,961|461|0xcaddf0,667|433|0xf5f5f5,369|408|0xcaddf0,936|491|0xf5f5f5,999|433|0xf5f5f5,897|372|0xf5f5f5,332|432|0xf5f5f5",
				srcPos = "793|446|0xcaddf0,368|410|0xcaddf0,960|461|0xcaddf0,666|432|0xf5f5f5,618|492|0xf5f5f5,721|489|0xf5f5f5,992|256|0xf5f5f5",
				dstPos = "",
				dstArea = Rect.ZERO
			},
			{
				tag = "恭喜晋级",
				enable = false,
				anchor = "A",
				srcPos = "617|592|0xcaddf0,376|565|0xcaddf0,959|614|0xcaddf0,673|644|0xf5f5f5,1170|209|0xf5f5f5,169|103|0xf5f5f5,1159|106|0xf5f5f5,1242|132|0x972249",
				dstPos = "",
				dstArea = Rect.ZERO
			},
			{
				tag = "联赛奖励",
				enable = false,
				anchor = "A",
				srcPos = "617|597|0xcaddf0,370|561|0xcaddf0,959|611|0xcaddf0,632|240|0xf05674,669|242|0xfffada,706|242|0xf05674",
				dstPos = "",
				dstArea = Rect.ZERO
			},
		},
	},
	{
		tag = "匹配联赛对手",
		widgetList = {
			{
				tag = "综合特征",
				enable = true,
				anchor = "A",
				srcPos = "185|133|0x205080,1151|130|0x205080,323|576|0xff9500,851|576|0xff9500,162|190|0xffffff,1165|624|0xffffff,1126|713|0x0079fd",
				dstPos = "",
				dstArea = Rect.ZERO
			},
		},
	},
}

--公共导航控件，如下一步、返回、确认、取消、通知
local _navigationList = {
	{
		tag = "next",
		enable = true,
		anchor = "CRB",
		srcPos = "1130|732|0x1270e3-0x13091a,1127|702|0x1270e3-0x13091a,1102|703|0x1270e3-0x13091a,1088|733|0x1270e3-0x13091a",
		dstPos = "",
		dstArea = Rect(
			math.floor(CFG.EFFECTIVE_AREA[1] + (CFG.EFFECTIVE_AREA[3] - CFG.EFFECTIVE_AREA[1]) * 3 / 4),
			math.floor(CFG.EFFECTIVE_AREA[2] + (CFG.EFFECTIVE_AREA[4] - CFG.EFFECTIVE_AREA[2]) * 7 / 8),
			math.floor(CFG.DEV_RESOLUTION.width - (CFG.EFFECTIVE_AREA[1] + (CFG.EFFECTIVE_AREA[3] - CFG.EFFECTIVE_AREA[1]) * 3 / 4)),
			math.floor(CFG.DEV_RESOLUTION.height - (CFG.EFFECTIVE_AREA[2] + (CFG.EFFECTIVE_AREA[4] - CFG.EFFECTIVE_AREA[2]) * 7 / 8))
		)
	},
	{
		tag = "comfirm",
		enable = true,
		anchor = "MTB",
		srcPos = "682|460|0x2c8efa-0x2c1603,523|433|0xcaddf0,782|434|0xcaddf0,538|478|0xcaddf0,790|477|0xcaddf0,533|400|0xf5f5f5,\
		772|390|0xf5f5f5,538|517|0xf5f5f5,763|517|0xf5f5f5",
		dstPos = "",
		dstArea = Rect.ZERO
	},
	{
		tag = "确定-合约过期",
		enable = true,
		anchor = "A",
		srcPos = "608|584|0xcaddf0,399|545|0xcaddf0,855|584|0xcaddf0,665|240|0xffa0a9-0x000202,685|231|0xffffff,664|197|0xfe5343-0x010807",
		dstPos = "",
		dstArea = Rect.ZERO
	},
	{
		tag = "球员续约-球员列表",
		enable = true,
		anchor = "A",
		srcPos = "235|197|0xff3b2f,258|198|0xff3b2f,394|129|0x205080,865|132|0x205080,400|708|0xc5c5c7,928|709|0xc5c5c7,1137|716|0x0079fd",
		dstPos = "",
		dstArea = Rect.ZERO,
		actionFunc = selectExpiredPlayer	--选中待签约球员, 
	},
	{
		tag = "球员续约-点击签约",
		enable = true,
		anchor = "A",
		srcPos = "884|720|0xcaddf0,703|695|0xcaddf0,984|728|0xcaddf0,406|709|0xcaddf0,1137|714|0x0079fd,213|130|0x205080,1064|120|0x205080",
		dstPos = "",
		dstArea = Rect.ZERO
	},
	{
		tag = "球员续约-续约",
		enable = true,
		anchor = "A",
		srcPos = "638|388|0x3e99fd-0x3f2101,339|256|0xdedede,998|440|0xdedede,339|497|0xcaddf0,981|543|0xcaddf0,513|131|0x13304d,855|132|0x13304d",
		dstPos = "",
		dstArea = Rect.ZERO
	},
	{
		tag = "球员续约-付款确认",
		enable = true,
		anchor = "A",
		srcPos = "500|392|0x1e54b2,517|393|0x9ec2ff,812|398|0xcea402,830|394|0xfee680,376|346|0xe6e6ed,625|485|0xe6e6ed,626|528|0xf5f5f5,565|589|0xcaddf0",
		dstPos = "",
		dstArea = Rect.ZERO
	},
	{
		tag = "球员续约-支付确定",
		enable = true,
		anchor = "A",
		srcPos = "783|449|0xcaddf0,954|461|0xcaddf0,377|408|0xcaddf0,666|436|0xf5f5f5,336|260|0xf5f5f5,995|262|0xf5f5f5,155|131|0x13304d,1163|121|0x13304d",
		dstPos = "",
		dstArea = Rect.ZERO
	},
	{
		tag = "球员续约-已续约",
		enable = true,
		anchor = "A",
		srcPos = "618|533|0xcaddf0,373|495|0xcaddf0,952|543|0xcaddf0,416|581|0xf5f5f5,664|240|0x21c43d-0x0d090c,666|320|0x70ef85-0x1a0617,386|182|0xf5f5f5,414|121|0x13304d",
		dstPos = "",
		dstArea = Rect.ZERO
	},
	{
		tag = "教练续约定额",
		enable = true,
		anchor = "A",
		srcPos = "617|483|0xcaddf0,377|445|0xcaddf0,935|488|0xcaddf0,477|270|0x4cd964,489|286|0x4cd964,641|524|0xf5f5f5,335|463|0xf5f5f5,1000|463|0xf5f5f5",
		dstPos = "",
		dstArea = Rect.ZERO
	},
	{
		tag = "教练续约确定",
		enable = true,
		anchor = "A",
		srcPos = "619|462|0xcaddf0,372|433|0xcaddf0,952|483|0xcaddf0,606|512|0xf5f5f5,607|397|0xf5f5f5,1108|294|0x2e823c,434|130|0x13304d",
		dstPos = "",
		dstArea = Rect.ZERO
	},
}

--全局导航优先级，一般next在最后
local _navigationPriorityList = {
	"确定-合约过期", 
	"球员续约-球员列表", 
	"球员续约-点击签约", 
	"球员续约-续约", 
	"球员续约-付款确认", 
	"球员续约-支付确定", 
	"球员续约-已续约",
	"教练续约定额",
	"教练续约确定",
	"next",
	"comfirm",
}


--将项目的pageList、navigationList和_navigationPriorityList插入page总表
page.initPage(_pageList, _navigationList, _navigationPriorityList)

