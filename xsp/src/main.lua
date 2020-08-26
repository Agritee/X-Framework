-- main.lua
-- Author: cndy1860
-- Date: 2018-12-25
-- Descrip: 程序入口，注意require顺序会影响各文件的init，后续添加任务依次require
--loadfile("good1.txt")
--require("log")
--loadstring(require("encrypt")())

require("api")
require("global")
require("encrypt")
require("config")
require("func")
require("login")
require("init")
require("zui/base_ui")
require("scale")
require("page")
require("exec")
require("project/projFunc")
require("project/projPage")
require("project/task/soldScout")
require("project/task/rankSim")
require("project/task/leagueSim")
require("project/task/tourSim")
require("project/task/tourManuel")
require("project/task/challengeSim")
require("project/task/championSim")
require("project/task/IntSezonSim")
require("project/task/IntTourSim")
require("project/task/IntTourManuel")
require("project/task/roundSim")


function main()
	screen.keep(false)
	
	--dispUI()
	
	if PREV.restartedAPP then
		if xmod.PROCESS_MODE == xmod.PROCESS_MODE_STANDALONE then	--通用模式的延时只能放在重启时
			sleep(CFG.WAIT_RESTART * 1000)
		end
		
		processInitPage()	--先跳过未定义界面
	end
	
	exec.run(USER.TASK_NAME, USER.REPEAT_TIMES)
	xmod.exit()
end

main()

--sleep(2000)

--page.isExsitNavigation("notice")
page.checkPage()
page.checkNavigation()
--page.tapNavigation("notice")


--sleep(2000)
--CFG.SCALING_RATIO = 720/750
--prt(scale.scalePos("1059|440|0xd0e2cf-0x2f1d30,987|434|0x335a26-0x232117,1123|475|0x335a26-0x232117,1016|500|0x335a26-0x232117,1098|379|0x335a26-0x232117"))
--refreshContract()
--execNavigationQueue({"comfirm", "notice", "back"})

--page.checkNavigation()
page.checkCommonWidget()
--page.tapWidget("比赛", "活动模式")

--refreshUnmetCoach()

--page.matchPage("俱乐部")
--page.tapWidget("阵容展示", "切换状态")


--page.tapWidget("标准经纪人", "中场")
--page.tapNavigation("notice")

--page.tapWidget("比赛", "联赛")

--page.tryNavigation()

--获取一个区域内某种状态的所有球员位置信息
--sleep(2000)
--switchPlayer()

--prt(scale.offsetPos("343|308|0xffffff,343|315|0x007aff,324|312|0x007aff,363|313|0x007aff,324|355|0x007aff,362|355|0x007aff", Point(342, 306)))
--storage.purge()
--storage.put("test", "123")
--storage.commit()
--prt(storage.get("test", "noda"))

--tap(293,852)
--ratioSlide(30, 700, 30, 153, 200)

--switchPlayer()


--encrypt.genEncFile("good_")
--encrequire("LAT")
--tmp = base64.dec("HU1PT04jDRp/UAEBDwMAAAAEX0VOVgABAQMuLi4BAAD///8VDwACDDxjaHVuay1yb290PgAWAgECAAEXAQENAgoAAAACAQsADwEEAwJpbxEBBAQFd3JpdGUFAQQFEkhlbGxvIHdvcmxkLCBmcm9tIAsADwEEBghfVkVSU0lPTgUBBAcCIQoYAwgAAgEaAA==")
--prt(tmp)


--encrypt.genEncFile("good")
