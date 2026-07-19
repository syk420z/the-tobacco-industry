ENT.Type            = "anim"
ENT.Base            = "base_gmodentity"

ENT.PrintName       = "Cigarette Filters"
ENT.Category        = "Tobacco Industry"
ENT.Author          = "baccy-mod"

ENT.Spawnable       = true
ENT.AdminSpawnable  = true

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "Amount")
end