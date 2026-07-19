AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_wasteland/laundry_washer003.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    self:SetHealth(100)

    self:SetNWInt('time', TobaccoConfig.ProcessingTime)

    self:SetLeaves(0)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
    end
end

function ENT:StartTouch(ent)
    if not IsValid(ent) then return end
    if ent:GetClass() == "tobacco_box_fresh" and self:GetLeaves() < TobaccoConfig.MaxLeaves then
        self:SetLeaves(self:GetLeaves() + TobaccoConfig.LeavesPerBox)
        self:EmitSound("physics/wood/wood_box_impact_hard4.wav")
        ent:Remove()
    elseif ent:GetClass() == "tobacco_propylene" and self:GetPropylene() < TobaccoConfig.MaxPropylene then
        self:SetPropylene(self:GetPropylene() + TobaccoConfig.PropylenePerJug)
        self:EmitSound("ambient/water_splash1.wav")
        ent:Remove()
    end

    if self:GetLeaves() == TobaccoConfig.MaxLeaves and
       self:GetPropylene() == TobaccoConfig.MaxPropylene and
       not self:GetNWBool("isProcessing") then
        self:StartProcessing()
    end
end

function ENT:FinishProcessing()
    timer.Remove("tobacco_processor_"..self:EntIndex())
    self:SetNWBool('isProcessing', false)

    self:SetLeaves(0)
    self:SetPropylene(0)

    self:SetBatch(TobaccoConfig.TobaccoOutputPerProcess)
    self:SetNWInt('time', TobaccoConfig.ProcessingTime)
    self:StopSound("ambient/machines/deep_boil.wav")
    self:EmitSound("buttons/button15.wav")
end

function ENT:StartProcessing()
    if self:GetNWBool('isProcessing') == true then return end
    self:SetNWBool('isProcessing', true)

    self:EmitSound("ambient/machines/deep_boil.wav", 60, 100, 1, CHAN_AUTO)
    self:EmitSound("buttons/button9.wav")

    timer.Create("tobacco_processor_"..self:EntIndex(), 1, 0, function()
        if not IsValid(self) or self:GetNWBool('isProcessing') == false then return end
        self:SetNWInt('time', self:GetNWInt('time') - 1)
        if self:GetNWInt('time') <= 0 then
            self:FinishProcessing()
        end
    end)
end

function ENT:Use(act, call)
    local curTime = CurTime()
    if not self.nextUse or curTime >= self.nextUse then
        if self:GetNWBool('isProcessing') == false and self:GetLeaves() == 0 and self:GetPropylene() == 0 and self:GetBatch() ~= 0 then
            local curedLeaves = ents.Create("tobacco_box_cured")
            curedLeaves:SetPos(self:GetPos() + Vector(0, 0, 40))
            curedLeaves:SetBatch(self:GetBatch())
            curedLeaves:Spawn()

            self:SetBatch(0)

            self.nextUse = curTime + 1
        end
    end
end

function ENT:OnRemove()
    self:StopSound('ambient/machines/deep_boil.wav')
    timer.Remove("tobacco_processor_"..self:EntIndex())
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