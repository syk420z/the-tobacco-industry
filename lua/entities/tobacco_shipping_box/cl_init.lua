include("shared.lua")

function ENT:Draw()
    self:DrawModel()

    if not IsValid(LocalPlayer()) then return end
    if not self:GetShowInfo() then return end

    if LocalPlayer():GetPos():Distance(self:GetPos()) > TobaccoConfig.DrawDistance then return end

    local speed = 3
    local amplitude = 1
    local bobbing = math.sin(CurTime() * speed) * amplitude
    local pos = self:LocalToWorld(Vector(0, 0, 15 + bobbing))
    local ang = Angle(0, LocalPlayer():EyeAngles().y - 90, 90)

    cam.Start3D2D(pos, ang, 0.1)
        local w, h = 220, 70

        surface.SetDrawColor(0, 0, 0, 220)
        surface.DrawRect(-w/2, -h/2, w, h)

        draw.SimpleText(
            "Cigarettes: " .. self:GetCigarettes() .. "/" .. TobaccoConfig.ShippingBoxCigaretteMax,
            "TobaccoLarge",
            0,
            -12,
            Color(255,255,255),
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER
        )

        draw.SimpleText(
            "Cigars: " .. self:GetCigars() .. "/" .. TobaccoConfig.ShippingBoxCigarMax,
            "TobaccoLarge",
            0,
            12,
            Color(255,255,255),
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER
        )

    cam.End3D2D()
end