local filter = require('../util/filtertable')

local function assert_table_len(tab, num)
  local count = 0
  for _ in pairs(tab) do count = count + 1 end
  assert_equal(num, count)
end

local function assert_table_elems(tab, tab2)
  local result = true
  for i, v in ipairs(tab2) do if v ~= tab[i] then result = false; break end end
  assert_true(result)
end

context("filtering tables in place", function()
  test("filters at the start", function()
    tab = filter({1,2,3,4}, function(val) return val == 1 end)
    assert_table_len(tab, 3)
    assert_table_elems(tab, {2,3,4})

    tab = filter({1,2,3,4}, function(val) return val == 1 or val == 2 end)
    assert_table_len(tab, 2)
    assert_table_elems(tab, {3,4})
  end)

  test("filters at the end", function()
    tab = filter({1,2,3,4}, function(val) return val == 4 end)
    assert_table_len(tab, 3)
    assert_table_elems(tab, {1,2,3})

    tab = filter({1,2,3,4}, function(val) return val == 3 or val == 4 end)
    assert_table_len(tab, 2)
    assert_table_elems(tab, {1,2})
  end)

  test("filters at the middle", function()
    tab = filter({1,2,3,4}, function(val) return val == 3 end)
    assert_table_len(tab, 3)
    assert_table_elems(tab, {1,2,4})

    tab = filter({1,2,3,4}, function(val) return val == 2 or val == 3 end)
    assert_table_len(tab, 2)
    assert_table_elems(tab, {1,4})
  end)

  test("filters non/completely", function()
    tab = filter({1,2,3,4}, function(val) return true end)
    assert_table_len(tab, 0)
    assert_table_elems(tab, {})

    tab = filter({1,2,3,4}, function(val) return false end)
    assert_table_len(tab, 4)
    assert_table_elems(tab, {1,2,3,4})
  end)
end)
