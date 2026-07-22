AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local cigaretteModels = {
    "models/thebaccy/cigarette_packet.mdl",
    "models/thebaccy/cigarette_packet_camel.mdl",
    "models/thebaccy/cigarette_packet_marlboro.mdl",
    "models/thebaccy/cigarette_packet_menthol.mdl"
}

function ENT:Initialize()
    self:SetModel(table.Random(cigaretteModels))
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    self:SetHealth(0)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
    end

    self:SetAmount(0)
end


function ENT:StartTouch(ent)
    if not IsValid(ent) then return end

    if ent:GetClass() == "tobacco_cigarette" then
        
        local current = self:GetAmount()
        local max = TobaccoConfig.CigaretteBoxMax

        if current >= max then
            return
        end

        local addAmount = 1

        if ent.GetAmount then
            addAmount = ent:GetAmount()
        end

        local space = max - current
        addAmount = math.min(addAmount, space)

        self:SetAmount(current + addAmount)

        ent:Remove()
    end
end

function ENT:OnTakeDamage(dmg)
    local attacker = dmg:GetAttacker()

    if not IsValid(attacker) or not attacker:IsPlayer() then return end

    self:SetHealth(self:Health() - dmg:GetDamage())

    if self:Health() > 0 then return end

    self:Remove()
end