-- esp.lua
--// Variables
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera
local cache = {}

-- Trident Survival may use different body parts, so update this accordingly
local function getValidBodyParts(character)
    local parts = {}
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            table.insert(parts, part)
        end
    end
    return parts
end

--// Settings
local ESP_SETTINGS = {
    BoxOutlineColor = Color3.new(0, 0, 0),
    BoxColor = Color3.new(1, 1, 1),
    NameColor = Color3.new(1, 1, 1),
    HealthOutlineColor = Color3.new(0, 0, 0),
    HealthHighColor = Color3.new(0, 1, 0),
    HealthLowColor = Color3.new(1, 0, 0),
    Teamcheck = false,
    WallCheck = false,
    Enabled = false,
    ShowBox = false,
    ShowName = false,
    ShowHealth = false,
    ShowDistance = false,
    ShowTracer = false,
    TracerColor = Color3.new(1, 1, 1),
    TracerThickness = 2,
    TracerPosition = "Bottom",
}

local function create(class, properties)
    local drawing = Drawing.new(class)
    for property, value in pairs(properties) do
        drawing[property] = value
    end
    return drawing
end

local function createEsp(player)
    local esp = {
        tracer = create("Line", {
            Thickness = ESP_SETTINGS.TracerThickness,
            Color = ESP_SETTINGS.TracerColor,
            Transparency = 0.5
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
        distance = create("Text", {
            Color = Color3.new(1, 1, 1),
            Size = 12,
            Outline = true,
            Center = true
        })
    }

    cache[player] = esp
end

local function isPlayerBehindWall(player)
    local character = player.Character
    if not character then
        return false
    end

    local bodyParts = getValidBodyParts(character)
    if #bodyParts == 0 then
        return false
    end

    local ray = Ray.new(camera.CFrame.Position, (bodyParts[1].Position - camera.CFrame.Position).Unit * (bodyParts[1].Position - camera.CFrame.Position).Magnitude)
    local hit, position = workspace:FindPartOnRayWithIgnoreList(ray, {localPlayer.Character, character})

    return hit and hit:IsA("BasePart")
end

local function removeEsp(player)
    local esp = cache[player]
    if not esp then return end

    for _, drawing in pairs(esp) do
        drawing:Remove()
    end

    cache[player] = nil
end

local function updateEsp()
    for player, esp in pairs(cache) do
        local character = player.Character
        if character then
            local bodyParts = getValidBodyParts(character)
            local isBehindWall = ESP_SETTINGS.WallCheck and isPlayerBehindWall(player)
            local shouldShow = not isBehindWall and ESP_SETTINGS.Enabled

            if #bodyParts > 0 and shouldShow then
                local rootPart = bodyParts[1] -- Use first found body part as a reference point
                local position, onScreen = camera:WorldToViewportPoint(rootPart.Position)

                if onScreen then
                    if ESP_SETTINGS.ShowName then
                        esp.name.Visible = true
                        esp.name.Text = player.Name
                        esp.name.Position = Vector2.new(position.X, position.Y - 16)
                    else
                        esp.name.Visible = false
                    end

                    if ESP_SETTINGS.ShowDistance then
                        local distance = (camera.CFrame.Position - rootPart.Position).Magnitude
                        esp.distance.Text = string.format("%.1f studs", distance)
                        esp.distance.Position = Vector2.new(position.X, position.Y + 10)
                        esp.distance.Visible = true
                    else
                        esp.distance.Visible = false
                    end

                    if ESP_SETTINGS.ShowTracer then
                        local tracerY = ESP_SETTINGS.TracerPosition == "Top" and 0 or
                            (ESP_SETTINGS.TracerPosition == "Middle" and camera.ViewportSize.Y / 2 or camera.ViewportSize.Y)

                        esp.tracer.Visible = true
                        esp.tracer.From = Vector2.new(camera.ViewportSize.X / 2, tracerY)
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
        else
            for _, drawing in pairs(esp) do
                drawing.Visible = false
            end
        end
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= localPlayer then
        createEsp(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= localPlayer then
        createEsp(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    removeEsp(player)
end)

RunService.RenderStepped:Connect(updateEsp)
return ESP_SETTINGS
