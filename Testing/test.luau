
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
        self.Storage[Client] = Pos
    end
end

function ModuleServer:GetStorage(Client: Player): Vector3
    if self.Storage[Client] ~= nil then
        return self.Storage[Client]
    else
        return Vector3.zero
    end
end

function ModuleClient:CharacterStuff(Client: Player): Vector3
    return self.Storage[Client]
end

function Test:Initialize()
    print("Wow im initialized!")
end

return Test
