local mwalker = require("mwalker")
local sassert = require("sassert")

local defaultconfig = [[
local defaultbl = require 'blacklist'

return {
  recurLimit = 16,       -- do not recurse deeper than this number of directories.
  skipBiggerThan = 1024, -- do not keep file entries if the directory has more than this number of children.
  blacklist = defaultbl, -- blacklist some paths (repository bookeeping, temporal files, etc...).

  -- You can write your own path/file blacklist like this:
  -- blacklist = function(path, name, ext)
  --   if ilike(path) or ilike(name) or (ext and ilike(ext)) then -- You'll have to write the ilike function :-).
  --     return false
  --   else
  --     return defaultbl(path, name, ext)
  --   end
  -- end,
}
]]

local mwalker = require('mwalker')

-- Writes a default configuration file to the given path.
local function doconfig(path)
  local configpath = path.."/"..".mwalker"

  sassert(mwalker.isdirectory(path), "invalid directory")
  sassert(not mwalker.isfile(configpath), "error generating default configuration: "..configpath.." already exists.")

  local out = sassert(io.open(configpath, 'w'), "cannot write "..configpath)
  out:write(defaultconfig)
  out:close()

  print("default configuration written to: "..configpath)
end

return {
  doconfig = doconfig,
  defaultconfig = defaultconfig
}
