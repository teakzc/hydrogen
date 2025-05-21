local euphoria = {}
euphoria.Services = {}

export type SERVICE_TYPE = {
    Name: string,
    Client: {[any]: any}?,
    [any] : any,
}

function euphoria:CreateService(Data: SERVICE_TYPE)
    assert(type(Data) == "table", "Where is the table bro.")
    euphoria.Services[Data.Name] = Data
    return Data
end

function euphoria:Start()
    for i, Service in euphoria.Services do
        local t = os.clock()
        
        if type(Service["Initialize"]) == "function" then
            Service["Initialize"]()
        end

        print(i.. " initialized in ".. math.round((os.clock() - t) * 10))
    end
end

return euphoria
