local function filtertab(tab, predicate)
  local length = #tab

  for i = length, 1, -1 do
    if predicate(tab[i]) then table.remove(tab, i) end
  end

  return tab
end

return filtertab
