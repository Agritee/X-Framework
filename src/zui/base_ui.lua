require("zui/Z_ui")

local feildPositionStr = "位置1,位置2,位置3,位置4,位置5,位置6,位置7,位置8,位置9,位置10,位置11,不换"
local feildPositionSubstituteCondition = "主力红才换,好一档就换,好两档才换"

function GetUI()
	DevScreen={--开发设备的参数
		Width=CFG.DEV_RESOLUTION.width,--注意Width要大于Height,开发机分辨率是啥就填啥
		Height=CFG.DEV_RESOLUTION.height --注意Width要大于Height,开发机分辨率是啥就填啥
	}

	local myui=UI:new(DevScreen,{align="left",w=90,h=90,size=40,cancelname="取消",okname="OK",countdown=0,config="zui.dat",bg="bk.png"})--在page中传入的size会成为所有page中所有控件的默认字体大小,同时也会成为所有page控件的最小行距
	local pageBaseSet = Page:new(myui,{text = "基本设置", size = 24})
	pageBaseSet:nextLine()
	pageBaseSet:addLabel({text="								任务选择 ",size=44})
	pageBaseSet:addComboBox({id="comboBoxTask",list="自动联赛,自动天梯,自动巡回,箱式抽球,标准抽球",select=1,w=30,h=12, size = 28})
	
	pageBaseSet:nextLine()
	pageBaseSet:nextLine()
	pageBaseSet:addLabel({text="		开场换人 ",size=30})
	pageBaseSet:addRadioGroup({id="radioSubstitute",list="开启,关闭",select=1,w=35,h=12})
	
	pageBaseSet:addLabel({text="		自动续约 ",size=30})
	pageBaseSet:addRadioGroup({id="radioRefreshConctract",list="开启,关闭",select=1,w=35,h=12})
	
	pageBaseSet:nextLine()
	pageBaseSet:addLabel({text="		购买体力 ",size=30})
	pageBaseSet:addRadioGroup({id="radioRestoredEnergy",list="开启,关闭",select=1,w=35,h=12})

	pageBaseSet:addLabel({text="		恢复体力 ",size=30})
	pageBaseSet:addRadioGroup({id="radioRestoredEnergy",list="开启,关闭",select=1,w=35,h=12})
	
	pageBaseSet:nextLine()
	pageBaseSet:addLabel({text="		抽球类型 ",size=30})
	pageBaseSet:addRadioGroup({id="radioRestoredEnergy",list="单抽,十连",select=0,w=35,h=12})

	pageBaseSet:addLabel({text="		抽球位置 ",size=30})
	pageBaseSet:addRadioGroup({id="radioRestoredEnergy",list="前锋,中场,后卫",select=0,w=35,h=12})
	
	pageBaseSet:nextLine()
	pageBaseSet:addLabel({text="		清空缓存 ",size=30})
	pageBaseSet:addRadioGroup({id="radioRestoredEnergy",list="开启,关闭",select=1,w=35,h=12})
	
	pageBaseSet:addLabel({text="		崩溃重启 ",size=30})
	pageBaseSet:addRadioGroup({id="radioRestart",list="开启,关闭",select=1,w=35,h=12})
	pageBaseSet:nextLine()
	pageBaseSet:addLabel({text="		循环场数 ",size=30})
	pageBaseSet:addEdit({id="editerCircleTimes",prompt="提示文本1",text=tostring(CFG.DEFAULT_REPEAT_TIMES),color="0,0,255",w=20,h=10,align="right",size=24})
	
	
	local pageSubstituteSet = Page:new(myui,{text = "换人设置",size = 24})
	--pageSubstituteSet:addLabel({text="    替补席按从上到下分别编号为1-7号位，球场上11个球员按从上到下，从左到右为1-11号为，可",size=15})
	pageSubstituteSet:nextLine()
	pageSubstituteSet:nextLine()
	pageSubstituteSet:addLabel({text="替补1 ->",size=36})
	pageSubstituteSet:addComboBox({id="comboBoxBench1",list=feildPositionStr,select=11,w=17,h=10, size = 18})
	pageSubstituteSet:addLabel({text=" ",size=24})
	pageSubstituteSet:addComboBox({id="comboBoxBenchCondition1",list=feildPositionSubstituteCondition,select=0,w=24,h=10, size = 18})
	pageSubstituteSet:addLabel({text="                  换人说明",size=24})
	pageSubstituteSet:nextLine()
	pageSubstituteSet:addLabel({text="替补2 ->",size=36})
	pageSubstituteSet:addComboBox({id="comboBoxBench2",list=feildPositionStr,select=11,w=17,h=10, size = 18})
	pageSubstituteSet:addLabel({text=" ",size=24})
	pageSubstituteSet:addComboBox({id="comboBoxBenchCondition2",list=feildPositionSubstituteCondition,select=0,w=24,h=10, size = 18})
	pageSubstituteSet:addLabel({text="        对位换人，替补席从上到下",size=20})
	pageSubstituteSet:nextLine()
	pageSubstituteSet:addLabel({text="替补3 ->",size=36})
	pageSubstituteSet:addComboBox({id="comboBoxBench3",list=feildPositionStr,select=11,w=17,h=10, size = 18})
	pageSubstituteSet:addLabel({text=" ",size=24})
	pageSubstituteSet:addComboBox({id="comboBoxBenchCondition3",list=feildPositionSubstituteCondition,select=0,w=24,h=10, size = 18})
	pageSubstituteSet:addLabel({text="    依次为替补1-7号，场上球员严",size=20})
	pageSubstituteSet:nextLine()
	pageSubstituteSet:addLabel({text="替补4 ->",size=36})
	pageSubstituteSet:addComboBox({id="comboBoxBench4",list=feildPositionStr,select=11,w=17,h=10, size = 18})
	pageSubstituteSet:addLabel({text=" ",size=24})
	pageSubstituteSet:addComboBox({id="comboBoxBenchCondition4",list=feildPositionSubstituteCondition,select=0,w=24,h=10, size = 18})
	pageSubstituteSet:addLabel({text="    格按照从上到下（请参考编号",size=20})
	pageSubstituteSet:nextLine()
	pageSubstituteSet:addLabel({text="替补5 ->",size=36})
	pageSubstituteSet:addComboBox({id="comboBoxBench5",list=feildPositionStr,select=11,w=17,h=10, size = 18})
	pageSubstituteSet:addLabel({text=" ",size=24})
	pageSubstituteSet:addComboBox({id="comboBoxBenchCondition5",list=feildPositionSubstituteCondition,select=0,w=24,h=10, size = 18})
	pageSubstituteSet:addLabel({text="    图示），从左到右的顺序编为",size=20})
	pageSubstituteSet:nextLine()
	pageSubstituteSet:addLabel({text="替补6 ->",size=36})
	pageSubstituteSet:addComboBox({id="comboBoxBench6",list=feildPositionStr,select=11,w=17,h=10, size = 18})
	pageSubstituteSet:addLabel({text=" ",size=24})
	pageSubstituteSet:addComboBox({id="comboBoxBenchCondition6",list=feildPositionSubstituteCondition,select=0,w=24,h=10, size = 18})
	pageSubstituteSet:addLabel({text="    1-11号位置，自行对应，可设",size=20})
	pageSubstituteSet:nextLine()
	pageSubstituteSet:addLabel({text="替补7 ->",size=36})
	pageSubstituteSet:addComboBox({id="comboBoxBench7",list=feildPositionStr,select=11,w=17,h=10, size = 18})
	pageSubstituteSet:addLabel({text=" ",size=24})
	pageSubstituteSet:addComboBox({id="comboBoxBenchCondition7",list=feildPositionSubstituteCondition,select=0,w=24,h=10, size = 18})
	pageSubstituteSet:addLabel({text="    置每个位置的换人条件。",size=20})
	
	
	local pageSubstitutePic = Page:new(myui,{text = "编号图示",size = 24})
	pageSubstitutePic:addLabel({text="        ",size=20})
	pageSubstitutePic:addImage({src="substitute.jpg",w=70,h=100,xpos=0,align="cnter"})
	
	local pageTestting = Page:new(myui,{text = "相关说明",size = 24})
	--pageTestting:nextLine()
	pageTestting:nextLine()
	pageTestting:addLabel({text="    1.只能使用原版背景，游戏时HOME键（导航栏）一定要在右 ",size=20, align="cnter"})
	pageTestting:nextLine()
	pageTestting:addLabel({text="    2.需要开场自动按状态换人的，请在换人设置里设置好换人规则 ",size=20, align="cnter"})
	pageTestting:nextLine()
	pageTestting:addLabel({text="    3.需要下半场换人的请打开自动换人，另建议所有模式下都关闭自动铲球防止红黄牌 ",size=20, align="cnter"})
	pageTestting:nextLine()
	pageTestting:addLabel({text="    4.启动脚本前请先切换至游戏主界面 ",size=20, align="cnter"})
	pageTestting:nextLine()
	pageTestting:addLabel({text="    5.已实现的功能：自动循环刷联赛教练模式，天梯教练模式，支持加时赛和点球，支",size=20, align="cnter"})
	pageTestting:nextLine()
	pageTestting:addLabel({text="       持开场根据球员状态自动换人，支持自动续约教练和球员，支持游戏崩溃自动重启 ",size=20, align="cnter"})
	pageTestting:nextLine()
	pageTestting:addLabel({text="       续接任务 ",size=20, align="cnter"})
	pageTestting:nextLine()
	pageTestting:addLabel({text="    6.目前只适配了16:9的比例，请其他比例分辨率用户暂时使用模拟器尝试 ",size=20, align="cnter"})
	pageTestting:nextLine()
	pageTestting:addLabel({text="    7.另外不喜欢XX助手的用户，可以进群下载本脚本专用小精灵应用 ",size=20, align="cnter"})
	pageTestting:nextLine()
	pageTestting:addLabel({text="    8.有任何问题及建议请反馈给作者，Q群：574025168 ",size=20, align="cnter"})
	
	return myui
end

local ui = GetUI():show(3)