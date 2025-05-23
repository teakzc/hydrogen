
local RpS = game:GetService("ReplicatedStorage")

local ByteNet = require(RpS.Packages.bytenet)

return ByteNet.defineNamespace("ClientFrameworkSync", function()
    return {
        ClientSync = ByteNet.definePacket({
            value = ByteNet.struct({
                ServiceInstance = ByteNet.inst
            })
        })
    }
end)
