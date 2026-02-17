local geometry = require("sizeup.geometry")
local feedback = require("sizeup.feedback")

local SizeUp = {}

-- SizeUp 기본 동작을 재현하기 위한 설정
local config = {
	center = { mode = "absolute", width = 800, height = 600 },
	alert = {
		duration = 0.4,
		style = { textSize = 18 },
		messages = {
			left = "왼쪽 반 화면",
			right = "오른쪽 반 화면",
			up = "위쪽 반 화면",
			down = "아래쪽 반 화면",
			upperLeft = "좌상단 사분면",
			upperRight = "우상단 사분면",
			lowerLeft = "좌하단 사분면",
			lowerRight = "우하단 사분면",
			previousScreen = "이전 모니터",
			nextScreen = "다음 모니터",
			center = "중앙 배치",
			maximize = "창 최대화",
			snapback = "이전 위치 복귀",
		},
	},
}

local snapbackStore = {}

local function updateCenterMessage()
	local center = config.center
	if center.mode == "relative" then
		local widthRatio = math.floor((center.widthRatio or 0.75) * 100)
		local heightRatio = math.floor((center.heightRatio or 0.75) * 100)
		config.alert.messages.center = string.format("중앙 %d%% x %d%%", widthRatio, heightRatio)
	else
		config.alert.messages.center = string.format("중앙 %dx%d", center.width or 800, center.height or 600)
	end
end

updateCenterMessage()

local function applyAlertOverrides(alertOptions)
	if not alertOptions then
		return
	end
	if alertOptions.duration then
		config.alert.duration = alertOptions.duration
	end
	if alertOptions.style then
		config.alert.style = alertOptions.style
	end
	if alertOptions.messages then
		config.alert.messages = alertOptions.messages
	end
end

local function cloneFrame(frame)
	return { x = frame.x, y = frame.y, w = frame.w, h = frame.h }
end

local function showAction(actionKey, win, screen)
	if not actionKey then
		return
	end
	local targetScreen = screen or (win and win:screen()) or hs.screen.mainScreen()
	if not targetScreen then
		return
	end
	feedback.show(actionKey, targetScreen, config.alert)
end

-- 가장 앞에 있는 창을 찾아 존재하지 않으면 경고
local function frontmostWindow()
	local win = hs.window.frontmostWindow()
	if not win then
		hs.alert.show("조작할 창이 없습니다")
	end
	return win
end

-- SnapBack을 위해 이전 프레임을 저장
local function storeFrame(win)
	local id = win:id()
	if not id then
		return
	end
	snapbackStore[id] = cloneFrame(win:frame())
end

-- 프레임을 갱신하기 전에 현재 프레임을 백업
local function applyFrame(win, frame)
	if not frame then
		return
	end
	storeFrame(win)
	win:setFrame(frame)
end

-- 현재 창이 위치한 모니터의 frame을 추출
local function screenFrame(win)
	local screen = win:screen()
	if not screen then
		hs.alert.show("모니터 정보를 찾을 수 없습니다")
		return nil, nil
	end
	return screen:frame(), screen
end

local function moveHalf(direction)
	local win = frontmostWindow()
	if not win then
		return
	end
	local frame, screen = screenFrame(win)
	if not frame then
		return
	end
	applyFrame(win, geometry.halfFrame(frame, direction))
	showAction(direction, win, screen)
end

local function moveQuadrant(quadrant)
	local win = frontmostWindow()
	if not win then
		return
	end
	local frame, screen = screenFrame(win)
	if not frame then
		return
	end
	applyFrame(win, geometry.quadrantFrame(frame, quadrant))
	showAction(quadrant, win, screen)
end

local function moveToScreen(direction)
	local win = frontmostWindow()
	if not win then
		return
	end
	local currentScreen = win:screen()
	if not currentScreen then
		hs.alert.show("모니터 정보를 찾을 수 없습니다")
		return
	end
	local key = direction == "next" and "nextScreen" or "previousScreen"
	local target = direction == "next" and currentScreen:next() or currentScreen:previous()
	if not target or target:id() == currentScreen:id() then
		hs.alert.show("이동할 다른 모니터가 없습니다")
		return
	end
	storeFrame(win)
	win:moveToScreen(target, false, true)
	showAction(key, win, target)
end

local function centerWindow()
	local win = frontmostWindow()
	if not win then
		return
	end
	local frame, screen = screenFrame(win)
	if not frame then
		return
	end
	local centerFrame = geometry.centerFrame(frame, config.center)
	applyFrame(win, centerFrame)
	showAction("center", win, screen)
end

local function toggleMaximize()
	local win = frontmostWindow()
	if not win then
		return
	end
	storeFrame(win)
	win:maximize()
	showAction("maximize", win)
end

local function snapBack()
	local win = frontmostWindow()
	if not win then
		return
	end
	local id = win:id()
	if not id or not snapbackStore[id] then
		hs.alert.show("복구할 이전 위치가 없습니다")
		return
	end
	local current = cloneFrame(win:frame())
	win:setFrame(snapbackStore[id])
	snapbackStore[id] = current
	showAction("snapback", win)
end

local function bind(bindings)
	for _, binding in ipairs(bindings) do
		hs.hotkey.bind(binding.mods, binding.key, binding.fn)
	end
end

-- SizeUp이 제공하던 기본 단축키를 최대한 유사하게 구성
local defaultBindings = {
	{ mods = { "ctrl", "alt", "cmd" }, key = "left", fn = function()
		moveHalf("left")
	end },
	{ mods = { "ctrl", "alt", "cmd" }, key = "right", fn = function()
		moveHalf("right")
	end },
	{ mods = { "ctrl", "alt", "cmd" }, key = "up", fn = function()
		moveHalf("up")
	end },
	{ mods = { "ctrl", "alt", "cmd" }, key = "down", fn = function()
		moveHalf("down")
	end },
	{ mods = { "ctrl", "alt", "shift", "cmd" }, key = "u", fn = function()
		moveQuadrant("upperLeft")
	end },
	{ mods = { "ctrl", "alt", "shift", "cmd" }, key = "i", fn = function()
		moveQuadrant("upperRight")
	end },
	{ mods = { "ctrl", "alt", "shift", "cmd" }, key = "j", fn = function()
		moveQuadrant("lowerLeft")
	end },
	{ mods = { "ctrl", "alt", "shift", "cmd" }, key = "k", fn = function()
		moveQuadrant("lowerRight")
	end },
	{ mods = { "ctrl", "alt" }, key = "left", fn = function()
		moveToScreen("previous")
	end },
	{ mods = { "ctrl", "alt" }, key = "right", fn = function()
		moveToScreen("next")
	end },
	{ mods = { "ctrl", "alt", "cmd" }, key = "m", fn = toggleMaximize },
	{ mods = { "ctrl", "alt", "cmd" }, key = "c", fn = centerWindow },
	{ mods = { "ctrl", "alt", "cmd" }, key = "/", fn = snapBack },
}

function SizeUp.setup(options)
	options = options or {}
	if options.center then
		config.center = options.center
		updateCenterMessage()
	end
	applyAlertOverrides(options.alert)
	local bindings = options.bindings or defaultBindings
	bind(bindings)
end

return SizeUp
