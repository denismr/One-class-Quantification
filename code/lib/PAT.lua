
local fun = require 'vendor.fun.fun'

local meta = {}

local function Const1() return 1 end

function meta:__call(...)
  local tot = fun.sum(fun.map(Const1, ...))
  return math.min(1, (fun.sum(fun.map(Const1, fun.filter(self.filter, ...))) / tot) / (1 - self.quantile))
end

return function(quantile, threshold)
  return setmetatable({
    filter = function(x) return x >= threshold end,
    quantile = quantile,
  }, meta)
end
