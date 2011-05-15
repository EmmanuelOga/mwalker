local ssm = require('mwalker').ssmatch
local isslash = require('helpers').isslash
local strfind = string.find

-- given a db (a table representing the files tree structure) filter the
-- entries matching the subsequence.
-- mode can be "f" (files), "d" (directories) or "a" (any).
local function walker(db, mode, ssq)
  local results = {}

  local retdirs = mode == "d" or mode == "a"
  local retfiles = mode == "f" or mode == "a"

  local function ssqsearch(tree, match)
    if retdirs and match == -1 then results[#results + 1] = {tree.name, tree.base} end

    if retfiles then
      for _, name in ipairs(tree.files) do
        if match == -1 or ssm(ssq, name, match) == -1 then
          results[#results + 1] = {name, tree.base.."/"..name}
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

  table.sort(results, function(ta, tb)
    local a, b = ta[1], tb[1]

    local fa = strfind(a, ssq, 1, true)
    local fb = strfind(b, ssq, 1, true)

    if fa and not fb then return true
    elseif fb and not fa then return false
    elseif fa and fb then return fa < fb
    else
      a, b = ta[2], tb[2]
      if #a == #b then return a < b else return #a < #b end
    end
  end)

  for k, v in ipairs(results) do results[k] = v[2] end -- get rid of scores.

  return results
end

return walker
