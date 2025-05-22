
local RpS = game:GetService("ReplicatedStorage")

local hydrogen = require(RpS.hydrogen)

local Server = {}
local Client = {}

function Server:SetPos(Client: Player)
    local Character = Client.Character
    local Pos = Character.PrimaryPart.Position
    self.Storage[Client] = Pos
end

function Server:GetStorage(Client: Player): Vector3
    return assert(self.Storage[Client], "This client does not have any position stored, ".. Client)
end

function Client:CharacterStuff(Client: Player)
    local Character = Client.Character
    return Character.PrimaryPart.Position
end

local TestService: hydrogen.SERVICE_TYPE = {
    Name = "TestService",
    Server = Server,
    Client = Client,
    Shared = {}
}

return hydrogen:CreateService(TestService)
