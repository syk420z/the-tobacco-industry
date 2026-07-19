include("shared.lua")

surface.CreateFont("TobaccoLarge", {
    font = "Arial",
    extended = false,
    size = 25,
})

surface.CreateFont("TobaccoSmall", {
    font = "Arial",
    extended = false,
    size = 18,
})

local function Draw3D2DProgressBar(x, y, width, height, currentVal, maxVal, colorBg, colorFill)
    local fraction = math.Clamp(currentVal / maxVal, 0, 1)

    surface.SetDrawColor(colorBg.r, colorBg.g, colorBg.b, colorBg.a)
    surface.DrawRect(x, y, width, height)

    surface.SetDrawColor(colorFill.r, colorFill.g, colorFill.b, colorFill.a)
    surface.DrawRect(x, y, width * fraction, height)
end

function ENT:Draw()
    self:DrawModel()

    if not IsValid(LocalPlayer()) then return end

    if LocalPlayer():GetPos():Distance(self:GetPos()) > TobaccoConfig.DrawDistance then return end

    local pos = self:LocalToWorld(Vector(0, 0, 40))
    local ang = Angle(0, LocalPlayer():EyeAngles().y - 90, 90)

    local timeElapsed = TobaccoConfig.GrindTime - self:GetNWInt("time")
    local progress = math.Clamp(timeElapsed / TobaccoConfig.GrindTime, 0, 1)
    local percent = math.floor(progress * 100)

    local status = "Idle"

    if self:GetCuredLeaf() > 0 then
        status = "Grinding"
    end

    if self:GetBatch() > 0 and percent >= 100 then
        status = "Ready"
    end

    cam.Start3D2D(pos, ang, 0.1)

        local w, h = 320, 200

        surface.SetDrawColor(15, 15, 15, 235)
        surface.DrawRect(-w / 2, -h / 2, w, h)

        surface.SetDrawColor(248, 148, 55, 100)
        surface.DrawOutlinedRect(-w / 2, -h / 2, w, h, 2)

        draw.SimpleText(
            "Leaf Grinder",
            "TobaccoLarge",
            0,
            -75,
            Color(248, 248, 248),
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER
        )

        draw.SimpleText(
            "Status: " .. status,
            "TobaccoSmall",
            -140,
            -45,
            Color(255, 200, 100),
            TEXT_ALIGN_LEFT,
            TEXT_ALIGN_CENTER
        )

        draw.SimpleText(
            "Cured Tobacco: " .. self:GetCuredLeaf() .. "g",
            "TobaccoSmall",
            -140,
            -20,
            Color(131, 91, 31),
            TEXT_ALIGN_LEFT,
            TEXT_ALIGN_CENTER
        )

        draw.SimpleText(
            "Ground Tobacco: " .. self:GetBatch() .. "g",
            "TobaccoSmall",
            -140,
            5,
            Color(194, 155, 98),
            TEXT_ALIGN_LEFT,
            TEXT_ALIGN_CENTER
        )

        Draw3D2DProgressBar(
            -140,
            40,
            280,
            15,
            timeElapsed,
            TobaccoConfig.GrindTime,
            Color(60,60,60),
            Color(248,148,55)
        )

        draw.SimpleText(
            percent .. "%",
            "TobaccoSmall",
            140,
            47,
            Color(255, 255, 255),
            TEXT_ALIGN_RIGHT,
            TEXT_ALIGN_CENTER
        )

        draw.SimpleText(
            "[E] Collect Output",
            "TobaccoSmall",
            -140,
            75,
            Color(255, 255, 255),
            TEXT_ALIGN_LEFT,
            TEXT_ALIGN_CENTER
        )

    cam.End3D2D()
end