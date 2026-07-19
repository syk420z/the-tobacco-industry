include("shared.lua")

surface.CreateFont("TobaccoLarge",{
	font = "Roboto",
	extended = false,
	size = 25,
})

surface.CreateFont("TobaccoSmall",{
	font = "Roboto",
	extended = false,
	size = 18,
})

local function Draw3D2DProgressBar(x, y, width, height, currentVal, maxVal, colorBg, colorFill)
    local fraction = math.Clamp(currentVal / maxVal, 0, 1)
    surface.SetDrawColor(colorBg.r, colorBg.g, colorBg.b, colorBg.a)
    surface.DrawRect(x, y, width, height)

    local fillWidth = width * fraction
    surface.SetDrawColor(colorFill.r, colorFill.g, colorFill.b, colorFill.a)
    surface.DrawRect(x, y, fillWidth, height)
end

function ENT:Draw()
    self:DrawModel()

    if not IsValid(LocalPlayer()) then return end

    if LocalPlayer():GetPos():Distance(self:GetPos()) > TobaccoConfig.DrawDistance then return end

    local pos = self:LocalToWorld(Vector(0, 0, 40))
    local ang = Angle(0, LocalPlayer():EyeAngles().y - 90, 90)

    local timeElapsed = TobaccoConfig.ProcessingTime - self:GetNWInt("time")
    local progress = math.Clamp(timeElapsed / TobaccoConfig.ProcessingTime, 0, 1)
    local percent = math.floor(progress * 100)

    local status = "Idle"

    if self:GetLeaves() > 0 and self:GetPropylene() > 0 then
        status = "Processing"
    end

    if self:GetBatch() > 0 and percent >= 100 then
        status = "Ready"
    end

    cam.Start3D2D(pos, ang, 0.1)

        local w, h = 320, 200

        surface.SetDrawColor(15, 15, 15, 235)
        surface.DrawRect(-w/2, -h/2, w, h)

        surface.SetDrawColor(248,148,55, 100)
        surface.DrawOutlinedRect(-w/2, -h/2, w, h, 2)

        draw.SimpleText(
            "Tobacco Processor",
            "TobaccoLarge",
            0,
            -75,
            Color(248,248,248),
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER
        )

        -- Status
        draw.SimpleText(
            "Status: " .. status,
            "TobaccoSmall",
            -140,
            -45,
            Color(255,200,100),
            TEXT_ALIGN_LEFT,
            TEXT_ALIGN_CENTER
        )

        -- Resources
        draw.SimpleText(
            "Leaves: " .. self:GetLeaves() .. "/" .. TobaccoConfig.MaxLeaves .. "kg",
            "TobaccoSmall",
            -140,
            -20,
            Color(119,238,119),
            TEXT_ALIGN_LEFT,
            TEXT_ALIGN_CENTER
        )

        draw.SimpleText(
            "Propylene Glycol: " .. self:GetPropylene() .. "/" .. TobaccoConfig.MaxPropylene .. "L",
            "TobaccoSmall",
            -140,
            5,
            Color(143,231,180),
            TEXT_ALIGN_LEFT,
            TEXT_ALIGN_CENTER
        )

        -- Output
        draw.SimpleText(
            "Output: " .. TobaccoConfig.TobaccoOutputPerProcess,
            "TobaccoSmall",
            -140,
            40,
            Color(194,155,98),
            TEXT_ALIGN_LEFT,
            TEXT_ALIGN_CENTER
        )

        -- Progress Bar
        Draw3D2DProgressBar(
            -140,
            55,
            280,
            15,
            timeElapsed,
            TobaccoConfig.ProcessingTime,
            Color(60,60,60),
            Color(248,148,55)
        )

        draw.SimpleText(
            percent .. "%",
            "TobaccoSmall",
            140,
            62,
            Color(255,255,255),
            TEXT_ALIGN_RIGHT,
            TEXT_ALIGN_CENTER
        )

        -- Interaction
        draw.SimpleText(
            "[E] Collect Output",
            "TobaccoSmall",
            -140,
            82,
            Color(255,255,255),
            TEXT_ALIGN_LEFT,
            TEXT_ALIGN_CENTER
        )

    cam.End3D2D()
end