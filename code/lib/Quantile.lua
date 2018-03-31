return function(values, q)
  local right_w = math.fmod(q * #values, 1)
  local left_w = 1 - right_w
  local left = math.max(1, math.floor(q * #values))
  local right = math.min(#values, left + 1)
  return left_w * values[left] + right_w * values[right]
end