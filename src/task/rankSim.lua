-- randSim.lua
-- Author: cndy1860
-- Date: 2018-12-26
-- Descrip: 自动刷天梯赛教练模式
require("exec")

local _task = {
	tag = "天梯",
	processes = {
		--{tag = "其他"},
		--{tag = "比赛", nextTag = "线上对战"},
		--{tag = "线上对战", nextTag = "自动比赛"},
		--{tag = "天梯教练模式", nextTag = "next"},
		--{tag = "匹配对手", nextTag = "next"},
		{tag = "阵容展示", nextTag = "next"},
	},
}

local function insertFunc(processTag, fn)
	for _, v in pairs(_task.processes) do
		if v.tag == processTag then
			v.actionFunc = fn
			return true
		end
	end
end


local fn = function()
	switchMainPage("比赛")
end
insertFunc("其他", fn)


--将任务添加至taskList
exec.insertTask(_task)