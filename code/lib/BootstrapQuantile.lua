local fun = require 'vendor.fun.fun'
local Quantile = require 'lib.Quantile'
local Shuffle = require 'lib.Shuffle'

return function(values, q, iterations)
  local w = math.floor(2 * #values / 3)

  iterations = iterations or 1000

  local thr = 0

  for it = 1, iterations do
    Shuffle(values)
    local values = fun.take_n(w, values):totable()
    table.sort(values)
    thr = thr + Quantile(values, q)
  end

  return thr / iterations
end