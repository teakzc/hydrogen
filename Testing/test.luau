
local RpS = game:GetService("ReplicatedStorage")

local hydrogen = require(RpS.hydrogen)

local Test = {
    Server = {
        Storage = {}
    },
    Client = {},
}

local ModuleServer = Test.Server
local ModuleClient = Test.Client

function ModuleServer:SetPos(Client: Player)
    local Character = Client.Character
    if Character ~= nil then
        local Pos = Character.PrimaryPart.Position
        print(self)
        self.Storage[Client] = Pos
    end
end

function ModuleServer:GetStorage(Client: Player): Vector3
    return assert(self.Storage[Client], "This client does not have any position stored, ".. Client.Name)
end

function ModuleClient:CharacterStuff(Client: Player): Vector3
    local Character = Client.Character
    return Character.PrimaryPart.Position
end

function Test:Initialize()
    print("Wow im initialized!")
end

return Test
