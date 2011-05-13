local tabinsert
do
  -- Avoid heap allocs for performance
  local fcomp_default = function( a,b ) return a < b end
  local floor = math.floor
  local insert = table.insert

  tabinsert = function(t, value, fcomp)
    local fcomp = fcomp or fcomp_default
    local iStart,iEnd,iMid,iState = 1, #t, 1, 0

    while iStart <= iEnd do
      iMid = floor((iStart+iEnd) / 2)
      if fcomp(value, t[iMid]) then
        iEnd,iState = iMid - 1,0
      else
        iStart,iState = iMid + 1,1
      end
    end
    insert(t, (iMid+iState), value)
    return (iMid+iState)
  end
end

return tabinsert
