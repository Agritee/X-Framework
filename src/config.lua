-- config.lua
-- Author: cndy1860
-- Date: 2018-12-24
-- Descrip: 参数配置表，注册在_G

CFG = {}
-----------------调试参数-----------------
CFG.LOG = true				--是否允许输出LOG信息
CFG.WRITE_LOG = false		--是否将LOG写入log.txt文件, 不受CFG.LOG影响

-----------------分辨率参数-----------------
CFG.SUPPORT_RESOLUTION = {max = {width = 5040, height = 2160}, min = {width = 600, height = 450}}	--分辨率支持范围
CFG.DEV_RESOLUTION = {width = 1334, height = 750}	--开发分辨率
CFG.DST_RESOLUTION = {}		--运行设备分辨率，由init设置
CFG.SCALING_RATIO = 0		--短边缩放比率，由init设置
CFG.EFFECTIVE_AREA = {}		--界面有效区，由init设置
CFG.BLACK_BORDER = {	--黑边
	limitRatio = {leftRight = 16/9, topBottom = 4/3},	--出现规则黑边（上下左右相等）临界比例
	borderList = {		--width >= height，此优先级大于由imitRatio生成的项
		--{width = 2340, height = 1080, left = 210, right = 210, top = 0, bottom = 0}
	},
}

-----------------线性插值取色-----------------
CFG.BILINEAR = false		--开启线性二次插值

-----------------重启脚本及应用参数-----------------
CFG.ALLOW_BREAKING_TASK = false		--是否允许中断任务
CFG.ALLOW_RESTART = false			--是否允许重启脚本来解决异常
CFG.APP_ID = "com.netease.pes"		--应用名称
CFG.DEFAULT_APP_ID = "com.netease.pes"

-----------------找色参数-----------------
CFG.DEFAULT_FUZZY = 95		--默认颜色模糊相似度


CFG.DEFAULT_REPEAT_TIMES = 10		--任务默认运行次数

-----------------文件-----------------
CFG.LOG_FILE_NAME = "log.dat"


CFG.DEFAULT_REPEAT_TIMES = 999
CFG.DEFAULT_TIMEOUT = 30

CFG.WAIT_CHECK_SKIP = 5