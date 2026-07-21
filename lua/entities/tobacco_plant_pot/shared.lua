ENT.Type            = "anim"
ENT.Base            = "base_gmodentity"

ENT.PrintName       = "Clay Pot"
ENT.Category        = "Tobacco Industry"
ENT.Author          = "baccy-mod"

ENT.Spawnable       = true
ENT.AdminSpawnable  = true

function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "Status")
end