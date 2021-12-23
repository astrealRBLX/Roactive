# Roactive

Welcome to Roactive, a lightweight and fast reactive state library made specifically for use in Roblox. The creation of this library was inspired by Vue.js and Fusion.

Code snippets show casing various Roactive features can be found in the [examples](/examples) directory.

## Understanding Reactivity

Roactive state is *reactive*. What this means is it can have dependents that actively listen for state changes. When a state occurs all dependents will be signaled to update accordingly.

### State

Creating Roactive state is really simple.

```lua
local myState = Roactive.State('Hello world!')
```

You can also easily get and set the state's value.

```lua
print(myState:Get()) --> Outputs: 'Hello world!'
myState:Set('World hello!')
print(myState:Get()) --> Outputs: 'World hello!'
```

It's worth mentioning that Roactive state supports tuples.

```lua
local myState = Roactive.State(1, 2, 3)
```

On its own state isn't very useful. State must be used as a dependency for it to have actual use. Roactive introduces various classes to help with this.

### Watchers

Watchers are inspired by Vue.js watchers and are extremely useful. A Watcher accepts a function called a target function. The target will capture all stateful dependencies within it and will recalled whenever those dependencies update.

```lua
Roactive.Watcher(function()
  print(myState:Get())
end)
```

Now `myState` is a dependency of this Watcher and this function will be called whenever `myState` changes.

### Delay

Sometimes you want to hold a reference to your state that is delayed and doesn't instantly update. That's where delay comes in. It is both a dependent and dependency and essentially wraps a state object. It accepts a state object and a constant number that acts as the delay duration.

```lua
local myState = Roactive.State(true)
local myStateDelayed = Roactive.Delay(myState, 3)
```

You can update your state just like usual.

```lua
myState:Set(false)

print(myState:Get()) --> Outputs: false
print(myStateDelayed:Get()) --> Outputs: true
```

The delayed object outputs `true` because 3 seconds haven't yet passed and therefore its state hasn't updated to `false`.

### Stopwatch

Stopwatches are sort of like a loop. They will repeatedly increment a position forever or until they reach a goal. They only have one argument, a settings table. They can be both a dependent and dependency.

```lua
{
  interval: number?,        -- Position increments every x seconds (default 1)
  increment: number?,       -- Increment amount (default 1)
  startPosition: number?,   -- Start position (default 0)
  goal: number?,            -- Goal position (default nil)
  playing: any?,            -- Is playing (default true)
}
```

The `playing` settings accepts either a constant or a stateful object.

```lua
local isPlaying = Roactive.State(true)
local stopwatch = Roactive.Stopwatch {
  goal = 5,
  playing = isPlaying
}
```

In order to listen to changes you can just use a Watcher.

```lua
Roactive.Watcher(function()
  print(stopwatch:Get())
end)
```

The Watcher's target function will be called every time the Stopwatch updates just like any other object.