local ssm = require('mwalker').ssmatch
local isslash = require('helpers').isslash

-- given a db (a table representing the files tree structure) filter the
-- entries matching the subsequence.
-- mode can be "f" (files), "d" (directories) or "a" (any).
local function walker(db, mode, ssq)
  local results = {}

  local retdirs = mode == "d" or mode == "a"
  local retfiles = mode == "f" or mode == "a"

  local function ssqsearch(tree, match)
    if retdirs and match == -1 then results[#results + 1] = tree.base end

    if retfiles then
      for _, name in ipairs(tree.files) do
        if match == -1 or ssm(ssq, name, match) == -1 then
          results[#results + 1] = tree.base.."/"..name
        end
      end
    end

    for _, subtree in ipairs(tree.dirs) do
      if match == -1 then
        ssqsearch(subtree, -1)
      else
        local nm = ssm(ssq, subtree.name, match) --+ ((isslash(ssq, match) and 1) or 0))
        ssqsearch(subtree, nm + ((isslash(ssq, nm) and 1) or 0))
      end
    end
  end

  ssqsearch(db, 1)

  table.sort(results, function(a, b)
    if #a == #b then
      return a < b
    else
      return #a < #b
    end
  end)

  return results
end

return walker
