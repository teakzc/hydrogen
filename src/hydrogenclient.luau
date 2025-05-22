local RpS = game:GetService("ReplicatedStorage")

local ByteNet = require(RpS.Packages.bytenet)
local LemonSignal = require(RpS.Packages.lemonsignal)

local hydrogenserver = require(script.Parent.hydrogenserver)

local hydrogen = {}

function hydrogen:GetService(Name)
    return hydrogenserver.Services[Name].Client
end

return hydrogen
