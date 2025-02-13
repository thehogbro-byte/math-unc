-- esp.lua
--// Variables
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera
local cache = {}

local bones = {
    {"Head", "UpperTorso"},
    {"UpperTorso", "RightUpperArm"},
    {"RightUpperArm", "RightLowerArm"},
    {"RightLowerArm", "RightHand"},
    {"UpperTorso", "LeftUpperArm"},
    {"LeftUpperArm", "LeftLowerArm"},
    {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "LowerTorso"},
    {"LowerTorso", "LeftUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"},
    {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"},
    {"RightUpperLeg", "RightLowerLeg"},
    {"RightLowerLeg", "RightFoot"}
}

--// Settings
local ESP_SETTINGS = {
    BoxOutlineColor = Color3.new(0, 0, 0),
    BoxColor = Color3.new(1, 1, 1),
    NameColor = Color3.new(1, 1, 1),
    HealthOutlineColor = Color3.new(0, 0, 0),
    HealthHighColor = Color3.new(0, 1, 0),
    HealthLowColor = Color3.new(1, 0, 0),
    CharSize = Vector2.new(4, 6),
    Teamcheck = false,
    WallCheck = false,
    Enabled = false,
    ShowBox = false,
    BoxType = "2D",
    ShowName = false,
    ShowHealth = false,
    ShowDistance = false,
    ShowSkeletons = false,
    ShowTracer = false,
    TracerColor = Color3.new(1, 1, 1), 
    TracerThickness = 2,
    SkeletonsColor = Color3.new(1, 1, 1),
    TracerPosition = "Bottom",
}

local function create(class, properties)
    local drawing = Drawing.new(class)
    for property, value in pairs(properties) do
        drawing[property] = value
    end
    return drawing
end

local function createEsp(target)
    local esp = {
        tracer = create("Line", {
            Thickness = ESP_SETTINGS.TracerThickness,
            Color = ESP_SETTINGS.TracerColor,
            Transparency = 0.5
        }),
        boxOutline = create("Square", {
            Color = ESP_SETTINGS.BoxOutlineColor,
            Thickness = 3,
            Filled = false
        }),
        box = create("Square", {
            Color = ESP_SETTINGS.BoxColor,
            Thickness = 1,
            Filled = false
        }),
        name = create("Text", {
            Color = ESP_SETTINGS.NameColor,
            Outline = true,
            Center = true,
            Size = 13
        }),
        healthOutline = create("Line", {
            Thickness = 3,
            Color = ESP_SETTINGS.HealthOutlineColor
        }),
        health = create("Line", {
            Thickness = 1
        }),
        distance = create("Text", {
            Color = Color3.new(1, 1, 1),
            Size = 12,
            Outline = true,
            Center = true
        }),
        boxLines = {},
        skeletonlines = {}
    }

    cache[target] = esp
end

local function removeEsp(target)
    local esp = cache[target]
    if not esp then return end

    for _, drawing in pairs(esp) do
        drawing:Remove()
    end

    cache[target] = nil
end

local function updateEsp()
    for target, esp in pairs(cache) do
        local character = target.Character or target
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        local head = character:FindFirstChild("Head")
        local humanoid = character:FindFirstChild("Humanoid")
        
        if rootPart and head and humanoid and ESP_SETTINGS.Enabled then
            local position, onScreen = camera:WorldToViewportPoint(rootPart.Position)
            if onScreen then
                local boxSize = Vector2.new(4, 6) * 10
                local boxPosition = Vector2.new(position.X - boxSize.X / 2, position.Y - boxSize.Y / 2)
                
                if ESP_SETTINGS.ShowName then
                    esp.name.Visible = true
                    esp.name.Text = target:IsA("Player") and target.Name or rootPart.Parent.Name
                    esp.name.Position = Vector2.new(boxPosition.X + boxSize.X / 2, boxPosition.Y - 16)
                else
                    esp.name.Visible = false
                end

                if ESP_SETTINGS.ShowBox then
                    esp.boxOutline.Size = boxSize
                    esp.boxOutline.Position = boxPosition
                    esp.box.Size = boxSize
                    esp.box.Position = boxPosition
                    esp.box.Visible = true
                    esp.boxOutline.Visible = true
                else
                    esp.box.Visible = false
                    esp.boxOutline.Visible = false
                end

                if ESP_SETTINGS.ShowTracer then
                    esp.tracer.Visible = true
                    esp.tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                    esp.tracer.To = Vector2.new(position.X, position.Y)
                else
                    esp.tracer.Visible = false
                end
            else
                for _, drawing in pairs(esp) do
                    drawing.Visible = false
                end
            end
        else
            for _, drawing in pairs(esp) do
                drawing.Visible = false
            end
        end
    end
end

--// Detect players
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= localPlayer then
        createEsp(player)
    end
end

Players.PlayerAdded:Connect(createEsp)
Players.PlayerRemoving:Connect(removeEsp)

--// Detect NPCs
workspace.ChildAdded:Connect(function(child)
    if _G.ESP_NPC and child:IsA("Model") and child:FindFirstChild("Humanoid") and child:FindFirstChild("HumanoidRootPart") then
        createEsp(child)
    end
end)

workspace.ChildRemoved:Connect(removeEsp)

RunService.RenderStepped:Connect(updateEsp)

return ESP_SETTINGS
