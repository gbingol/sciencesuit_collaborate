
-- Modified from http://lua-users.org/wiki/GeneralizedPairsAndIpairs

--For the function to work on a Userdata, the userdata must provide a method called next

local luanext = next --next function provided by Lua
function next(t,k)
  local m = getmetatable(t)
  local n = (m and m["next"]) or luanext
  return n(t,k)
end