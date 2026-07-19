if SERVER then return end

local function RoundedPanel(panel, color)

    panel.Paint = function(self, w, h)

        draw.RoundedBox(
            8,
            0,
            0,
            w,
            h,
            color
        )

    end

end


local function AddLabel(parent, text, font, color, margin)

    local label = vgui.Create("DLabel", parent)

    label:SetText(text)
    label:SetFont(font)
    label:SetTextColor(color)

    label:Dock(TOP)
    label:DockMargin(0, margin or 5, 0, 5)

    label:SizeToContents()

end


local function AddButton(parent, text, command)

    local button = vgui.Create("DButton", parent)

    button:SetText(text)
    button:SetFont("DermaDefault")
    button:SetTall(32)

    button:SetTextColor(Color(240,240,240))

    button:Dock(TOP)
    button:DockMargin(0,2,0,2)


    button.Paint = function(self,w,h)

        local col

        if self:IsHovered() then
            col = Color(160,110,60)
        else
            col = Color(90,60,30)
        end


        draw.RoundedBox(
            6,
            0,
            0,
            w,
            h,
            col
        )

    end


    button.DoClick = function()

        RunConsoleCommand(command)

    end


    return button

end



hook.Add("PopulateToolMenu", "TobaccoPopulateMenu", function()


    spawnmenu.AddToolMenuOption(
        "Utilities",
        "The Tobacco Industry",
        "TobaccoSettings",
        "Settings",
        "",
        "",
        function(panel)


            panel:ClearControls()


            local background = vgui.Create("DPanel")

            background:SetTall(500)

            RoundedPanel(
                background,
                Color(20,20,20,255)
            )

            panel:AddItem(background)



            local contents = vgui.Create(
                "DPanel",
                background
            )

            contents:Dock(FILL)
            contents:DockMargin(10,10,10,10)

            contents.Paint = function() end



            AddLabel(
                contents,
                "The Tobacco Industry",
                "DermaLarge",
                Color(180,120,60),
                0
            )


            AddLabel(
                contents,
                "Version 1.0 | Administration Tools",
                "DermaDefault",
                Color(170,170,170),
                0
            )



            AddLabel(
                contents,
                "Buyer Management",
                "DermaDefaultBold",
                Color(255,255,255),
                15
            )


            AddButton(
                contents,
                "Save Buyer Position",
                "tobacco_savebuyer"
            )


            AddButton(
                contents,
                "Remove All Buyers",
                "tobacco_removebuyers"
            )



            AddLabel(
                contents,
                "Production Tools",
                "DermaDefaultBold",
                Color(255,255,255),
                15
            )


            AddButton(
                contents,
                "Spawn Cured Tobacco Leaves",
                "tobacco_spawncured"
            )


            AddButton(
                contents,
                "Spawn Ground Tobacco",
                "tobacco_spawnground"
            )


            AddButton(
                contents,
                "Spawn Cigar Box",
                "tobacco_spawncigars"
            )


            AddButton(
                contents,
                "Spawn Cigarette Box",
                "tobacco_spawncigarettes"
            )



            AddLabel(
                contents,
                "Configuration",
                "DermaDefaultBold",
                Color(255,255,255),
                15
            )


            AddButton(
                contents,
                "Reload Tobacco Config",
                "tobacco_reloadconfig"
            )


        end
    )


end)