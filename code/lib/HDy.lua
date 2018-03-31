local function TernarySearch(left, right, f, eps)
  repeat
    if math.abs(left - right) < eps then return (left + right) / 2 end

    local leftThird = left + (right - left) / 3
    local rightThird = right - (right - left) / 3

    if f(leftThird) > f(rightThird) then
      left = leftThird
    else
      right = rightThird
    end
  until nil
end

local function HD(pos_hist, neg_hist, pos, target_hist)
  local sum = 0
  for i = 1, #target_hist do
    sum = sum + (math.sqrt(pos_hist[i] * pos + neg_hist[i] * (1 - pos)) - math.sqrt(target_hist[i])) ^ 2
  end
  return math.sqrt(sum)
end

local function HDy(pos_hist, neg_hist, target_hist)
  local function f(x)
    return HD(pos_hist, neg_hist, x, target_hist)
  end
  return TernarySearch(0, 1, f, 1e-5)
end

local meta = {}

function meta:__call(target_hist)
  return HDy(self.pos_hist, self.neg_hist, target_hist)
end

return function(pos_hist, neg_hist)
  return setmetatable({
    pos_hist = pos_hist,
    neg_hist = neg_hist,
  }, meta)
end
