if CLIENT then return end

local function GetBuyerSavePath()

    return "thebaccy/" .. game.GetMap() .. "_buyers.json"

end



local function SaveBuyers()

    local buyers = {}


    for _, ent in ipairs(ents.FindByClass("tobacco_buyer")) do

        table.insert(buyers, {
            pos = ent:GetPos(),
            ang = ent:GetAngles()
        })

    end


    file.CreateDir("thebaccy")


    file.Write(
        GetBuyerSavePath(),
        util.TableToJSON(buyers, true)
    )

end



concommand.Add("tobacco_savebuyer", function(ply)

    if IsValid(ply) and not ply:IsAdmin() then return end


    SaveBuyers()


    if IsValid(ply) then
        if IsValid(ply) then
            DarkRP.talkToPerson(
                ply,
                Color(120,80,40),
                "Tobacco Industry: ",
                Color(255,255,255),
                "Buyers saved for "..game.GetMap()
            )
        end
    end

end)