if CLIENT then return end

local function GetBuyerSavePath()
    return "thebaccy/" .. game.GetMap() .. "_buyers.json"
end


hook.Add("InitPostEntity", "TobaccoLoadBuyers", function()

    local path = GetBuyerSavePath()

    if not file.Exists(path, "DATA") then
        print("[Tobacco] No buyer save found for " .. game.GetMap())
        return
    end


    local data = util.JSONToTable(file.Read(path, "DATA"))

    if not data then return end


    for _, buyerData in ipairs(data) do

        local buyer = ents.Create("tobacco_buyer")

        if IsValid(buyer) then

            buyer:SetPos(Vector(
                buyerData.pos.x,
                buyerData.pos.y,
                buyerData.pos.z
            ))

            buyer:SetAngles(Angle(
                buyerData.ang.p,
                buyerData.ang.y,
                buyerData.ang.r
            ))

            buyer:Spawn()

        end

    end


    print("[Tobacco] Loaded " .. #data .. " buyers")

end)