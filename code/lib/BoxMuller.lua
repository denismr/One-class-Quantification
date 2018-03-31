return function(mu, sigma)
  mu = mu or 0
  sigma = sigma or 1
  local x1, x2, w, y1, y2

  repeat
    x1 = 2.0 * math.random() - 1.0
    x2 = 2.0 * math.random() - 1.0
    w = x1 * x1 + x2 * x2
  until w < 1

  w = math.sqrt((-2.0 * math.log(w)) / w)
  y1 = x1 * w
  y2 = x2 * w

  return y1 * sigma + mu, y2 * sigma + mu
end


