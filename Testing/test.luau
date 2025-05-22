
local RpS = game:GetService("ReplicatedStorage")

local hydrogen = require(RpS.hydrogen)

local Test = {}
local Server = Test.Server
local Client = Test.Client

export type typecast = {
    SetPos: (Client: Player) -> (),
    GetStorage: (Client: Player) -> Vector3,
    CharacterStuff: (Client: Player) -> Vector3,
}

function Server:SetPos(Client: Player)
    local Character = Client.Character
    local Pos = Character.PrimaryPart.Position
    self.Storage[Client] = Pos
end

function Server:GetStorage(Client: Player): Vector3
    return assert(self.Storage[Client], "This client does not have any position stored, ".. Client)
end

function Client:CharacterStuff(Client: Player): Vector3
    local Character = Client.Character
    return Character.PrimaryPart.Position
end

return Test
