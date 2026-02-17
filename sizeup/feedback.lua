local feedback = {}

local defaultMessages = {
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
}

function feedback.message(actionKey, customMessages)
	assert(actionKey, "actionKey가 필요합니다")
	local tableSource = customMessages or defaultMessages
	return tableSource[actionKey] or actionKey
end

function feedback.show(actionKey, screen, config)
	local alertConfig = config or {}
	local duration = alertConfig.duration or 0.4
	local style = alertConfig.style or { textSize = alertConfig.textSize or 18 }
	local message = feedback.message(actionKey, alertConfig.messages)
	if hs and hs.alert then
		hs.alert.show(message, style, screen, duration)
	end
	return message
end

return feedback
