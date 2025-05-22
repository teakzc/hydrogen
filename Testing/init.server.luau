local RpS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local hydrogen = require(RpS.hydrogen)

local Framework = hydrogen.new(script)
Framework:LoadServices()

local Test = Framework:GetService("test")

Players.PlayerAdded:Connect(function(Client)  
    while true do
        task.wait(1) 
        Test:SetPos(Client)
        task.wait(1)
        print(Test:GetStorage(Client))
    end
end)