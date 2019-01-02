-- esse arquivo contem a funcao main_loop() chamada pela timer main_loop_tmr que esta registrado no arquivo init.lua, uma vez por segundo.

last_min_ilu=-1
last_hour_irrig=-1

function main_loop()
    --debug
    --print("loop\n")

    -- pega os valores de tempo em minuto
    sec,usec,rate=rtctime.get()
    min=math.floor(sec/60)
    hour=math.floor(min/60)    

    if not las_min_ilu==min then    
        -- acionamento dos coolers
        if han_luz[min]==0 then
            com("3","12000")    -- 3: d0, 12: coolers, 000: desligado               
        else
            com("3","12001")    -- 3: d0, 12: coolers, 001: ligado
        end    

        -- acionamento dos leds
        han_luz_formatado=string.format("%03d",han_luz[min])
        com("1","09"..han_luz_formatado)  -- 1: pwm, 09: i_led1    
        com("1","05"..han_luz_formatado)  -- 1: pwm, 05: i_led2    
        com("1","06"..han_luz_formatado)  -- 1: pwm, 06: i_led3    
        com("1","03"..han_luz_formatado)  -- 1: pwm, 03: i_led4    

        -- altera last_min_ilu
        last_min_ilu=min
    end

    -- acionamento das bombas
    if not last_hour_irrig==hour then
        if not kbc_bomba[hour]==0 then
            -- liga bombas            
            com("3","02001")    -- 3: d0, 02: bomba1, 001: ligado
            com("3","07001")    -- 3: d0, 07: bomba2, 001: ligado
            com("3","04001")    -- 3: d0, 04: bomba3, 001: ligado
            com("3","08001")    -- 3: d0, 08: bomba4, 001: ligado

            -- programa o desligamento das bombas
            timer_bomba=tmr.create()
	        timer_bomba:register(kbc_bomba[hour]*1000,tmr.ALARM_SINGLE,function()
                com("3","02000")    -- 3: d0, 02: bomba1, 000: desligado
                com("3","07000")    -- 3: d0, 07: bomba2, 000: desligado
                com("3","04000")    -- 3: d0, 04: bomba3, 000: desligado
                com("3","08000")    -- 3: d0, 08: bomba4, 000: desligado
	        end)
	        timer_bomba:start()        
        end
        
        -- altera last_hour_irrig
        last_hour_irrig=hour
    end
end
