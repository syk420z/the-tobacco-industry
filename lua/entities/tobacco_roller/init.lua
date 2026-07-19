AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


function ENT:Initialize()

    self:SetModel("models/thebaccy/rolling_machine.mdl")

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    self:SetHealth(100)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
    end

    self.Rolling = false

    self:SetNWInt("tobacco", 0)
    self:SetNWInt("filters", 0)

    self:SetNWInt("time", TobaccoConfig.CigaretteProductionTime)
    self:SetNWBool("rolling", false)

end


function ENT:CanRoll()

    return self:GetNWInt("tobacco") >= TobaccoConfig.RollingMachineTobaccoPerCigarette
        and self:GetNWInt("filters") >= TobaccoConfig.FiltersPerCigarette

end



function ENT:GetOutputBox()

    local outputPos =
        self:GetPos()
        + self:GetForward() * 30
        + Vector(0,0,5)


    local entsFound = ents.FindInSphere(outputPos, 20)


    for _, ent in ipairs(entsFound) do

        if ent:GetClass() == "tobacco_cigarette_box" then

            if ent:GetAmount() < TobaccoConfig.CigaretteBoxMax then
                return ent
            end

        end

    end


    return nil

end



function ENT:StartTouch(ent)

    if not IsValid(ent) then return end


    if ent:GetClass() == "tobacco_ground" then

        local current = self:GetNWInt("tobacco")


        if current >= TobaccoConfig.RollingMachineMaxTobacco then
            return
        end


        local amount = math.min(
            ent:GetBatch(),
            TobaccoConfig.RollingMachineMaxTobacco - current
        )


        if amount <= 0 then
            return
        end


        self:SetNWInt(
            "tobacco",
            current + amount
        )


        ent:SetBatch(
            ent:GetBatch() - amount
        )


        if ent:GetBatch() <= 0 then
            ent:Remove()
        end


    elseif ent:GetClass() == "tobacco_filters" then


        local current = self:GetNWInt("filters")


        if current >= TobaccoConfig.RollingMachineMaxFilters then
            return
        end


        local amount = math.min(
            ent:GetAmount(),
            TobaccoConfig.RollingMachineMaxFilters - current
        )


        self:SetNWInt(
            "filters",
            current + amount
        )


        ent:SetAmount(
            ent:GetAmount() - amount
        )


        if ent:GetAmount() <= 0 then
            ent:Remove()
        end


    end



    if self:CanRoll() then
        self:StartRolling()
    end

end




function ENT:StartRolling()

    if self.Rolling then return end
    if not self:CanRoll() then return end


    self.Rolling = true

    self:SetNWBool("rolling", true)

    self:SetNWInt(
        "time",
        TobaccoConfig.CigaretteProductionTime
    )



    local timerName = "RollingMachine_" .. self:EntIndex()



    timer.Create(timerName, 1, 0, function()


        if not IsValid(self) then

            timer.Remove(timerName)
            return

        end



        local timeLeft =
            self:GetNWInt("time") - 1



        self:SetNWInt(
            "time",
            math.max(timeLeft, 0)
        )



        if timeLeft > 0 then
            return
        end




        local tobaccoLeft =
            self:GetNWInt("tobacco")
            - TobaccoConfig.RollingMachineTobaccoPerCigarette


        local filtersLeft =
            self:GetNWInt("filters")
            - TobaccoConfig.FiltersPerCigarette



        self:SetNWInt(
            "tobacco",
            math.max(tobaccoLeft, 0)
        )


        self:SetNWInt(
            "filters",
            math.max(filtersLeft, 0)
        )




        local box = self:GetOutputBox()



        if IsValid(box) then

            box:SetAmount(
                box:GetAmount() + 1
            )


        else


            local cigarette = ents.Create("tobacco_cigarette")


            if IsValid(cigarette) then

                cigarette:SetPos(
                    self:GetPos()
                    + self:GetForward() * 20
                    + Vector(0,0,5)
                )


                cigarette:SetAngles(
                    self:GetAngles()
                )


                cigarette:Spawn()

            end

        end




        self:EmitSound(
            "buttons/lever1.wav",
            70,
            100
        )




        if self:CanRoll() then

            self:SetNWInt(
                "time",
                TobaccoConfig.CigaretteProductionTime
            )

            return

        end




        if self:GetNWInt("tobacco")
            < TobaccoConfig.RollingMachineTobaccoPerCigarette then


            self:SetNWInt(
                "tobacco",
                0
            )

        end



        self.Rolling = false

        self:SetNWBool(
            "rolling",
            false
        )


        timer.Remove(timerName)


    end)

end




function ENT:OnRemove()

    timer.Remove(
        "RollingMachine_" .. self:EntIndex()
    )

end




function ENT:OnTakeDamage(dmg)

    local attacker = dmg:GetAttacker()


    if not IsValid(attacker)
    or not attacker:IsPlayer() then
        return
    end



    self:SetHealth(
        self:Health() - dmg:GetDamage()
    )



    if self:Health() > 0 then
        return
    end



    local effectData = EffectData()

    effectData:SetOrigin(
        self:GetPos()
    )


    util.Effect(
        "Explosion",
        effectData
    )


    self:Remove()

end