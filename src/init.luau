local RS = game:GetService("RunService")

if RS:IsServer() then
    return require(script.euphoriaserver)
else
    return require(script.euphoriaclient)
end