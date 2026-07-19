AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_wasteland/laundry_dryer002.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    self:SetHealth(100)

    self:SetNWInt('time', TobaccoConfig.GrindTime)

    self:SetCuredLeaf(0)

    self:SetModelScale(0.5, 0)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
    end
end

function ENT:StartTouch(ent)
    if not IsValid(ent) then return end

    if ent:GetClass() == "tobacco_box_cured" and not self:GetNWBool("isGrinding") then
        self:SetCuredLeaf(self:GetCuredLeaf() + ent:GetBatch())
        self:EmitSound("physics/wood/wood_box_impact_hard4.wav")
        ent:Remove()

        if not self:GetNWBool("isGrinding") then
            self:StartGrinding()
        end
    end
end

function ENT:StartGrinding()
    if self:GetNWBool('isGrinding') == true then return end

    self:SetNWInt('time', TobaccoConfig.GrindTime)
    self:SetNWBool('isGrinding', true)

    self:EmitSound("ambient/machines/diesel_engine_idle1.wav", 60, 100, 1, CHAN_AUTO)
    self:EmitSound("buttons/button9.wav")

    timer.Create("tobacco_grinder_"..self:EntIndex(), 1, 0, function()
        if not IsValid(self) or self:GetNWBool('isGrinding') == false then return end
        self:SetNWInt('time', self:GetNWInt('time') - 1)
        if self:GetNWInt('time') <= 0 then
            self:FinishGrinding()
        end
    end)
end

function ENT:FinishGrinding()
    timer.Remove("tobacco_grinder_"..self:EntIndex())
    self:SetNWBool('isGrinding', false)

    self:SetBatch(self:GetCuredLeaf())
    self:SetCuredLeaf(0)

    self:SetNWInt('time', TobaccoConfig.GrindTime)
    self:StopSound("ambient/machines/diesel_engine_idle1.wav")
    self:EmitSound("buttons/button15.wav")
end

function ENT:Use(act, call)
    local curTime = CurTime()
    if not self.nextUse or curTime >= self.nextUse then
        if self:GetNWBool('isGrinding') == false and self:GetBatch() > 0 then
            local groundTobacco = ents.Create("tobacco_ground")
            groundTobacco:SetPos(self:GetPos() + Vector(0, 0, 40))
            groundTobacco:SetBatch(self:GetBatch())
            groundTobacco:Spawn()

            self:SetBatch(0)

            self.nextUse = curTime + 1
        end
    end
end

function ENT:OnRemove()
    self:StopSound('ambient/machines/diesel_engine_idle1.wav')
    timer.Remove("tobacco_grinder_"..self:EntIndex())
end

function ENT:OnTakeDamage(dmg)
    local attacker = dmg:GetAttacker()

    if not IsValid(attacker) or not attacker:IsPlayer() then return end

    self:SetHealth(self:Health() - dmg:GetDamage())

    if self:Health() > 0 then return end

    local effectdata = EffectData()
    effectdata:SetOrigin(self:GetPos())
    util.Effect("Explosion", effectdata)

    self:Remove()
end