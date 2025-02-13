local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/thehogbro-byte/math-unc/refs/heads/main/extra.lua"))();

--// Master switch (disabled at start)
ESP.Enabled = false;

--// Default settings
ESP.ShowBox = false;
ESP.BoxType = "2D";
ESP.ShowName = false;
ESP.ShowHealth = false;
ESP.ShowTracer = false;
ESP.ShowDistance = false;
ESP.TeamCheck = false;

--// Global toggle variables
_G.ESP_Master = false;
_G.ESP_Box = false;
_G.ESP_Name = false;
_G.ESP_Health = false;
_G.ESP_Tracer = false;
_G.ESP_Distance = false;
_G.ESP_TeamCheck = false;
_G.ESP_BoxType_Corner = false;
_G.ESP_BoxType_2D = true;
_G.ESP_NPC = false; -- **New: NPC ESP toggle**

--// Update function
local function UpdateESP()
    ESP.Enabled = _G.ESP_Master;
    ESP.ShowBox = _G.ESP_Box;
    ESP.ShowName = _G.ESP_Name;
    ESP.ShowHealth = _G.ESP_Health;
    ESP.ShowTracer = _G.ESP_Tracer;
    ESP.ShowDistance = _G.ESP_Distance;
    ESP.TeamCheck = _G.ESP_TeamCheck;

    if _G.ESP_BoxType_Corner then
        ESP.BoxType = "Corner Box Esp";
    elseif _G.ESP_BoxType_2D then
        ESP.BoxType = "2D";
    end
end

game:GetService("RunService").RenderStepped:Connect(UpdateESP)
