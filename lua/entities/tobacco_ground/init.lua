AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/thebaccy/ground_tobacco.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    self:SetHealth(100)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
    end
end

function ENT:OnTakeDamage(dmg)
    local attacker = dmg:GetAttacker()

    if not IsValid(attacker) or not attacker:IsPlayer() then return end

    self:SetHealth(self:Health() - dmg:GetDamage())

    if self:Health() > 0 then return end

    self:Remove()
end