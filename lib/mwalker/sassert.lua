-- like assert but without the fuzz: won't print backtrace, etc...
local function softassert(...)
  condition = ...
  if not condition then
    print(select(2, ...))
    os.exit(1)
  end
  return ...
end

return softassert
