--[[

  This example is a mock version of Fusion by Elttob.
  Fusion was one of the inspirations for this project. The main
  difference between Fusion and Roactive is that Fusion markets
  itself as a UI framework whereas Roactive is general-purpose
  and significantly smaller.

  This example creates a new part using a mock version of Fusion's
  `New` function and demonstrates Roactive state, delay, watchers,
  and stopwatches.

]]

local Roactive = require(game.ReplicatedStorage.Roactive)
local isStateful = require(game.ReplicatedStorage.Roactive.Util.isStateful)

local function New(instanceType: string)
  return function(props: { [string]: any })
    local instance = Instance.new(instanceType)
    local cleanup = {}

    for key, value in pairs(props) do
      -- isStateful() returns if an object contains some sort of Roactive state
      if isStateful(value) then
        -- Watch for state changes and update its property
        table.insert(cleanup, Roactive.Watcher(function()
          instance[key] = value:Get()
        end))
      
      -- Allow function keys for functionality similar to Fusion's Computed()
      elseif typeof(value) == 'function' then
        table.insert(cleanup, Roactive.Watcher(function()
          instance[key] = value()
        end))

      -- Constant values
      else
        instance[key] = value
      end
    end

    instance.AncestryChanged:Connect(function()
      if not instance:IsDescendantOf(game) then
        for _, value in pairs(cleanup :: { Roactive.Watcher }) do
          value:Destroy()
        end
      end
    end)

    return instance
  end
end

local isPlaying = Roactive.State(false)
local color = Roactive.State(Color3.new(0.5, 0.5, 0.5))

local RNG = Random.new()

local stopwatch = Roactive.Stopwatch {
  playing = Roactive.Delay(isPlaying, 3), -- Delay playing state changes by 3 seconds
  increment = 0.05,
  interval = 0.01,
}

New 'Part' {
  Position = function()
    -- Randomize color
    color:Set(Color3.new(RNG:NextNumber(), RNG:NextNumber(), RNG:NextNumber()))

    -- Map the stopwatch's position into a Vector3
    return Vector3.new(stopwatch:Get(), 5, 0)
  end,
  Color = color,
  Size = Vector3.new(1, 1, 1),
  Anchored = true,
  Parent = workspace
}

isPlaying:Set(true) -- Start playing the stopwatch