--最好看完下面API说明再用吧...给的示例并没有用到全部的内容
--部分代码懒得优化了...反正UI部分调用的次数最少,效率低点无所谓了
--[竹UI,简写ZUI,Z_ui]
--作者:竹子菌  QQ:454689880
--2018年11月14日21:03:35


--所有控件均可使用w/h/xpos/ypos参数
--w:控件占用的UI客户区的宽度比例(1~100)
--h:控件占用的UI客户区的高度比例(1~100)
--xpos:控件X轴偏移量
--ypos:控件Y轴偏移量
--所有中括号[]内的选项为可有可无的选项,缺省时会使用默认值
--[[
	竹UI使用说明/API
	
	创建一个新UI界面
	UI名=UI:new(DevScreen,Parm)
	参数:
		DevScreen={Width=开发分辨率width,Height=开发分辨率height}
		Parm={
			[align="left" or "right" or "center"]>>>>设置UI内控件的默认对齐方式
			[w=90]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>UI界面的宽度占整个屏幕宽度的百分比,范围建议50~100,不可超过100
			[h=90]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>该UI界面的高度占整个屏幕高度的百分比,范围建议50~100,不可超过100
			[color="13,13,13"]>>>>>>>>>>>>>>>>>>>>>>>UI内默认的字体颜色,子控件传入参数若缺省color时会使用此项
			[size=40]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>UI内默认字体大小,子控件传入参数若缺省size时会使用此项
			[xpos=5]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>UI内单行默认左侧留空宽度,该值为UI界面宽度的百分比,建议范围0~10
			[rowSpace=2]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>UI内默认行距,该值为UI界面高度的百分比,建议范围0~5
			[calcelname="取消"]>>>>>>>>>>>>>>>>>>>>>>取消按键的显示名字
			[okname="OK"]>>>>>>>>>>>>>>>>>>>>>>>>>>>>OK按键的显示名字
			[countdown=0]>>>>>>>>>>>>>>>>>>>>>>>>>>>>UI显示的倒计时,为0则永久
			[config="ZUI.dat"]>>>>>>>>>>>>>>>>>>>>>>>UI设置的保存文件,建议自行修改文件名
			[bg="13,13,13" or "xxx.png"]>>>>>>>>>>>>>UI的背景图片或颜色
		}
	
	创建一个新TAB页面
	页面名=Page:new(UI,Parm)
	参数:
		UI名=UI名>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>该Page挂载在哪个UI上,就把哪个UI传进来
		Parm={
			text="page标题">>>>>>>>>>>>>>>>>>>>>>>>>>Page的标题,显示在页签上
			[size=40]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Page内默认字体大小,子控件传入参数若缺省size时会使用此项,优先级高于UI的size设置
			[xpos=5]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Page内单行默认左侧留空宽度,该值为UI界面宽度的百分比,建议范围0~10,优先级高于UI的xpos设置
			[rowSpace=2]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Page内默认行距,该值为UI界面高度的百分比,建议范围0~5,优先级高于UI的rowSpace设置
			[align="left" or "right" or "center"]>>>>设置Page内控件的默认对齐方式,优先级高于UI
			[color="13,13,13"]>>>>>>>>>>>>>>>>>>>>>>>UI内默认的字体颜色,子控件传入参数若缺省color时会使用此项
		}
	
	切换到下一行
	页面名:nextLine(height)
	参数:
		[height=1]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>用于设置多倍行距,默认为1
	
	以下控件均可使用xpos/ypos/h/w参数来调整位置和占用大小
	以下控件均可使用xpos/ypos/h/w参数来调整位置和占用大小
	
	创建Label
	页面名:addLabel(Parm)
	参数:
		Parm={
			text="显示内容">>>>>>>>>>>>>>>>>>>>>>>>>>>显示内容
			[align="left" or "right" or "center"]>>>>文本的对齐方式,优先级最高
			[color="13,13,13"]>>>>>>>>>>>>>>>>>>>>>>>文本颜色,优先级最高
			[size=40]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>文本大小,优先级最高
			[bg="13,13,13" or "xxx.png"]>>>>>>>>>>>>>背景图片或背景颜色
			[xpos/ypos/h/w]
		}
	创建QQ超链接
	页面名:addQQ(Parm)
	参数:
		Parm={
			text="454689880">>>>>>>>>>>>>>>>>>>>>>>>>填要跳转到的QQ
			[align="left" or "right" or "center"]>>>>文本的对齐方式,优先级最高
			[color="13,13,13"]>>>>>>>>>>>>>>>>>>>>>>>文本颜色,优先级最高
			[size=40]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>文本大小,优先级最高
			[bg="13,13,13" or "xxx.png"]>>>>>>>>>>>>>背景图片或背景颜色
			[xpos/ypos/h/w]
		}
	创建网址超链接
	页面名:addUrl(Parm)
	参数:
		Parm={
			text="点我跳转百度">>>>>>>>>>>>>>>>>>>>>>>显示内容
			url="http://www.baidu.com">>>>>>>>>>>>>>>跳转的网址
			[align="left" or "right" or "center"]>>>>文本的对齐方式,优先级最高
			[color="13,13,13"]>>>>>>>>>>>>>>>>>>>>>>>文本颜色,优先级最高
			[size=40]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>文本大小,优先级最高
			[bg="13,13,13" or "xxx.png"]>>>>>>>>>>>>>背景图片或背景颜色
			[xpos/ypos/h/w]
		}
	创建Image
	页面名:addImage(Parm)
	参数:
		Parm={
			src="xxxxx.png/jpg">>>>>>>>>>>>>>>>>>>>>>显示的图片名
			[xpos/ypos/h/w]>>>>>>>>>>>>>>>>>>>>>>>>>>图片最好设置一下这四个参数
		}
	创建WebView
	页面名:addWeb(Parm)
	参数:
		Parm={
			id="WebView">>>>>>>>>>>>>>>>>>>>>>>>>>>>>控件id,全局唯一,必填
			url="http://www.baidu.com">>>>>>>>>>>>>>>网址
			[xpos/ypos/h/w]
		}
	创建Line
	页面名:addLine(Parm)
	参数:
		Parm={
			id="Line">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>控件id,全局唯一,必填
			[color="13,13,13"]>>>>>>>>>>>>>>>>>>>>>>>线段颜色
			[xpos/ypos/h/w]>>>>>>>>>>>>>>>>>>>>>>>>>>图片最好设置一下这四个参数
		}
	创建RadioGroup
	页面名:RadioGroup(Parm)
	参数:
		Parm={
			id="RadioGroup">>>>>>>>>>>>>>>>>>>>>>>>>>控件id,全局唯一,必填
			list="选项1,选项2,选项3">>>>>>>>>>>>>>>>>>选项
			w=50>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>占用页面30%宽度,必填
			h=10>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>占用页面10%高度,必填
			[select=0]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>默认选中0号选项
			[orientation="horizontal" or "vertical"]>横向排版或竖向排版,默认横向
			[color="13,13,13"]>>>>>>>>>>>>>>>>>>>>>>>文本颜色,优先级最高
			[size=40]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>文本大小,优先级最高
			[xpos/ypos]
		}
	创建CheckBoxGroup
	页面名:addCheckBoxGroup(Parm)
	参数:
		Parm={
			id="CheckBoxGroup">>>>>>>>>>>>>>>>>>>>>>>>控件id,全局唯一,必填
			list="选项1,选项2,选项3">>>>>>>>>>>>>>>>>>选项
			w=50>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>占用页面30%宽度,必填
			h=10>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>占用页面10%高度,必填
			[select="0@2"]>>>>>>>>>>>>>>>>>>>>>>>>>>>默认选中0号和2号选项
			[orientation="horizontal" or "vertical"]>横向排版或竖向排版,默认横向
			[color="13,13,13"]>>>>>>>>>>>>>>>>>>>>>>>文本颜色,优先级最高
			[size=40]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>文本大小,优先级最高
			[xpos/ypos]
		}
	创建Edit
	页面名:addEdit(Parm)
	参数:
		Parm={
			id="Edit">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>控件id,全局唯一,必填
			prompt="提示文本">>>>>>>>>>>>>>>>>>>>>>>>>淡灰色的提示文本
			text="默认文本">>>>>>>>>>>>>>>>>>>>>>>>>>输入框内的默认文本
			w=30>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>占用页面30%宽度,必填
			h=10>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>占用页面10%高度,必填
			[color="13,13,13"]>>>>>>>>>>>>>>>>>>>>>>>文本颜色,优先级最高
			[size=40]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>文本大小,优先级最高
			[kbtype="default" or "number" or "ascii"]键盘模式,默认,数字,字母
			[align="left" or "right" or "center"]>>>>文本的对齐方式,优先级最高
			[xpos/ypos]
		}
	创建ComboBox
	页面名:ComboBox(Parm)
	参数:
		Parm={
			id="ComboBox">>>>>>>>>>>>>>>>>>>>>>>>>>>>>控件id,全局唯一,必填
			list="选项1,选项2,选项3">>>>>>>>>>>>>>>>>>选项
			w=30>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>占用页面30%宽度,必填
			h=10>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>占用页面10%高度,必填
			[select=0]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>默认选中0号选项
			[color="13,13,13"]>>>>>>>>>>>>>>>>>>>>>>>文本颜色,优先级最高
			[size=40]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>文本大小,优先级最高
			[xpos/ypos]
		}
		
	显示UI并获取返回值
	UI名:show(ReturnType)
	参数:
		[ReturnType=0 or 1 or 2 or 3] >>>>>>>>>>>>>>>>>>>>>>>>决定返回值的格式,ReturnType为1时,返回值格式较为精简,但是UI内的所有选项名不可以出现重复
			--0为原版showui返回,建议用3
	具体ReturnType的效果请自行printTbl查看
	
--]]

function split(str, delimiter)
	if str==nil or str=='' or delimiter==nil then
		return {}
	end
	local result = {}
	for match in (str..delimiter):gmatch("(.-)"..delimiter) do
		table.insert(result, match)
	end
	return result
end
function print(...)--万能输出
	local con={...}
	for key,value in ipairs(con) do
		if(type(value)=="table")then
			printTbl(value)
			con[key]=""
		else
			con[key]=tostring(value)
		end
	end
	sysLog(table.concat(con,"  "))
end
function printTbl(tbl)--table输出,请注意不要传入对象,会无限循环卡死
	local function prt(tbl,tabnum)
		tabnum=tabnum or 0
		if not tbl then return end
		for k,v in pairs(tbl)do
			if type(v)=="table" then
				print(string.format("%s[%s](%s) = {",string.rep("\t",tabnum),tostring(k),"table"))
				prt(v,tabnum+1)
				print(string.format("%s}",string.rep("\t",tabnum)))
			else
				print(string.format("%s[%s](%s) = %s",string.rep("\t",tabnum),tostring(k),type(v),tostring(v)))
			end
		end
	end
	print("Print Table = {")
	prt(tbl,1)
	print("}")
end

function errorReport(info,isStop)--逻辑错误报告,info是附加信息,isStop是否以error的形式报错,否为直接打印
	local pt= getOSType()
	if isPriviateMode()==1 then
		pt=pt.."越狱/Root"
	else
		pt=pt.."免越狱/免Root"
	end
	if getProduct then
		if getProduct()==7 then pt=pt.."(酷玩)" end
	end
	local w,h = getScreenSize()
	local ScreenSize=w.."_"..h
	local str=string.format("%s\r\n===系统信息===\r\n手机分辨率:%s\r\npt:%s\r\n引擎版本号%s\r\n请反馈给作者附加信息和发生错误的具体情况!",info,ScreenSize,pt,getEngineVersion())
	if isStop then error(str,0) end
	print(str)
end

function getStrLen(a)--支持识别中文,UTF8编码的
	local l=string.len(a)
	local len=0
	for i=1,l do
		asc2=string.byte(string.sub(a,i,i))
		if asc2>127 then
			len=len+1/3-0.00000001
		else
			len=len+1
		end
	end
	return math.floor(len+0.5)
end




local _screenw,_screenh=getScreenSize()
if _screenw<_screenh then _screenw,_screenh=_screenh,_screenw end

local sizediff=2+(3/(2240-720))*(_screenw-720)

local _dpi=getScreenDPI()
if not tonumber(_dpi) then
	_dpi=320
elseif tonumber(_dpi)==-1 then
	_dpi=320
else
	_dpi=tonumber(_dpi)
end
local _dip=_dpi/160
local __dip=1 or _dpi/320--解决单选框和多选框前面的圈或勾选框在低dpi下过大或高dpi下过小(但同时会导致字体过小或过大...)
			--删除"1 or "可以启用此项,默认不启用()
local _sysbottomheight=1




local function getStrWidth(a)
	local l=string.len(a)
	local len=0
	for i=1,l do
		asc2=string.byte(string.sub(a,i,i))
		if asc2>127 then
			len=len+1/3
		else
			len=len+9/16
		end
	end
	return len
end

	local function urlencode(w)
		pattern = "[^%w%d%?=&:/._%-%* ]"
		s = string.gsub(w, pattern, function(c)
			local c = string.format("%%%02X", string.byte(c))
			return c
		end)
		s = string.gsub(s, " ", "+")
		return s
	end
local function tableTojson(t)
	local function serialize(tbl)
		local tmp = {}
		for k, v in pairs(tbl) do
			local k_type = type(k)
			local v_type = type(v)
			local key
			if k_type == "string" then
				key = "\"" .. k .. "\":"
			elseif k_type == "number" then
				key = ""
			end
			local value
			if v_type == "table" then
				value = serialize(v)
			elseif v_type == "boolean" then
				value = tostring(v)
			elseif v_type == "string" then
				value = "\"" .. v .. "\""
			elseif v_type == "number" then
				value = v
			end
			tmp[#tmp + 1] = key and value and tostring(key) .. tostring(value) or nil
		end
		if #tbl == 0 then
			return "{" .. table.concat(tmp, ",") .. "}"
		else
			return "[" .. table.concat(tmp, ",") .. "]"
		end
	end
	return serialize(t)
end

UI={
}

function UI:new(DevScreen,Parm)--align="left",w=90,h=90,size=40,calcelname="取消",okname="OK",countdown=0,config="1.dat"
	
	local _width,_height = getScreenSize()--当前设备分辨率
	if _width<_height then _width,_height=_height,_width end
	--Parm.w  	UI宽度占比(开发环境下)
	--Parm.h	UI高度占比(开发环境下)
	Parm.w=Parm.w or 90
	Parm.h=Parm.h or 90
	local Scale,fsize,Xpos
	if _width/_height>=DevScreen.Width/DevScreen.Height then
		Scale=_height/DevScreen.Height
	else
		Scale=_width/DevScreen.Width
	end
	
	local tmp={
		w= Parm.w/100*DevScreen.Width*Scale,
		h= Parm.h/100*DevScreen.Height*Scale
	}
	
	
	
	local fsize=math.floor((Parm.size or 25)*Scale)
	local Xpos=math.floor((Parm.xpos or 5)/100*(tmp.w))
	local RowSpace=math.floor((Parm.rowSpace or 2)/100*(tmp.h))
	
	local o = {
		type="UI",
		Width=tmp.w,
		Height=tmp.h,
		Scale=Scale,
		RowSpace=RowSpace,
		Xpos=Xpos,
		
		DefaultAlign=Parm.align or "left",
		DefaultFrontSize=fsize,
		DefaultFrontColor=Parm.color or "13,13,13",
		
		con={
			style=Parm.style or "custom",
			config=Parm.config or "save_Default.dat",
			width=tmp.w,
			height=tmp.h,
			cancelname=Parm.cancelname or "Cancel",
			okname=Parm.okname or "OK",
			countdown=Parm.countdown or 30,
			views={}
		},
		ret={
		}
	}
	if Parm.bg then o.con.bg=Parm.bg end
	setmetatable(o,{__index = self} )
	if Parm.cancelscroll~=nil then
		o.con.cancelscroll = Parm.cancelscroll
	else
		o.con.cancelscroll = true
	end
	o.realheight=tmp.h-110*_dip
	o.realwidth=tmp.w-10
	
	
	return o
end

function UI:xper2pix(per)
	return math.floor(per/100*self.realwidth)
end
function UI:yper2pix(per)
	return math.floor(per/100*self.realheight)
end

Page={
}

function Page:new(UI,Parm)
	
	local fsize,Xpos,RowSpace
	
	if Parm.size then
		fsize=math.floor((Parm.size or 25)*UI.Scale)
	else
		fsize=UI.DefaultFrontSize
	end
	if Parm.xpos then
		Xpos=math.floor((Parm.xpos)/100*(UI.con.width))
	else
		Xpos=UI.Xpos
	end
	if Parm.RowSpace then
		RowSpace=math.floor((Parm.rowSpace)/100*(UI.con.height))
	else
		RowSpace=UI.RowSpace
	end
	
	local o={
		UI=UI,
		type="Page",
		CurX=Xpos,
		CurY=0,
		LastLineFrontSize=0,
		Scale=UI.Scale,
		
		RowSpace=RowSpace,
		Xpos=Xpos,
		DefaultFrontSize=fsize,
		DefaultAlign=Parm.align or UI.DefaultAlign,
		
		DefaultFrontColor=Parm.color or UI.DefaultFrontColor,
		
		con={
			style="custom",
			text=Parm.text or "",
			size=fsize,
			type="Page",
			views={
			}
			
			
		}
	}
	setmetatable(o,{__index = self} )
	
	table.insert(UI.con.views,o.con)
	return o
end

function Page:nextLine(height)
	height=height or 1
	self.CurX=self.Xpos
	self.CurY=math.floor(self.CurY+height*(self.RowSpace+self.LastLineFrontSize))
	self.LastLineFrontSize=self.DefaultFrontSize
end

function Page:addLabel(Parm)
	local fsize,Xpos,Ypos
	if Parm.size then
		fsize=math.floor(Parm.size*self.Scale)
	else
		fsize=self.DefaultFrontSize
	end
	if Parm.xpos then
		Xpos=math.floor((Parm.xpos)/100*self.UI.realwidth)
	else
		Xpos=0
	end
	if Parm.ypos then
		Ypos=math.floor((Parm.ypos)/100*self.UI.realheight)
	else
		Ypos=0
	end
	local con={
		type="Label",
		text=Parm.text or Parm[1] or "",
		size=fsize,
		align=Parm.align or self.DefaultAlign,
		color=Parm.color or self.DefaultFrontColor,
		bg=Parm.bg or nil
	}
	
	local StrWidth=math.ceil(getStrWidth(con.text)*(fsize+sizediff))
	local rect={self.CurX+Xpos,self.CurY+Ypos,
		Parm.w and self.UI:xper2pix(Parm.w) or StrWidth,Parm.h and self.UI:yper2pix(Parm.h) or (self.RowSpace+fsize)}
	con.rect=table.concat(rect,",")
	self.CurX=self.CurX+Xpos+(Parm.w and self.UI:xper2pix(Parm.w) or StrWidth)
	if (Parm.h and self.UI:xper2pix(Parm.w) or fsize)>self.LastLineFrontSize and not Parm.ypos then
		self.LastLineFrontSize=(Parm.h and self.UI:yper2pix(Parm.h) or fsize)
	end
	table.insert(self.con.views,con)
end

function Page:addQQ(Parm)
	local fsize,Xpos,Ypos
	if Parm.size then
		fsize=math.floor(Parm.size*self.Scale)
	else
		fsize=self.DefaultFrontSize
	end
	if Parm.xpos then
		Xpos=math.floor((Parm.xpos)/100*self.UI.realwidth)
	else
		Xpos=0
	end
	if Parm.ypos then
		Ypos=math.floor((Parm.ypos)/100*self.UI.realheight)
	else
		Ypos=0
	end
	local con={
		type="Label",
		text=Parm.text or Parm[1] or "",
		size=fsize,
		align=Parm.align or self.DefaultAlign,
		color=Parm.color or self.DefaultFrontColor,
		bg=Parm.bg or nil,
		extra={
			{
				goto="qq",
				text=Parm.text or Parm[1] or ""
			}
		}
	}
	
	local StrWidth=math.ceil(getStrWidth(con.text)*(fsize+sizediff))
	local rect={self.CurX+Xpos,self.CurY+Ypos,
		Parm.w and self.UI:xper2pix(Parm.w) or StrWidth,Parm.h and self.UI:yper2pix(Parm.h) or (self.RowSpace+fsize)}
	con.rect=table.concat(rect,",")
	self.CurX=self.CurX+Xpos+(Parm.w and self.UI:xper2pix(Parm.w) or StrWidth)
	if (Parm.h and self.UI:xper2pix(Parm.w) or fsize)>self.LastLineFrontSize and not Parm.ypos then
		self.LastLineFrontSize=(Parm.h and self.UI:yper2pix(Parm.h) or fsize)
	end
	table.insert(self.con.views,con)
end

function Page:addUrl(Parm)
	local fsize,Xpos,Ypos
	if Parm.size then
		fsize=math.floor(Parm.size*self.Scale)
	else
		fsize=self.DefaultFrontSize
	end
	if Parm.xpos then
		Xpos=math.floor((Parm.xpos)/100*self.UI.realwidth)
	else
		Xpos=0
	end
	if Parm.ypos then
		Ypos=math.floor((Parm.ypos)/100*self.UI.realheight)
	else
		Ypos=0
	end
	local url=Parm.url
	if not string.find(url,"http://") then
		print("url前缺少了http://  已自动补全")
		url="http://"..url
	end
	url=urlencode(url)
	
	local con={
		type="Label",
		text=Parm.text or Parm[1] or "",
		size=fsize,
		align=Parm.align or self.DefaultAlign,
		color=Parm.color or self.DefaultFrontColor,
		bg=Parm.bg or nil,
		extra={
			{
				goto=url,
				text=Parm.text or Parm[1] or ""
			}
		}
	}
	
	
	local StrWidth=math.ceil(getStrWidth(con.text)*(fsize+sizediff))
	local rect={self.CurX+Xpos,self.CurY+Ypos,
		Parm.w and self.UI:xper2pix(Parm.w) or StrWidth,Parm.h and self.UI:yper2pix(Parm.h) or (self.RowSpace+fsize)}
	con.rect=table.concat(rect,",")
	self.CurX=self.CurX+Xpos+(Parm.w and self.UI:xper2pix(Parm.w) or StrWidth)
	if (Parm.h and self.UI:xper2pix(Parm.w) or fsize)>self.LastLineFrontSize and not Parm.ypos then
		self.LastLineFrontSize=(Parm.h and self.UI:yper2pix(Parm.h) or fsize)
	end
	table.insert(self.con.views,con)
end

function Page:addImage(Parm)
	local Xpos,Ypos
	if Parm.xpos then
		Xpos=math.floor((Parm.xpos)/100*self.UI.realwidth)
	else
		Xpos=0
	end
	if Parm.ypos then
		Ypos=math.floor((Parm.ypos)/100*self.UI.realheight)
	else
		Ypos=0
	end
	Parm.w=Parm.w or 50
	Parm.h=Parm.h or Parm.w
	
	
	local con={
		type="Image",
		src=Parm.src or Parm[1] or "",
		width=self.UI:xper2pix(Parm.w)
	}
	
	local rect={self.CurX+Xpos,self.CurY+Ypos,
		con.width,self.RowSpace+self.UI:yper2pix(Parm.h)}
	con.rect=table.concat(rect,",")
	self.CurX=self.CurX+Xpos+con.width
	if self.UI:yper2pix(Parm.h)>self.LastLineFrontSize and not Parm.ypos then
		self.LastLineFrontSize=self.UI:yper2pix(Parm.h)
	end
	table.insert(self.con.views,con)
end

function Page:addWeb(Parm)
	local Xpos,Ypos
	if Parm.xpos then
		Xpos=math.floor((Parm.xpos)/100*self.UI.realwidth)
	else
		Xpos=0
	end
	if Parm.ypos then
		Ypos=math.floor((Parm.ypos)/100*self.UI.realheight)
	else
		Ypos=0
	end
	Parm.w=Parm.w or 50
	Parm.h=Parm.h or Parm.w
	
	
	local url=Parm.url
	if not string.find(url,"http://") then
		print("url前缺少了http://  已自动补全")
		url="http://"..url
	end
	url=urlencode(url)
	if not Parm.id then
		errorReport("Web控件缺少id",true)
	end
	
	local con={
		type="WebView",
		id=Parm.id,
		url=url,
		width=self.UI:xper2pix(Parm.w),
		height=self.UI:yper2pix(Parm.h)
	}
	
	local rect={self.CurX+Xpos,self.CurY+Ypos,
		con.width,self.RowSpace+self.UI:yper2pix(Parm.h)}
	con.rect=table.concat(rect,",")
	self.CurX=self.CurX+Xpos+con.width
	if self.UI:yper2pix(Parm.h)>self.LastLineFrontSize and not Parm.ypos then
		self.LastLineFrontSize=self.UI:yper2pix(Parm.h)
	end
	table.insert(self.con.views,con)
end

function Page:addWebOnDefault(Parm)
	
	
	local url=Parm.url
	if not string.find(url,"http://") then
		print("url前缺少了http://  已自动补全")
		url="http://"..url
	end
	url=urlencode(url)
	if not Parm.id then
		errorReport("Web控件缺少id",true)
	end
	Parm.w=Parm.w or 50
	Parm.h=Parm.h or Parm.w
	
	local con={
		type="WebView",
		id=Parm.id,
		url=url,
		width=self.UI:xper2pix(Parm.w),
		height=self.UI:yper2pix(Parm.h)
	}
	
	table.insert(self.con.views,con)
end

function Page:addLine(Parm)
	local Xpos,Ypos
	if Parm.xpos then
		Xpos=math.floor((Parm.xpos)/100*self.UI.realwidth)
	else
		Xpos=0
	end
	if Parm.ypos then
		Ypos=math.floor((Parm.ypos)/100*self.UI.realheight)
	else
		Ypos=0
	end
	Parm.w=Parm.w or 10
	Parm.h=Parm.h or 1
	
	
	if not Parm.id then
		errorReport("Line控件缺少id",true)
	end
	
	local con={
		type="Line",
		id=Parm.id,
		color=Parm.color or self.DefaultFrontColor,
		width=self.UI:xper2pix(Parm.w),
		height=self.UI:yper2pix(Parm.h)
	}
	local rect={self.CurX+Xpos,self.CurY+Ypos,
		con.width,con.height}
	con.rect=table.concat(rect,",")
	self.CurX=self.CurX+Xpos+con.width
	if con.height>self.LastLineFrontSize and not Parm.ypos then
		self.LastLineFrontSize=con.height
	end
	table.insert(self.con.views,con)
end

function Page:addRadioGroup(Parm)
	local Xpos,Ypos
	if Parm.xpos then
		Xpos=math.floor((Parm.xpos)/100*self.UI.realwidth)
	else
		Xpos=0
	end
	if Parm.ypos then
		Ypos=math.floor((Parm.ypos)/100*self.UI.realheight)
	else
		Ypos=0
	end
	if not Parm.id then
		errorReport("RadioGroup控件缺少id",true)
	end
	if Parm.size then
		fsize=math.floor(Parm.size*self.Scale*__dip)
	else
		fsize=self.DefaultFrontSize*__dip
	end
	if not Parm.w or not Parm.h then errorReport("请指定RadioGroup控件的width和height",true) end
	local width=self.UI:xper2pix(Parm.w)
	local height=self.UI:yper2pix(Parm.h)
	
	local con={
		type="RadioGroup",
		id=Parm.id,
		list=Parm.list,
		color=Parm.color or self.DefaultFrontColor,
		select=Parm.select or 0,
		size=fsize,
		orientation=Parm.orientation or "horizontal"
	}
	
	
	local rect={self.CurX+Xpos,self.CurY+Ypos,
		width,height+self.RowSpace}
	con.rect=table.concat(rect,",")
	self.CurX=self.CurX+Xpos+width
	if height>self.LastLineFrontSize and not Parm.ypos then
		self.LastLineFrontSize=height
	end
	table.insert(self.con.views,con)
	
	self.UI.ret[Parm.id]=split(Parm.list,",")
	self.UI.ret[Parm.id].type="RadioGroup"
end

function Page:addCheckBoxGroup(Parm)
	local Xpos,Ypos
	if Parm.xpos then
		Xpos=math.floor((Parm.xpos)/100*self.UI.realwidth)
	else
		Xpos=0
	end
	if Parm.ypos then
		Ypos=math.floor((Parm.ypos)/100*self.UI.realheight)
	else
		Ypos=0
	end
	if not Parm.id then
		errorReport("CheckBoxGroup控件缺少id",true)
	end
	if Parm.size then
		fsize=math.floor(Parm.size*self.Scale*__dip)
	else
		fsize=self.DefaultFrontSize*__dip
	end
	if not Parm.w or not Parm.h then errorReport("请指定CheckBoxGroup控件的width和height",true) end
	local width=self.UI:xper2pix(Parm.w)
	local height=self.UI:yper2pix(Parm.h)
	
	local con={
		type="CheckBoxGroup",
		id=Parm.id,
		list=Parm.list,
		color=Parm.color or self.DefaultFrontColor,
		select=Parm.select or "",
		size=fsize,
		orientation=Parm.orientation or "horizontal"
	}
	
	
	local rect={self.CurX+Xpos,self.CurY+Ypos,
		width,height+self.RowSpace}
	con.rect=table.concat(rect,",")
	self.CurX=self.CurX+Xpos+width
	if height>self.LastLineFrontSize and not Parm.ypos then
		self.LastLineFrontSize=height
	end
	table.insert(self.con.views,con)
	
	self.UI.ret[Parm.id]=split(Parm.list,",")
	self.UI.ret[Parm.id].type=Parm.a and "CheckBoxGroupOne" or "CheckBoxGroup"
end

function Page:addEdit(Parm)
	local Xpos,Ypos
	if Parm.xpos then
		Xpos=math.floor((Parm.xpos)/100*self.UI.realwidth)
	else
		Xpos=0
	end
	if Parm.ypos then
		Ypos=math.floor((Parm.ypos)/100*self.UI.realheight)
	else
		Ypos=0
	end
	if not Parm.id then
		errorReport("Edit控件缺少id",true)
	end
	if Parm.size then
		fsize=math.floor(Parm.size*self.Scale)
	else
		fsize=self.DefaultFrontSize
	end
	if not Parm.w or not Parm.h then errorReport("请指定Edit控件的width和height",true) end
	local width=self.UI:xper2pix(Parm.w)
	local height=self.UI:yper2pix(Parm.h)
	
	local con={
		type="Edit",
		id=Parm.id,
		prompt=Parm.prompt or "",
		text=Parm.text or "",
		align=Parm.align or self.DefaultAlign,
		color=Parm.color or self.DefaultFrontColor,
		size=fsize,
		kbtype=Parm.kbtype or "default"
	}
	
	
	local rect={self.CurX+Xpos,self.CurY+Ypos,
		width,height+self.RowSpace}
	con.rect=table.concat(rect,",")
	self.CurX=self.CurX+Xpos+width
	if height>self.LastLineFrontSize and not Parm.ypos then
		self.LastLineFrontSize=height
	end
	table.insert(self.con.views,con)
	
	self.UI.ret[Parm.id]={}
	self.UI.ret[Parm.id].type="Edit"
end

function Page:addComboBox(Parm)
	local Xpos,Ypos
	if Parm.xpos then
		Xpos=math.floor((Parm.xpos)/100*self.UI.realwidth)
	else
		Xpos=0
	end
	if Parm.ypos then
		Ypos=math.floor((Parm.ypos)/100*self.UI.realheight)
	else
		Ypos=0
	end
	if not Parm.id then
		errorReport("ComboBox控件缺少id",true)
	end
	if Parm.size then
		fsize=math.floor(Parm.size*self.Scale)
	else
		fsize=self.DefaultFrontSize
	end
	if not Parm.w or not Parm.h then errorReport("请指定ComboBox控件的width和height",true) end
	local width=self.UI:xper2pix(Parm.w)
	local height=self.UI:yper2pix(Parm.h)
	
	local con={
		type="ComboBox",
		id=Parm.id,
		list=Parm.list,
		select=Parm.select or 0,
		size=fsize,
	}
	
	local rect={self.CurX+Xpos,self.CurY+Ypos,
		width,height+self.RowSpace}
	con.rect=table.concat(rect,",")
	self.CurX=self.CurX+Xpos+width
	if height>self.LastLineFrontSize and not Parm.ypos then
		self.LastLineFrontSize=height
	end
	table.insert(self.con.views,con)
	
	self.UI.ret[Parm.id]=split(Parm.list,",")
	self.UI.ret[Parm.id].type="ComboBox"
end

function UI:show(ReturnType)
	--print(tableTojson(self.con))
	ReturnType=ReturnType or 3
	local ret,results=showUI(tableTojson(self.con))
	local res={_cancel=false}
	local _a=0
	if ret==1 then
		local tmp
		if ReturnType==0 then
			return results
		elseif ReturnType==1 then
			for k,v in pairs(self.ret) do
				if type(v)=="table" then
					if v.type=="ComboBox" then
						res[v[tonumber(results[k])+1]]=true
					elseif v.type=="Edit" then
						res[k]=results[k]
					elseif v.type=="RadioGroup" then
						res[v[tonumber(results[k])+1]]=true
					elseif v.type=="CheckBoxGroup" then
						tmp=split(results[k],"@")
						for _,vv in ipairs(tmp) do
							res[tostring(v[vv+1])]=true
						end
					end
				end
			end
			
			for k,v in pairs(res) do
				if tonumber(v) then
					res[k]=tonumber(v)
				end
			end
		elseif ReturnType==2 then
			
			for k,v in pairs(self.ret) do
				if type(v)=="table" then
					if v.type=="ComboBox" then
						res[k]={}
						res[k][v[tonumber(results[k])+1]]=true
					elseif v.type=="Edit" then
						res[k]=results[k]
					elseif v.type=="RadioGroup" then
						res[k]={}
						res[k][v[tonumber(results[k])+1]]=true
					elseif v.type=="CheckBoxGroup" then
						tmp=split(results[k],"@")
						res[k]={}
						for _,vv in ipairs(tmp) do
							res[k][tostring(v[vv+1])]=true
						end
					end
				end
			end
			
			for k,v in pairs(res) do
				if type(k)=="table" then
					for kk,vv in pairs(res) do
						if tonumber(vv) then
							res[k][kk]=tonumber(vv)
						end
					end
				elseif tonumber(v) then
					res[k]=tonumber(v)
				end
			end
		elseif ReturnType==3 then
			for k,v in pairs(self.ret) do
				if type(v)=="table" then
					if v.type=="ComboBox" then
						res[k]=v[tonumber(results[k])+1]
					elseif v.type=="Edit" then
						res[k]=results[k]
					elseif v.type=="RadioGroup" then
						res[k]={}
						res[k][v[tonumber(results[k])+1]]=true
					elseif v.type=="CheckBoxGroup" then
						tmp=split(results[k],"@")
						res[k]={}
						for _,vv in ipairs(tmp) do
							res[k][tostring(v[vv+1])]=true
						end
					elseif v.type=="CheckBoxGroupOne" then
						tmp=results[k]
						if tmp and tmp=="0" then
							res[k]=true
						else
							res[k]=false
						end
					end
				end
			end
			
			for k,v in pairs(res) do
				if type(k)=="table" then
					for kk,vv in pairs(res) do
						if tonumber(vv) and string.len(vv)<=5 then
							res[k][kk]=tonumber(vv)
						end

					end
				elseif tonumber(v) and string.len(v)<=5 then
					res[k]=tonumber(v)
				end
			end
			
		end
			
		return res
	end
	return {_cancel=true}
end




