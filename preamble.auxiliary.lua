local _, fluffy = ...

function mysplit_damage (inputstr)
	local t={}

	if inputstr == nil or #inputstr < 1 then
		return t;
	end

	inputstr = inputstr:gsub( ",", ".")

	for str in string.gmatch(inputstr, "([^%D]+)") do
		table.insert(t, str)
	end
	return t
end

function mysplit_speed (inputstr)
	local t={}

	if inputstr == nil or #inputstr < 1 then
		return t;
	end

	inputstr = inputstr:gsub( ",", ".")

	for str in string.gmatch(inputstr, "([^%s]+)") do
		table.insert(t, str);
	end
	return t
end

function get_percent(inputstr)
	local out = 0;

	if inputstr == nil or #inputstr < 1 then
		return out;
	end

	if string.find(inputstr, "%%") == nil then
		return out;
	end

	for str in string.gmatch(inputstr, "([^%%]+)") do

		local val = tonumber(str);
		if val ~= nil then
			out = 0.01 * val;
			break;
		end
	end

	return out;
end

function comma_value(amount)
	local formatted = amount
	while true do  
	  formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
	  if (k==0) then
		break
	  end
	end
	return formatted
  end
  
function round(val, decimal)
	if (decimal) then
	  return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
	else
	  return math.floor(val+0.5)
	end
  end
  
  function format_num(amount, decimal, prefix, neg_prefix)
	local str_amount,  formatted, famount, remain
  
	decimal = decimal or 2  -- default 2 decimal places
	neg_prefix = neg_prefix or "-" -- default negative sign
  
	famount = math.abs(round(amount,decimal))
	famount = math.floor(famount)
  
	remain = round(math.abs(amount) - famount, decimal)
  
		  -- comma to separate the thousands
	formatted = comma_value(famount)
  
		  -- attach the decimal portion
	if (decimal > 0) then
	  remain = string.sub(tostring(remain),3)
	  formatted = formatted .. "." .. remain ..
				  string.rep("0", decimal - string.len(remain))
	end
  
		  -- attach prefix string e.g '$' 
	formatted = (prefix or "") .. formatted 
  
		  -- if value is negative then format accordingly
	if (amount<0) then
	  if (neg_prefix=="()") then
		formatted = "("..formatted ..")"
	  else
		formatted = neg_prefix .. formatted 
	  end
	end
  
	return formatted
  end


  function InitDB()

	if fluffy.is_player_hunter == false then
		FluffyDBPC = {};
		FluffyDBPC["hidden"] = {true};
		return;
	end
	
	if FluffyDBPC == nil then
		FluffyDBPC = {};
	end

	if FluffyDBPC["version"] == nil then
		FluffyDBPC["version"] = 0;
	end
	
	if FluffyDBPC["pos"] == nil then
		FluffyDBPC["pos"] = {"CENTER", 0, 0};
	end
	
	if FluffyDBPC["size"] == nil then
		FluffyDBPC["size"] = {321, 25};
	end
	
	if FluffyDBPC["update"] == nil then
		FluffyDBPC["update"] = {45};
	end
	
	if FluffyDBPC["hidden"] == nil then
		FluffyDBPC["hidden"] = {false};
	end
	
	if FluffyDBPC["show_icons"] == nil then
		FluffyDBPC["show_icons"] = {false};
	end

	if FluffyDBPC["icosize"] == nil then
		FluffyDBPC["icosize"] = {24};
	end
	
	if FluffyDBPC["locked"] == nil then
		FluffyDBPC["locked"] = {false};
	end

	if FluffyDBPC["quiver"] == nil then
		FluffyDBPC["quiver"] = {};
	end

	if FluffyDBPC["ammo"] == nil then
		FluffyDBPC["ammo"] = {};
	end

	if FluffyDBPC["ranged_weapons"] == nil then
		FluffyDBPC["ranged_weapons"] = {};
	end

	if FluffyDBPC["melee_weapons"] == nil then
		FluffyDBPC["melee_weapons"] = {};
	end

end