function mcl_curry(fn)
	return function(x)
		return function(...)
			return fn(x, ...)
		end
	end
end
