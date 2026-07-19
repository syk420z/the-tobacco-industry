ENT.Type            = "anim"
ENT.Base            = "base_gmodentity"

ENT.PrintName       = "Shipping Box"
ENT.Category        = "Tobacco Industry"
ENT.Author          = "baccy-mod"

ENT.Spawnable       = true
ENT.AdminSpawnable  = true

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "Cigarettes")
    self:NetworkVar("Int", 1, "Cigars")
    self:NetworkVar("Bool", 3, "ShowInfo")
end