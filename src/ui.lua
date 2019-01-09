local wui = require 'wui.wui'
local cjson = require 'cjson'

local ratio = (CFG.DST_RESOLUTION.height * CFG.DEV_RESOLUTION.width / CFG.DEV_RESOLUTION.height) / CFG.DST_RESOLUTION.width

local storageUI = {map = {}}

storageUI.put = function(key, value)
	if not key or not value then
		return
	end
	
	storageUI.map[key] = value
end

storageUI.get = function(key, defaultValue)
	if not key or not defaultValue then
		return
	end
	
	storageUI.load()
	
	return storageUI.map[key] or defaultValue
end

storageUI.commit = function() 
	local UIDataStr = cjson.encode(storageUI.map)
	
	storage.put("UIData", UIDataStr)
	storage.commit()
	storageUI.purge()
end

storageUI.purge = function() 
	storageUI.map = {}
end

storageUI.load = function()
	local UIDataStr = storage.get("UIData", "{}")
	
	storageUI.map = cjson.decode(UIDataStr)
end

storageUI.delete = function(key)
	if not key then
		return
	end
	
	storageUI.map[key] = nil
	local tmpTb = storageUI.map
	storageUI.purge()
	storageUI.load()
	storageUI.map[key] = nil
	storageUI.commit()
	storageUI.map = tmpTb
end

local uiClosedFlag = false

local globalStyle = {
	scroller = {
		flex = 1,
	},
}

local rootLayout = {
	view = 'div',
	class = 'div',
	style = {
		width = 750,
		['align-items'] = 'center',
		--['justify-content'] = 'flex-end',
		['justify-content'] = 'center',
	},
	subviews = {
	}
}


local gridStyleTaskSelect = {
	lineSpacing = 14 * ratio,
	width = 160 * ratio,
	height = 60 * ratio,
	fontSize = 24 * ratio,
	color = '#333333',
	checkedColor = '#ffffff',
	disabledColor = '#BBBBBB',
	borderColor = '#666666',
	checkedBorderColor = '#ffb200',
	backgroundColor = '#ffffff',
	checkedBackgroundColor = '#ffb200',
	icon = ''
}

local gridListTaskSelect= {
	{title = '自动联赛'},
	{title = '自动天梯'},
	{title = '自动巡回', disabled = true},
	{title = '手动联赛', disabled = true},
	{title = '玄学抽球', disabled = true},
	{title = '在线签到', disabled = true},
}

local gridStyleTaskRepeat = {
	lineSpacing = 14 * ratio,
	width = 50 * ratio,
	height = 40 * ratio,
	fontSize = 16 * ratio * ratio,
	color = '#999999',
	checkedColor = '#ffffff',
	disabledColor = '#BBBBBB',
	borderColor = '#999999',
	checkedBorderColor = '#ffb200',
	backgroundColor = '#ffffff',
	checkedBackgroundColor = '#ffb200',
	icon = ''
}

local gridListTaskRepeat= {
	{title = '次数', disabled = true},
	{title = '1'},
	{title = '2'},
	{title = '5'},
	{title = '10'},
	{title = '20'},
	{title = '50'},
	{title = '无限'},
}

local gridStyleFunctionSelect = {
	lineSpacing = 14 * ratio,
	width = 160 * ratio,
	height = 60 * ratio,
	fontSize = 24 * ratio,
	color = '#333333',
	checkedColor = '#333333',
	disabledColor = '#BBBBBB',
	borderColor = '#F6F6F6',
	checkedBorderColor = '#ffb200',
	backgroundColor = '#F6F6F6',
	checkedBackgroundColor = '#FFFFFF',
	--icon = ''
}

local gridListFunctionSelect = {
	{title = '球员续约'},
	{title = '购买能量', disabled = true},
	{title = '等待恢复'},
	{title = '开场换人'},
	{title = '自动重启'},
}

local gridStylePosition = {
	lineSpacing = 14 * ratio,
	width = 45 * ratio,
	height = 40 * ratio,
	fontSize = 15 * ratio,
	color = '#333333',
	checkedColor = '#ffffff',
	disabledColor = '#eeeeee',
	borderColor = '#666666',
	checkedBorderColor = '#ffb200',
	backgroundColor = '#ffffff',
	checkedBackgroundColor = '#ffb200',
}

local gridListPosation = {
	{ title = '1', value = 1 },
	{ title = '2', value = 2 },
	{ title = '3', value = 3 },
	{ title = '4', value = 4 },
	{ title = '5', value = 5 },
	{ title = '6', value = 6 },
	{ title = '7', value = 7 },
	{ title = '8', value = 8 },
	{ title = '9', value = 9 },
	{ title = '10', value = 10 },
	{ title = '11', value = 11 }
}

local layoutList = {
	{"TASK_NAME", "grid"},
}

function initUserSelection(paramList)
	for k, v in pairs(paramList) do
		local storeValue = storage.get(v[1], false)
		if storeValue then
			USER[v[1]] = storeValue
		end
		
		if v[2] == "grid" then
			
		end
	end
end

function initUISelect()
	Log("load last user setting")
	prt(storage.get("USER.TASK_NAME", "NO_TASK"))
	prt(storage.get("USER.REPEAT_TIMES", 0))
	prt(storage.get("USER.REFRESH_CONCTRACT", false))
	prt(storage.get("USER.BUY_ENERGY", false))
	prt(storage.get("USER.RESTORED_ENERGY", false))
	prt(storage.get("USER.ALLOW_SUBSTITUTE", false))
	prt(storage.get("USER.ALLOW_RESTART", false))
	

	
	local taskName = storage.get("USER.TASK_NAME", "NO_TASK")
	for _, v in pairs(gridListTaskSelect) do
		if v.title == taskName then
			v.checked = true
			break
		end
	end
	USER.TASK_NAME = taskName
	
	local repeatTimes = storage.get("USER.REPEAT_TIMES", 0)
	if repeatTimes > 0 then
		if repeatTimes == 9999 then
			for _, v in pairs(gridListTaskRepeat) do
				if v.title == "无限" then
					v.checked = true
					break
				end
			end
		else
			for _, v in pairs(gridListTaskRepeat) do
				--prt(v)
				if v.title == tostring(repeatTimes) then
					v.checked = true
					break
				end
			end		
		end
	end
	USER.REPEAT_TIMES = repeatTimes
	
	local refreshConctract = storage.get("USER.REFRESH_CONCTRACT", false)
	if refreshConctract then
		for _, v in pairs(gridListFunctionSelect) do
			if v.title == "球员续约" then
				v.checked = true
				break
			end
		end
	end
	USER.REFRESH_CONCTRACT = refreshConctract
	
	local buyEnergy = storage.get("USER.BUY_ENERGY", false)
	if buyEnergy then
		for _, v in pairs(gridListFunctionSelect) do
			if v.title == "购买能量" then
				v.checked = true
				break
			end
		end
	end
	USER.BUY_ENERGY = buyEnergy
	
	local restoredEnergy = storage.get("USER.RESTORED_ENERGY", false)
	if restoredEnergy then
		for _, v in pairs(gridListFunctionSelect) do
			if v.title == "等待恢复" then
				v.checked = true
				break
			end
		end
	end
	USER.RESTORED_ENERGY = restoredEnergy

	local allowSubstitute = storage.get("USER.ALLOW_SUBSTITUTE", false)
	if allowSubstitute then
		for _, v in pairs(gridListFunctionSelect) do
			if v.title == "开场换人" then
				v.checked = true
				break
			end
		end
	end
	USER.ALLOW_SUBSTITUTE = allowSubstitute

	local allowRestart = storage.get("USER.ALLOW_RESTART", false)
	if allowRestart then
		for _, v in pairs(gridListFunctionSelect) do
			if v.title == "自动重启" then
				v.checked = true
				break
			end
		end
	end
	USER.ALLOW_RESTART = allowRestart
	
	for i = 1, 7, 1 do
		tmpFieldIndex = string.format("USER.SUBSTITUTE_INDEX_LIST[%d].fieldIndex", i)
		tmpSubstituteCondition = string.format("USER.SUBSTITUTE_INDEX_LIST[%d].substituteCondition", i)
		
		USER.SUBSTITUTE_INDEX_LIST[i].fieldIndex = storage.get(tmpFieldIndex, 0)
		USER.SUBSTITUTE_INDEX_LIST[i].substituteCondition = storage.get(tmpSubstituteCondition, 0)
		
		prt(storage.get(tmpFieldIndex, 0))
		prt(storage.get(tmpSubstituteCondition, 0))
	end		
end

initUISelect()

local pages = {
	{
		view = 'div',
		style = {
			width = 700 * ratio,
			['background-color'] = '#FFFFFF',
			['justify-content'] = 'center',
			['align-items'] = 'center'
		},
		subviews = {
			
			
			wui.GridSelect.createLayout({id = "grid_taskSelect", list = gridListTaskSelect, config = { single = true, totalWidth = 540  * ratio, gridStyle = gridStyleTaskSelect } }),
			{
				view = 'div',
				style = {
					width = 700 * ratio,
					['background-color'] = '#FFFFFF',
				},
				subviews = {
					{
						view = 'text',
						value = '\n ',
						style = {
							['background-color'] = '#FFFFFF',
							['font-size'] = 10 * ratio,
							color = '#5f5f5f'
						}
					},
				}
			},
			
			wui.GridSelect.createLayout({id = "grid_taskRepeat", list = gridListTaskRepeat, config = {single = true, totalWidth = 480 * ratio, gridStyle = gridStyleTaskRepeat} }),
			{
				view = 'div',
				style = {
					width = 700 * ratio,
					['background-color'] = '#FFFFFF',
				},
				subviews = {
					{
						view = 'text',
						value = '\n ',
						style = {
							['background-color'] = '#FFFFFF',
							['font-size'] = 14 * ratio,
							color = '#5f5f5f'
						}
					},
				}
			},
			{
				view = 'div',
				style = {
					width = 700 * ratio,
					['background-color'] = '#FFFFFF',
					['justify-content'] = 'space-around',
					--['align-items'] = 'center',
					['flex-direction'] = 'row'
				},
				subviews = {
					wui.Button.createLayout({ id = 'btn_taskCancle', size = 'medium', text = "退出脚本" }),
					wui.Button.createLayout({ id = 'btn_taskOk', size = 'medium', text = "开始任务" })
				}
			}
		}
	},
	{
		view = 'div',
		style = {
			width = 700 * ratio,
			['background-color'] = '#FFFFFF',
			--['justify-content'] = 'center',
			['align-items'] = 'center'
		},
		subviews = {
			{
				view = 'div',
				style = {
					width = 700 * ratio,
					['background-color'] = '#FFFFFF',
					['justify-content'] = 'center',
					['align-items'] = 'center'
				},
				subviews = {
					{
						view = 'text',
						value = '\n请选择需要的功能\n\n',
						style = {
							['background-color'] = '#FFFFFF',
							['font-size'] = 26 * ratio,
							color = '#5f5f5f'
						}
					},
				}
			},
			
			wui.GridSelect.createLayout({id = "grid_functionSelect", list = gridListFunctionSelect, config = {limit = #gridListFunctionSelect, totalWidth = 500 * ratio, gridStyle = gridStyleFunctionSelect} }),
		}
		
	},
	{
		view = 'div',
		style = {
			width = 700 * ratio,
			['background-color'] = '#F0F0F0'
		},
		subviews = {
			{
				view = 'text',
				value = ' ',
				style = {
					['font-size'] = 20 * ratio,
					color = '#5f5f5f'
				}
			},
			{
				view = 'div',
				style = {
					width = 700 * ratio,
					['background-color'] = '#F0F0F0',
					['flex-direction'] = 'row',
				},
				subviews = {
					{
						view = 'text',
						value = '  替补1号位  ',
						style = {
							['font-size'] = 20 * ratio,
							color = '#5f5f5f'
						}
						
					},
					wui.GridSelect.createLayout({id = "grid_bench1", list = gridListPosation, config = {single = true, gridStyle = gridStylePosition } }),
				},
				
			},
			{
				view = 'div',
				style = {
					width = 700 * ratio,
					['background-color'] = '#F0F0F0',
					['flex-direction'] = 'row',
				},
				subviews = {
					{
						view = 'text',
						value = '  替补2号位  ',
						style = {
							['font-size'] = 20 * ratio,
							color = '#5f5f5f'
						}
						
					},
					wui.GridSelect.createLayout({id = "grid_bench2", list = gridListPosation, config = {single = true, gridStyle = gridStylePosition } }),
				},
				
			},
			{
				view = 'div',
				style = {
					width = 700 * ratio,
					['background-color'] = '#F0F0F0',
					['flex-direction'] = 'row',
				},
				subviews = {
					{
						view = 'text',
						value = '  替补3号位  ',
						style = {
							['font-size'] = 20 * ratio,
							color = '#5f5f5f'
						}
						
					},
					wui.GridSelect.createLayout({id = "grid_bench3", list = gridListPosation, config = {single = true, gridStyle = gridStylePosition } }),
				},
			},
			{
				view = 'div',
				style = {
					width = 700 * ratio,
					['background-color'] = '#F0F0F0',
					['flex-direction'] = 'row',
				},
				subviews = {
					{
						view = 'text',
						value = '  替补4号位  ',
						style = {
							['font-size'] = 20 * ratio,
							color = '#5f5f5f'
						}
						
					},
					wui.GridSelect.createLayout({id = "grid_bench4", list = gridListPosation, config = {single = true, gridStyle = gridStylePosition } }),
				},
			},
			{
				view = 'div',
				style = {
					width = 700 * ratio,
					['background-color'] = '#F0F0F0',
					['flex-direction'] = 'row',
				},
				subviews = {
					{
						view = 'text',
						value = '  替补5号位  ',
						style = {
							['font-size'] = 20 * ratio,
							color = '#5f5f5f'
						}
						
					},
					wui.GridSelect.createLayout({id = "grid_bench5", list = gridListPosation, config = {single = true, gridStyle = gridStylePosition } }),
				},
			},
			{
				view = 'div',
				style = {
					width = 700 * ratio,
					['background-color'] = '#F0F0F0',
					['flex-direction'] = 'row',
				},
				subviews = {
					{
						view = 'text',
						value = '  替补6号位  ',
						style = {
							['font-size'] = 20 * ratio,
							color = '#5f5f5f'
						}
						
					},
					wui.GridSelect.createLayout({id = "grid_bench6", list = gridListPosation, config = {single = true, gridStyle = gridStylePosition } }),
				},
			},
			{
				view = 'div',
				style = {
					width = 700 * ratio,
					['background-color'] = '#F0F0F0',
					['flex-direction'] = 'row',
				},
				subviews = {
					{
						view = 'text',
						value = '  替补7号位  ',
						style = {
							['font-size'] = 20 * ratio,
							color = '#5f5f5f'
						}
						
					},
					wui.GridSelect.createLayout({id = "grid_bench7", list = gridListPosation, config = {single = true, gridStyle = gridStylePosition } }),
				},
				
			},
		}
	},
	{
		view = 'div',
		style = {
			width = 700 * ratio,
			['background-color'] = '#F0F0F0'
		},
		subviews = {
			{
				view = 'text',
				value = '教程',
				style = {
					['font-size'] = 20 * ratio,
					color = '#5f5f5f'
				}
				
			}
		}
	},
	
}

local tabPageConfig = {}
tabPageConfig.currentPage = 1
tabPageConfig.pageWidth = 700 * ratio
tabPageConfig.pageHeight = 400 * ratio
tabPageConfig.tabTitles = {
	{
		title = '任务选择',
	},
	{
		title = '功能设置',
	},
	{
		title = '换人设置',
	},
	{
		title = '使用教程',
	},
	
}

tabPageConfig.tabStyle = {
	backgroundColor = '#F0F0F0',
	titleColor = '#666666',
	activeTitleColor = '#3D3D3D',
	activeBackgroundColor = '#F0F0F0',
	isActiveTitleBold = true,
	iconWidth = 0,
	iconHeight = 0,
	width = 160 * ratio,
	height = 50 * ratio,
	fontSize = 24 * ratio,
	hasActiveBottom = true,
	activeBottomColor = '#FFC900',
	activeBottomHeight = 6,
	activeBottomWidth = 120,
	textPaddingLeft = 10,
	textPaddingRight = 10
}

tabPageConfig.wrapBackgroundColor= '#FF0000'

local context = UI.createContext(rootLayout, globalStyle)
local rootView = context:getRootView()

local tabPage = wui.TabPage.createView(context, { pages = pages, config = tabPageConfig })
rootView:addSubview(tabPage)

wui.TabPage.setOnSelectedCallback(tabPage, function (id, currentPage)
		print('wui.TabPage id: ' .. id)
		print('wui.TabPage currentPage: ' .. tostring(currentPage))
	end)

wui.Button.setOnClickedCallback(context:findView('btn_taskCancle'), function (id, action)
		printf('wui.Button %s click', id)
		
		uiClosedFlag = true
		context:close()
		storage.purge()
		xmod.exit()
	end
)

wui.Button.setOnClickedCallback(context:findView('btn_taskOk'), function (id, action)
		printf('wui.Button %s click', id)
		prt(USER.TASK_NAME)
		prt(USER.REPEAT_TIMES)
		
		local exsitFlag = false
		for k, v in pairs(gridListTaskSelect) do
			if USER.TASK_NAME == v.title then
				exsitFlag = true
				break
			end
		end
		if not exsitFlag then
			return
		end
		
		exsitFlag = false
		for k, v in pairs(gridListTaskRepeat) do
			if USER.REPEAT_TIMES == 9999 or v.title == tostring(USER.REPEAT_TIMES) then
				exsitFlag = true
				break
			end
		end
		if not exsitFlag then
			return
		end
		
		uiClosedFlag = true
		context:close()
		
		return
	end
)

wui.GridSelect.setOnSelectedCallback(context:findView("grid_taskRepeat"), function (id, index, checked, checkedList)
		print('wui.GridSelect index: ' .. tostring(index))
		print('wui.GridSelect checked: ' .. tostring(checked))
		for i, v in ipairs(checkedList) do
			print('> wui.GridSelect checkedList index: ' .. tostring(v))
		end
		
		local isChecked = function(checkedIndex)
			for _k, _v in pairs(checkedList) do
				if _v == checkedIndex then
					return true
				end
			end
			
			return false
		end
		
		if checked then
			if isChecked(1) then
				USER.REPEAT_TIMES = 1
			elseif isChecked(2) then
				USER.REPEAT_TIMES = 1
			elseif isChecked(3) then
				USER.REPEAT_TIMES = 2
			elseif isChecked(4) then
				USER.REPEAT_TIMES = 5
			elseif isChecked(5) then
				USER.REPEAT_TIMES = 10
			elseif isChecked(6) then
				USER.REPEAT_TIMES = 20
			elseif isChecked(7) then
				USER.REPEAT_TIMES = 50
			elseif isChecked(8) then
				USER.REPEAT_TIMES = 9999
			end
		else
			USER.REPEAT_TIMES = 0
		end
		
		storage.put("USER.REPEAT_TIMES", USER.REPEAT_TIMES)
		prt(USER.REPEAT_TIMES)
	end
)

wui.GridSelect.setOnSelectedCallback(context:findView("grid_taskSelect"), function (id, index, checked, checkedList)
		print('wui.GridSelect index: ' .. tostring(index))
		print('wui.GridSelect checked: ' .. tostring(checked))
		for i, v in ipairs(checkedList) do
			print('> wui.GridSelect checkedList index: ' .. tostring(v))
		end
		
		if checked then
			USER.TASK_NAME = gridListTaskSelect[checkedList[1]].title
			storage.put("USER.TASK_NAME", USER.TASK_NAME)
		else
			USER.TASK_NAME = nil
		end
	end
)

wui.GridSelect.setOnSelectedCallback(context:findView("grid_functionSelect"), function (id, index, checked, checkedList)
		print('wui.GridSelect index: ' .. tostring(index))
		print('wui.GridSelect checked: ' .. tostring(checked))
		for i, v in ipairs(checkedList) do
			print('> wui.GridSelect checkedList index: ' .. tostring(v))
		end
		
		local isChecked = function(checkedIndex)
			for _k, _v in pairs(checkedList) do
				if _v == checkedIndex then
					return true
				end
			end
			
			return false
		end
		
		if checked then
			if isChecked(1) then
				USER.REFRESH_CONCTRACT = true
			else
				USER.REFRESH_CONCTRACT = false
			end
			
			if isChecked(2) then
				USER.BUY_ENERGY = true
			else
				USER.BUY_ENERGY = false
			end
			
			if isChecked(3) then
				USER.RESTORED_ENERGY = true
			else
				USER.RESTORED_ENERGY = false
			end
			
			if isChecked(4) then
				USER.ALLOW_SUBSTITUTE = true
			else
				USER.ALLOW_SUBSTITUTE = false
			end
			
			if isChecked(5) then
				USER.ALLOW_RESTART = true
			else
				USER.ALLOW_RESTART = false
			end
		else
			USER.REFRESH_CONCTRACT = false
			USER.BUY_ENERGY = false
			USER.RESTORED_ENERGY = false
			USER.ALLOW_SUBSTITUTE = false
			USER.ALLOW_RESTART = false
		end
		
		storage.put("USER.REFRESH_CONCTRACT", USER.REFRESH_CONCTRACT)
		storage.put("USER.BUY_ENERGY", USER.BUY_ENERGY)
		storage.put("USER.RESTORED_ENERGY", USER.RESTORED_ENERGY)
		storage.put("USER.ALLOW_SUBSTITUTE", USER.ALLOW_SUBSTITUTE)
		storage.put("USER.ALLOW_RESTART", USER.ALLOW_RESTART)
		
	end,
	function (id, limit)
		print('wui.GridSelect limit: ' .. tostring(limit))
	end
)

local benchList = {'grid_bench1', 'grid_bench2', 'grid_bench3', 'grid_bench4', 'grid_bench5', 'grid_bench6', 'grid_bench7'}

for k, v in pairs(benchList) do
	wui.GridSelect.setOnSelectedCallback(context:findView(v), function(id, index, checked, checkedList)
			print('wui.GridSelect id: ' .. tostring(id))
			print('wui.GridSelect index: ' .. tostring(index))
			print('wui.GridSelect checked: ' .. tostring(checked))
			
			for _k, _v in pairs(benchList) do
				if _v == id then
					if checked then
						USER.SUBSTITUTE_INDEX_LIST[_k].fieldIndex = index
						USER.SUBSTITUTE_INDEX_LIST[_k].substituteCondition = 1
					else
						USER.SUBSTITUTE_INDEX_LIST[_k].fieldIndex = 0
						USER.SUBSTITUTE_INDEX_LIST[_k].substituteCondition = 0
					end

					storage.put(string.format("USER.SUBSTITUTE_INDEX_LIST[%d].fieldIndex", _k), index)
					storage.put(string.format("USER.SUBSTITUTE_INDEX_LIST[%d].substituteCondition", _k), 1)
					break
				end
			end
			--prt(USER.SUBSTITUTE_INDEX_LIST)
			
		end)
end




-- 显示UI，但不会阻塞

local count = 1

function dispUI()

	
	print('show view')
	context:show()

	while not uiClosedFlag do
		sleep(200)
	end
	
	storage.commit()
	
	Log("storage.commit yet, prt info")
	prt(storage.get("USER.TASK_NAME", "NO_TASK"))
	prt(storage.get("USER.REPEAT_TIMES", 0))
	prt(storage.get("USER.REFRESH_CONCTRACT", false))
	prt(storage.get("USER.BUY_ENERGY", false))
	prt(storage.get("USER.RESTORED_ENERGY", false))
	prt(storage.get("USER.ALLOW_SUBSTITUTE", false))
	prt(storage.get("USER.ALLOW_RESTART", false))
	
	for i = 1, 7, 1 do
		tmpFieldIndex = string.format("USER.SUBSTITUTE_INDEX_LIST[%d].fieldIndex", i)
		tmpSubstituteCondition = string.format("USER.SUBSTITUTE_INDEX_LIST[%d].substituteCondition", i)
		
		prt(storage.get(tmpFieldIndex, 0))
		prt(storage.get(tmpSubstituteCondition, 0))
	end
end