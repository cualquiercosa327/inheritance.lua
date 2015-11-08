##inheritance.lua
---

#### Improved by notanimposter
based on http://lua-users.org/wiki/InheritanceTutorial

---

##### Do this bit at the top:
```lua
class = require "inheritance"
```
##### Now you have a few different ways you can make a class:

- you can call 'class' with a table containing the static members:

    ```lua
    local Thing = class {
    	create = function(self, v)
    		self.value = 16
            --does not need to return anything
    	end,
    	doSomething = function(self)
    		return "boop "..tostring(self.class)
    	end
    }
    ```

- or with a function that defines the static members. In this context, you can use `This` to refer to the class. Note that you need ()s if you want to pass a function:

    ```lua
    local Thing = class(function()
    	--use 'This' to refer to the class in this context
    	function This:create()
    		self.value = 16
    	end
    	function This:doSomething()
    		return "boop "..tostring(self.class)
    	end
    end)
    ```

##### When you want to extend a class, you also have a few options:
- you can use the + operator:

    ```lua
    local NewThing = Thing + {
    }
    ```

- which is really just shorthand for:

  ```lua
  local NewThing = Thing:extend {
  }
  ```

- you can also use functions instead of tables in those scenarios, but you get the idea.

##### To make a new instance, just do:
```lua
local nt = NewThing(args)
```
Don't call `Thing:create()`. `Thing()` maps to a wrapper function that calls `Thing:create()` for you so you don't need to return `self` at the end of all your `create()` functions.
##### Every class/instance has these:
  - `nt.class`: the class object of the instance `nt`
  - `nt.super`: the parent class object
  - `nt < Thing` or `Thing > nt` tests whether `nt` inherits from `Thing`, which is just shorthand for `nt:isa(Thing)`
