-- exec.lua
-- Author: cndy1860
-- Date: 2018-12-25
-- Descrip: 运行任务

local modName = "exec"
local M = {}

_G[modName] = M
package.loaded[modName] = M

--任务列表，在具体任务(task_list)中的任务文件中会调用task.insert()把具体的任务添加到此表中
M.taskList = {}

--将具体任务中的task表添加到taskList总表
function M.insertTask(task)
	table.insert(M.taskList, task)
	--prt(M.taskList)
end

--检测任务是否存在
function M.isExistTask(taskName)
	for _, v in pairs(M.taskList) do
		if taskName == v.tag then
			return true
		end
	end
	
	return false
end

--设置当前任务运行阶段
function M.setExecStatus(status)
	setStringConfig("CurrentExecStatus", status)
end

--获取当前任务
function M.getCurrentTask()
	if CURRENT_TASK ~= TASK_NONE and CURRENT_TASK ~= nil then
		return CURRENT_TASK
	end
end

--获取当前任务的流程
function M.getTaskProcesses(taskName)
	for k, v in pairs(M.taskList) do
		if v.tag == taskName then
			return v.processes
		end
	end
end

--当前界面是否为当前任务流程中的某一个流程片的界面
function M.isInTaskPage()
	local currentPage = M.getCurrentPage()
	if currentPage == nil or currentPage == PAGE_NONE then
		return false
	end
	
	local currentProcesses = M.getTaskProcesses(CURRENT_TASK)
	for k, v in pairs(currentProcesses) do
		if v.tag == currentPage then
			return true
		end
	end
	return false
end

--回溯流程片tag，用于M.run中控制回溯流程片
local backProcessTag = nil
function M.setBackProcess(backTag)
	backProcessTag = backTag
end

--执行任务，param:任务名称，任务重复次数
function M.run(taskName, repeatTimes)
	local reTimes = repeatTimes or CFG.DEFAULT_REPEAT_TIMES
	
	if M.isExistTask(taskName) ~= true then		--检查任务是否存在
		M.setExecStatus("end")	--清空断点任务状态，防止错误卡死
		catchError(ERR_PARAM, "have no task: "..taskName)
	end
	
	if M.getTaskProcesses(taskName) == nil then		--检查任务流程是否存在
		catchError(ERR_PARAM, "task:"..taskName.." have no processes!")
	end
	--[[
	if page.getCurrentPage() == nil then	--等待获取一个已定义界面(非过度界面)
		Log("waiting until catch a not nil page")
		local startTime = os.time()
		while true do
			if page.getCurrentPage() then
				break
			end
			
			if os.time() - startTime > CFG.DEFAULT_TIMEOUT then
				catchError(ERR_TIMEOUT, "still start from a unkown page! can not work!")
			end
			
			sleep(200)
		end
		end]]
		
		M.setExecStatus("start")
		
		for i = 1, reTimes, 1 do
			Log("-----------------------START RUN A ROUND OF TASK: "..taskName.."-----------------------")
			local taskProcesses = M.getTaskProcesses(taskName)	--重新获取流程，如果发生了回溯流程片改变了taskProcesses，在此处恢复
			
			for k, v in pairs(taskProcesses) do
				if i == 1 then	--首次运行断点流程(断点未发生的情况下)均不跳过
					if v.justBreakingRun == true then
						if IS_BREAKING_TASK then
							v.skipStatus = false
						else
							v.skipStatus = true
						end
					else
						v.skipStatus = false
					end
				else	--非首次运行跳过仅首次运行和续接断点流程片的流程片
					if v.justFirstRun or v.justBreakingRun then	--跳过只允许首次运行的流程片和断点流程片
						v.skipStatus = true
					else
						v.skipStatus = false
					end
				end
			end
			
			local waitCheckSkipTime = 0
			if i == 1 then		--第一次运行就快速检测是否可以跳过主界面
				waitCheckSipTime = 1
				--waitCheckSkipTime = CFG.WAIT_CHECK_SKIP
			else
				waitCheckSkipTime = CFG.WAIT_CHECK_SKIP
			end
			--prt(taskProcesses)
			for k, v in pairs(taskProcesses) do
				local checkInterval = v.checkInterval or CFG.DEFAULT_PAGE_CHECK_INTERVAL
				local timeout = v.timeout or CFG.DEFAULT_TIMEOUT
				
				local startTime = os.time()
				while true do		--循环匹配当前流程片界面
					if v.skipStatus == true then	--跳过当前界面流程
						Log("skip process: "..v.tag)
						if waitCheckSkipTime ~= CFG.WAIT_CHECK_SKIP then
							waitCheckSkipTime = CFG.WAIT_CHECK_SKIP --第一次进入skip的时候为1秒，在此处恢复
						end
						break
					end
					
					screen.keep(true)		--为提高效率screen.keep(true)只在此处使用，其他地方慎用
					local currentPage = page.getCurrentPage()
					
					--Log("try match process page: "..v.tag)
					if currentPage == v.tag then
						--actionFunc中，涉及到界面变化时(actionFunc和next)会放开screen.keep(false)进行界面判定，但是因为完成actionFunc和next后，
						--会重新返回screen.keep(true)处
						screen.keep(false)		--执行actionFunc可能涉及到界面变化
						
						Log("------start execute process: "..v.tag)
						if v.actionFunc == nil then
							Log("process: "..v.tag.." have no actionFunc")
						else
							Log("------>start actionFunc")
							v.actionFunc()	--执行
							Log("------>end actionFunc")
						end
						
						--exec next
						if v.nextTag ~= nil then 	--有下一步事件
							Log("start next at process page: "..v.tag)
							
							if v.nextTag == "pageNext" then		--页面专用next
								page.tapPageNext(v.tag)
							elseif v.nextTag == "next" then		--全局导航next
								page.tapNext()
							else						--点击某个控件作为next
								page.tapWidget(v.tag, v.nextTag)
							end
							
							Log("end next")
						end
						
						Log("--------end execute process: "..v.tag)
						break	--完成当前流程片
					end
					
					--检测流程是否超时
					Log("process index:"..k.." ----wait current process has : "..(os.time() - startTime))
					if os.time() - startTime > timeout then	--流程超时
						catchError(ERR_TIMEOUT, "have waitting process: "..v.tag.." "..tostring(os.time() - startTime).."s yet, try end it")
					end
					
					--等待期间执行的process的等待函数
					if v.waitFunc ~= nil then
						v.waitFunc(k)
					end
					
					--检测是否需要跳过当前流程片
					--如果当前检测到的界面page_current为当前流程片界面page_k之后的某个流程片的界面page_k+n，那么设
					--置page_k至page_k+n之间所有的流程片的sikpStaut属性为true
					if currentPage ~= nil and os.time() - startTime > waitCheckSkipTime then	--跳过
						local isProcessPage = false
						local pageIndex = 0
						for _k, _v in pairs(taskProcesses) do
							if _k > k and _v.tag == currentPage then	--当前界面为其后的某个流程片中界面
								Log("set it skip between current process page and a next process page")
								for __k, __v  in pairs(taskProcesses) do
									if __k >= k and __k < _k then
										Log("set skipStatus true: "..__v.tag)
										__v.skipStatus = true
									end
								end
								break	--必须跳出，不然后边的相同名称流程片也被skip了
							end
						end
					end
					
					--是否需要处理全局导航事件
					if currentPage == nil and os.time() - startTime >= CFG.WAIT_CHECK_NAVIGATION then
						screen.keep(false)		--执行execNavigation.actionFunc可能涉及到界面变化
						if page.execNavigation() then
							sleep(200)
							--Log("executed a navigation")
						end
					end
					
					--检测是否需要回溯流程片，当运行到流程片k的时候，如需返回至K或k之前的某个流程片
					--实现方法为：在k至k+1之间，插入需要回溯的流程片，例：processes = {p1, p2, p3, p4}，假如当运行完p3时，我们需要
					--返回至p1，那么当运行到p3后，插入p1-p3的流程，即为processes = {p1, p2, p3, p1, p2, p3, p4}
					--因在execNavigation中可能触发回溯，故而放在execNavigation之后
					if backProcessTag then
						Log("Exsit backProcess")
						for _k, _v in pairs(taskProcesses) do
							if _v.tag == backProcessTag and _k <= k then	--在当前(下一个)流程片之前存在backProcess流程片，满足回溯条件
								local tmpProcesses = taskProcesses
								local insertIndex = k + 1
								for __k, __v in pairs(taskProcesses) do
									if __k >= _k and __k <= k then
										table.insert(tmpProcesses, insertIndex, __v)	--将需要回溯的流程片插入tmpProcesses
										insertIndex = insertIndex + 1
										--prt(tmpProcesses)
									end
								end
								taskProcesses = tmpProcesses
								Log("---------insert backProcess---------")
								prt(taskProcesses)
							end
						end
						backProcessTag = nil		--清除状态
					end
					
					sleep(checkInterval)
				end
				
				sleep(50)
			end
			Log("-------------------------END OF THIS ROUND TASK: "..taskName.."-----------------------")
		end
		
		M.setExecStatus("end")
	end
	
	
	