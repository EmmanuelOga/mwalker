local byte = string.byte

local SLASH_BYTE = string.byte("/")

local function isslash(string, idx)
  return byte(string, idx or 1) == SLASH_BYTE
end

return {
  isslash = isslash
}
