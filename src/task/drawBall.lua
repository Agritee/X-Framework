-- drawBall.lua
-- Author: cndy1860
-- Date: 2019-01-15
-- Descrip: 抽球

local _task = {
	tag = "玄学抽球",
	processes = {
		{tag = "抽球-支付界面"},
		{tag = "抽球界面"},
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

local function insertWaitFunc(processTag, fn)
	for _, v in pairs(_task.processes) do
		if v.tag == processTag then
			v.waitFunc = fn
			return true
		end
	end
end

local fn = function()
	page.tapNavigation("comfirm")
end
insertFunc("抽球-支付界面", fn)

local fn = function()
	Log("wait drawBall")
	local startTime = os.time()
	local lastDisp = 0
	while true do
		currentTime = os.time()

		if currentTime - startTime >= 13 then
			tap(50,50)
			break
		end
		
		log(tostring(currentTime - startTime))
	end
	
	xmod.exit()
end
insertFunc("抽球界面", fn)



--将任务添加至taskList
exec.loadTask(_task)