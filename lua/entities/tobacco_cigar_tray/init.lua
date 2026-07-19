AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")


function ENT:Initialize()

    self:SetModel("models/thebaccy/cigar_tray.mdl")

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    self:SetHealth(100)


    local phys = self:GetPhysicsObject()

    if IsValid(phys) then
        phys:Wake()
    end


    self.Rolling = false


    self:SetNWInt("leaves", 0)

    self:SetNWInt(
        "time",
        TobaccoConfig.CigarProductionTime
    )

    self:SetNWBool(
        "rolling",
        false
    )

end



function ENT:CanRoll()

    return self:GetNWInt("leaves") >= TobaccoConfig.CigarTrayLeavesPerCigar

end



function ENT:StartTouch(ent)

    if not IsValid(ent) then return end



    if ent:GetClass() == "tobacco_box_cured" then


        local current = self:GetNWInt("leaves")


        if current >= TobaccoConfig.CigarTrayMaxLeaves then
            return
        end



        local amount = math.min(
            ent:GetBatch(),
            TobaccoConfig.CigarTrayMaxLeaves - current
        )


        if amount <= 0 then
            return
        end



        self:SetNWInt(
            "leaves",
            current + amount
        )


        ent:SetBatch(
            ent:GetBatch() - amount
        )


        if ent:GetBatch() <= 0 then
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


    self:SetNWBool(
        "rolling",
        true
    )


    self:SetNWInt(
        "time",
        TobaccoConfig.CigarProductionTime
    )



    local timerName = "CigarTray_" .. self:EntIndex()



    timer.Create(timerName, 1, 0, function()


        if not IsValid(self) then

            timer.Remove(timerName)

            return

        end



        local time = self:GetNWInt("time") - 1


        self:SetNWInt(
            "time",
            math.max(time, 0)
        )



        if time > 0 then return end



        self:SetNWInt(
            "leaves",
            math.max(
                self:GetNWInt("leaves") - TobaccoConfig.CigarTrayLeavesPerCigar,
                0
            )
        )



        local cigar = ents.Create("tobacco_cigar")


        if IsValid(cigar) then

            cigar:SetPos(
                self:GetPos()
                + self:GetForward() * 25
                + Vector(0,0,10)
            )


            cigar:SetAngles(
                self:GetAngles()
            )


            cigar:Spawn()

        end



        self:EmitSound(
            "ambient/materials/ripped_screen01.wav",
            70,
            100
        )



        if self:CanRoll() then

            self:SetNWInt(
                "time",
                TobaccoConfig.CigarProductionTime
            )

            return

        end



        self.Rolling = false


        self:SetNWBool(
            "rolling",
            false
        )


        self:SetNWInt(
            "time",
            TobaccoConfig.CigarProductionTime
        )


        timer.Remove(timerName)


    end)

end



function ENT:OnRemove()

    timer.Remove(
        "CigarTray_" .. self:EntIndex()
    )

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