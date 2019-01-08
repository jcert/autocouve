-- Data Example 05;03 (as 5 horas, regar por 03 segundos)
kbc_bomba = {}

for i=1,24,1 do
    kbc_bomba[i] = 0
end

function set_watering_time(data)


  dados_table = split(data,";")

  if #dados_table ~= 2 then
    return false
  end
  hora_added = tonumber(dados_table[1])
  bomba_timer_added = tonumber(dados_table[2])

  kbc_bomba[hora_added] = bomba_timer_added

  --print("Watering table updated!")
  --print("\n")
  --print("Hour" .. "\t" .. "t_seg")
  --for i=1,#kbc_bomba,1 do
  --  print(i .." \t " .. kbc_bomba[i])
  --end
collectgarbage()
end
