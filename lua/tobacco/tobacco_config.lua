TobaccoConfig = TobaccoConfig or {}

TobaccoConfig.DrawDistance = 256

-- ======================================
-- Raw Materials
-- ======================================

TobaccoConfig.MaxLeaves = 50
TobaccoConfig.MaxPropylene = 25

TobaccoConfig.LeavesPerBox = 25
TobaccoConfig.PropylenePerJug = 5

-- ======================================
-- Farming
-- ======================================

TobaccoConfig.WaterPerBottle = 10
TobaccoConfig.MaxWater = 100

TobaccoConfig.WaterDrainPerCycle = math.random(5, 8)

-- ======================================
-- Processing
-- ======================================

TobaccoConfig.TobaccoOutputPerProcess = 50

TobaccoConfig.ProcessingTime = 90
TobaccoConfig.GrindTime = 60


-- ======================================
-- Cigarette Production
-- ======================================

TobaccoConfig.FiltersPerBox = 50
TobaccoConfig.FiltersPerCigarette = 1

TobaccoConfig.CigaretteBoxMax = 20

TobaccoConfig.RollingMachineTobaccoPerCigarette =
    math.floor((TobaccoConfig.MaxLeaves + TobaccoConfig.MaxPropylene) / TobaccoConfig.CigaretteBoxMax)


TobaccoConfig.RollingMachineMaxFilters = 25
TobaccoConfig.RollingMachineMaxTobacco = 50

TobaccoConfig.CigaretteProductionTime = 3


-- ======================================
-- Cigar Production
-- ======================================

TobaccoConfig.CigarCartonMax = 5

TobaccoConfig.CigarTrayLeavesPerCigar =
    math.floor(TobaccoConfig.MaxLeaves / TobaccoConfig.CigarCartonMax)
    
TobaccoConfig.MaxLeaves = 50

TobaccoConfig.CigarTrayMaxLeaves = 50
TobaccoConfig.CigarProductionTime = 6


-- ======================================
-- Packaging / Storage
-- ======================================

TobaccoConfig.ShippingBoxCigaretteMax = 40
TobaccoConfig.ShippingBoxCigarMax = 20


-- ======================================
-- Economy
-- ======================================

TobaccoConfig.PricePerCigarette = 20
TobaccoConfig.PricePerCigar = 40


-- ======================================
-- NPC / Buyer
-- ======================================

TobaccoConfig.BuyerModel = "models/Humans/Group03/male_08.mdl"