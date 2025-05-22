local RpS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LPlayer = Players.LocalPlayer

local hydrogen = require(RpS.hydrogen)
local Test = hydrogen:GetService("test")

print("Greetings")
while task.wait(1) do
    print(Test:CharacterStuff(LPlayer))
end
