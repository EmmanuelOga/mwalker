local banner = [[

MoonWalker
----------

    Walks your paths tree looking for files matching a given subsequence. A
    subsequence is the string you are looking for where any number of letters
    has been removed.

    E.G.: "hlo" is a subsequence of "hello".

Commands:

  config [path]

      Writes a config file for generating an index for the given path. The
      path defaults to current directory if not given.

  index [path]

      Writes an index of contents of directories under the given path. The
      path defaults to the current directory.

  filter path [-limit=N] [-mode=<f|d|a>] [pattern]

      Loads the index or generates one on the fly, and returns the entries
      matching the given subsequence.

      If the path is -, it will filter the entries coming from the standard
      input instead of building or loading a an index of files.

      Mode only applies when not reading from stdin. It controls whether the
      subsequence can match only files (default), only directories, or both.
]]

local isslash = require("helpers").isslash

local action, opt1, opt2, opt3, opt4 = ..., select(2, ...)
local path = opt1 or "."

if isslash(path) then path = path:sub(1, -2) end

if     action == "config" then require("cmdconfig").doconfig(path)
elseif action == "index"  then require("cmdindex").doindex(path)
elseif action == "filter" then
  if not opt1 then print("please provide a path or - for standard input."); os.exit(1) end

  local pattern, limit, mode = "", nil, nil

  local opts, nopts, v, p = {opt2, opt3, opt4}, 3, nil, nil
  while nopts > 0 do
    v, nopts = table.remove(opts, nopts), nopts - 1
    p = not limit and v and v:match("^-limit=(%d+)$"); if p then limit, v = p, nil end
    p = not mode and v and v:match("^-mode=(.).*$"); if p then mode, v = p, nil end
    if v then pattern = v end
  end

  limit = tonumber(limit) or 0
  mode = ((mode=="f" or mode=="d" or mode=="a") and mode) or "f"

  require("cmdfilter").dofilter(path, mode, limit, pattern)
else
  print(banner)
end
