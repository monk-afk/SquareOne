
local function sales_tax(denomination, multiplier, conversion)
  local deducted_tax = 0

  if multiplier > 3 then
    local tax = math.ceil(multiplier * 0.1)
    deducted_tax = (denomination * tax)
    multiplier = multiplier - tax

  elseif denomination > 1 then
    denomination = conversion[1]
    multiplier   = conversion[2] * multiplier
    local tax = math.ceil(multiplier * 0.1)
    deducted_tax = (denomination * tax)
    multiplier   = multiplier - tax
  end

  return denomination, multiplier, deducted_tax
end

local note_strings = {
  {[1]   = {1, 1}},
  {[5]   = {1, 5}},
  {[10]  = {1, 10}},
  {[50]  = {10, 5}},
  {[100] = {10, 10}},
  {[500] = {100, 5}},
}

io.write(
"|    |    |    |    |\n",
"|:--:|:--:|---:|---:|\n")

local new_row = "|  | x %2s ($%5s) | x %2s ($%5s) | $%4s |\n"
local new_column = "| ![SQ1 Note %s](/images/textures/money/money_note_%s.png) | Range From | Range To | Shared Profit |\n"

for n = 1, #note_strings do
  for denomination, conversion in pairs(note_strings[n]) do
    local _,_,last_tax = sales_tax(denomination, 1, conversion) -- start with 1
    local last_multiplier = 1
    local last_value = 1 * denomination
    io.write(new_column:format(denomination, denomination))

    for current_multiplier = 1, 100 do  -- shops can't charge more than a stack of any denomination, overshoot by 1 to get the 99
      local new_denomination, new_multiplier, current_tax = sales_tax(denomination, current_multiplier, conversion)

      if current_tax ~= last_tax or current_multiplier == 100 then -- only print when the amount of tax changes
        local output = (new_row):format(
            last_multiplier,
            last_value,
            current_multiplier -1,
            (current_multiplier - 1) * denomination,
            last_tax
          )

        io.write(output)
        last_tax = current_tax
        last_multiplier = current_multiplier
        last_value = current_multiplier * denomination
      end
    end
  end
end
