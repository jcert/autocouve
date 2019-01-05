-- configure for 115200, 8N1, with echo
uart.setup(0, 115200, 8, uart.PARITY_NONE, uart.STOPBITS_1, 1)

-- script principal

node.compile("aux.lua")
node.compile("com.lua")
node.compile("hard.lua")
node.compile("wifi.lua")
node.compile("mqtt.lua")
node.compile("watering.lua")
node.compile("main_loop.lua")



----acho que vai economizar espaço usar as chaves numericas e não string
--[ 1] T_led1
--[ 2] T_led2
--[ 3] T_led3
--[ 4] T_led4
--[ 5] i_led1
--[ 6] i_led2
--[ 7] i_led3
--[ 8] i_led4
--[ 9] Umid_G
--[10] Temp_G
--[11] Umid_v1
--[12] Umid_v2
--[13] Umid_v3 não existe ainda
--[14] Umid_v4 não existe ainda
--[15] Cooler
--[16] Reservatorio
estado={}

--usa os scripts compilados
-- funcoes auxiliares
dofile("aux.lc")

-- comunicacao i2c com o nano
dofile("com.lc")

-- acesso ao hardware instalado no nano
dofile("hard.lc")

-- wifi
print("1 memory:",node.heap())
dofile("wifi.lua")

-- mqtt
print("2 memory:",node.heap())
dofile("mqtt.lc")
print("3 memory:",node.heap())

-- set_watering
dofile("watering.lc")

-- main_loop
print("4 memory:",node.heap())
dofile("main_loop.lc")
print("5 memory:",node.heap())

tmr.delay(50)
collectgarbage();
print("6 memory:",node.heap())
tmr.delay(50)

-- seta o rtc interno
rtctime.set(1546300800, 0)
tm = rtctime.epoch2cal(rtctime.get())
print(string.format("%04d/%02d/%02d %02d:%02d:%02d", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"], tm["sec"]))

-- incializa o ciclo principal da estufa
main_loop_tmr = tmr.create()
main_loop_tmr:register(1000, tmr.ALARM_AUTO, main_loop)
main_loop_tmr:start()

han_luz = {}
for i=0,144 do
  han_luz[i] = 200
end

kbc_bomba = {}
for i=0,24 do
  kbc_bomba[i] = 3
end
