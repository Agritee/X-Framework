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
		tag = "比赛",
		widgetList = {
			{
				tag = "活动模式",
				enable = true,
				anchor = "LM",
				srcPos = "331|312|0x007aff,356|311|0x007aff,326|323|0xffffff,361|322|0xffffff,343|348|0x007aff,338|354|0xffffff,350|354|0xffffff,344|362|0x007aff",
				--春节红色srcPos = "340|374|0xf2d8aa,343|358|0xf2d8aa,332|359|0x1a083c,361|335|0x1a083c,357|346|0x19083d,354|324|0xf2d8aa,369|329|0xf4d9ab,366|323|0x1a083c",
			},
			{
				tag = "联赛",
				enable = true,
				anchor = "LB",
				srcPos = "327|579|0x007aff,316|569|0xffffff,358|579|0x007aff,368|569|0xffffff,336|611|0x007aff,327|619|0xffffff,361|617|0xffffff,353|609|0x007aff",
				--春节红色srcPos = "328|605|0xf2d8aa,358|605|0xf2d8aa,332|631|0xf2d8aa,328|646|0x1a083c,343|641|0xf2d8aa,342|655|0x1a083c,363|642|0x1a083c,352|635|0xf2d8aa",
			},
			{
				tag = "线上对战",
				enable = true,
				anchor = "RM",
				srcPos = "985|310|0x007aff,987|302|0xffffff,1005|324|0xffffff,997|334|0x007aff,982|332|0x007aff,974|343|0xffffff",
				--春节红色srcPos = "973|330|0xf2d8aa,975|362|0xf2d8aa,1007|362|0xf2d8aa,980|336|0xff1e30,968|325|0xff1e30,981|355|0xff1e30,1007|330|0xf2d8aa,1015|332|0xff1e30",
			},
			{
				tag = "本地比赛",
				enable = true,
				anchor = "RB",
				srcPos = "979|581|0xffffff,991|571|0x007aff,1007|601|0xffffff,1003|614|0x007aff,989|611|0xffffff,977|614|0x007aff,992|595|0x007aff",
				--春节红色srcPos = "1001|606|0x1a083c,1007|600|0xfee7b2,991|598|0xf2d8aa,1011|612|0xf2d8aa,1002|613|0x1a083c,997|618|0xf2d8aa,1012|613|0xf2d8aa",
			},
		},
	},
	{
		tag = "俱乐部",
		widgetList = {
			{
				tag = "我的球队",
				enable = true,
				anchor = "RM",
				srcPos = "989|342|0xffffff,983|346|0x007aff,996|346|0x007aff,990|351|0xffffff,979|359|0xffffff,1000|359|0xffffff,1009|358|0x007aff,971|357|0x007aff,995|366|0x007aff",
				--春节红色srcPos = "989|333|0x1a083c,989|342|0x1a083c,1000|346|0xf2d8aa,969|326|0xf2d8aa,1010|365|0xf2d8aa,984|355|0x1a083c,997|356|0x1a083c",
			},
			{
				tag = "成就",
				enable = true,
				anchor = "LB",
				srcPos = "343|644|0x007aff,335|649|0xffffff,352|649|0xffffff,343|648|0x007aff,344|628|0x007aff,337|625|0xffffff,350|625|0xffffff,343|597|0x007aff",
				--春节红色srcPos = "343|647|0xf2d8aa,336|649|0x1a083c,351|649|0x1a083c,335|642|0xf2d8aa,352|642|0xf2d8aa,360|637|0x1a083c,331|596|0xf5dbac,332|590|0x19073c",
			},
		},
	},
	{
		tag = "合同",
		widgetList = {
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
		},
	},
	{
		tag = "其他",
		widgetList = {
			{
				tag = "玩家信息",
				enable = true,
				anchor = "LM",
				srcPos = "343|308|0xffffff,343|315|0x007aff,324|312|0x007aff,363|313|0x007aff,324|355|0x007aff,362|355|0x007aff",
				--春节红色srcPos = "343|320|0x1a083c,343|314|0xf9dfaf,343|326|0xf4dbac,331|316|0x1a083c,353|349|0x100038,346|358|0x100038,356|358|0xf2d8aa,343|365|0xf2d8aa",
			},
			{
				tag = "游戏帮助",
				enable = true,
				anchor = "LB",
				srcPos = "343|308|0xffffff,343|315|0x007aff,324|312|0x007aff,363|313|0x007aff,324|355|0x007aff,362|355|0x007aff",
				--春节红色srcPos = "343|595|0x1a083c,344|589|0xf9e0af,343|602|0xf5dbac,343|607|0x0f0337,343|612|0xf2d8aa,329|611|0xf2d8aa,337|622|0xf2d8aa",
			},
			{
				tag = "支持",
				enable = true,
				anchor = "RB",
				srcPos = "985|575|0x007aff,1016|575|0x007aff,1017|594|0x007aff,993|589|0xffffff,965|606|0xffffff,979|598|0x007aff",
				--春节红色srcPos = "990|624|0xf4d9ac,994|615|0x1a083c,990|602|0xf2d8aa,1005|606|0xf2d8aa,1007|624|0xf2d8aa,1004|634|0x1a083c,1017|630|0x1a083c,873|538|0xe7e5f2",
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
				anchor = "M",
				srcPos = "670|340|0x007aff,670|351|0xf8f9fb,660|340|0xf8f9fb,680|340|0xf8f9fb,663|366|0x007aff,655|384|0xf8f9fb,641|391|0x0079ff,548|128|0xc8457a-0x181010,589|128|0xc8457a-0x181010",
			},
			{
				tag = "绿茵赛",
				enable = true,
				anchor = "RM",
				srcPos = "293|346|0x007aff,297|408|0x007aff,285|371|0x007aff,300|371|0x007aff,292|357|0xf8f9fb,277|390|0xf8f9fb,308|389|0xf8f9fb",
			},
		},
	},
	{
		tag = "活动模式",	--巡回赛
		widgetList = {
			{
				tag = "继续",		--“加入”,用于判定进入活动模式成功
				enable = true,
				anchor = "B",
				srcPos = "728|557|0x3091fa-0x301804,133|454|0x8f8f94,736|559|0xcaddf0,793|572|0xcaddf0,687|541|0xcaddf0,133|454|0xa9a9ad-0x1b1b1a,161|452|0xa9a9ad-0x1b1b1a",
			},
			{
				tag = "返回按钮",		--辅助唯一标识界面
				enable = true,
				anchor = "CLB",
				srcPos = "59|706|0xbeddfe,51|684|0x0079fe,78|705|0x0079fe,295|723|0x0079fe",
			},
			{
				tag = "手动巡回赛",		--取了教练模式左边的两点来实现区分标识
				enable = false,
				anchor = "B",
				srcPos = "729|557|0x0079fe,688|552|0xcaddf0,112|92|0xa77b54,107|343|0xa77b53,822|110|0xc8b3a4,832|333|0xbda392,207|397|0x020202,893|128|0xb6906c,892|335|0xa67b53",
			},
			{
				tag = "教练巡回赛",	--取了手动模式右边的两点来实现区分标识
				enable = false,
				anchor = "B",
				srcPos = "1120|557|0x0079fe,1078|542|0xcaddf0,508|95|0xa67b54,506|337|0xa67b54,1214|112|0xc8b3a4,1220|325|0xbda392,597|404|0x000000,441|114|0xc9b3a5,441|330|0xbda392",
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
			--[[{
				tag = "主客场球衣",
				enable = true,
				anchor = "CLB",
				srcPos = "175|697|0x000000,175|713|0x000000,137|698|0x353e5f,157|698|0x353e5f,198|718|0x353e5f,207|718|0x353e5f",
			},]]
			{
				tag = "替补席",
				enable = true,
				anchor = "LM",
				srcPos = "95|398|0xfefefe,79|401|0x0079fe,114|400|0x0079fe,106|420|0xfefefe,74|409|0x0079fe,76|455|0x0079fe,116|456|0x0079fe",
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
				anchor = "RB",
				srcPos = "1218|487|0xfe3b30,1216|492|0xfe3b30,1211|508|0xfe3b30,1209|515|0xfe3b30",
			},
		},
	},
	{
		tag = "比赛中",
		widgetList = {
			{
				tag = "比赛信息",
				enable = true,
				anchor = "dLT",
				--srcPos = "186|22|0xeac278,184|42|0xeac278,289|22|0xeac278,290|39|0xeac278,45|63|0x001e30,153|83|0x001e30,322|60|0x001e30,430|80|0x001e30",
				srcPos = "240|60|0xffffff,221|56|0x451d4d-0x101010,255|55|0x451d4d-0x101010,187|19|0x451d4d-0x101010,293|37|0x451d4d-0x101010,48|81|0x451d4d-0x101010,423|83|0x451d4d-0x101010",
				dstArea = Rect(
					0,
					0,
					math.floor(CFG.DST_RESOLUTION.width / 4),
					math.floor(CFG.DST_RESOLUTION.height / 8)
				)			
			},
			{
				tag = "暂停按钮",		--半透明识别失败概率相对较高，但识别失败的代价是tryskip，不影响
				enable = true,
				anchor = "CRT",
				srcPos = "1267|40|0x313030-0x111012,1267|48|0x313030-0x111012,1276|40|0x313030-0x111012,1276|48|0x313030-0x111012,1233|21|0xd2d4d3-0x2d2b2c,1309|65|0xd2d4d3-0x2d2b2c,1235|64|0xd2d4d3-0x2d2b2c",
				dstArea = Rect(
					math.floor(CFG.EFFECTIVE_AREA[1] + (CFG.EFFECTIVE_AREA[3] - CFG.EFFECTIVE_AREA[1]) * 7 / 8),
					0,
					math.floor(CFG.DST_RESOLUTION.width / 8),
					math.floor(CFG.DST_RESOLUTION.height / 8)
				)			
			},
			{
				tag = "门球",
				enable = false,
				anchor = "RT",
				srcPos = "1086|138|0xffffff,1086|168|0xffffff,1084|245|0xffffff,1087|273|0xffffff,1173|127|0xffffff,1175|285|0xffffff",
			},
		},
	},
	{
		tag = "终场统计",
		widgetList = {
			{
				tag = "比赛事件",
				enable = true,
				anchor = "M",
				srcPos = "491|317|0xc6ced3-0x21191d,500|317|0x5fabfe-0x603201,510|344|0x5fabfe-0x603201,523|315|0x5fabfe-0x603201,530|315|0xffffff,537|315|0x5fabfe-0x603201,529|321|0x5fabfe-0x603201",
			},
			{
				tag = "抢断区域",
				enable = true,
				anchor = "M1/3",
				srcPos = "511|510|0xffffff,505|505|0x12a42b,529|541|0x12a42b,519|494|0xc6ced3-0x21191d,532|494|0x5fabfe-0x603201",
			},
			{
				tag = "球员评价",
				enable = true,
				anchor = "RM",
				srcPos = "945|323|0x36b24b-0x240e21,930|306|0x0079fe,957|309|0x0079fe,927|350|0x0079fe,960|350|0x0079fe,944|351|0xffffff,943|339|0x0079fe",
			},
		},
	},
	
	--联赛
	{
		tag = "联赛",
		widgetList = {
			{
				tag = "手动联赛",
				enable = true,
				anchor = "LT",
				srcPos = "106|124|0x0079fe,86|123|0xfefefe,125|124|0xfefefe,80|196|0xfefefe,129|198|0xfefefe,106|198|0x0079fe,87|157|0x0079fe,122|158|0x0079fe",
			},
			{
				tag = "教练模式联赛",
				enable = true,
				anchor = "RT",
				srcPos = "751|129|0x0079fe,752|123|0xfefefe,782|130|0x0079fe,752|198|0x0079fe,731|194|0xfefefe,772|194|0xfefefe,714|153|0xfefefe,790|155|0xfefefe",
			},
		},
	},
	{
		tag = "点球",
		widgetList = {
			{
				tag = "比分综合特征",
				enable = true,
				anchor = "B/4",
				--srcPos = "622|626|0xf0ca8a,710|685|0xf0ca8a,590|646|0x001e30,742|623|0x001e30,1065|636|0x001e30,1218|653|0x001e30,1163|714|0x001e30,114|654|0x001e30,157|601|0x001e30",
				--srcPos = "622|626|0xf0ca8a,710|685|0xf0ca8a,590|646|0x001e30,742|623|0x001e30,1065|636|0x001e30,1224|653|0x001e30,1168|714|0x001e30,106|654|0x001e30,164|598|0x001e30",
				srcPos = "488|662|0x2e002c,521|659|0x47244b-0x050603,551|659|0x2e002c,584|659|0x47244b-0x050603,978|657|0x2e002c,1011|662|0x900888-0x170508,1046|659|0x2e002c,1081|661|0x900888-0x170508",
			},
		},
	},
	{
		tag = "初始化界面INT",
		widgetList = {
			{
				tag = "unreal",
				enable = true,
				anchor = "CRT",
				srcPos = "1258|64|0xffffff,1252|61|0xffffff,1267|60|0xffffff,1260|53|0x363c3f-0x030201,1249|39|0xffffff,1267|42|0xffffff",
			},
			{
				tag = "rakuten",
				enable = true,
				anchor = "A",
				srcPos = "700|346|0xfdfd9f,766|404|0xbbcbc7,865|376|0xdde6e4,715|352|0x6b292f,726|352|0x2d325a",
			},
		},
	},
	{
		tag = "初始化界面",
		widgetList = {
			{
				tag = "实况足球",
				enable = true,
				anchor = "LM",
				--srcPos = "149|305|0xffffff,232|374|0xffffff,301|336|0xffffff,413|351|0xffffff,541|341|0xffffff,388|481|0xffffff,356|515|0xffffff",
				srcPos = "158|307|0xffffff,154|375|0xffffff,416|335|0xffffff,540|307|0xffffff,564|362|0xffffff,563|301|0xffffff",
			},
			{
				tag = "用户协议",
				enable = true,
				anchor = "LB",
				srcPos = "34|569|0xcccccc,31|571|0xcccccc,34|579|0xcccccc,37|576|0xcccccc",
			},
			{
				tag = "unreal",
				enable = true,
				anchor = "CRT",
				srcPos = "1245|40|0xffffff,1252|42|0xffffff,1255|63|0xffffff,1269|61|0xffffff,1268|40|0xffffff,1243|99|0xc3c2c2-0x3c3d3d,1283|97|0xc3c2c2-0x3c3d3d",
			},
		},
	},

	{
		tag = "决战32强",
		widgetList = {
			{
				tag = "报名",
				enable = true,
				anchor = "RB",
				srcPos = "926|645|0x0079fe,666|645|0xf5f5f5,630|639|0xcbdef1,700|650|0xcbdef1,216|634|0xcbdef1,1102|663|0xcbdef1,205|92|0x1b0b38,1135|82|0x1a0b38",
			},
		},
	},
	--[[{
		tag = "冠军赛",
		widgetList = {
			{
				tag = "球队管理",
				enable = true,
				anchor = "LT",
				srcPos = "65|171|0x0079fd,55|169|0xffffff,65|180|0xffffff,92|172|0x0079fd,91|180|0xffffff,124|176|0x12a42b",
			},
			{
				tag = "比赛历史",
				enable = true,
				anchor = "LM",
				srcPos = "77|303|0xc0c7c7-0x141214,72|328|0x55bd74-0x441a4a,61|329|0x0079fe,93|328|0x0079fe,110|329|0x55bd74-0x441a4a,124|327|0x0079fe",
			},
			{	--20190625 和国际服巡回赛重复，需要处理
				tag = "信息框",
				enable = true,
				anchor = "RT",
				srcPos = "1281|207|0x323232,487|210|0x323232,489|603|0x323232,1275|605|0x323232",
			},
		}
	},]]
	{
		tag = "通用比赛界面",
		widgetList = {
			{
				tag = "球队管理",
				enable = true,
				anchor = "LT",
				srcPos = "65|171|0x0079fd,55|169|0xffffff,65|180|0xffffff,92|172|0x0079fd,91|180|0xffffff,124|176|0x12a42b",
			},
			{
				tag = "比赛历史",
				enable = true,
				anchor = "LM",
				srcPos = "77|303|0xc0c7c7-0x141214,72|328|0x55bd74-0x441a4a,61|329|0x0079fe,93|328|0x0079fe,110|329|0x55bd74-0x441a4a,124|327|0x0079fe",
			},
			{	--20190625 和国际服巡回赛重复，需要处理
				tag = "信息框",
				enable = true,
				anchor = "RT",
				srcPos = "1281|207|0x323232,487|210|0x323232,489|603|0x323232,1275|605|0x323232",
			},
			{
				tag = "跳过余下比赛",		--仅用于跳过余下比赛，enable == false，不参与matchPage/matchWidgets
				enable = false,
				anchor = "MTB",
				srcPos = "652|707|0x52a1f9-0x522904,526|689|0xeeeef4,528|724|0xeeeef4,799|691|0xeeeef4,801|718|0xeeeef4,667|662|0xdfdfe1,482|705|0xdfdfe1,861|708|0xdfdfe1",
			},
			{
				tag = "跳过余下比赛-未激活",
				enable = false,
				anchor = "MTB",
				srcPos = "652|708|0x98989c-0x0b0b0b,526|690|0xc5c5c8,527|719|0xc5c5c8,807|689|0xc5c5c8,804|722|0xc5c5c8",
			},
		}
	},
	{
		tag = "冠军赛结束",
		widgetList = {
			{
				tag = "冠军杯标题",
				enable = true,
				anchor = "CLT",
				srcPos = "75|30|0xf9f9fb,76|55|0xfbfbfd,61|44|0x494780-0x181c2a,213|49|0x021e30,632|29|0x021e30",
			},
			{
				tag = "重置",
				enable = true,
				anchor = "BM",
				srcPos = "681|701|0xf9665f-0x042c30,531|693|0xeeeef4,525|720|0xeeeef4,811|695|0xeeeef4,802|722|0xeeeef4",
			},
			{
				tag = "下一步未激活",
				enable = true,
				anchor = "CRB",
				srcPos = "1278|706|0x8d8d92,1287|687|0x5d5d5e,1039|720|0x5d5d5e,1039|691|0x5d5d5e,1280|722|0x5d5d5e",
			},
		},
	},
	{
		tag = "国际服季节赛",
		widgetList = {
			{
				tag = "球队管理",
				enable = true,
				anchor = "LT",
				srcPos = "65|171|0x0079fd,55|169|0xffffff,65|180|0xffffff,92|172|0x0079fd,91|180|0xffffff,124|176|0x12a42b",
			},
			{
				tag = "比赛历史",
				enable = true,
				anchor = "LM",
				srcPos = "77|303|0xc0c7c7-0x141214,72|328|0x55bd74-0x441a4a,61|329|0x0079fe,93|328|0x0079fe,110|329|0x55bd74-0x441a4a,124|327|0x0079fe",
			},
			{
				tag = "信息框",
				enable = true,
				anchor = "M",
				--srcPos = "544|396|0x27ba36,526|478|0xffc000,494|104|0x2a2a2a,514|577|0x323232,1271|108|0x2a2a2a,1250|591|0x323232,525|479|0xffc000,544|396|0x27ba36",
				srcPos = "544|396|0x27ba36,526|478|0xffc000,494|104|0x2a2a2a,514|577|0x323232,1220|108|0x2a2a2a,1220|591|0x323232,525|479|0xffc000,544|396|0x27ba36",
			},
		}
	},
	{
		tag = "国际服巡回赛",
		widgetList = {
			{
				tag = "球队管理",
				enable = true,
				anchor = "LT",
				srcPos = "65|171|0x0079fd,55|169|0xffffff,65|180|0xffffff,92|172|0x0079fd,91|180|0xffffff,124|176|0x12a42b",
			},
			{
				tag = "比赛历史",
				enable = true,
				anchor = "LM",
				srcPos = "77|303|0xc0c7c7-0x141214,72|328|0x55bd74-0x441a4a,61|329|0x0079fe,93|328|0x0079fe,110|329|0x55bd74-0x441a4a,124|327|0x0079fe",
			},
			{
				tag = "信息框",
				enable = true,
				anchor = "LT",
				--srcPos = "491|106|0x2a2a2a,491|603|0x323232,1271|105|0x2a2a2a,1265|595|0x323232,532|226|0xf44189,515|456|0x27ba36,526|513|0x10a2fe",
				srcPos = "491|106|0x2a2a2a,491|603|0x323232,1220|105|0x2a2a2a,1220|595|0x323232,532|226|0xf44189,515|456|0x27ba36,526|513|0x10a2fe",
			},
		}
	},
	{
		tag = "球探名单",
		widgetList = {
			{
				tag = "球探",
				enable = true,
				anchor = "L",
				--srcPos = "191|198|0xfecb00,186|205|0x648799,199|204|0x648799,177|238|0x648799,273|241|0x648799,181|502|0xffffff,149|549|0xffffff",
				srcPos = "192|198|0xfecb00,186|204|0x638698,199|203|0x638698,179|174|0xffffff,176|234|0x638698,275|233|0x638698"
			},
			{
				tag = "解约",
				enable = false,
				anchor = "LB",
				srcPos = "488|706|0xfd3b30,350|690|0xeeeef4,632|720|0xeeeef4,324|704|0xdfdfe1,296|707|0x0079fe",
			},
			{
				tag = "解约确认",
				enable = false,
				anchor = "A",
				srcPos = "821|463|0xfd3c31,689|434|0xdfdfdf,961|480|0xdfdfdf,668|455|0xf5f5f5,367|484|0xcbdef1,635|433|0xcbdef1",
			},
		}
	},
	{
		tag = "挑战赛完成",
		widgetList = {
			{
				tag = "球队管理",
				enable = true,
				anchor = "LT",
				srcPos = "65|171|0x0079fd,55|169|0xffffff,65|180|0xffffff,92|172|0x0079fd,91|180|0xffffff,124|176|0x12a42b",
			},
			{
				tag = "比赛历史",
				enable = true,
				anchor = "LM",
				srcPos = "77|303|0xc0c7c7-0x141214,72|328|0x55bd74-0x441a4a,61|329|0x0079fe,93|328|0x0079fe,110|329|0x55bd74-0x441a4a,124|327|0x0079fe",
			},
			{
				tag = "挑战赛完成提示框",
				enable = true,
				anchor = "RT",
				srcPos = "941|255|0x00bd20,941|275|0xffffff,953|283|0x00bd20,493|103|0x2a2a2a,503|586|0x323232,1157|106|0x2a2a2a,1190|588|0x323233",
			},
		}
	},
}

--公共导航控件，如下一步、返回、确认、取消、通知
local _navigationList = {
	{
		tag = "next",
		enable = true,
		--caching = false,
		anchor = "CRB",
		srcPos = "1277|705|0xC8E2FD-0x361C01,1192|683|0x0079fd,1187|727|0x0079fd,1091|705|0x0079fd",
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
		caching = false,
		anchor = "MTB",
		--srcPos = "843|449|0xcaddf0,884|405|0xcaddf0,507|457|0xcaddf0,409|407|0xcaddf0,487|379|0xf5f5f5,804|491|0xf5f5f5,328|436|0xf5f5f5,1007|435|0xf5f5f5",
		--兼容手机联赛界面的确定按钮过小的问题
		srcPos = "864|497|0xcaddf0,861|467|0xcaddf0,415|475|0xcaddf0,554|499|0xcaddf0,329|486|0xf5f5f5,997|481|0xf5f5f5,502|549|0xf5f5f5,831|427|0xf5f5f5",
	},
	{
		tag = "notice",
		enable = true,
		anchor = "CRT",
		--srcPos = "1279|54|0x55a4f9-0x562b06,1269|45|0x55a4f9-0x562b06,1289|44|0x55a4f9-0x562b06,1268|65|0x55a4f9-0x562b06,1288|64|0x55a4f9-0x562b06,\
		--1268|55|0xccdff2,1278|44|0xccdff2,1289|54|0xccdff2,1198|66|0xffffff",
		srcPos = "1279|54|0x007aff,1267|55|0xccdff2,1289|55|0xccdff2,1278|43|0xccdff2,1271|62|0x007aff,1285|61|0x007aff,1286|47|0x007aff,1273|49|0x007aff"
	},
	{
		tag = "back",
		enable = true,
		anchor = "CLB",
		srcPos = "56|706|0xc8e2fd-0x361c01,72|707|0x0079fe,173|690|0x0079fe,218|719|0x0079fe",
		dstArea = Rect(
			CFG.EFFECTIVE_AREA[1],
			math.floor(CFG.EFFECTIVE_AREA[2] + (CFG.EFFECTIVE_AREA[4] - CFG.EFFECTIVE_AREA[2]) * 7 / 8),
			math.floor(CFG.DST_RESOLUTION.width - (CFG.EFFECTIVE_AREA[1] + (CFG.EFFECTIVE_AREA[3] - CFG.EFFECTIVE_AREA[1]) * 3 / 4)),
			math.floor(CFG.DST_RESOLUTION.height - (CFG.EFFECTIVE_AREA[2] + (CFG.EFFECTIVE_AREA[4] - CFG.EFFECTIVE_AREA[2]) * 7 / 8))
		)
	},
	--被整合，系统直接选是选择好了待续约球员的"球员续约-点击签约"状态
	--{
	--	tag = "球员续约-球员列表",
	--	enable = true,
	--	anchor = "TL",
	--	srcPos = "279|175|0xffffff,279|167|0xff3b2f,267|184|0xff3b2f,290|184|0xff3b2f,278|198|0xff3b2f,100|189|0xffffff,1224|204|0xffffff",
	--	actionFunc = refreshContract	--续约合同,
	--},
	{
		tag = "球员续约-点击签约",
		enable = true,
		anchor = "B/4",
		--srcPos = "822|698|0x0079fd,487|709|0x0079fd,614|702|0xeeeef4,728|707|0xeeeef4,1078|706|0x0079fd",
		srcPos = "822|698|0x0079fd,487|709|0x0079fd,614|702|0xeeeef4,728|707|0xeeeef4",
		actionFunc = refreshContract	--续约合同,
	},
	{
		tag = "教练签约-满足条件",	--不满足条件的，放在巡回赛界面点击续约处理
		enable = true,
		--anchor = "MTB",
		anchor = "BM",
		--srcPos = "651|698|0x66abf9-0x673204,517|689|0xeeeef4,803|721|0xeeeef4,531|353|0x7391af-0x534130,564|230|0x7391af-0x534130",
		--srcPos = "625|672|0x007afd,499|663|0xeeeef4,465|695|0xe2e2e4,30|660|0xe2e2e4,779|694|0xeeeef4,812|661|0xe2e2e4,949|693|0xe2e2e4,998|662|0x5d5d5e,1180|696|0x5d5d5e"
		srcPos = "624|672|0x1885fc-0x190c01,521|663|0xeeeef4,744|696|0xeeeef4,390|667|0xe2e2e4,54|676|0xe2e2e4,876|677|0xe2e2e4,1022|658|0x5d5d5e,1068|693|0x5d5d5e"
	},
	{
		tag = "国际服教练签约-满足条件",	--不满足条件的，放在巡回赛界面点击续约处理
		enable = true,
		--anchor = "MTB",
		anchor = "BM",
		srcPos = "651|700|0x2f90fb-0x2f1702,659|682|0xeeeef4,658|666|0xe2e2e4,659|637|0xffffff,530|690|0xeeeef4,800|722|0xeeeef4,1002|700|0xe2e2e4,1035|699|0x5d5d5e",
		--srcPos = "651|700|0x2f90fb-0x2f1702,659|682|0xf6f6f9-0x090906,658|666|0xebebed-0x0a090a,659|637|0xffffff,530|690|0xf6f6f9-0x090906,800|722|0xf6f6f9-0x090906,1002|700|0xebebed-0x0a090a,1035|699|0x5b5b5c-0x020202",
	},
	{
		tag = "登录奖励",
		enable = true,
		anchor = "R",
		srcPos = "936|364|0x2bb544,924|365|0xffffff,937|373|0xffffff,950|364|0xffffff,936|353|0xffffff,934|344|0x2bb544,936|335|0xffffff,925|355|0xffffff,914|353|0x2bb544",
	},
}

--全局导航优先级
local _navigationPriorityList = {
	"球员续约-点击签约",
	"comfirm",
	"next",
	"notice",
	"教练签约-满足条件",
	"国际服教练签约-满足条件",
	"登录奖励",
}


--公用控件，不参与流程检测，只在特殊界面下出现后，进行点击操作
local _commonWidgetList = {
	{
		tag = "球员续约-点击签约",
		enable = true,
		anchor = "B/4",
		--srcPos = "822|698|0x0079fd,487|709|0x0079fd,614|702|0xeeeef4,728|707|0xeeeef4,1078|706|0x0079fd",
		srcPos = "822|698|0x0079fd,487|709|0x0079fd,614|702|0xeeeef4,728|707|0xeeeef4",
	},
	{
		tag = "球员续约-续约",
		enable = true,
		anchor = "A",
		srcPos = "640|212|0x4a9ffa-0x4b2603,558|211|0x4a9ffa-0x4b2603,784|208|0x4a9ffa-0x4b2603,671|121|0x4a9ffa-0x4b2603,536|536|0xf5f5f5,525|652|0xcbdef1",
	},
	{
		tag = "付款确认",
		enable = true,
		anchor = "A",
		--IOS和安卓偏色不一样，注意取色
		--srcPos = "519|395|0xa0c3fb-0x0b0804,502|394|0x2361d8-0x211f26,476|395|0x2361d8-0x211f26,532|394|0x2361d8-0x211f26,506|339|0xe6e6ed",(只兼容国服)
		--以下改为兼容国际服偏色
		srcPos = "519|395|0xaac7fb-0x0f0804,502|394|0x2258d3-0x222829,476|395|0x2258d3-0x222829,532|394|0x2258d3-0x222829,506|339|0xe6e6ed"
	},
	{
		tag = "球队异常",		--教练合约失效或球员红牌、伤病
		enable = true,
		anchor = "LT",
		srcPos = "429|81|0xffffff,428|72|0xff3b2f,422|81|0xff3b2f,438|82|0xff3b2f,397|101|0xffffff,462|63|0xe1e1e3,370|123|0xffffff",
	},
	{
		tag = "教练合约失效",		--教练合约失效
		enable = true,
		anchor = "CLT",
		srcPos = "146|92|0xffffff,145|84|0xff8a82-0x004f54,134|95|0xff8a82-0x004f54,155|95|0xff8a82-0x004f54,145|111|0xff8a82-0x004f54",
		dstArea = Rect(
			CFG.EFFECTIVE_AREA[1],
			CFG.EFFECTIVE_AREA[2],
			(CFG.EFFECTIVE_AREA[3] - CFG.EFFECTIVE_AREA[1]) / 8,
			(CFG.EFFECTIVE_AREA[4] - CFG.EFFECTIVE_AREA[2]) / 4
		)
	},
	{
		tag = "教练续约",		--点击教练续约
		enable = true,
		anchor = "A",
		srcPos = "687|346|0x6db0f9-0x6e3804,711|242|0x6db0f9-0x6e3804,705|150|0x6db0f9-0x6e3804,683|444|0x6db0f9-0x6e3804",
	},
	{
		tag = "罚点球员",
		enable = true,
		caching = false,
		anchor = "A",
		srcPos = "934|331|0x00f8ff,930|325|0x00f8ff,938|325|0x00f8ff",
	},
	--[[{
		tag = "球队菜单",		--只在球队取了首点，后边的是点在替补席的球衣上，注意锚点
		enable = true,
		caching = false,
		anchor = "LT",
		srcPos = "52|329|0x1d3753-0x060605,106|422|0xfefefe,93|418|0x0079fe,107|408|0x0079fe,118|422|0x0079fe,113|452|0x0079fe,126|439|0xfefefe,63|440|0xfefefe",
	},
	{
		tag = "保存",
		enable = true,
		caching = false,
		anchor = "LB",
		srcPos = "478|697|0xffffff,448|692|0xffffff,512|694|0xffffff,480|666|0xffffff,481|726|0xffffff,237|699|0x0079fe",
	},]]
	{
		tag = "切换小队",
		enable = true,
		caching = false,
		anchor = "T",
		srcPos = "715|159|0x3694fb-0x361c02,694|185|0xf5f5f5,770|244|0x3694fb-0x361c02,765|278|0xf5f5f5,784|592|0xf5f5f5,798|626|0x3694fb-0x361c02",
	},
	{
		tag = "设为主力阵容",
		enable = true,
		caching = false,
		anchor = "TM",
		srcPos = "651|211|0x3694fb-0x361c02,654|126|0xfa766e-0x033b3f,736|294|0x3694fb-0x361c02,672|39|0x3d3d3d-0x3e3e3e",
	},
	{
		tag = "国际服巡回赛自动比赛",
		enable = true,
		caching = false,
		anchor = "MLR",
		srcPos = "851|337|0x444444,867|356|0x444444,841|344|0xf8f9fb,874|344|0x444444,885|346|0xf8f9fb,514|113|0xe6477a,581|110|0xe94c7e",
	},
	{
		tag = "国际服巡回赛手动比赛",
		enable = true,
		caching = false,
		anchor = "MLR",
		srcPos = "470|373|0x444444,461|370|0xf8f9fb,478|368|0xf8f9fb,477|357|0x444444,449|345|0xf8f9fb,457|336|0x444444,971|110|0xe94c7e",
	},
	{
		tag = "开始前续约",
		enable = true,
		caching = false,
		anchor = "MLR",
		srcPos = "686|333|0x1a86fc-0x1b0e01,686|156|0x1a86fc-0x1b0e01,683|445|0x1a86fc-0x1b0e01,679|314|0xf5f5f5,679|371|0xf5f5f5",
	},
}



--将项目的pageList、navigationList和_navigationPriorityList,_commonWidgetList插入page总表
page.loadPagesData(_pageList, _navigationList, _navigationPriorityList, _commonWidgetList)

