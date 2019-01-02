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

function main()

	exec.run("联赛", 9)
	xmod.exit()
end
sleep(1000)

main()

--page.tapWidget("联赛教练模式", "恭喜晋级")

page.tapNavigation("能量不足")

