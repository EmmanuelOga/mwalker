--local profiler = require('profiler')
--profiler = newProfiler("time", 1000)
--profiler:start()
--profiler:stop()
--local outfile = io.open("profile.txt", "w+")
--profiler:report(outfile)
--outfile:close()

local function bench(name, count, cbk)
  local start = os.clock()
  for i = 1, count do cbk() end
  local endt = os.clock() - start
  print(name, endt)
  return endt
end

return bench
