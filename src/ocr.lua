-- ocr.lua
-- Author: cndy1860
-- Date: 2019-01-25
-- Descrip: 文字识别

function ocrAreaText(area, offsetColor)
	if area == nil then
		return
	end
	
	if offsetColor == nil then
		offsetColor = {"0xffffff-0xf0f0f0"}
	end
	
	local ocr, msg = createOCR({
			type = "tesseract",
			path = "res/", -- 自定义字库暂时只能放在脚本res/目录下
			lang = "num", -- 使用生成的num.traineddata文件
			whitelist = "01"
		})
	if ocr ~= nil then
		local code, text = ocr:getText({
				rect = area,
				diff = offsetColor,
			})
		ocr:release()
		if code == 0 then
			--Log("recognize succeed: text = " .. text)
			local function cleanOcrText(text)
				local i, j = string.find(text, "[0123456789.k]")	--找到首个字符
				local _i, _j = string.find(text, "[^0123456789.k]", i)	--找到结束字符
				
				local cleText = string.sub(text, i, _j - 1)
				Log("cleanOcrText:"..cleText)
				
				return cleText
			end
			return cleanOcrText(text)
		else
			catchError(ERR_WARNING, "recognize failed: code = " .. tostring(code))
		end
	else
		catchError(ERR_WARNING, "createOCR failed: " .. msg)
	end
end