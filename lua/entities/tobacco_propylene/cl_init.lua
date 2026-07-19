include("shared.lua")

function ENT:Draw()
    self:DrawModel()

    if not IsValid(LocalPlayer()) then return end

    if LocalPlayer():GetPos():Distance(self:GetPos()) > TobaccoConfig.DrawDistance then return end

    local speed = 3
    local amplitude = 1
    local bobbing = math.sin(CurTime() * speed) * amplitude
    local pos = self:LocalToWorld(Vector(0, 0, 20 + bobbing))
    local ang = Angle(0, LocalPlayer():EyeAngles().y - 90, 90)

    cam.Start3D2D(pos, ang, 0.1)

        local w, h = 180, 40
        surface.SetDrawColor(0, 0, 0, 220)
        surface.DrawRect(-w/2, -h/2, w, h)

        draw.SimpleText("Propylene", "TobaccoLarge", 0, 0, Color(143,231,180), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    cam.End3D2D()
end
