include("shared.lua")

function ENT:Draw()
    if not IsValid(self) then return end

    self:DrawModel()

    if not IsValid(LocalPlayer()) then return end

    if LocalPlayer():GetPos():Distance(self:GetPos()) > TobaccoConfig.DrawDistance then return end

    local speed = 3
    local amplitude = 1
    local bobbing = math.sin(CurTime() * speed) * amplitude
    local pos = self:LocalToWorld(Vector(0, 0, 40 + bobbing))
    local ang = Angle(0, LocalPlayer():EyeAngles().y - 90, 90)

    cam.Start3D2D(pos, ang, 0.1)

        local w, h = 220, 80

        surface.SetDrawColor(0, 0, 0, 220)
        surface.DrawRect(-w/2, -h/2, w, h)

        draw.SimpleText(
            "Shipping Pallet",
            "TobaccoLarge",
            0,
            -15,
            Color(255,255,255),
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER
        )


        if self:GetCigarettes() > 0 or self:GetCigars() > 0 then

            local value = self:GetSellAmount()

            if DarkRP then
                value = DarkRP.formatMoney(value)
            else
                value = "$" .. string.Comma(value)
            end
            
            draw.SimpleText(
                value,
                "TobaccoLarge",
                0,
                15,
                Color(80,199,76),
                TEXT_ALIGN_CENTER,
                TEXT_ALIGN_CENTER
            )

        else

            draw.SimpleText(
                "Empty",
                "TobaccoLarge",
                0,
                15,
                Color(200,200,200),
                TEXT_ALIGN_CENTER,
                TEXT_ALIGN_CENTER
            )

        end

    cam.End3D2D()
end