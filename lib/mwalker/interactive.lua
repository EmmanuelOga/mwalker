if not mwalker.isdirectory(path) then
  print(path.." is not a directory.")
  os.exit()
end

local dbpath = path .. "/.mwalkerdb"
if not mwalker.isfile(dbpath) then
  print("Could not find a configuration file in: "..dbpath..". Please run mwalkerdb -h for help.")
  os.exit()
end

local result, db = pcall(loadstring(io.open(dbpath):read("*all")))
assert(result, "\n\nERROR: could not load "..dbpath..".\nRun mwalkerdb -h for help.\n")

print("Loaded db, "..db.size.." entries.")

local input = require 'input'
local walker = require 'walker'

for ssq in input() do
  os.execute("clear")
  local results = walker(db, ssq)
  print(#results.." results for ["..ssq.."]")
  for i, val in ipairs(results) do
    print(val); if i > 40 then break end
  end
end
