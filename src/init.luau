
local RS = game:GetService("RunService")

local hydrogen = {}
hydrogen.__index = hydrogen

type Array<T> = {T}
type Dictionary = {[string]: any}

export type self = {
    LoadingServices: Instance,
    Services: Dictionary, --how do i make it type check a array of required modules like {require(this), require(that)}
    ServicesList: Array<string>,
    StartTime: number,
    Loaded: boolean
}

export type hydrogen = typeof(setmetatable({} :: self, hydrogen))

function hydrogen:AddServices(Services: Instance)
	self.LoadingServices = Services
	self.StartTime = os.clock()
    self.Loaded = false
    self.Services = {}
    self.ServicesList = {}
end

function hydrogen:LoadService(Service: ModuleScript)
	local StartTime = os.clock()

	local success, err = pcall(function()
		local _Service = require(Service)
        if _Service["Initialize"] then
            _Service["Initialize"]()
        end

        self.Services[Service.Name] = _Service
        table.insert(self.ServicesList, Service.Name)
	end)

	if success then
		local LoadTime = math.round((os.clock() - StartTime) * 10)
		print(
            string.format(
                Service.Name.." took [%s] ms to load!",
                LoadTime
            )
        )
	else
		warn(Service.Name .. "has errored! " .. tostring(err))
	end
end

function hydrogen:LoadServices()
    if self.Loaded then return end

	for _, Service in self.LoadingServices:GetDescendants() do
		if Service:IsA("ModuleScript") then
            self:LoadService(Service)
        end
	end

    local LoadTime = math.round((os.clock() - self.StartTime) * 10)
    print(
        string.format(
            "Framework took [%s] ms to load!",
            LoadTime
        )
    )


    table.freeze(self.Services)
    self.Loaded = true
end

function hydrogen:HasLoaded()
    if RS:IsClient() then
        
    else
        repeat
		    task.wait()
	    until self.Loaded == true
    end
end

function hydrogen:GetServices(): Array<string>
    self:HasLoaded()
    return self.ServicesList
end

function hydrogen:GetService(Service: string)
    self:HasLoaded()
    local LoadedService = self.Services[Service]
    assert(LoadedService, Service .." is not registered!")
    if RS:IsServer() then
        return LoadedService.Server
    else
        return LoadedService.Client
    end
end

return hydrogen
