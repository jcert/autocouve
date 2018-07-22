-- script principal

node.compile("aux.lua")
node.compile("com.lua")
node.compile("hard.lua")
node.compile("wifi.lua")
node.compile("mqtt.lua")

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

tmr.delay(50)
collectgarbage();
print("4 memory:",node.heap())
tmr.delay(50)
