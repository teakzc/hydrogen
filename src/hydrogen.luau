local hydrogen = {}
hydrogen.__index = hydrogen

export type FRAMEWORK_TYPE = {
    Modules: Instance,
    StartTime: number,
    Loaded: boolean
}

function hydrogen.new(Modules: Instance): FRAMEWORK_TYPE
	local self = setmetatable({}, hydrogen)
	self.Modules = Modules :: Instance
	self.StartTime = os.clock() :: number
    self.Loaded = false :: boolean
	return self
end

function hydrogen:LoadModule(Module: ModuleScript)
	local StartTime = os.clock()

	local success, err = pcall(function()
		require(Module)
	end)

	if success then
		local LoadTime = math.round((os.clock() - StartTime) * 10)
		print(
            string.format(
                Module.Name.." took [%s] ms to load!",
                LoadTime
            )
        )
	else
		warn(Module.Name .. "has errored! " .. tostring(err))
	end
end

function hydrogen:LoadModules()
	for _, Module in self.Modules:GetDescendants() do
		if Module:IsA("ModuleScript") then
            task.spawn(function()
                self:LoadModule(Module)
            end)
        end
	end

    local LoadTime = math.round((os.clock() - self.StartTime) * 10)
    print(
        string.format(
            "Framework took [%s] ms to load!",
            LoadTime
        )
    )

    self.Loaded = true
end

function hydrogen:HasLoaded(): boolean
	repeat
		task.wait()
	until self.Loaded == true
end

return hydrogen
