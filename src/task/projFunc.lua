-- projFunc.lua
-- Author: cndy1860
-- Date: 2018-12-26
-- Descrip: 任务相关函数

--在主界面4个子界面切换
function switchMainPage(pageName)
	Log("swich to "..pageName)
	
	if pageName == "比赛" then
		ratioTap(179, 115)
	elseif pageName == "俱乐部" then
		ratioTap(490, 115)
	elseif pageName == "合同" then
		ratioTap(828, 115)
	elseif pageName == "其他" then
		ratioTap(1148, 115)
	else
		catchError(ERR_PARAM, "swich a wrong page")
	end
end
