local RpS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local hydrogen = require(RpS.hydrogen)

hydrogen:AddService(script)
hydrogen:Start()

local IDKSERVICE = hydrogen:GetService("TestService")

print("HI2")

Players.PlayerAdded:Connect(function(Client)
    while true do
        print("HI")
        task.wait(1)
        IDKSERVICE.Server:SetPos(Client)
    end
end)

