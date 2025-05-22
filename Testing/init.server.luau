local RpS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local hydrogen = require(RpS.hydrogen)

hydrogen:AddServices(script)
hydrogen:LoadServices()

local Test = hydrogen:GetService("test")

Players.PlayerAdded:Connect(function(Client)  
    while true do
        task.wait(1) 
        Test:SetPos(Client)
    end
end)