local fun = require 'vendor.fun.fun'
local Shuffle = require 'lib.Shuffle'

-- How much of A outsides B, at scale factor s
local function Overflow(A, B, s)
  local tot_pdif = 0
  for i = 1, #A do
    tot_pdif = tot_pdif + math.max(0, s * A[i] - B[i])
  end
  return tot_pdif
end

local function BestFit(A, B, overflow_limit, eps)
  local left = 0
  local right = 1
  while math.abs(right - left) > eps do
    local middle = (left + right) / 2
    local check = Overflow(A, B, middle)
    if check <= middle * overflow_limit then
      left = middle
    else
      right = middle
    end
  end
  return (left + right) / 2
end

local function FindP(A, B, overflow_limit)
  local p = BestFit(A, B, overflow_limit, 1e-5)
  return p - Overflow(A, B, p)
end

local function EstimateOverflowLimit(positive_data, filler, iterations)
  local w = math.floor(#positive_data / 3)
  iterations = iterations or 100

  local sum = 0
  local sum2 = 0

  for it = 1, iterations do
    Shuffle(positive_data)
    local dist_out = filler(fun.take_n(w, positive_data))
    local dist_in = filler(fun.drop_n(w, positive_data))
    local v = Overflow(dist_in, dist_out, 1)
    sum = sum + v
    sum2 = sum2 + v ^ 2
  end

  local mu = sum / iterations
  local sd = math.sqrt((sum2 / iterations) - mu ^ 2)
  return mu + 3 * sd
end

local meta = {}

function meta:__call(test_norm_hist)
  return FindP(self.training_norm_hist, test_norm_hist, self.overflow_limit)
end

return setmetatable({
  EstimateOverflowLimit = EstimateOverflowLimit,
}, {
  __call = function(_, training_norm_hist, overflow_limit)
    return setmetatable({
      training_norm_hist = training_norm_hist,
      overflow_limit = overflow_limit
    }, meta)
  end
})