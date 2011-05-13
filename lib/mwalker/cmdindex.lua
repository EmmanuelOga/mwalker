local mwalker = require("mwalker")
local sassert = require("sassert")

-- generate the tree database.
local function gendb(path)
  sassert(mwalker.isdirectory(path), path.." is not a directory")

  local configpath = path.."/"..".mwalker"

  local _, options
  if mwalker.isfile(configpath) then
    _, options = pcall(loadstring(io.open(configpath):read("*all")))
    sassert(_, "could not load "..configpath..", please fix or remove that configuration file")
  else
    options = loadstring(require("cmdconfig").defaultconfig)()
  end

  return mwalker.tree(path, options.blacklist, options.skipBiggerThan, options.recurLimit)
end

-- generate the db and save it to disk.
local function doindex(path)
  sassert(mwalker.isdirectory(path), path.." is not a directory")

  local time = os.clock()
  print("indexing "..path.." ...")

  local db = gendb(path)
  local dbpath = path.."/"..".mwalkerdb"
  print(db.size..' entries found, saving to '..dbpath)

  local out = sassert(io.open(dbpath, 'w'))
  out:write('return ')
  out:write(require('serialize')(db))
  out:close()

  print("indexing finished after "..os.clock() - time.. " seconds.")
end

return {
  gendb = gendb,
  doindex = doindex
}
