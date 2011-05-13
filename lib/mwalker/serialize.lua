-- simple serializer adapted from the one on the pil book, for our humble needs.
local function serialize(o)
  local str = ""

  if type(o) == "number" or type(o) == "boolean" then
    str = str..tostring(o)

  elseif type(o) == "string" then
    str = str..(string.format("%q", tostring(o)))

  elseif type(o) == "table" then
    str = str.."{\n"
    for k, v in pairs(o) do
      str = str.." ["..serialize(k).."]="
      str = str..serialize(v)..",\n"
    end
    str = str.."}\n"

  else
    error("cannot serialize a " .. type(o))
  end

  return str
end

return serialize
