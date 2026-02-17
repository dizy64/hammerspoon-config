local geometry = {}

local function validateFrame(frame)
	if type(frame) ~= "table" then
		error("screenFrame은 table이어야 합니다", 2)
	end
	for _, key in ipairs({ "x", "y", "w", "h" }) do
		if type(frame[key]) ~= "number" then
			error("screenFrame." .. key .. " 값이 필요합니다", 2)
		end
	end
end

local function halfSize(value)
	return math.floor(value / 2)
end

function geometry.halfFrame(screenFrame, direction)
	validateFrame(screenFrame)
	local frame = { x = screenFrame.x, y = screenFrame.y, w = screenFrame.w, h = screenFrame.h }

	if direction == "left" then
		frame.w = halfSize(screenFrame.w)
	elseif direction == "right" then
		frame.x = screenFrame.x + halfSize(screenFrame.w)
		frame.w = halfSize(screenFrame.w)
	elseif direction == "up" then
		frame.h = halfSize(screenFrame.h)
	elseif direction == "down" then
		frame.y = screenFrame.y + halfSize(screenFrame.h)
		frame.h = halfSize(screenFrame.h)
	else
		error("알 수 없는 방향: " .. tostring(direction))
	end

	return frame
end

function geometry.quadrantFrame(screenFrame, quadrant)
	validateFrame(screenFrame)
	local halfW = halfSize(screenFrame.w)
	local halfH = halfSize(screenFrame.h)
	local frame = { x = screenFrame.x, y = screenFrame.y, w = halfW, h = halfH }

	if quadrant == "upperLeft" then
		return frame
	elseif quadrant == "upperRight" then
		frame.x = screenFrame.x + halfW
	elseif quadrant == "lowerLeft" then
		frame.y = screenFrame.y + halfH
	elseif quadrant == "lowerRight" then
		frame.x = screenFrame.x + halfW
		frame.y = screenFrame.y + halfH
	else
		error("알 수 없는 사분면: " .. tostring(quadrant))
	end

	return frame
end

local function clampRatio(value)
	if type(value) ~= "number" then
		error("비율은 number 여야 합니다", 3)
	end
	if value <= 0 or value > 1 then
		error("비율은 0보다 크고 1 이하이어야 합니다", 3)
	end
	return value
end

function geometry.centerFrame(screenFrame, options)
	validateFrame(screenFrame)
	options = options or {}
	local mode = options.mode or "absolute"
	local width
	local height

	if mode == "absolute" then
		width = options.width or 800
		height = options.height or 600
	elseif mode == "relative" then
		local widthRatio = clampRatio(options.widthRatio or 0.75)
		local heightRatio = clampRatio(options.heightRatio or 0.75)
		width = math.floor(screenFrame.w * widthRatio)
		height = math.floor(screenFrame.h * heightRatio)
	else
		error("centerFrame mode 값이 올바르지 않습니다 (absolute|relative)", 2)
	end

	width = math.min(width, screenFrame.w)
	height = math.min(height, screenFrame.h)

	local x = screenFrame.x + math.floor((screenFrame.w - width) / 2)
	local y = screenFrame.y + math.floor((screenFrame.h - height) / 2)

	return { x = x, y = y, w = width, h = height }
end

return geometry
