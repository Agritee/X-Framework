local wui = require 'wui.wui'
local cjson = require 'cjson'

--style缩放参数(包括字体大小)，以保证在任何比例的分辨下，UI都能按照开发分辨率的样式完整的呈现，若比例大于开发分辨率，两边留白
local ratio = (CFG.DST_RESOLUTION.height * CFG.DEV_RESOLUTION.width / CFG.DEV_RESOLUTION.height) / CFG.DST_RESOLUTION.width

local uiClosedFlag = false

local _gridList = {
	{
		tag = "选择任务",
		checkedList = {1},
		--当singleCheck为true时，通过USER[singleParamKey]设置值，否则用USER[list[i].paramKey]设置
		--当singleCheck为true时，list每一项对应的值优先取list[i].value，value为nil时直接取title的值
		--当singleCheck为false时，list中，由checkedList标记的项的值优先取list[i].value，value为nil时值为true
		singleCheck = true,
		singleParamKey = "TASK_NAME",
		list = {
			{title = '自动联赛'},
			{title = '自动天梯'},
			{title = '自动巡回', disabled = true},
			{title = '手动联赛', disabled = true},
			{title = '玄学抽球', disabled = true},
			{title = '在线签到', disabled = true},
		},
		style = {
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
	},
	{
		tag = "任务次数",
		checkedList = {4},
		singleCheck = true,
		singleParamKey = "REPEAT_TIMES",
		list = {
			{title = '次数', disabled = true, value = 0},
			{title = '1', value = 1},
			{title = '2', value = 2},
			{title = '5', value = 5},
			{title = '10', value = 10},
			{title = '20', value = 20},
			{title = '50', value = 50},
			{title = '无限', value = 9999},
		},
		style = {
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
			icon = '',
		}
	},
	{
		tag = "选择功能",
		checkedList = {1,2},
		singleCheck = false,
		singleParamKey = nil,
		list = {
			{title = '球员续约', paramKey = "REFRESH_CONCTRACT"},
			{title = '等待恢复', paramKey = "RESTORED_ENERGY"},
			{title = '购买能量', disabled = true, paramKey = "BUY_ENERGY"},
			{title = '开场换人', paramKey = "ALLOW_SUBSTITUTE"},
			{title = '自动重启', paramKey = "ALLOW_RESTART"},
		},
		style = {
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
	},
	
}

--从_gridList获取list，并过滤掉不需要的参数
local function generateGridList(gridTag)
	for k, v in pairs(_gridList) do
		if v.tag == gridTag then
			local tmpList = tbCopy(v.list)
			for _k, _v in pairs(tmpList) do
				if _v.value then
					_v.value = nil
				end
				if _v.paramKey then
					_v.paramKey = nil
				end
			end
			return tmpList
		end
	end
end

--从_gridList获取style
local function generateGridStyle(gridTag)
	for k, v in pairs(_gridList) do
		if v.tag == gridTag then
			return tbCopy(v.style)
		end
	end
end

local function generateGridID(gridTag)
	return string.format("grid_%s", gridTag)
end

local function parserGridID(gridID)
	return string.sub(gridID, 6, -1)
end

local function setGridChecked(gridTag, checkedList)
	for k, v in pairs(_gridList) do
		if v.tag == gridTag then
			v.checkedList = checkedList
			break
		end
	end
end

local function loadGridChecked()
	Log("load last user setting")
	prt(storage.get("TASK_NAME", "NO_TASK"))
	prt(storage.get("REPEAT_TIMES", 0))
	prt(storage.get("REFRESH_CONCTRACT", false))
	prt(storage.get("BUY_ENERGY", false))
	prt(storage.get("RESTORED_ENERGY", false))
	prt(storage.get("ALLOW_SUBSTITUTE", false))
	prt(storage.get("ALLOW_RESTART", false))
	
	for k, v in pairs(_gridList) do
		local storeList = cjson.decode(storage.get(v.tag, "{}"))
		Log("init initCheckedGrid: "..v.tag)
		prt(storeList)
		
		if singleCheck then		--单选
			if #storeList >= 1 then		--单选至少需有一个选项
				v.checkedList = storeList	--为空可能是没有存储过，直接使用表里的默认值
				
				for _k, _v in pairs(v.list) do	--先全部置为unchecked
					_v.checked = false
				end
				for _k, _v in pairs(v.list) do
					for __k, __v in pairs(v.checkedList) do
						if __v == _k then
							_v.checked = true
							break		--仅一个有效
						end
					end
				end
			end
		else					--多选
			v.checkedList = storeList
			for _k, _v in pairs(v.list) do	--先全部置为unchecked
				_v.checked = false
			end
			
			for _k, _v in pairs(v.list) do
				for __k, __v in pairs(v.checkedList) do
					if __v == _k then
						_v.checked = true
					end
				end
			end
		end
	end
end

local function submitGridChecked()
	for k, v in pairs(_gridList) do
		--设置对应的USER值
		if v.singleCheck then		--单选
			USER[v.singleParamKey] = false
			for _k, _v in pairs(v.list) do
				for __k, __v in pairs(v.checkedList) do
					if __v == _k then
						USER[v.singleParamKey] = _v.value or _v.title
						Log("set USER."..v.singleParamKey.."="..(v.value or _v.title))
						break
					end
				end
			end
		else						--多选
			for _k, _v in pairs(v.list) do
				USER[_v.paramKey] = false
			end
			
			for _k, _v in pairs(v.list) do
				for __k, __v in pairs(v.checkedList) do
					if __v == _k then
						USER[_v.paramKey] = true
						Log("set USER.".._v.paramKey.."=true")
						break
					end
				end
			end
		end
		
		--保存当前checkedList数据
		local storeStr = cjson.encode(v.checkedList)
		Log("save user selection: "..storeStr)
		storage.put(v.tag, storeStr)
	end
	
	storage.commit()
end

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

loadGridChecked()

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
			
			wui.GridSelect.createLayout({id = generateGridID("选择任务"), list = generateGridList("选择任务"),
					config = { single = true, totalWidth = 540  * ratio, gridStyle = generateGridStyle("选择任务")} }),
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
			
			wui.GridSelect.createLayout({id = generateGridID("任务次数"), list = generateGridList("任务次数"),
					config = {single = true, totalWidth = 480 * ratio, gridStyle = generateGridStyle("任务次数")} }),
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
			
			wui.GridSelect.createLayout({id = generateGridID("选择功能"), list = generateGridList("选择功能"),
					config = {limit = #(generateGridList("选择功能")), totalWidth = 500 * ratio, gridStyle = generateGridStyle("选择功能")} }),
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
					--wui.GridSelect.createLayout({id = "grid_bench1", list = gridListPosation, config = {single = true, gridStyle = gridStylePosition } }),
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
		
		for k, v in pairs(_gridList) do
			if v.tag == "选择任务" or v.tag == "任务次数" then
				if #v.checkedList == 0 then
					Log("no 选择任务 or 任务次数")
					return
				end
			end
		end
		
		submitGridChecked()
		
		uiClosedFlag = true
		context:close()
		
		return
	end
)


local function setCallbacks()
	for k, v in pairs(_gridList) do
		wui.GridSelect.setOnSelectedCallback(context:findView(generateGridID(v.tag)), function (id, index, checked, checkedList)
				print('wui.GridSelect index: ' .. tostring(index))
				print('wui.GridSelect checked: ' .. tostring(checked))
				for i, v in ipairs(checkedList) do
					print('> wui.GridSelect checkedList index: ' .. tostring(v))
				end
				prt(checkedList)
				setGridChecked(parserGridID(id), checkedList)
			end
		)
	end
end



-- 显示UI，但不会阻塞

local count = 1

function dispUI()
	
	
	print('show view')
	context:show()
	
	while not uiClosedFlag do
		sleep(200)
	end
	
	for i = 1, 7, 1 do
		tmpFieldIndex = string.format("USER.SUBSTITUTE_INDEX_LIST[%d].fieldIndex", i)
		tmpSubstituteCondition = string.format("USER.SUBSTITUTE_INDEX_LIST[%d].substituteCondition", i)
		
		prt(storage.get(tmpFieldIndex, 0))
		prt(storage.get(tmpSubstituteCondition, 0))
	end
end


setCallbacks()
--prt(_gridList)