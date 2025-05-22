local RpS = game:GetService("ReplicatedStorage")

local ByteNet = require(RpS.Packages.bytenet)
local LemonSignal = require(RpS.Packages.lemonsignal)

local hydrogen = {}
hydrogen.Services = {}

export type SERVICE_TYPE = {
    Name: string,
    Server: {[any]: any}?,
    Client: {[any]: any}?,
    [any] : any,
}

function hydrogen:CreateService(Data: SERVICE_TYPE): SERVICE_TYPE
    assert(type(Data) == "table", "Where is the table bro.")
    hydrogen.Services[Data.Name] = Data
    return Data
end

function hydrogen:Start()
    table.freeze(hydrogen.Services)
    for i, Service in hydrogen.Services do
        local t = os.clock()
        
        if type(Service["Initialize"]) == "function" then
            Service["Initialize"]()
        end

        print(i.. " initialized in ".. math.round((os.clock() - t) * 10))
    end
end

function hydrogen:GetService(Name: string): SERVICE_TYPE
    return assert(hydrogen.Services[Name], Name.. "service is not registered in hydrogen's services!")
end

return hydrogen
