package.path = "./?.lua;./?/init.lua;" .. package.path

local geometry = require("sizeup.geometry")

local function assertFrameEquals(actual, expected, label)
	assert(type(actual) == "table", (label or "frame") .. "은(는) table 이어야 합니다")
	assert(
		actual.x == expected.x and actual.y == expected.y and actual.w == expected.w and actual.h == expected.h,
		string.format(
			"%s mismatch: expected {x=%s,y=%s,w=%s,h=%s} got {x=%s,y=%s,w=%s,h=%s}",
			label or "frame",
			expected.x,
			expected.y,
			expected.w,
			expected.h,
			actual.x,
			actual.y,
			actual.w,
			actual.h
		)
	)
end

local screen = { x = 0, y = 0, w = 1440, h = 900 }

do
	local left = geometry.halfFrame(screen, "left")
	assertFrameEquals(left, { x = 0, y = 0, w = 720, h = 900 }, "left half")

	local down = geometry.halfFrame(screen, "down")
	assertFrameEquals(down, { x = 0, y = 450, w = 1440, h = 450 }, "bottom half")
end

do
	local upperLeft = geometry.quadrantFrame(screen, "upperLeft")
	assertFrameEquals(upperLeft, { x = 0, y = 0, w = 720, h = 450 }, "upper left quadrant")

	local lowerRight = geometry.quadrantFrame(screen, "lowerRight")
	assertFrameEquals(lowerRight, { x = 720, y = 450, w = 720, h = 450 }, "lower right quadrant")
end

do
	local centerAbsolute = geometry.centerFrame(screen, { mode = "absolute", width = 800, height = 600 })
	assertFrameEquals(centerAbsolute, { x = 320, y = 150, w = 800, h = 600 }, "center absolute")

	local centerRelative = geometry.centerFrame(screen, { mode = "relative", widthRatio = 0.75, heightRatio = 0.5 })
	assertFrameEquals(centerRelative, { x = 180, y = 225, w = 1080, h = 450 }, "center relative")
end

print("geometry_spec: all tests passed")
