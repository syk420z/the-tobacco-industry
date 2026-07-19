include("shared.lua")
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()
    self:DrawModel()

    if not IsValid(LocalPlayer()) then return end

    local pos = self:LocalToWorld(Vector(2, -1, 78))
    local ang = Angle(0, LocalPlayer():EyeAngles().y - 90, 90)

    cam.Start3D2D(pos, ang, 0.1)
        local w, h = 200, 40
        surface.SetDrawColor(0, 0, 0, 190)
        surface.DrawRect(-w/2, -h/2, w, h)

        draw.SimpleText("Tobacco Buyer", "TobaccoLarge", -15, 0, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255,255,255,255)
        surface.SetMaterial(Material("ui/uileaf.png"))
        surface.DrawTexturedRect(65,-12,26,26)
    cam.End3D2D()
end

net.Receive("TobaccoBuyerChat", function()
    chat.AddText(
        Color(120, 80, 40),
        "Tobacco Buyer: ",
        Color(255, 255, 255),
        net.ReadString(),
        Color(119, 219, 115),
        net.ReadString()
    )
end)