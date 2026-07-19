AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("TobaccoBuyerChat")

local BuyerVoicesSold = {
    "vo/npc/male01/answer10.wav",
    "vo/npc/male01/finally.wav",
    "vo/npc/male01/question16.wav",
    "vo/npc/male01/question30.wav",
    "vo/npc/male01/vquestion01.wav",
    "vo/npc/male01/vquestion04.wav",
}

local BuyerVoicesNotSold = {
    "vo/npc/male01/waitingsomebody.wav",
    "vo/npc/male01/notthemanithought02.wav",
    "vo/npc/male01/doingsomething.wav",
    "vo/npc/male01/busy02.wav",
    "vo/npc/male01/answer15.wav",
    "vo/npc/male01/answer28.wav",
    "vo/npc/male01/answer16.wav",
    "vo/npc/male01/answer02.wav",
}

function ENT:PlayBuyerVoice(tbl)

    if CurTime() < self.NextVoiceTime then return end

    local sound = table.Random(tbl)

    self:EmitSound(
        sound,
        75,
        100,
        1
    )

    local sndDuration = SoundDuration(sound)

    self.NextVoiceTime = CurTime() + math.max(sndDuration, 2)

end


function ENT:Initialize()

    self:SetModel(TobaccoConfig.BuyerModel)

    self:SetHullType(HULL_HUMAN)
    self:SetHullSizeNormal()
    self:SetNPCState(NPC_STATE_SCRIPT)
    self:SetSolid(SOLID_BBOX)
    self:SetUseType(SIMPLE_USE)
    self:SetBloodColor(BLOOD_COLOR_RED)

    self:CapabilitiesAdd(CAP_ANIMATEDFACE)
    self:CapabilitiesAdd(CAP_TURN_HEAD)

    self:DropToFloor()
    self:SetSchedule(SCHED_IDLE_STAND)

    self.NextVoiceTime = 0

end



function ENT:Use(ply)

    if not IsValid(ply) then return end


    local foundEntities = ents.FindInSphere(self:GetPos(), 300)

    local shipments = {}



    for _, ent in ipairs(foundEntities) do

        if not IsValid(ent) then continue end


        -- Ignore boxes stored inside pallets
        if IsValid(ent:GetParent()) then
            continue
        end


        if ent:GetClass() == "tobacco_shipping_pallete"
        or ent:GetClass() == "tobacco_shipping_box" then


            local cigarettes = ent:GetCigarettes() or 0
            local cigars = ent:GetCigars() or 0


            if cigarettes > 0 or cigars > 0 then
                table.insert(shipments, ent)
            end

        end

    end



    if #shipments <= 0 then

        DarkRP.talkToPerson(
            ply,
            Color(120,80,40),
            "Tobacco Buyer: ",
            Color(255,255,255),
            "Bring me a filled shipping box or pallet first."
        )

        self:PlayBuyerVoice(BuyerVoicesNotSold)

        return

    end



    local totalValue = 0



    for _, shipment in ipairs(shipments) do

        if IsValid(shipment) then


            if shipment.GetSellAmount then

                totalValue = totalValue + shipment:GetSellAmount()

            else

                totalValue = totalValue
                    + ((shipment:GetCigarettes() or 0) * TobaccoConfig.PricePerCigarette)
                    + ((shipment:GetCigars() or 0) * TobaccoConfig.PricePerCigar)

            end



            -- Remove boxes inside pallets
            if shipment.Boxes then

                for _, box in ipairs(shipment.Boxes) do

                    if IsValid(box) then
                        box:Remove()
                    end

                end

            end


            shipment:Remove()

        end

    end



    ply:addMoney(totalValue)

    self:PlayBuyerVoice(BuyerVoicesSold)

    net.Start("TobaccoBuyerChat")

        net.WriteString("Sold tobacco shipment for ")
        net.WriteString(DarkRP.formatMoney(totalValue))

    net.Send(ply)

end



function ENT:PhysgunPickup(ply)

    if ply:IsAdmin() then
        return true
    end

    return false

end