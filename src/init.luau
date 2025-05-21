local RS = game:GetService("RunService")

if RS:IsServer() then
    return require(script.hydrogenserver)
else
    return require(script.hydrogenclient)
end