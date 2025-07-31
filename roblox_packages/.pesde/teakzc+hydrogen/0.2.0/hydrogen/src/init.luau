type Array<T> = { T }
type Dictionary<T> = { [string]: T }

--[=[
	@type hydrogen {LoadingServices: Instance, Services: Dictionary<any>, ServicesList: Array<string>, Loaded: boolean}
	@within hydrogen
]=]
export type hydrogen = {
	LoadingServices: Instance,
	Services: Dictionary<any>,
	ServicesList: Array<string>,
	Loaded: boolean,
}

export type Methods = {
	AddServices: (self: hydrogen, Holder: Instance) -> (),
	LoadService: (self: hydrogen, Service: ModuleScript) -> (),
	LoadServices: (self: hydrogen) -> (),
	HasLoaded: (self: hydrogen) -> (),
	GetService: (self: hydrogen, Service: string) -> any,
}

--[=[
	@class hydrogen
]=]
local hydrogen = {} :: Methods

--[=[
	@prop LoadingServices Instance
	@within hydrogen
	The instance that is holding all the module scripts to be required within.
]=]
--[=[
	@prop Loaded boolean
	@within hydrogen
	Loaded will be true when :LoadServices() has completed.
]=]
--[=[
	@prop Services {[string]: any}
	@within hydrogen
	Table containing the required modules.
]=]
--[=[
	@prop ServicesList {string}
	@within hydrogen
	Array of the names of all the services.
]=]

--[=[
	@param Services Instance -- The instance that is holding all the module scripts to be required within.

	Sets up hydrogen by creating tables to store services and additional details and the start time in os.clock()
]=]
function hydrogen:AddServices(Services: Instance)
	self.LoadingServices = Services
	self.Loaded = false
	self.Services = {}
	self.ServicesList = {}
end

--[=[
	@param Service ModuleScript -- The module script to be required

	Runs a pcall to require.
]=]
function hydrogen:LoadService(Service: ModuleScript)
	local success, err = pcall(function()
		local _Service = require(Service)

		self.Services[Service.Name] = _Service
		table.insert(self.ServicesList, Service.Name)
	end)

	if not success then
		warn(Service.Name .. "has errored! " .. tostring(err))
	end
end

--[=[
	Requires all children of LoadingServices and initialize the module, followed with a print taking how long it takes to finish initializing then freezing Services.
]=]
function hydrogen:LoadServices()
	if self.Loaded then
		return
	end

	for _, Service in self.LoadingServices:GetChildren() do
		if Service:IsA("ModuleScript") then
			self:LoadService(Service)
		end
	end

	for _, Service in self.Services do
		task.spawn(function()
			if Service["Initialize"] then
				local StartTime = os.clock
				Service["Initialize"]()
				print(string.format(Service.Name .. " took [%s] ms to load!", os.clock() - StartTime))
			end
		end)
	end

	print(
		"=================================================================================\n[FRAMEWORK SUCCESSFULLY LOADED]\n================================================================================="
	)

	table.freeze(self.Services)
	self.Loaded = true
end

--[=[
	@yields
	Yields via task.wait() until self.Loaded == true.
]=]
function hydrogen:HasLoaded()
	repeat
		task.wait()
	until self.Loaded == true
end

--[=[
	@return Array<string>
	Returns a array of the services that have been required.
]=]
function hydrogen:GetServices(): Array<string>
	self:HasLoaded()
	return self.ServicesList
end

--[=[
	@yields
	@param Service string -- The name of the module script to be feteched
	:HasLoaded() is ran to ensure other module dependencies are loaded, warns if self.Services[Service] does not exist.
]=]
function hydrogen:GetService(Service: string): any
	local LoadedService = self.Services[Service]
	self:HasLoaded()

	assert(LoadedService, Service .. " is not registered!")
	return LoadedService
end

return hydrogen
