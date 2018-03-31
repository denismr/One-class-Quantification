return function (values, searched_value, proxy_n)
  local a = 1
  local b = proxy_n or #values
  local idx = 0

  while a <= b do
    local mid = math.floor(a / 2 + b / 2)
    if values[mid] > searched_value then
      b = mid - 1
    else
      idx = mid
      a = mid + 1
    end
  end
  return idx
end