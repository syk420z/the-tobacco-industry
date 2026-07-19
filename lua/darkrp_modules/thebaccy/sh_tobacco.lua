if not DarkRP then return end

--=====================================================
-- Jobs
--=====================================================

TEAM_TOBACCO = DarkRP.createJob("Illegal Tobacco Manufacturer", {
    color = Color(120, 80, 40),
    model = "models/player/monk.mdl",
    description = [[
        Produces tobacco products.
    ]],
    weapons = {},
    command = "tobaccomanufacturer",
    max = 3,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Gangsters",
    canDemote = false,
})

--=====================================================
-- Categories
--=====================================================

DarkRP.createCategory {
    name = "Tobacco",
    categorises = "jobs",
    startExpanded = true,
    color = Color(120, 80, 40),
    sortOrder = 25,
    canSee = function(ply) 
         return table.HasValue({TEAM_TOBACCO}, ply:Team()) 
    end,
}

DarkRP.createCategory {
    name = "Tobacco",
    categorises = "entities",
    startExpanded = true,
    color = Color(120, 80, 40),
    sortOrder = 25,
    canSee = function(ply) 
         return table.HasValue({TEAM_TOBACCO}, ply:Team()) 
    end,
}

--=====================================================
-- Entities
--=====================================================

DarkRP.createEntity("Cigar Tray", {
    ent = "tobacco_cigar_tray",
    cmd = "buycigartray",
    model = "models/thebaccy/cigar_tray.mdl",
    price = 1500,
    max = 2,
    category = "Tobacco",
    allowed = TEAM_TOBACCO
})


DarkRP.createEntity("Cigarette Roller", {
    ent = "tobacco_roller",
    cmd = "buyroller",
    model = "models/thebaccy/rolling_machine.mdl",
    price = 2000,
    max = 2,
    category = "Tobacco",
    allowed = TEAM_TOBACCO
})


DarkRP.createEntity("Fresh Leaves", {
    ent = "tobacco_box_fresh",
    cmd = "buyfreshleaves",
    model = "models/thebaccy/tobacco_box_fresh.mdl",
    price = 100,
    max = 4,
    category = "Tobacco",
    allowed = TEAM_TOBACCO
})


DarkRP.createEntity("Propylene Glycol", {
    ent = "tobacco_propylene",
    cmd = "buypropylene",
    model = "models/props_junk/plasticbucket001a.mdl",
    price = 75,
    max = 4,
    category = "Tobacco",
    allowed = TEAM_TOBACCO
})


DarkRP.createEntity("Filter Tubes", {
    ent = "tobacco_filters",
    cmd = "buyfilters",
    model = "models/thebaccy/cigarette_filters.mdl",
    price = 50,
    max = 4,
    category = "Tobacco",
    allowed = TEAM_TOBACCO
})


DarkRP.createEntity("Leaf Grinder", {
    ent = "tobacco_grinder",
    cmd = "buytobaccogrinder",
    model = "models/props_wasteland/laundry_dryer002.mdl",
    price = 1750,
    max = 2,
    category = "Tobacco",
    allowed = TEAM_TOBACCO
})


DarkRP.createEntity("Tobacco Processor", {
    ent = "tobacco_processor",
    cmd = "buytobaccoprocessor",
    model = "models/props_wasteland/laundry_washer003.mdl",
    price = 1750,
    max = 2,
    category = "Tobacco",
    allowed = TEAM_TOBACCO
})


DarkRP.createEntity("Cigar Box", {
    ent = "tobacco_cigar_carton",
    cmd = "buycigarbox",
    model = "models/thebaccy/cigar_carton.mdl",
    price = 75,
    max = 8,
    category = "Tobacco",
    allowed = TEAM_TOBACCO
})


DarkRP.createEntity("Cigarette Box", {
    ent = "tobacco_cigarette_box",
    cmd = "buycigarettebox",
    model = "models/thebaccy/cigarette_packet.mdl",
    price = 50,
    max = 8,
    category = "Tobacco",
    allowed = TEAM_TOBACCO
})


DarkRP.createEntity("Shipping Box", {
    ent = "tobacco_shipping_box",
    cmd = "buyshippingbox",
    model = "models/thebaccy/shipping_box.mdl",
    price = 150,
    max = 18,
    category = "Tobacco",
    allowed = TEAM_TOBACCO
})


DarkRP.createEntity("Shipping Pallet", {
    ent = "tobacco_shipping_pallete",
    cmd = "buyshippingpallete",
    model = "models/props_junk/wood_pallet001a.mdl",
    price = 250,
    max = 2,
    category = "Tobacco",
    allowed = TEAM_TOBACCO
})