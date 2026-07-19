ENT.Type            = "anim"
ENT.Base            = "base_gmodentity"

ENT.PrintName       = "Processor"
ENT.Category        = "Tobacco Industry"
ENT.Author          = "baccy-mod"

ENT.Spawnable       = true
ENT.AdminSpawnable  = true

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "Leaves")
    self:NetworkVar("Int", 1, "Propylene")
    self:NetworkVar("Int", 2, "Batch")
end