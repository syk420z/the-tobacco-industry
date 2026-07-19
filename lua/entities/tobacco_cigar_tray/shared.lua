ENT.Type            = "anim"
ENT.Base            = "base_gmodentity"

ENT.PrintName       = "Cigar Tray"
ENT.Category        = "Tobacco Industry"
ENT.Author          = "baccy-mod"

ENT.Spawnable       = true
ENT.AdminSpawnable  = true

function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "ProductionStart")
end

if SERVER then
    AddCSLuaFile()
end

resource.AddFile("sound/thebaccy/cigar_tray_rolling.wav")