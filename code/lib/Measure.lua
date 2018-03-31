local index = {}
local mt = {__index = index}

function index:Increment(val)
  self.c = self.c + 1
  self.mu = self.mu + val
  self.m2 = self.m2 + val ^ 2
end

function index:Mean()
  return self.mu / self.c
end

function index:Sd()
  local mean = self.mu / self.c
  return math.sqrt(math.max(0, (self.m2 / self.c) - mean ^ 2))
end

function mt:__call(val)
  if val then
    self.c = self.c + 1
    self.mu = self.mu + val
    self.m2 = self.m2 + val ^ 2
  else
    local mean = self.mu / self.c
    local sd = math.sqrt(math.max(0, (self.m2 / self.c) - mean ^ 2))
    return mean, sd
  end
end

return function()
  return setmetatable({
    c = 0,
    mu = 0,
    m2 = 0, 
  }, mt)
end