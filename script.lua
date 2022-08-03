--! FUNCTIONS ----------------------------------------------------
--[[
  {
    summary: "Checks if IPV4 address is valid"
    params: {
      ip: "IP address in string format"
    }
    return: "True if IP address is valid IPV4 address"
  }
]]
function Ipv4Validator(ip)
  local chunks = { ip:match("^(%d+)%.(%d+)%.(%d+)%.(%d+)$") }

  if #chunks == 4 then
    for _, v in pairs(chunks) do
      if tonumber(v) > 255 then
        return false
      end
    end
    return true
  end

  return false
end

--[[
  {
    summary: "Checks if IPV6 address is valid"
    params: {
      ip: "IP address in string format"
    }
    return: "True if IP address is valid IPV6 address"
  }
]]
function Ipv6Validator(ip)
  local chunks = { ip:match("^" .. (("([a-fA-F0-9]*):"):rep(8):gsub(":$", "$"))) }
  if #chunks == 8
      or #chunks < 8 and ip:match('::') and not ip:gsub("::", "", 1):match('::') then
    for _, v in pairs(chunks) do
      if #v > 0 and tonumber(v, 16) > 65535 then
        return false
      end
    end
    return true
  end

  return false
end

--[[
  {
    summary: "Splits string by delimiter"
    params: {
      s: "String to be split"
      delimiter: "Parameter on whitch string has to be split"
    }
    return: "Array of strings"
  }
]]
function Split(s, delimiter)
  if delimiter == nil then
    delimiter = "%s"
  end
  local t = {}
  for str in string.gmatch(s, "([^" .. delimiter .. "]+)") do
    table.insert(t, str)
  end
  return t
end

--[[
  {
    summary: "Calulates UNIT32 value for ip"
    params: {
      array: "Array of IP values"
    }
    return: "integer with calculated value"
  }
]]
function MultiplyIPV4Elements(array)
  return array[4] + 256 * array[3] + 65536 * array[2] + 16777216 * array[1]
end

--[[
  {
    summary: "Calulates UNIT32 value for ip"
    params: {
      array: "Array of IP values"
    }
    return: "integer with calculated value"
  }
]]
function MultiplyIPV6Elements(array)
  return array[8] + 65536 * array[7] + 4294967296 * array[6] + 281474976710656 * array[5] +
      (281474976710656 * 65536) * array[4] + (281474976710656 * 65536 * 65536) * array[3] +
      (281474976710656 * 65536 * 65536 * 65536) * array[2] +
      (281474976710656 * 65536 * 65536 * 65536 * 65536) * array[1
      ]
end

--[[
  {
    summary: "Compares two ip addresses"
    params: {
      ip1: "first array of ip values"
      ip2: "second array of ip values"
    }
    return: "error or value of ip addresses in range"
  }
]]
function CompareIPs(mode, ip1, ip2)
  if mode == "ipv4" then
    Ip1value = MultiplyIPV4Elements(ip1)
    Ip2value = MultiplyIPV4Elements(ip2)
  else
    Ip1value = MultiplyIPV6Elements(ip1)
    Ip2value = MultiplyIPV6Elements(ip2)
  end

  if Ip1value < Ip2value then
    return Ip2value - Ip1value
  end

  print("Secnd IP must be greater than the first one")
  os.exit()
end

--! FUNCTIONS ----------------------------------------------------

--* Validate there is at least two args, but no more than three
if not (#arg >= 2 and #arg <= 3) then
  print("You must provide two or three arguments for this program")
  os.exit()
end

--* Checking if mode is set
if #arg == 3 and arg[1] ~= "ipv4" and arg[1] ~= "ipv6" then
  print([[If you want to specify whether to use ipv4 or ipv6 ip addresses
the first argument must be either "ipv4" or "ipv6"]])
  os.exit()
end

--* Assigning mode and ip values
if #arg == 2 then
  Mode = "ipv4"
  Ips = { arg[1], arg[2] }
else
  Mode = arg[1]
  Ips = { arg[2], arg[3] }
end

--* Checking if ips are valid
for _, ip in pairs(Ips) do
  if Mode == "ipv4" then
    if not Ipv4Validator(ip) then
      print(ip .. " is not a valid ip address")
      os.exit()
    end
  else
    if not Ipv6Validator(ip) then
      print(ip .. " is not a valid ip address")
      os.exit()
    end
  end
end

--* Split ip address
Delimiter = ""
if Mode == "ipv4" then
  Delimiter = "."
else
  Delimiter = ":"
end
SplitIP1 = Split(Ips[1], Delimiter)
SplitIP2 = Split(Ips[2], Delimiter)

--* Compare ip addresses
print(CompareIPs(Mode, SplitIP1, SplitIP2))
