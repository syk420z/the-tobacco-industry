AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/thebaccy/clay_pot.mdl")

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    self:SetHealth(100)

    self.hasSeed = false
    self.growth = 0.1
    self.maxGrowth = 0.8

    self.water = TobaccoConfig.MaxWater
    self.maxWater = TobaccoConfig.MaxWater

    self:SetNWInt("Water", self.water)
    self:SetStatus("Empty")

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
    end

    self.plant = ents.Create("prop_dynamic")

    if IsValid(self.plant) then
        self.plant:SetModel("models/perftest/grass_tuft_004b.mdl")
        self.plant:SetColor(Color(67,148,20))
        self.plant:SetParent(self)
        self.plant:SetPos(self:LocalToWorld(Vector(0, 0, 0)))
        self.plant:SetAngles(self:GetAngles())
        self.plant:SetModelScale(self.growth, 0)
        self.plant:Spawn()
    end
end

function ENT:StartTouch(ent)
    if ent:GetClass() == "tobacco_plant_seed" and not self.hasSeed then
        self.hasSeed = true
        self.water = self.maxWater
        self:SetNWInt("Water", self.water)

        self:EmitSound("physics/wood/wood_box_impact_hard4.wav")

        self:SetStatus("Growing")

        ent:Remove()
        self:StartGrowing()
    end

    if ent:GetClass() == "tobacco_plant_water" and self.water < TobaccoConfig.MaxWater then
        self.water = math.min(self.water + TobaccoConfig.WaterPerBottle, self.maxWater)
        self:SetNWInt("Water", self.water)
        self:EmitSound("ambient/water/water_spray1.wav")

        ent:Remove()

        if self:GetStatus() == "Dry" and self.hasSeed then
            self:SetStatus("Growing")
            self:StartGrowing()
        end
    end
end

function ENT:StartGrowing()
    timer.Create("tobacco_growth_" .. self:EntIndex(), 10, 0, function()
        if not IsValid(self) then return end
        if not IsValid(self.plant) then return end

        self.water = math.max(self.water - TobaccoConfig.WaterDrainPerCycle, 0)
        self:SetNWInt("Water", self.water)

        if self.water <= 0 then
            self:SetStatus("Dry")
            return
        end

        if self.growth < self.maxGrowth then
            self.growth = math.min(self.growth + 0.05, self.maxGrowth)

            self:SetNWInt("Growth", math.floor((self.growth / self.maxGrowth) * 100))

            self.plant:SetModelScale(self.growth, 0)
        else
            self:SetStatus("Harvest")

            timer.Remove("tobacco_growth_" .. self:EntIndex())
        end
    end)
end

function ENT:Use(activator)
    if not IsValid(activator) or not activator:IsPlayer() then return end
    if self:GetStatus() ~= "Harvest" then return end
    if self.harvesting then return end

    self.harvesting = true

    self:EmitSound("player/footsteps/grass2.wav")

    timer.Create("tobacco_harvest_" .. self:EntIndex(), 1, 1, function()
        if not IsValid(self) then return end

        local leaves = ents.Create("tobacco_box_fresh")

        if IsValid(leaves) then
            leaves:SetPos(self:GetPos() + Vector(0, 0, 10))
            leaves:Spawn()
        end

        self.hasSeed = false
        self.growth = 0.1
        self.water = self.maxWater

        self:SetNWInt("Water", self.water)
        self:SetNWInt("Growth", 0)

        self:SetStatus("Empty")

        if IsValid(self.plant) then
            self.plant:SetModelScale(self.growth, 1)
        end

        self.harvesting = false
    end)
end

function ENT:OnTakeDamage(dmg)
    local attacker = dmg:GetAttacker()

    if not IsValid(attacker) or not attacker:IsPlayer() then return end

    self:SetHealth(self:Health() - dmg:GetDamage())

    if self:Health() <= 0 then
        self:Remove()
    end
end

function ENT:OnRemove()
    timer.Remove("tobacco_growth_" .. self:EntIndex())
    timer.Remove("tobacco_harvest_" .. self:EntIndex())

    if IsValid(self.plant) then
        self.plant:Remove()
    end
end
