-- exec.lua
-- Author: cndy1860
-- Date: 2018-12-25
-- Descrip: 运行任务 

local modName = "exec"
local M = {}

_G[modName] = M
package.loaded[modName] = M

--任务列表，在具体任务(task_list)中的任务文件中会调用task.loadTask()把具体的任务添加到此表中
M.taskList = {}

--将具体任务中的task表添加到taskList总表
function M.loadTask(task)
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

--获取指定任务的流程
function M.getTaskProcesses(taskTag)
	for k, v in pairs(M.taskList) do
		if v.tag == taskTag then
			return v.processes
		end
	end
end

--设置当前任务运行阶段，开始START，结束END，断点任务BREAKING
function M.setExecStatus(status)
	setStringConfig("CurrentExecStatus", status)
end

--是否存在重启游戏的断点任务
function M.isExistBreakingTask()
	local status = getStringConfig("CurrentExecStatus", "END")
	if status == "BREAKING" then
		setStringConfig("CurrentExecStatus", "END")
		Log("____________EXIST A BREAKING TASK____________")
		return true
	end
	
	return false
end

--是否跳过skip机制中_k == k - 1情况的标识，调用之后，会在skip机制中触发跳过当前（前一个）流程
local skipPrevFlag = false
function M.execPrevProcess()
	skipPrevFlag = true
end

--执行任务，param:任务名称，任务重复次数
function M.run(taskName, repeatTimes)
	local reTimes = repeatTimes or CFG.DEFAULT_REPEAT_TIMES
	
	if M.isExistTask(taskName) ~= true then		--检查任务是否存在
		M.setExecStatus("END")	--清空断点任务状态，防止错误卡死
		catchError(ERR_PARAM, "have no task: "..taskName)
	end
	
	if M.getTaskProcesses(taskName) == nil then		--检查任务流程是否存在
		catchError(ERR_PARAM, "task:"..taskName.." have no processes!")
	end
	
	page.setPageEnable(M.getTaskProcesses(taskName))	--设置page.enable

	M.setExecStatus("START")
	
	for i = 1, reTimes, 1 do
		Log("-----------------------START RUN A ROUND OF TASK: "..taskName.."-----------------------")
		local taskProcesses = M.getTaskProcesses(taskName)	--重新获取流程，如果发生了回溯流程片改变了taskProcesses，在此处恢复
		
		for k, v in pairs(taskProcesses) do	
			if v.mode == "firstRun" then				--仅首次运行
				if IS_BREAKING_TASK then		
					if i <= 2 then		--有断点时，前两次都可能不需要跳过，因为恢复可能是从中间的流程片插入的，因而在第二遍流程还是可能返回首个流程片
						v.skipStatus = false
					else
						v.skipStatus = true
					end
				else	--从主界面开始，仅第一次不跳过
					if i <= 1 then
						v.skipStatus = false
					else
						v.skipStatus = true
					end					
				end
			elseif v.mode == "breakingRun" then			--仅发生断点时运行
				if IS_BREAKING_TASK then
					if i <= 1 then		--发生断点时，有且仅有第一遍流程会触发breaking process
						v.skipStatus = false
					else
						v.skipStatus = true
					end
				else
					v.skipStatus = true
				end
			else		--普通流程片默认不跳过
				v.skipStatus = false
			end
		end
		
		local waitCheckSkipTime = 0
		if i == 1 then		--第一次运行就快速检测是否可以跳过主界面
			waitCheckSipTime = 1
		else
			waitCheckSkipTime = CFG.WAIT_CHECK_SKIP
		end
		
		for k, v in pairs(taskProcesses) do
			local checkInterval = v.checkInterval or CFG.DEFAULT_PAGE_CHECK_INTERVAL
			local timeout = v.timeout or CFG.DEFAULT_TIMEOUT
			
			--监听和执行流程片
			local startTime = os.time()
			while true do		--循环匹配当前流程片界面
				if v.skipStatus == true then	--跳过当前界面流程
					Log("skip process: "..v.tag)
					if waitCheckSkipTime ~= CFG.WAIT_CHECK_SKIP then
						waitCheckSkipTime = CFG.WAIT_CHECK_SKIP --第一次进入skip的时候为1秒，在此处恢复
					end
					break
				end
				
				--截取判定帧，在整个监听和执行流程片的过程中，均以此截取的界面进行判定
				--为提高效率，screen.keep(true)尽量只在此处使用，但在process.actionFunc和navigation.actionFunc里可能涉及
				--界面变化，因此进行了刷新帧或者释放帧的操作（这两处在执行完后会返回监听的开始处，重新截取判定帧，所以不影响）
				screen.keep(true)		
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
						if v.nextTag == "next" then		--全局导航next
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
				Log("wait current process: ["..v.tag.."] has : "..(os.time() - startTime))
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
					for _k, _v in pairs(taskProcesses) do
						if _v.tag == currentPage then	--当前界面属于某个流程片的界面
							--按当前等待的流程界面为为k，检测到当前实际界面为_k
							--1.当_k>k时，当前界面为在k之后的流程，直接设置当前流程剩下的skipStatus=true
							--2.当_k==k时，当前界面即为等待界面，matchPage成功根本不会进入此skip流程
							--3.当_k==k-1时，当前界面为等待界面的前一个界面，即为正常等待matchPage，不需skip
							--4.当_k<k-1时，当前界面为在k之前的流程，先设置剩下流程片skipStatus=true，跳过当前流程剩余的
							--所有流程片，然后等循环到下一个流程时，再通过1跳过_k之前的流程，实现skip至_k的功能
							if _k > k then				--当前界面为其后的某个流程片中界面
								Log("set skip latter process")
								for __k, __v  in pairs(taskProcesses) do
									if __k >= k and __k < _k then
										Log("set skipStatus process: "..__v.tag)
										__v.skipStatus = true
									end
								end
								break
							elseif _k < k - 1 then		--当前界面为之前的某个流程片中界面
								Log("set skip befor process")
								for __k, __v  in pairs(taskProcesses) do
									if __k >= k then
										Log("set skipStatus process: "..__v.tag)
										__v.skipStatus = true
									end
								end
								break
							elseif _k == k - 1 and skipPrevFlag then		--当前界面为等待流程的前一个界面
								Log("set skip pre process")
								skipPrevFlag = false
								for __k, __v  in pairs(taskProcesses) do
									if __k >= k then
										Log("set skipStatus process: "..__v.tag)
										__v.skipStatus = true
									end
								end
								break
							end
						end
					end
				end
				
				--处理全局导航事件
				if currentPage == nil and os.time() - startTime >= CFG.WAIT_CHECK_NAVIGATION then
					if page.tryNavigation() then
						sleep(200)
						startTime = os.time()	--防止因执行Navigation.actionFunc超时
					end
				end
				
				sleep(checkInterval)
			end
			
			sleep(50)
		end
		Log("-------------------------END OF THIS ROUND TASK: "..taskName.."-----------------------")
	end
	
	M.setExecStatus("END")
end


