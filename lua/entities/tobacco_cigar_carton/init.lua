AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local cigarModels = {
    "models/thebaccy/cigar_carton.mdl",
    "models/thebaccy/cigar_box_02.mdl",
    "models/thebaccy/cigar_box_03.mdl",
}

function ENT:Initialize()
    self:SetModel(table.Random(cigarModels))
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    self:SetHealth(100)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
    end

    self:SetAmount(0)
end


function ENT:StartTouch(ent)
    if not IsValid(ent) then return end

    if ent:GetClass() == "tobacco_cigar" then
        
        local current = self:GetAmount()
        local max = TobaccoConfig.CigarCartonMax

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