--[[

  This example demonstrates how state
  changes can be delayed.

]]

local Roactive = require(game.ReplicatedStorage.Roactive)

local isAnchored = Roactive.State(true)
local isAnchoredDelayed =  Roactive.Delay(isAnchored, 2) -- Delay state changes by 2 seconds

local part = Instance.new('Part')
part.Position = Vector3.new(0, 15, 0)

-- Watch for changes on the delayed state object
Roactive.Watcher(function()
  part.Anchored = isAnchoredDelayed:Get()
end)

part.Parent = workspace

-- Update the original state object. The original
-- is instantly updated but the delayed one
-- is updated after 2 seconds.
isAnchored:Set(false)