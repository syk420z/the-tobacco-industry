include("shared.lua")

function ENT:Draw()
    self:DrawModel()

    if not IsValid(LocalPlayer()) then return end

    if LocalPlayer():GetPos():Distance(self:GetPos()) > TobaccoConfig.DrawDistance then return end

    local speed = 3
    local amplitude = 1
    local bobbing = math.sin(CurTime() * speed) * amplitude

    local pos = self:LocalToWorld(Vector(2, 0, 12 + bobbing))
    local ang = Angle(0, LocalPlayer():EyeAngles().y - 90, 90)


    local progress = 0

    if self:GetNWBool("rolling") then
        local timeElapsed = TobaccoConfig.CigarProductionTime - self:GetNWInt("time")

        progress = math.Clamp(
            timeElapsed / TobaccoConfig.CigarProductionTime,
            0,
            1
        )
    end


    cam.Start3D2D(pos, ang, 0.1)

        local w, h = 220, 105

        surface.SetDrawColor(0, 0, 0, 220)
        surface.DrawRect(-w/2, -h/2, w, h)


        draw.SimpleText(
            "Cigar Tray",
            "TobaccoLarge",
            0,
            -35,
            Color(255,255,255),
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER
        )


        draw.SimpleText(
            "Leaves: "..self:GetNWInt("leaves"),
            "TobaccoSmall",
            0,
            -5,
            Color(255,255,255),
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER
        )


        local barW, barH = 150, 12


        surface.SetDrawColor(0, 0, 0, 220)
        surface.DrawRect(
            -barW/2,
            20,
            barW,
            barH
        )


        surface.SetDrawColor(120, 220, 120, 255)
        surface.DrawRect(
            -barW/2,
            20,
            barW * progress,
            barH
        )


    cam.End3D2D()
end