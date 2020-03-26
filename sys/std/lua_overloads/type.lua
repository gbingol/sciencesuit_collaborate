
local luatype = type --type function provided by Lua

function type(entry)
  local m = getmetatable(entry)
  local n = (m and m["__name"]) or luatype
  
  if(luatype(n)=="string") then
    return n
  end

  return n(entry)

end