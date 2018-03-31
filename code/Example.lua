require 'vendor.fun.fun'() -- Incorporates functional programming into the global scope
require 'lib.BlockGlobal'

local BoxMuller = require 'lib.BoxMuller' -- Normal RNG
local CreateHistogramDivisions = require 'lib.CreateHistogramDivisions'
local BucketFiller = require 'lib.BucketFiller'
local BootstrapQuantile = require 'lib.BootstrapQuantile'
local Shuffle = require 'lib.Shuffle'
local Measure = require 'lib.Measure'

local ODIn = require 'lib.ODIn'
local PAT = require 'lib.PAT'
local HDy = require 'lib.HDy'

--[[
  First, we will synthesize test and training scores.
  NOTE: Negative training scores are only used for HDy.
]]

local function PositiveObservation() return (BoxMuller(1, 0.5)) end
local function NegativeObservation() return (BoxMuller(0, 0.5)) end

local positive_training = range(2000):map(PositiveObservation):totable()
local negative_training = range(2000):map(NegativeObservation):totable()

local positive_test     = range(2000):map(PositiveObservation):totable()
local negative_test     = range(2000):map(NegativeObservation):totable()

-- Now, we create the divisions for the histograms
local divs, quantiles = CreateHistogramDivisions(positive_training, 10)

print 'Histograms thresholds'
print('QUANT', 'THRESHOLD')
each(print, zip(quantiles, divs))
print()

--[[
  In the next line, we create a function that receives data and returns
  a normalized histogram based on the divisions we provide
]]
local filler = BucketFiller(divs)

-- Now we estimate the parameter for ODIn (the overflow limit)
local overflow_limit = ODIn.EstimateOverflowLimit(positive_training, filler)

-- Here, we estimate the only parameter for PAT
local conservative_quantile = 0.5
local conservative_threshold = BootstrapQuantile(positive_training, conservative_quantile)

-- Now, we create our competing models
local odin = ODIn(filler(positive_training), overflow_limit)
local pat = PAT(conservative_quantile, conservative_threshold)
local hdy = HDy(filler(positive_training), filler(negative_training))

-- Now, we will test our approaches, varying the positive ratio from 0% to 100%

local GLOBAL_MAE_ODIN = Measure()
local GLOBAL_MAE_PAT = Measure()
local GLOBAL_MAE_HDY = Measure()

local ITERATIONS_PER_STEP = 100
local STEPS = 11

for step = 1, STEPS do
  local mae_odin = Measure()
  local mae_pat = Measure()
  local mae_hdy = Measure()

  local positive_ratio = (step - 1) / (STEPS - 1)
  local positive_n = math.floor(positive_ratio * (#positive_test + #negative_test))
  local negative_n = (#positive_test + #negative_test) - positive_n

  print(string.format('%6.2f%%', positive_ratio * 100))

  for it = 1, ITERATIONS_PER_STEP do
    Shuffle(positive_test)
    Shuffle(negative_test)

    local sample_norm_hist = filler(chain(take_n(positive_n, positive_test), take_n(negative_n, negative_test)))
    local p_odin = odin(sample_norm_hist)
    local p_pat = pat(chain(take_n(positive_n, positive_test), take_n(negative_n, negative_test)))
    local p_hdy = hdy(sample_norm_hist)

    mae_odin(math.abs(positive_ratio - p_odin))
    mae_pat(math.abs(positive_ratio - p_pat))
    mae_hdy(math.abs(positive_ratio - p_hdy))

    GLOBAL_MAE_ODIN(math.abs(positive_ratio - p_odin))
    GLOBAL_MAE_PAT(math.abs(positive_ratio - p_pat))
    GLOBAL_MAE_HDY(math.abs(positive_ratio - p_hdy))
  end

  print(string.format('  ODIn %.3f (%.3f)', mae_odin()))
  print(string.format('   PAT %.3f (%.3f)', mae_pat()))
  print(string.format('   HDy %.3f (%.3f)', mae_hdy()))
end

print(string.format('ODIn %.3f (%.3f)', GLOBAL_MAE_ODIN()))
print(string.format(' PAT %.3f (%.3f)', GLOBAL_MAE_PAT()))
print(string.format(' HDy %.3f (%.3f)', GLOBAL_MAE_HDY()))