local read = io.read
local exec = os.execute
local byte = string.byte

local function getch()
  exec("stty raw -echo")
  local c = io.read(1)
  exec("stty sane")
  return c
end

local function input(initial)
  local i = initial or ""

  local function pump()
    local c = getch()
    local b = byte(c)
    if b == 127 then
      i = i:sub(1, -2) or ""
    elseif b > 32 and b < 127 then
      i = i..c
    end
  end

  return function()
    pump()
    return ((not i:match("q")) and i) or nil
  end
end

return input
