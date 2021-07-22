local Frames = {}

local frame, scale, multiplier = CreateFrame("Frame")

local default = {
	backdropOpacity = 0.4,
	borderRegions = { "TOP", "RIGHT", "BOTTOM", "LEFT" },
	borderSize = 2,
}

function Frames:AddBackdrop(name)
	assert(type(name) == "string", "Invalid argument to AddBackdrop")
	self:AddFrameBackdrop(_G[name])
end

function Frames:AddBorder(subject)
    assert(type(subject) == "table", "Invalid argument to AddBorder")

	local pos, neg = self:GetScaledValue(default.borderSize)

	local width = subject:GetWidth()
	local height = subject:GetHeight()

	for i = 0, 4 do
		local point = default.borderRegions[i]
		local size = default.borderSize * mult
		local border = backdropFrame:CreateTexture(nil, "BORDER")

		if point == "TOP" or point == "BOTTOM" then
			border:SetWidth(width)
			border:SetHeight(pos)
		else
			border:SetWidth(pos)
			border:SetHeight(height)
		end

		border:SetPoint(point, backdropFrame, point)
	end
end

function Frames:AddFrameBackdrop(subject, addBorder)
	assert(type(subject) == "table", "Invalid argument to AddFrameBackdrop")

	if frame.GetFrameStrata(subject) ~= "LOW" then
		frame.SetFrameStrata(subject, "LOW")
	end

	if frame.GetFrameLevel(subject) ~= 2 then
		frame.SetFrameLevel(subject, 2)
	end

	-- this was added in 9.0.2, but is also available in WoW Classic TBC
	frame.SetFixedFrameStrata(subject, true)
	frame.SetFixedFrameLevel(subject, true)
	frame.SetParent(subject, UIParent)

	local backdropFrame = CreateFrame("Frame")
	backdropFrame:SetParent(subject)
	backdropFrame:SetFrameStrata("BACKGROUND")
	backdropFrame:SetFrameLevel(1)
	backdropFrame:SetFixedFrameStrata(true)
	backdropFrame:SetFixedFrameLevel(true)

	if not addBorder then
		backdropFrame:SetAllPoints(true)
	else
		backdropFrame:SetPoint("TOPLEFT", subject, "TOPLEFT", neg, pos)
		backdropFrame:SetPoint("BOTTOMRIGHT", subject, "BOTTOMRIGHT", pos, neg)
		self:AddBorder(backdropFrame)
	end

	local backdrop = backdropFrame:CreateTexture(nil, "BACKGROUND")
	backdrop:SetColorTexture(0, 0, 0, default.backdropOpacity)
	backdrop:SetAllPoints(true)

	if not subject:IsShown() then backdropFrame:Hide() end

	subject:HookScript("OnHide", function() backdropFrame:Hide() end)
	subject:HookScript("OnShow", function() backdropFrame:Show() end)
end

function Frames:ConvertToBackdrop(subject, addBorder)
	assert(type(subject) == "table", "Invalid argument to AddFrameBackdrop")

	local plus, minus = self:GetScaledValue(default.borderSize)

	local backdrop = subject:CreateTexture(nil, "BACKGROUND")
	backdrop:SetColorTexture(0, 0, 0, default.backdropOpacity)
	backdrop:SetAllPoints(true)

	if addBorder then self:AddBorder(subject) end
end

function Frames:GetScaledValue(value)
	assert(type(value) == "number", "Missing or invalid value to GetScaledValue")

	if not scale or not mutlipler then
		scale = GetCVar("uiScale")
		multipler = 1 / scale
	end

	local plus = value * multiplier
	local minus = plus * -1

	return plus, minus
end

function Frames:HideFrame(subject, persistent)
	assert(type(subject) == "table", "Invalid argument to HideFrame")

	if persistent then subject.Show = subject.Hide end

	subject:Hide()
end

function Frames:HideFrameByName(name, persistent)
	assert(type(name), "Invalid argument to HideFrameByName")

	self:HideFrame(_G[name])
end
