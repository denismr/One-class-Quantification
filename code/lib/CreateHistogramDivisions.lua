local fun = require 'vendor.fun.fun'
local Quantile = require 'lib.Quantile'
local Shuffle = require 'lib.Shuffle'


local function IsSorted(v)
  for i = 2, #v do
    if v[i] < v[i - 1] then
      return false
    end
  end
  return true
end


return function(data, inner_buckets, iterations)
  local w = math.floor(2 * #data / 3)

  iterations = iterations or 1000

  local thresholds = {}
  local quantiles = {}

  for i = 1, inner_buckets + 1 do
    local q = (i - 1) / inner_buckets
    quantiles[i] = q
    thresholds[i] = 0
  end

  for it = 1, iterations do
    Shuffle(data)
    local values = fun.take_n(w, data):totable()
    table.sort(values)
    for i = 1, inner_buckets + 1 do
      local q = (i - 1) / inner_buckets
      thresholds[i] = thresholds[i] + Quantile(values, q)
    end
  end
  for i = 1, inner_buckets + 1 do
    thresholds[i] = thresholds[i] / iterations
  end

  assert(IsSorted(thresholds))

  return thresholds, quantiles
end
