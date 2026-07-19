if CLIENT then return end

local savePath = "thebaccy/" .. game.GetMap() .. "_buyers.json"

concommand.Add("tobacco_removebuyers", function(ply)

    if IsValid(ply) and not ply:IsAdmin() then return end

    local count = 0

    for _, ent in ipairs(ents.FindByClass("tobacco_buyer")) do
        ent:Remove()
        count = count + 1
    end


    if file.Exists(savePath, "DATA") then
        file.Delete(savePath)
    end


    if IsValid(ply) then
        DarkRP.talkToPerson(
            ply,
            Color(120,80,40),
            "Tobacco Industry: ",
            Color(255,255,255),
            "Removed all buyer data."
        )
    end

end)

concommand.Add("tobacco_spawncured", function(ply)

    if IsValid(ply) and not ply:IsAdmin() then return end

    local ent = ents.Create("tobacco_box_cured")

    if IsValid(ent) then
        ent:SetPos(ply:GetEyeTrace().HitPos + Vector(0,0,10))
        ent:SetBatch(TobaccoConfig.TobaccoOutputPerProcess)
        ent:Spawn()
    end

end)

concommand.Add("tobacco_spawnground", function(ply)

    if IsValid(ply) and not ply:IsAdmin() then return end

    local ent = ents.Create("tobacco_ground")

    if IsValid(ent) then
        ent:SetPos(ply:GetEyeTrace().HitPos + Vector(0,0,10))
        ent:SetBatch(TobaccoConfig.TobaccoOutputPerProcess)
        ent:Spawn()
    end

end)

concommand.Add("tobacco_spawncigarettes", function(ply)

    if IsValid(ply) and not ply:IsAdmin() then return end

    local ent = ents.Create("tobacco_cigarette_box")

    if IsValid(ent) then
        ent:SetPos(ply:GetEyeTrace().HitPos + Vector(0,0,10))
        ent:Spawn()
        ent:SetAmount(TobaccoConfig.CigaretteBoxMax)
    end

end)

concommand.Add("tobacco_spawncigars", function(ply)

    if IsValid(ply) and not ply:IsAdmin() then return end

    local ent = ents.Create("tobacco_cigar_carton")

    if IsValid(ent) then
        ent:SetPos(ply:GetEyeTrace().HitPos + Vector(0,0,10))
        ent:Spawn()
        ent:SetAmount(TobaccoConfig.CigarCartonMax)
    end

end)

concommand.Add("tobacco_reloadconfig", function(ply)

        if IsValid(ply) and not ply:IsAdmin() then return end

        local path = "tobacco/tobacco_config.lua"

        if not file.Exists(path, "LUA") then
            if IsValid(ply) then
                ply:ChatPrint("Tobacco config file not found.")
            end
            return
        end

        include(path)

        if IsValid(ply) then
            DarkRP.talkToPerson(
                ply,
                Color(120,80,40),
                "Tobacco Industry: ",
                Color(255,255,255),
                "Config reloaded."
            )
        end

        print("[Tobacco] Config reloaded.")
end)