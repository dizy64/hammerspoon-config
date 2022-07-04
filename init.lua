function getNextOutputDevice()
	local currentOutputDevice = hs.audiodevice.defaultOutputDevice()
	local allOutputDevices = hs.audiodevice.allOutputDevices()
	local currentOutputDeviceIndex = nil

	for i = 1, #allOutputDevices do
		if allOutputDevices[i]:uid() == currentOutputDevice:uid() then
			currentOutputDeviceIndex = i
			break
		end
	end

    nextDeviceIndex = (currentOutputDeviceIndex + 1) % (#allOutputDevices + 1)
    
    if nextDeviceIndex == 0 then
        nextDeviceIndex = 1
    end

    return allOutputDevices[nextDeviceIndex]
end

hs.hotkey.bind({"cmd", "ctrl"}, "O", function()
    local device = getNextOutputDevice()
    hs.alert.closeAll()
    hs.alert.show(device:name())

    device:setDefaultOutputDevice()
end)
