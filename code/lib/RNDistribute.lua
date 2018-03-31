local function Dist(Q, n)
  local w = {}
  local sum = 0
  for i = 1, n do
    w[i] = math.random()
    sum = sum + w[i]
  end
  local SUM = 0
  for i, v in ipairs(w) do
    w[i] = math.floor(Q * v / sum)
    SUM = SUM + w[i]
  end
  while SUM < Q do
    local idx = math.random(n)
    w[idx] = w[idx] + 1
    SUM = SUM + 1
  end
  return w
end

return Dist