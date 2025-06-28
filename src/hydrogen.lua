
local hydrogen = {}
hydrogen.__index = hydrogen

type Array<T> = {T}
type Dictionary = {[string]: any}

export type self = {
	LoadingServices: Instance,
	Services: Dictionary,
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

	for _, Service in self.LoadingServices:GetChildren() do
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
	
	for _, Service in self.Services do
		if Service["Initialize"] then
			task.spawn(function()
				Service["Initialize"]()
			end)
		end
	end
end

function hydrogen:HasLoaded()
	repeat
		task.wait()
	until self.Loaded == true
end

function hydrogen:GetServices(): Array<string>
	self:HasLoaded()
	return self.ServicesList
end

function hydrogen:GetService(Service: string)
	local LoadedService = self.Services[Service]
	self:HasLoaded()

	assert(LoadedService, Service .." is not registered!")
	return LoadedService
end

return hydrogen
