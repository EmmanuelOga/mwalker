local ssm = require('mwalker').ssmatch

context("subsquence", function()
  local function test_match(expected, string, pattern, idx)
    local returned = ssm(pattern, string, idx)
    assert_equal(expected, returned)
  end

  test("matches subsequences returning true or an index", function()
    test_match(true , "bananas"  , "")
    test_match(true , "bananas"  , "as")
    test_match(true , "bananas"  , "bas")

    test_match(1    , "bananas"  , "x")
    test_match(1    , "bananas"  , "caf")
    test_match(2    , "bananas"  , "bfa")
    test_match(1    , "fanatic"  , "bfa")

    test_match(true , "fanatic"  , "bfa", 2)
    test_match(true,  "bananasx" , "bax", 3)
    test_match(3,     "bananas"  , "bax", 3)

    test_match(true,  "bananas"  , "bax", 4)
    test_match(true,  "bananas"  , "bax", 5)
  end)
end)
