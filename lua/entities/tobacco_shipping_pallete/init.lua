AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

    self:SetModel("models/props_junk/wood_pallet001a.mdl")

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    self:SetHealth(100)

    self.Boxes = {}
    self.SnapPoints = nil
    self.nextUse = 0

    self:SetCigarettes(0)
    self:SetCigars(0)
    self:SetSellAmount(0)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
    end

end


function ENT:GenerateSnapPoints(ent)

    local boxSize = ent:OBBMaxs() - ent:OBBMins()

    self.SnapPoints = {}

    local height = self:OBBMaxs().z - ent:OBBMins().z - 1

    for x = -1, 1 do
        for y = -1, 1 do
            table.insert(
                self.SnapPoints,
                Vector(
                    x * boxSize.x,
                    y * boxSize.y,
                    height
                )
            )
        end
    end

end


function ENT:UpdateValue()

    local value =
        (self:GetCigarettes() * TobaccoConfig.PricePerCigarette)
        +
        (self:GetCigars() * TobaccoConfig.PricePerCigar)

    self:SetSellAmount(value)

end


function ENT:StartTouch(ent)

    if not IsValid(ent) then return end

    if ent:GetClass() ~= "tobacco_shipping_box" then return end

    if ent:GetCigarettes() <= 0 and ent:GetCigars() <= 0 then
        return
    end

    if not self.SnapPoints then
        self:GenerateSnapPoints(ent)
    end

    if #self.Boxes >= #self.SnapPoints then
        return
    end

    local index = #self.Boxes + 1

    ent:SetPos(self:LocalToWorld(self.SnapPoints[index]))
    ent:SetAngles(self:GetAngles())
    ent:SetParent(self)

    local phys = ent:GetPhysicsObject()
    if IsValid(phys) then
        phys:EnableMotion(false)
        phys:Sleep()
    end

    table.insert(self.Boxes, ent)

    if ent.SetShowInfo then
        ent:SetShowInfo(false)
    end

    self:SetCigarettes(
        self:GetCigarettes() + ent:GetCigarettes()
    )

    self:SetCigars(
        self:GetCigars() + ent:GetCigars()
    )

    self:UpdateValue()

end


function ENT:Use(ply)

    if not IsValid(ply) then return end

    if self.nextUse > CurTime() then return end

    self.nextUse = CurTime() + 0.5

    local box = table.remove(self.Boxes)

    if not IsValid(box) then return end

    if box.SetShowInfo then
        box:SetShowInfo(true)
    end

    self:SetCigarettes(
        math.max(self:GetCigarettes() - box:GetCigarettes(), 0)
    )

    self:SetCigars(
        math.max(self:GetCigars() - box:GetCigars(), 0)
    )

    self:UpdateValue()

    box:SetParent(nil)

    box:SetPos(
        self:LocalToWorld(Vector(0, 60, 20))
    )

    local phys = box:GetPhysicsObject()
    if IsValid(phys) then
        phys:EnableMotion(true)
        phys:Wake()
    end

end


function ENT:ClearShipment()

    for _, box in ipairs(self.Boxes) do
        if IsValid(box) then
            box:Remove()
        end
    end

    self.Boxes = {}

    self:SetCigarettes(0)
    self:SetCigars(0)
    self:SetSellAmount(0)

end


function ENT:OnTakeDamage(dmg)

    self:SetHealth(self:Health() - dmg:GetDamage())

    if self:Health() > 0 then return end

    self:ClearShipment()
    self:Remove()

end


function ENT:OnRemove()

    self:ClearShipment()

end