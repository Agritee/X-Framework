-- config.lua
-- Author: cndy1860
-- Date: 2018-12-24
-- Descrip: 参数配置表，注册在_G

CFG = {}
-----------------调试参数-----------------
CFG.LOG = true				--是否允许输出LOG信息
CFG.WRITE_LOG = false		--是否将LOG写入log.txt文件, 不受CFG.LOG影响

-----------------开发分辨率-----------------
--通常情况下请保证width >= height，最大支持分辨率以为着最大比例分辨率，反之亦然
CFG.SUPPORT_RESOLUTION = {max = {width = 3360, height = 1440, tag = "21:9"}, min = {width = 600, height = 450, tag = "4:3"}}
CFG.DEV_RESOLUTION = {width = 1334, height = 750}
CFG.DST_RESOLUTION = {}
CFG.SCALING_RATIO = 1
CFG.EFFECTIVE_AREA = {}
CFG.BLACK_BORDER = {	--黑边，依据不同分辨率设置，保证width >= height
	{width = 2340, height = 1080, left = 210, right = 210, top = 0, bottom = 0},
}

-----------------开发分辨率-----------------
CFG.BILINEAR = false		--开启线性二次插值

-----------------找色参数-----------------
CFG.DEFAULT_FUZZY = 95		--默认颜色模糊相似度


CFG.DEFAULT_REPEAT_TIMES = 10		--任务默认运行次数

-----------------文件-----------------
CFG.LOG_FILE_NAME = "log.dat"


CFG.DEFAULT_REPEAT_TIMES = 999
CFG.DEFAULT_TIMEOUT = 30

CFG.WAIT_CHECK_SKIP = 5