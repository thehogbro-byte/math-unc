local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/linemaster2/esp-library/main/library.lua"))();

--// Master switch (disabled at start)
ESP.Enabled = false;

--// Default settings (everything disabled, 2D box type by default)
ESP.ShowBox = false;
ESP.BoxType = "2D"; -- Default Box Type
ESP.ShowName = false;
ESP.ShowHealth = false;
ESP.ShowTracer = false;
ESP.ShowDistance = false;
ESP.TeamCheck = false; -- Prevents ESP from showing teammates

--// Global toggle variables (default false)
_G.ESP_Master = true;
_G.ESP_Box = false;
_G.ESP_Name = false;
_G.ESP_Health = false;
_G.ESP_Tracer = false;
_G.ESP_Distance = false;
_G.ESP_TeamCheck = false; -- Team Check toggle (directly controlled via _G)
_G.ESP_BoxType_Corner = false; -- Switch to Corner Box
_G.ESP_BoxType_2D = true; -- Default: 2D Box

--// Function to update ESP settings based on _G variables
local function UpdateESP()
    ESP.Enabled = _G.ESP_Master;
    ESP.ShowBox = _G.ESP_Box;
    ESP.ShowName = _G.ESP_Name;
    ESP.ShowHealth = _G.ESP_Health;
    ESP.ShowTracer = _G.ESP_Tracer;
    ESP.ShowDistance = _G.ESP_Distance;
    ESP.TeamCheck = _G.ESP_TeamCheck; -- Update TeamCheck based on _G toggle

    -- Change Box Type based on _G toggles
    if _G.ESP_BoxType_Corner then
        ESP.BoxType = "Corner Box Esp";
    elseif _G.ESP_BoxType_2D then
        ESP.BoxType = "2D";
    end
end

--// Continuously check for updates
game:GetService("RunService").RenderStepped:Connect(UpdateESP);

-- Now you can control TeamCheck directly via _G.ESP_TeamCheck:
-- Example usage:
-- _G.ESP_TeamCheck = true  -- This will hide teammates from the ESP
-- _G.ESP_TeamCheck = false -- This will allow teammates to be shown in ESP
