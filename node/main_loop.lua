-- esse arquivo contem a funcao main_loop() chamada pela timer main_loop_tmr que esta registrado no arquivo init.lua, uma vez por segundo.

last_dec_min_ilu=-1
last_hour_irrig=-1
last_min_mqtt = -1
estufa="/estufa1"
topicos_status={
[1] =estufa.."/led1/i/status",
[2] =estufa.."/led2/i/status",
[3] =estufa.."/led3/i/status",
[4] =estufa.."/led4/i/status",
[5] =estufa.."/bomba/status",
[6] =estufa.."/coolers/status",
[7]=estufa.."/led1/t/status",
[8]=estufa.."/led2/t/status",
[9]=estufa.."/led3/t/status",
[10]=estufa.."/led4/t/status",
[11]=estufa.."/power/status"
}

function main_loop()
    --debug
    print("loop\n")

    -- pega os valores de tempo em minuto
    tm=rtctime.epoch2cal(rtctime.get())
    sec=tm["sec"]
    min=tm["min"]
    hour=tm["hour"]
    dec_min = math.floor(min/10)

  if last_dec_min_ilu~=dec_min then
        -- acionamento dos coolers
        if han_luz[dec_min]==0 then
            com(nano1_addr,"3","10000")    -- 3: d0, 12: coolers, 000: desligado
        else
            com(nano1_addr,"3","10001")    -- 3: d0, 12: coolers, 001: ligado
        end

        -- acionamento dos leds
        han_luz_formatado=string.format("%03d",han_luz[dec_min])
        com(nano1_addr,"1","09"..han_luz_formatado)  -- 1: pwm, 09: i_led1
        com(nano1_addr,"1","05"..han_luz_formatado)  -- 1: pwm, 05: i_led2
        com(nano1_addr,"1","06"..han_luz_formatado)  -- 1: pwm, 06: i_led3
        com(nano1_addr,"1","03"..han_luz_formatado)  -- 1: pwm, 03: i_led4

        -- altera last_dec_min_ilu
        last_dec_min_ilu=dec_min
    end

    -- acionamento das bombas
    if last_hour_irrig~=hour then
        if kbc_bomba[hour]~=0 then
            -- liga bombas
            com(nano1_addr,"3","02001")    -- 3: d0, 02: bomba1, 001: ligado
            com(nano1_addr,"3","07001")    -- 3: d0, 07: bomba2, 001: ligado
            com(nano1_addr,"3","04001")    -- 3: d0, 04: bomba3, 001: ligado
            com(nano1_addr,"3","08001")    -- 3: d0, 08: bomba4, 001: ligado

            -- programa o desligamento das bombas
            timer_bomba=tmr.create()
	        timer_bomba:register(kbc_bomba[hour]*1000,tmr.ALARM_SINGLE,function()
                com(nano1_addr,"3","02000")    -- 3: d0, 02: bomba1, 000: desligado
                com(nano1_addr,"3","07000")    -- 3: d0, 07: bomba2, 000: desligado
                com(nano1_addr,"3","04000")    -- 3: d0, 04: bomba3, 000: desligado
                com(nano1_addr,"3","08000")    -- 3: d0, 08: bomba4, 000: desligado
	        end)
	        timer_bomba:start()
        end

        -- altera last_hour_irrig
        last_hour_irrig=hour
    end

    --envio dos status
    if last_min_mqtt =~ min then
      for
      -- status dos leds
      client:publish(topicos_status[1], estado[5], 0, 0, function(client) print("sent led 1 i") end)
      client:publish(topicos_status[2], estado[6], 0, 0, function(client) print("sent led 2 i") end)
      client:publish(topicos_status[3], estado[7], 0, 0, function(client) print("sent led 3 i") end)
      client:publish(topicos_status[4], estado[8], 0, 0, function(client) print("sent led 4 i") end)


      -- converter table da bomba pra string
      for i=1, #kbc_bomba do
        status_bombas = status_bombas .. ";" .. tostring(kbc_bomba[i])
      end
      -- status da bomba
      client:publish(topicos_status[5], status_bombas, 0, 0, function(client) print("sent bomba status") end)
      -- status dos cooelers
      client:publish(topicos_status[6], estado[15], 0, 0, function(client) print("sent coolers status") end)

      --status da temperatura dos leds
      client:publish(topicos_status[7], estado[1], 0, 0, function(client) print("sent led 1 t") end)
      client:publish(topicos_status[8], estado[2], 0, 0, function(client) print("sent led 2 t") end)
      client:publish(topicos_status[8], estado[3], 0, 0, function(client) print("sent led 3 t") end)
      client:publish(topicos_status[10], estado[4], 0, 0, function(client) print("sent led 4 t") end)

      --client:publish(topicos_status[11], estado[4], 0, 0, function(client) print("sent led 4 t") end)

      --altera last_hour_irrig
      last_min_mqtt = min

    end










end
