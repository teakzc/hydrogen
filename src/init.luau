--!strict

type Array<T> = { T }
type Dictionary<T> = { [string]: T }

export type hydrogen = {
	ModuleHolder: Instance,
}

export type Methods = {
	AddModules: (self: Methods & hydrogen, ModuleHolder: Instance) -> (),
	LoadModule: (self: Methods & hydrogen, Module: ModuleScript) -> (),
	LoadModules: (self: Methods & hydrogen) -> (),
}

--[=[
	@class hydrogen
]=]
local hydrogen = {} :: Methods & hydrogen

--[=[
	@prop LoadingModules Instance
	@within hydrogen
	The instance that is holding all the module scripts to be required within.
]=]

--[=[
	@param ModuleHolder Instance -- The instance that is holding all the module scripts to be required within.

	Sets up hydrogen by creating tables to store Modules.
]=]
function hydrogen:AddModules(ModuleHolder: Instance)
	self.ModuleHolder = ModuleHolder
end

--[=[
	@param Module ModuleScript -- The module script to be required

	Runs a pcall to require.
]=]
function hydrogen:LoadModule(Module: ModuleScript)
	local success, err = pcall(function()
		local _Module = require(Module) :: any
		task.spawn(function()
			if _Module["Initialize"] then
				local StartTime = os.clock()
				_Module["Initialize"]()
				print(string.format(Module.Name .. " took [%s] ms to load!", os.clock() - StartTime))
			end
		end)
	end)

	if not success then
		warn(Module.Name .. "has errored! " .. tostring(err))
	end
end

--[=[
	Requires all descendants of LoadingModules and initialize the module via :LoadModule().
]=]
function hydrogen:LoadModules()
	for _, Module in self.ModuleHolder:GetDescendants() do
		if Module:IsA("ModuleScript") then
			self:LoadModule(Module)
		end
	end

	print(
		"=================================================================================\n[FRAMEWORK SUCCESSFULLY LOADED]\n================================================================================="
	)
end

return hydrogen
