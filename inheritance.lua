--inheritance.lua
--logan dean

function inheritsFrom (baseClass)

	local new_class = {}
	local class_mt = { __index = new_class }
	
	function new_class.extend(garbage, classDef)
		local class = inheritsFrom(new_class)
		if type(classDef) == "table" then
			for k,v in pairs(classDef) do
				class[k] = v
			end
		elseif type(classDef) == "function" then
			local origMT = getmetatable(_G)
			_G.This = class
			setmetatable(_G, {
				__index = function(t,k)
					if k == "This" then
						return class
					end
					return rawget(t, k)
				end
			})
			classDef(class)
		end
		setmetatable(_G, origMT)
		return class
	end
	
	function new_class:wrapCreate(...)
		local newInst = {}
		setmetatable( newInst, class_mt )
		new_class.create(newInst, ...)
		return newInst
	end
	function new_class:create()
		--to be overridden
	end
		setmetatable( new_class, {
			__call = new_class.wrapCreate,
			__index = baseClass,
			__add = function(_,...) return new_class:extend(...) end,
			__lt = function(a,b) return a:isa(b) end
		})

	-- Implementation of additional OO properties starts here --

	-- Return the class object of the instance
	
	new_class.class = new_class
	
	new_class.super = baseClass
	
	-- Return true if the caller is an instance of theClass
	function new_class:isa( theClass )
		local b_isa = false

		local cur_class = new_class

		while ( nil ~= cur_class ) and ( false == b_isa ) do
			if cur_class == theClass then
				b_isa = true
			else
				cur_class = cur_class.super
			end
		end

		return b_isa
	end

	return new_class
end
return function(classDef)
	return inheritsFrom(nil):extend(classDef)
end
