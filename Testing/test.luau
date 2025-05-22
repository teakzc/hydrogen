
local RpS = game:GetService("ReplicatedStorage")

local hydrogen = require(RpS.hydrogen)

local Test = {
    Server = {},
    Client = {}
}

local ModuleServer = Test.Server
local ModuleClient = Test.Client

function ModuleServer:SetPos(Client: Player)
    local Character = Client.Character
    local Pos = Character.PrimaryPart.Position
    self.Storage[Client] = Pos
end

function ModuleServer:GetStorage(Client: Player): Vector3
    return assert(self.Storage[Client], "This client does not have any position stored, ".. Client.Name)
end

function ModuleClient:CharacterStuff(Client: Player): Vector3
    local Character = Client.Character
    return Character.PrimaryPart.Position
end

return Test
