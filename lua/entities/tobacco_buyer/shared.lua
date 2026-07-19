ENT.Type = "ai"
ENT.Base = "base_ai"

ENT.PrintName = "Tobacco Buyer"
ENT.Category = "Tobacco Industry"

ENT.Spawnable = true
ENT.AdminOnly = false
ENT.AutomaticFrameAdvance = true

function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end