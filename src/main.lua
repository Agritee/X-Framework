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
require("task/projPage")
require("task/projFunc")
require("task/rankSim")
require("task/leagueSim")

function main()

	exec.run("天梯", 2)
end

main()