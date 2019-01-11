-- init.lua
-- Author: cndy1860
-- Date: 2018-12-25
-- Descrip: 程序入口，注意require顺序会影响各文件的init，后续添加任务依次require
require("config")
require("global")
require("func")
require("init")
require("scale")
require("page")
require("exec")
require("task/projFunc")
require("task/projPage")
require("task/rankSim")
require("task/leagueSim")
require("ui")

function main()
	screen.keep(false)
	IS_BREAKING_TASK = exec.isExistBreakingTask()
	
	dispUI()
	
	
	if IS_BREAKING_TASK then
		skipInitPage()	--先跳过未定义界面
	end
	
	exec.run(USER.TASK_NAME, USER.REPEAT_TIMES)
	xmod.exit()
end


main()
screen.init(1, 0)
--page.tapWidget("联赛教练模式", "恭喜晋级")

--page.tapNavigation("切换状态")
--prt(page.getCurrentPage())
--page.tapWidget("比赛", "联赛")

--获取一个区域内某种状态的所有球员位置信息
--sleep(2000)
--switchPlayer()

 --prt(scale.offsetPos("343|308|0xffffff,343|315|0x007aff,324|312|0x007aff,363|313|0x007aff,324|355|0x007aff,362|355|0x007aff", Point(342, 306)))
--storage.purge()
--storage.commit()
Log("widget-终场统计-技术统计")
prt(storage.get("widget-终场统计-技术统计", "null"))
storage.purge()
prt(storage.get("widget-终场统计-技术统计", "null"))