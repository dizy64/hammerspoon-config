package.path = "./?.lua;./?/init.lua;" .. package.path

local feedback = require("sizeup.feedback")

local customMessages = {
	center = "센터 800x600",
}

assert(feedback.message("left") == "왼쪽 반 화면", "기본 메시지가 일치해야 합니다")
assert(feedback.message("center", customMessages) == "센터 800x600", "커스텀 메시지가 우선되어야 합니다")
assert(feedback.message("unknown") == "unknown", "정의되지 않은 키는 그대로 돌려줍니다")

local shown = feedback.show("left", nil, { messages = { left = "왼쪽" }, duration = 0.1, style = { textSize = 10 } })
assert(shown == "왼쪽", "show는 표시된 메시지를 반환합니다")

print("feedback_spec: all tests passed")
