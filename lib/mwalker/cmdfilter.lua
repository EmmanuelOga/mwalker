local gendb = require('cmdindex').gendb
local sassert = require('sassert')
local ssm = require('mwalker').ssmatch

local function filterstdin(pattern)
  for line in io.lines() do
    if #line > 0 and ssm(pattern, line, 1) == -1 then print(line) end
  end
end

local function filtertree(path, mode, limit, pattern)
  sassert(mwalker.isdirectory(path), path.." is not a directory")

  local dbpath, db = path.."/.mwalkerdb", nil

  if mwalker.isfile(dbpath) then
    local result
    result, db = pcall(loadstring(io.open(dbpath):read("*all")))
    sassert(result, "\n\nERROR: could not load "..dbpath..".\nRun mwalkerdb -h for help.\n")
  else
    db = gendb(path)
  end

  local input = require 'input'
  local walker = require 'walker'

  local results = walker(db, mode, pattern)
  for i, val in ipairs(results) do
    print(val); if limit ~= 0 and i > limit then break end
  end
end

local function dofilter(path, mode, limit, pattern)
  if path == "-" then
    filterstdin(pattern)
  else
    filtertree(path, mode, limit, pattern)
  end
end

return {
  dofilter = dofilter
}
