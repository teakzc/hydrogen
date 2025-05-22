local RpS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local hydrogen = require(RpS.hydrogen)

local Framework = hydrogen.new(script)
Framework:LoadServices()

local Test = Framework:GetService("Test")
