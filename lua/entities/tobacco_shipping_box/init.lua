AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


function ENT:Initialize()

    self:SetModel("models/thebaccy/shipping_box.mdl")

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    self:SetHealth(100)

    self:SetCigarettes(0)
    self:SetCigars(0)
    self:SetShowInfo(true)


    local phys = self:GetPhysicsObject()

    if IsValid(phys) then
        phys:Wake()
    end

end



function ENT:StartTouch(ent)

    if not IsValid(ent) then return end



    -- Cigarette boxes

    if ent:GetClass() == "tobacco_cigarette_box" then


        local current = self:GetCigarettes()
        local max = TobaccoConfig.ShippingBoxCigaretteMax


        if current >= max then
            return
        end


        local amount = math.min(
            ent:GetAmount(),
            max - current
        )


        if amount <= 0 then
            return
        end



        self:SetCigarettes(
            current + amount
        )


        ent:SetAmount(
            ent:GetAmount() - amount
        )


        if ent:GetAmount() <= 0 then
            ent:Remove()
        end

    end



    -- Cigar cartons

    if ent:GetClass() == "tobacco_cigar_carton" then


        local current = self:GetCigars()
        local max = TobaccoConfig.ShippingBoxCigarMax


        if current >= max then
            return
        end


        local amount = math.min(
            ent:GetAmount(),
            max - current
        )


        if amount <= 0 then
            return
        end



        self:SetCigars(
            current + amount
        )


        ent:SetAmount(
            ent:GetAmount() - amount
        )


        if ent:GetAmount() <= 0 then
            ent:Remove()
        end

    end

end



function ENT:OnTakeDamage(dmg)

    local attacker = dmg:GetAttacker()


    if not IsValid(attacker) or not attacker:IsPlayer() then
        return
    end


    self:SetHealth(
        self:Health() - dmg:GetDamage()
    )


    if self:Health() > 0 then
        return
    end


    self:Remove()

end