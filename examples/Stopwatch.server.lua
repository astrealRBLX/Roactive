--[[

  Example showing how to properly utilize
  stopwatches.

]]

local Roactive = require(game.ReplicatedStorage.Roactive)

local isPlaying = Roactive.State(false)

-- Stopwatches will increment infinitely (or until the specified goal)
-- All settings are optional
local stopwatch = Roactive.Stopwatch {
  playing = isPlaying,
  increment = 0.05,
  interval = 0.05,
  goal = 1
}

-- You can also watch for a state change on the stopwatch
Roactive.Watcher(function()
  print(string.format('Stopwatch is at: %.02f', stopwatch:Get()))
end)

-- Start the stopwatch
isPlaying:Set(true)