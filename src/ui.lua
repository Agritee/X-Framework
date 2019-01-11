local wui = require 'wui.wui'
local cjson = require 'cjson'

--style缩放参数(包括字体大小)，以保证在任何比例的分辨下，UI都能按照开发分辨率的样式完整的呈现，若比例大于开发分辨率，两边留白
local ratio = (CFG.DST_RESOLUTION.height * CFG.DEV_RESOLUTION.width / CFG.DEV_RESOLUTION.height) / CFG.DST_RESOLUTION.width

local showwingFlag = true

local _gridList = {
	{
		tag = "选择任务",
		checkedList = {1},
		--当singleCheck为true时，通过USER[singleParamKey]设置值，否则用USER[list[i].paramKey]设置
		--当singleCheck为true时，list每一项对应的值优先取list[i].value，value为nil时直接取title的值
		--当singleCheck为false时，list中，由checkedList标记的项的值优先取list[i].value，value为nil时值为true
		singleCheck = true,
		singleBindParam = "USER.TASK_NAME",
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
		singleBindParam = "USER.REPEAT_TIMES",
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
			{title = '球员续约', bindParam = "USER.REFRESH_CONCTRACT"},
			{title = '等待恢复', bindParam = "USER.RESTORED_ENERGY"},
			{title = '购买能量', disabled = true, bindParam = "USER.BUY_ENERGY"},
			{title = '开场换人', bindParam = "USER.ALLOW_SUBSTITUTE"},
			{title = '自动重启', bindParam = "USER.ALLOW_RESTART"},
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
	{
		tag = "替补1",
		checkedList = {},
		singleCheck = true,
		singleBindParam = "USER.SUBSTITUTE_INDEX_LIST[1].fieldIndex",
		list = {
			{title = 'P1', disabled = true},
			{title = '1', value = 1},
			{title = '2', value = 2},
			{title = '3', value = 3},
			{title = '4', value = 4},
			{title = '5', value = 5},
			{title = '6', value = 6},
			{title = '7', value = 7},
			{title = '8', value = 8},
			{title = '9', value = 9},
			{title = '10', value = 10},
			{title = '11', value = 11},
		},
		style = {
			lineSpacing = 14 * ratio,
			width = 36 * ratio,
			height = 30 * ratio,
			fontSize = 10 * ratio,
			color = '#333333',
			checkedColor = '#333333',
			disabledColor = '#BBBBBB',
			borderColor = '#F6F6F6',
			checkedBorderColor = '#ffb200',
			backgroundColor = '#F6F6F6',
			checkedBackgroundColor = '#FFFFFF',
			icon = ''
		}
	},
	{
		tag = "状态1",
		checkedList = {},
		singleCheck = true,
		singleBindParam = "USER.SUBSTITUTE_INDEX_LIST[1].substituteCondition",
		list = {
			{title = "好一档", value = 1},
			{title = "好两档", value = 2},
			{title = "主力红", value = 0},
		},
		style = {
			lineSpacing = 14 * ratio,
			width = 50 * ratio,
			height = 30 * ratio,
			fontSize = 10 * ratio,
			color = '#333333',
			checkedColor = '#333333',
			disabledColor = '#BBBBBB',
			borderColor = '#F6F6F6',
			checkedBorderColor = '#ffb200',
			backgroundColor = '#F6F6F6',
			checkedBackgroundColor = '#FFFFFF',
			icon = ''
		}
	},
{
		tag = "替补2",
		checkedList = {},
		singleCheck = true,
		singleBindParam = "USER.SUBSTITUTE_INDEX_LIST[2].fieldIndex",
		list = {
			{title = 'P2', disabled = true},
			{title = '1', value = 1},
			{title = '2', value = 2},
			{title = '3', value = 3},
			{title = '4', value = 4},
			{title = '5', value = 5},
			{title = '6', value = 6},
			{title = '7', value = 7},
			{title = '8', value = 8},
			{title = '9', value = 9},
			{title = '10', value = 10},
			{title = '11', value = 11},
		},
		style = {
			lineSpacing = 14 * ratio,
			width = 36 * ratio,
			height = 30 * ratio,
			fontSize = 10 * ratio,
			color = '#333333',
			checkedColor = '#333333',
			disabledColor = '#BBBBBB',
			borderColor = '#F6F6F6',
			checkedBorderColor = '#ffb200',
			backgroundColor = '#F6F6F6',
			checkedBackgroundColor = '#FFFFFF',
			icon = ''
		}
	},
	{
		tag = "状态2",
		checkedList = {},
		singleCheck = true,
		singleBindParam = "USER.SUBSTITUTE_INDEX_LIST[2].substituteCondition",
		list = {
			{title = "好一档", value = 1},
			{title = "好两档", value = 2},
			{title = "主力红", value = 0},
		},
		style = {
			lineSpacing = 14 * ratio,
			width = 50 * ratio,
			height = 30 * ratio,
			fontSize = 10 * ratio,
			color = '#333333',
			checkedColor = '#333333',
			disabledColor = '#BBBBBB',
			borderColor = '#F6F6F6',
			checkedBorderColor = '#ffb200',
			backgroundColor = '#F6F6F6',
			checkedBackgroundColor = '#FFFFFF',
			icon = ''
		}
	},
{
		tag = "替补3",
		checkedList = {},
		singleCheck = true,
		singleBindParam = "USER.SUBSTITUTE_INDEX_LIST[3].fieldIndex",
		list = {
			{title = 'P3', disabled = true},
			{title = '1', value = 1},
			{title = '2', value = 2},
			{title = '3', value = 3},
			{title = '4', value = 4},
			{title = '5', value = 5},
			{title = '6', value = 6},
			{title = '7', value = 7},
			{title = '8', value = 8},
			{title = '9', value = 9},
			{title = '10', value = 10},
			{title = '11', value = 11},
		},
		style = {
			lineSpacing = 14 * ratio,
			width = 36 * ratio,
			height = 30 * ratio,
			fontSize = 10 * ratio,
			color = '#333333',
			checkedColor = '#333333',
			disabledColor = '#BBBBBB',
			borderColor = '#F6F6F6',
			checkedBorderColor = '#ffb200',
			backgroundColor = '#F6F6F6',
			checkedBackgroundColor = '#FFFFFF',
			icon = ''
		}
	},
	{
		tag = "状态3",
		checkedList = {},
		singleCheck = true,
		singleBindParam = "USER.SUBSTITUTE_INDEX_LIST[3].substituteCondition",
		list = {
			{title = "好一档", value = 1},
			{title = "好两档", value = 2},
			{title = "主力红", value = 0},
		},
		style = {
			lineSpacing = 14 * ratio,
			width = 50 * ratio,
			height = 30 * ratio,
			fontSize = 10 * ratio,
			color = '#333333',
			checkedColor = '#333333',
			disabledColor = '#BBBBBB',
			borderColor = '#F6F6F6',
			checkedBorderColor = '#ffb200',
			backgroundColor = '#F6F6F6',
			checkedBackgroundColor = '#FFFFFF',
			icon = ''
		}
	},
{
		tag = "替补4",
		checkedList = {},
		singleCheck = true,
		singleBindParam = "USER.SUBSTITUTE_INDEX_LIST[4].fieldIndex",
		list = {
			{title = 'P4', disabled = true},
			{title = '1', value = 1},
			{title = '2', value = 2},
			{title = '3', value = 3},
			{title = '4', value = 4},
			{title = '5', value = 5},
			{title = '6', value = 6},
			{title = '7', value = 7},
			{title = '8', value = 8},
			{title = '9', value = 9},
			{title = '10', value = 10},
			{title = '11', value = 11},
		},
		style = {
			lineSpacing = 14 * ratio,
			width = 36 * ratio,
			height = 30 * ratio,
			fontSize = 10 * ratio,
			color = '#333333',
			checkedColor = '#333333',
			disabledColor = '#BBBBBB',
			borderColor = '#F6F6F6',
			checkedBorderColor = '#ffb200',
			backgroundColor = '#F6F6F6',
			checkedBackgroundColor = '#FFFFFF',
			icon = ''
		}
	},
	{
		tag = "状态4",
		checkedList = {},
		singleCheck = true,
		singleBindParam = "USER.SUBSTITUTE_INDEX_LIST[4].substituteCondition",
		list = {
			{title = "好一档", value = 1},
			{title = "好两档", value = 2},
			{title = "主力红", value = 0},
		},
		style = {
			lineSpacing = 14 * ratio,
			width = 50 * ratio,
			height = 30 * ratio,
			fontSize = 10 * ratio,
			color = '#333333',
			checkedColor = '#333333',
			disabledColor = '#BBBBBB',
			borderColor = '#F6F6F6',
			checkedBorderColor = '#ffb200',
			backgroundColor = '#F6F6F6',
			checkedBackgroundColor = '#FFFFFF',
			icon = ''
		}
	},
{
		tag = "替补5",
		checkedList = {},
		singleCheck = true,
		singleBindParam = "USER.SUBSTITUTE_INDEX_LIST[5].fieldIndex",
		list = {
			{title = 'P5', disabled = true},
			{title = '1', value = 1},
			{title = '2', value = 2},
			{title = '3', value = 3},
			{title = '4', value = 4},
			{title = '5', value = 5},
			{title = '6', value = 6},
			{title = '7', value = 7},
			{title = '8', value = 8},
			{title = '9', value = 9},
			{title = '10', value = 10},
			{title = '11', value = 11},
		},
		style = {
			lineSpacing = 14 * ratio,
			width = 36 * ratio,
			height = 30 * ratio,
			fontSize = 10 * ratio,
			color = '#333333',
			checkedColor = '#333333',
			disabledColor = '#BBBBBB',
			borderColor = '#F6F6F6',
			checkedBorderColor = '#ffb200',
			backgroundColor = '#F6F6F6',
			checkedBackgroundColor = '#FFFFFF',
			icon = ''
		}
	},
	{
		tag = "状态5",
		checkedList = {},
		singleCheck = true,
		singleBindParam = "USER.SUBSTITUTE_INDEX_LIST[5].substituteCondition",
		list = {
			{title = "好一档", value = 1},
			{title = "好两档", value = 2},
			{title = "主力红", value = 0},
		},
		style = {
			lineSpacing = 14 * ratio,
			width = 50 * ratio,
			height = 30 * ratio,
			fontSize = 10 * ratio,
			color = '#333333',
			checkedColor = '#333333',
			disabledColor = '#BBBBBB',
			borderColor = '#F6F6F6',
			checkedBorderColor = '#ffb200',
			backgroundColor = '#F6F6F6',
			checkedBackgroundColor = '#FFFFFF',
			icon = ''
		}
	},
{
		tag = "替补6",
		checkedList = {},
		singleCheck = true,
		singleBindParam = "USER.SUBSTITUTE_INDEX_LIST[6].fieldIndex",
		list = {
			{title = 'P6', disabled = true},
			{title = '1', value = 1},
			{title = '2', value = 2},
			{title = '3', value = 3},
			{title = '4', value = 4},
			{title = '5', value = 5},
			{title = '6', value = 6},
			{title = '7', value = 7},
			{title = '8', value = 8},
			{title = '9', value = 9},
			{title = '10', value = 10},
			{title = '11', value = 11},
		},
		style = {
			lineSpacing = 14 * ratio,
			width = 36 * ratio,
			height = 30 * ratio,
			fontSize = 10 * ratio,
			color = '#333333',
			checkedColor = '#333333',
			disabledColor = '#BBBBBB',
			borderColor = '#F6F6F6',
			checkedBorderColor = '#ffb200',
			backgroundColor = '#F6F6F6',
			checkedBackgroundColor = '#FFFFFF',
			icon = ''
		}
	},
	{
		tag = "状态6",
		checkedList = {},
		singleCheck = true,
		singleBindParam = "USER.SUBSTITUTE_INDEX_LIST[6].substituteCondition",
		list = {
			{title = "好一档", value = 1},
			{title = "好两档", value = 2},
			{title = "主力红", value = 0},
		},
		style = {
			lineSpacing = 14 * ratio,
			width = 50 * ratio,
			height = 30 * ratio,
			fontSize = 10 * ratio,
			color = '#333333',
			checkedColor = '#333333',
			disabledColor = '#BBBBBB',
			borderColor = '#F6F6F6',
			checkedBorderColor = '#ffb200',
			backgroundColor = '#F6F6F6',
			checkedBackgroundColor = '#FFFFFF',
			icon = ''
		}
	},
{
		tag = "替补7",
		checkedList = {},
		singleCheck = true,
		singleBindParam = "USER.SUBSTITUTE_INDEX_LIST[7].fieldIndex",
		list = {
			{title = 'P7', disabled = true},
			{title = '1', value = 1},
			{title = '2', value = 2},
			{title = '3', value = 3},
			{title = '4', value = 4},
			{title = '5', value = 5},
			{title = '6', value = 6},
			{title = '7', value = 7},
			{title = '8', value = 8},
			{title = '9', value = 9},
			{title = '10', value = 10},
			{title = '11', value = 11},
		},
		style = {
			lineSpacing = 14 * ratio,
			width = 36 * ratio,
			height = 30 * ratio,
			fontSize = 10 * ratio,
			color = '#333333',
			checkedColor = '#333333',
			disabledColor = '#BBBBBB',
			borderColor = '#F6F6F6',
			checkedBorderColor = '#ffb200',
			backgroundColor = '#F6F6F6',
			checkedBackgroundColor = '#FFFFFF',
			icon = ''
		}
	},
	{
		tag = "状态7",
		checkedList = {},
		singleCheck = true,
		singleBindParam = "USER.SUBSTITUTE_INDEX_LIST[7].substituteCondition",
		list = {
			{title = "好一档", value = 1},
			{title = "好两档", value = 2},
			{title = "主力红", value = 0},
		},
		style = {
			lineSpacing = 14 * ratio,
			width = 50 * ratio,
			height = 30 * ratio,
			fontSize = 10 * ratio,
			color = '#333333',
			checkedColor = '#333333',
			disabledColor = '#BBBBBB',
			borderColor = '#F6F6F6',
			checkedBorderColor = '#ffb200',
			backgroundColor = '#F6F6F6',
			checkedBackgroundColor = '#FFFFFF',
			icon = ''
		}
	},	
}

local function generateGridID(gridTag)
	return string.format("grid_%s", gridTag)
end

local function parserGridID(gridID)
	return string.sub(gridID, 6, -1)
end

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

local function setGridChecked(gridTag, checkedList)
	for k, v in pairs(_gridList) do
		if v.tag == gridTag then
			v.checkedList = checkedList
			break
		end
	end
end

local function loadGridChecked()
	Log("loadGridChecked")
	
	for k, v in pairs(_gridList) do
		local storeList = cjson.decode(storage.get(v.tag, "{}"))
		Log("load last selection: "..v.tag)
		
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
			--setValueByStrKey(v.singleBindParam, false)
			for _k, _v in pairs(v.list) do
				--prt(_v)
				for __k, __v in pairs(v.checkedList) do
					if __v == _k then
						setValueByStrKey(v.singleBindParam, _v.value or _v.title)
						Log("________commit set "..v.singleBindParam.."="..(_v.value or _v.title))
						break
					end
				end
			end
		else						--多选
			for _k, _v in pairs(v.list) do
				setValueByStrKey(_v.bindParam, false)
			end
			
			for _k, _v in pairs(v.list) do
				for __k, __v in pairs(v.checkedList) do
					if __v == _k then
						setValueByStrKey(_v.bindParam, true)
						Log("________commit set ".._v.bindParam.."=true")
						break
					end
				end
			end
		end
		
		--保存当前checkedList数据
		local storeStr = cjson.encode(v.checkedList)
		Log("save user selection: "..v.tag)
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
		['justify-content'] = 'flex-end',
		--['justify-content'] = 'center',
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
			['background-color'] = '#FFFFFF',
			['justify-content'] = 'space-around',
		},
		subviews = {
			{
				view = 'text',
				value = ' ',
				style = {
					['font-size'] = 10 * ratio,
					color = '#5f5f5f'
				}
			},
			{
				view = 'div',
				style = {
					width = 700 * ratio,
					['background-color'] = '#FFFFFF',
					['flex-direction'] = 'row',
					--['justify-content'] = 'space-around',
					['justify-content'] = 'center',
				},
				subviews = {
					wui.GridSelect.createLayout({id = generateGridID("替补1"), list = generateGridList("替补1"), 
					config = {single = true, totalWidth = 440 * ratio, gridStyle = generateGridStyle("替补1")}}),
					{
						view = 'text',
						value = '		',
						style = {
							['font-size'] = 20 * ratio,
							color = '#5f5f5f'
						}
					},					
					wui.GridSelect.createLayout({id = generateGridID("状态1"), list = generateGridList("状态1"), 
					config = {single = true, totalWidth = 160 * ratio, gridStyle = generateGridStyle("状态1")}}),
				},
			},
			{
				view = 'div',
				style = {
					width = 700 * ratio,
					['background-color'] = '#FFFFFF',
					['flex-direction'] = 'row',
					--['justify-content'] = 'space-around',
					['justify-content'] = 'center',
				},
				subviews = {
					wui.GridSelect.createLayout({id = generateGridID("替补2"), list = generateGridList("替补2"), 
					config = {single = true, totalWidth = 440 * ratio, gridStyle = generateGridStyle("替补2")}}),
					{
						view = 'text',
						value = '		',
						style = {
							['font-size'] = 20 * ratio,
							color = '#5f5f5f'
						}
					},					
					wui.GridSelect.createLayout({id = generateGridID("状态2"), list = generateGridList("状态2"), 
					config = {single = true, totalWidth = 160 * ratio, gridStyle = generateGridStyle("状态2")}}),
				},
			},
			{
				view = 'div',
				style = {
					width = 700 * ratio,
					['background-color'] = '#FFFFFF',
					['flex-direction'] = 'row',
					--['justify-content'] = 'space-around',
					['justify-content'] = 'center',
				},
				subviews = {
					wui.GridSelect.createLayout({id = generateGridID("替补3"), list = generateGridList("替补3"), 
					config = {single = true, totalWidth = 440 * ratio, gridStyle = generateGridStyle("替补3")}}),
					{
						view = 'text',
						value = '		',
						style = {
							['font-size'] = 20 * ratio,
							color = '#5f5f5f'
						}
					},					
					wui.GridSelect.createLayout({id = generateGridID("状态3"), list = generateGridList("状态3"), 
					config = {single = true, totalWidth = 160 * ratio, gridStyle = generateGridStyle("状态3")}}),
				},
			},
			{
				view = 'div',
				style = {
					width = 700 * ratio,
					['background-color'] = '#FFFFFF',
					['flex-direction'] = 'row',
					--['justify-content'] = 'space-around',
					['justify-content'] = 'center',
				},
				subviews = {
					wui.GridSelect.createLayout({id = generateGridID("替补4"), list = generateGridList("替补4"), 
					config = {single = true, totalWidth = 440 * ratio, gridStyle = generateGridStyle("替补4")}}),
					{
						view = 'text',
						value = '		',
						style = {
							['font-size'] = 20 * ratio,
							color = '#5f5f5f'
						}
					},					
					wui.GridSelect.createLayout({id = generateGridID("状态4"), list = generateGridList("状态4"), 
					config = {single = true, totalWidth = 160 * ratio, gridStyle = generateGridStyle("状态4")}}),
				},
			},
			{
				view = 'div',
				style = {
					width = 700 * ratio,
					['background-color'] = '#FFFFFF',
					['flex-direction'] = 'row',
					--['justify-content'] = 'space-around',
					['justify-content'] = 'center',
				},
				subviews = {
					wui.GridSelect.createLayout({id = generateGridID("替补5"), list = generateGridList("替补5"), 
					config = {single = true, totalWidth = 440 * ratio, gridStyle = generateGridStyle("替补5")}}),
					{
						view = 'text',
						value = '		',
						style = {
							['font-size'] = 20 * ratio,
							color = '#5f5f5f'
						}
					},					
					wui.GridSelect.createLayout({id = generateGridID("状态5"), list = generateGridList("状态5"), 
					config = {single = true, totalWidth = 160 * ratio, gridStyle = generateGridStyle("状态5")}}),
				},
			},
			{
				view = 'div',
				style = {
					width = 700 * ratio,
					['background-color'] = '#FFFFFF',
					['flex-direction'] = 'row',
					--['justify-content'] = 'space-around',
					['justify-content'] = 'center',
				},
				subviews = {
					wui.GridSelect.createLayout({id = generateGridID("替补6"), list = generateGridList("替补6"), 
					config = {single = true, totalWidth = 440 * ratio, gridStyle = generateGridStyle("替补6")}}),
					{
						view = 'text',
						value = '		',
						style = {
							['font-size'] = 20 * ratio,
							color = '#5f5f5f'
						}
					},					
					wui.GridSelect.createLayout({id = generateGridID("状态6"), list = generateGridList("状态6"), 
					config = {single = true, totalWidth = 160 * ratio, gridStyle = generateGridStyle("状态6")}}),
				},
			},
			{
				view = 'div',
				style = {
					width = 700 * ratio,
					['background-color'] = '#FFFFFF',
					['flex-direction'] = 'row',
					--['justify-content'] = 'space-around',
					['justify-content'] = 'center',
				},
				subviews = {
					wui.GridSelect.createLayout({id = generateGridID("替补7"), list = generateGridList("替补7"), 
					config = {single = true, totalWidth = 440 * ratio, gridStyle = generateGridStyle("替补7")}}),
					{
						view = 'text',
						value = '		',
						style = {
							['font-size'] = 20 * ratio,
							color = '#5f5f5f'
						}
					},					
					wui.GridSelect.createLayout({id = generateGridID("状态7"), list = generateGridList("状态7"), 
					config = {single = true, totalWidth = 160 * ratio, gridStyle = generateGridStyle("状态7")}}),
				},
			},
			{
				view = 'text',
				value = ' ',
				style = {
					['font-size'] = 20 * ratio,
					color = '#5f5f5f'
				}
			},		
		}
	},
	{
		view = 'div',
		style = {
			width = 700 * ratio,
			['background-color'] = '#FFFFFF'
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

--tabPageConfig.wrapBackgroundColor= '#FF0000'
tabPageConfig.wrapBackgroundColor= '#FFFFFF'

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
		xmod.exit()
	end
)

wui.Button.setOnClickedCallback(context:findView('btn_taskOk'), function (id, action)
		printf('wui.Button %s click', id)
		prt(USER.TASK_NAME)
		prt(USER.REPEAT_TIMES)
		
		for k, v in pairs(_gridList) do
			if v.tag == "选择任务" or v.tag == "任务次数" then
				checkedFlag = false
				for _k, _v in pairs(v.checkedList) do
					if not v.list[_v].disabled then
						checkedFlag = true
						break
					end
				end
				if not checkedFlag then
					Log("not checked TASK_NAME or TASK_REPEATE")
					return
				end
			end
		end
		
		submitGridChecked()
		
		showwingFlag = false
		context:close()
		
		return
	end
)

local function setGridDefualtCallbacks()
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

function dispUI()	
	if not IS_BREAKING_TASK then
		print('show view')
		context:show()	
		showwingFlag = true
	else
		showwingFlag = false
		submitGridChecked()
	end
	
	while showwingFlag do
		sleep(200)
	end
	
	prt(USER)
end


setGridDefualtCallbacks()
