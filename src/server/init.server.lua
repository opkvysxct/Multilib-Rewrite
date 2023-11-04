local ReplicatedStorage = game:GetService("ReplicatedStorage")
_G.M_Loader = require(ReplicatedStorage.Multilib)
_G.M_Loader:Init(true)

_G.M_Instance:Create("Part",workspace,{Size = Vector3.new(1,1,1)})