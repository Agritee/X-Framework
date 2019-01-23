-- drawBall.lua
-- Author: cndy1860
-- Date: 2019-01-15
-- Descrip: 特殊抽球

local _task = {
	tag = "特殊抽球",
	processes = {
		{tag = "其他", mode = "firstRun"},
		{tag = "合同", nextTag = "经纪人", mode = "firstRun"},
		{tag = "经纪人", nextTag = "特殊经纪人", mode = "firstRun"},
		
		{tag = "箱式经纪人"},	--和箱式一样
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
	if USER.DRAW_MODE == "单抽" then
		page.tapWidget("箱式经纪人", "单抽")
	elseif USER.DRAW_MODE == "十连" then
		page.tapWidget("箱式经纪人", "连抽")
	else
		return
	end
	
	sleep(1000)
	page.tapWidget("箱式经纪人", "金币付款确认")
	sleep(1000)
end
insertFunc("箱式经纪人", fn)

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