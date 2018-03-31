local fun = require 'vendor.fun.fun'
local BS = require 'lib.BinarySearch'

return function(divs)
  return function(data)
    local distribution = fun.xrepeat(0):take_n(#divs + 1):totable()
    fun.iter(data)
    :map(function(x) return 1 + BS(divs, x) end)
    :each(function(x) distribution[x] = distribution[x] + 1 end)
    local tot = sum(distribution)
    for i, v in ipairs(distribution) do distribution[i] = v / tot end
    return distribution
  end
end