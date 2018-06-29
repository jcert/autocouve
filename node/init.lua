-- description
-- 
--

function irriga(vaso_id,time)
	gpio.write(vaso_id,gpio.HIGH)
	tmr.delay(time*1000000)
	gpio.write(vaso_id,gpio.LOW)
end

function send_message(id,fn,p)
	message="\t"..id..fn..p.."\n"
	uart.write(0,message)
end

-- comm tx
--send_message("01","2","34567")


-- comm rx

-- pin config
gpio.mode(1,gpio.OUTPUT) -- vaso1
gpio.mode(2,gpio.OUTPUT) -- vaso2
gpio.mode(3,gpio.OUTPUT) -- vaso3
gpio.mode(4,gpio.OUTPUT) -- vaso4


[=[
-- wifi config
station_cfg={}
station_cfg.ssid = ""
station_cfg.pwd = ""

-- wifi connection
wifi.setmode(wifi.STATION)
wifi.sta.config(station_cfg)
tmr.delay(4000000)
print(wifi.sta.getip())

-- mqtt
m = mqtt.Client("clientid",120)

m:on("connect", function(client) print ("connected") end)
m:on("offline", function(client) print ("offline") end)

m:on("message", function(client, topic, data) 
  print(topic .. ":" ) 
  if data ~= nil then
    print(data)
  end
end)

m:connect("broker.hivemq.com", 1883, 0, function(client)
  print("connected")
  client:subscribe("/autocouve/sensor1/vaso4", 0, function(client) print("subscribe success") end)
  client:publish("/autocouve/sensor1/vaso4", "hello", 0, 0, function(client) print("sent") end)
end,
function(client, reason)
  print("failed reason: " .. reason)
end)

m:close();
]=]
