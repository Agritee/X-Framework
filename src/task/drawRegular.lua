-- drawRegular.lua
-- Author: cndy1860
-- Date: 2019-01-158
-- Descrip: 标准抽，GP

local _task = {
	tag = "标准抽球",
	processes = {
		{tag = "其他", mode = "firstRun"},
		{tag = "合同", nextTag = "经纪人", mode = "firstRun"},
		{tag = "经纪人", nextTag = "标准经纪人", mode = "firstRun"},
		
		{tag = "标准经纪人"},
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
	switchMainPage("合同")
end
insertFunc("其他", fn)

local fn = function()
	local posationTag = USER.DRAW_REGULAR_POSATION
	page.tapWidget("标准经纪人", posationTag)
	sleep(1000)
	page.tapWidget("标准经纪人", "GP付款确认")
	sleep(1000)
end
insertFunc("标准经纪人", fn)

local fn = function()
	Log("wait drawBall")
	local startTime = os.time()
	local lastDisp = 0
	UI.toast("请等待计时结束", UI.TOAST.LENGTH_LONG)
	while true do
		if os.time() - startTime >= USER.DRAW_STOP_TIME then
			tap(50,50)
			break
		end
	end
	Log("抽球已点击")
end
insertFunc("抽球界面", fn)



--将任务添加至taskList
exec.loadTask(_task)