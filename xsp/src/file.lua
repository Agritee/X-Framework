-- file.lua
-- Author: cndy1860
-- Date: 2019-07-09
-- Descrip: 文件操作，受叉叉环境影响，2.0+引擎才支持lfs和任意目录的io.open

local modName = "file"
local M = {}
_G[modName] = M
package.loaded[modName] = M

--创建目录
function M.createDir(dir)
	if lfs.chdir(dir) then
		Log("exsit this dir!")
		return true
	end
	
	local dirSteps = {}					--分离目录层级
	for tmp in string.gmatch(dir, "(%/[%w_]*)") do
		dirSteps[#dirSteps + 1] = tmp
	end
	if #dirSteps == 0 then
		Log("get no dir level!")
		return false
	end
	if #dirSteps > 1 then
		dirSteps[#dirSteps] = nil		--去掉尾层目录结尾处的"/"
	end
	--prt(dirSteps)
	
	local currentDir = ""
	for k, v in pairs(dirSteps) do		--逐层创建
		currentDir = currentDir..v
		local step = string.sub(v, 2, -1)
		
		if not lfs.chdir(currentDir) then			--切换下一层级目录
			if not lfs.mkdir(step) then
				Log("create faild, check the store permission!")
				return false			
			end
			if not lfs.chdir(currentDir) then		--创建后重新切换下一层级
				Log("create faild, check the store permission!")
				return false
			end
		end
	end

	Log("creted dst dir: "..dir)
	return true
end

--copy文件
function M.copyFile(dst, src)
	Log("dst="..dst)
	Log("src="..src)
	
	local dir, fileName = M.parsePath(dst)
	Log("dir="..dir.."  fileName="..fileName)
	
	if not lfs.chdir(dir) then
		Log("no current dir, create it!")
		if not M.createDir(dir) then
			Log("create dir faild!")
			return false
		end
	end
	
	local srcFile = io.open(src, "r")
	if not srcFile then
		Log("err in open srcFile")
		return false
	end

	local dstFile = io.open(dst, "w")
	if not dstFile then
		Log("err in open dstFile")
		return false
	end
	
	dstFile:write(srcFile:read("*all"))
	
	srcFile:close()
	dstFile:close()
	Log("copy done!")
	return true
end

--解析出目录路径和文件名
function M.parsePath(path)
	--找出格式后缀
	local index = 0
	local j = 0
	while true do
		_, j =  string.find(path, "%.", j + 1)
		if j ~= nil then
			index = j
		else
			break
		end
	end
	if index == 0 then
		Log("not fileForm in path!")
		return nil, nil
	end
	
	local fileForm = string.sub(path, index, -1)
	
	local i, j, dir, fileName = string.find(path, "([%w_/.]*%/)([%w_]+)"..fileForm)
	if i == nil then
		Log("wrong form path!")
		return nil, nil
	end

	return dir, fileName..fileForm
end

--解析出dir的上一级dir
function M.parseAboveDir(dir)
	local i, j, aboveDir = string.find(dir, "([%w_/.]*%/)[%w_.]")
	if i == nil then
		Log("cant find above dir!")
		return nil
	end
	
	return aboveDir
end

--检测文件是否存在
function M.isExsitFile(src)
	if type(lfs.attributes(src)) == "table" then
		return true
	end
	
	return false
end

--从res copy 文件
function M.copyFileFromRes(dst, srcFileName)
	Log("dst="..dst)
	
	local dir, fileName = M.parsePath(dst)
	Log("dir="..dir.."  fileName="..fileName)
	
	if not lfs.chdir(dir) then
		Log("no current dir, create it!")
		if not M.createDir(dir) then
			Log("create dir faild!")
			return false
		end
	end
	
	local src= script.getResData(srcFileName)
	if not src then
		Log("err in getResData src")
		return false
	end

	local dstFile = io.open(dst, "w")
	if not dstFile then
		Log("err in open dstFile")
		return false
	end
	

	dstFile:write(src)

	dstFile:close()
	Log("copyFileFromRes done!")
	return true
end

--删除文件
function M.removeFile(dst)
	return os.remove(dst)
end
