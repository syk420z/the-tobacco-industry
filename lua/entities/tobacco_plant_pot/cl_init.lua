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
        local w, h = 180, 90
        surface.SetDrawColor(0, 0, 0, 220)
        surface.DrawRect(-w/2, -h/2, w, h)

        draw.SimpleText("Clay Pot", "TobaccoLarge", 0, -25, Color(194,155,98), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(self:GetStatus(), "TobaccoSmall", 0, 0, Color(248,247,245), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Water: "..self:GetNWInt("Water").."%", "TobaccoSmall", 0, 25, Color(0,183,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    cam.End3D2D()
end