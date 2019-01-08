
function set_light(data)
	local data = split(data,";")
	local a = tonumber(data[1])
	local c = tonumber(data[2])

	--han_luz = {}
	for i=0,144 do
		local gaussian = a*2.718282^(-(10*i-12*60)^2/(2*(c*60)^2))

		han_luz[i] = math.floor(gaussian)
	end

	return han_luz
end


m = mqtt.Client(mqtt_client_id,120,mqtt_user,mqtt_pwd)

m:lwt("/lwt", "offline", 0, 0)

m:on("connect", function(client) print ("connected") end)
m:on("offline", function(client) print ("offline - lugar do retry") end)

-- m:connect("iot.eclipse.org",1883, 0, function(client) print("ok") end, function(client,reason) print("Fail : " .. reason) end)
-- m:subscribe("/lffs", 0,function(conn) print("mqtt: inscrito nos topicos") end)
function connect_MQTT()

m:connect(mqtt_server_ip,mqtt_port, 0, function(client)
	print("mqtt: conectado")
		client:subscribe(topicos_comando[1], 0,function(conn) print("mqtt: inscrito nos topicos") end)
		client:subscribe(topicos_comando[2], 0,function(conn) print("mqtt: inscrito nos topicos") end)
		client:subscribe("/lffs", 0,function(conn) print("mqtt: inscrito nos topicos") end)
		client:publish("/lffs/status", "hello", 0, 0, function(client) print("status enviado") end)
		flag_mqtt = true
		if not MQTTtimer:stop() then end
  end,
	function(client, reason)
    print("mqtt: failed reason " .. reason)
  end)
end



--m:publish("/lffs/status", "ligadao", 0, 0, function(client) print("sent") end)



estufa="/estufa1"
-- publicacao dos status  -------------------------------------------------------------

nos_es_nada_por_cierto = [[
topicos_status={
[1] =estufa.."/led1/i/status",
[2] =estufa.."/led2/i/status",
[3] =estufa.."/led3/i/status",
[4] =estufa.."/led4/i/status",
[5] =estufa.."/vaso1/bomba/status",
[6] =estufa.."/vaso2/bomba/status",
[7] =estufa.."/vaso3/bomba/status",
[8] =estufa.."/vaso4/bomba/status",
[9] =estufa.."/coolers/status",
[10]=estufa.."/led1/t/status",
[11]=estufa.."/led2/t/status",
[12]=estufa.."/led3/t/status",
[13]=estufa.."/led4/t/status",
[14]=estufa.."/power/status"
}

]]

---------------------------------------------------------------------------------------

m:on("connect", function(client) print("mqtt: conectado 1") end)

m:on("offline", function(client)
MQTTtimer:start()
flag_mqtt = false
end)

MQTTtimer = tmr.create()
MQTTtimer:register(5000, tmr.ALARM_AUTO, function() connect_MQTT() end)


-- leitura de comandos ----------------------------------------------------------------

topicos_comando={
[1] = estufa.."/led/set_light",
[2] = estufa.."/bomba/set_water_time",
--[estufa.."/vaso1/bomba/comando"]=2,
--[estufa.."/vaso2/bomba/comando"]=2,
--[estufa.."/vaso3/bomba/comando"]=2,
--[estufa.."/vaso4/bomba/comando"]=2,
--[estufa.."/coolers/comando"]=2,
--[estufa.."/power/comando"]=2,
--[estufa.."/stop_status/comando"]=2
}



--TESTE
pin=4
led_state=0

gpio.mode(pin,gpio.OUTPUT)
gpio.write(pin,gpio.HIGH)


--receive_MQTT()

m:on("message", function(client, topic, data)
	topic_table=split(topic,"/")
	tam_topic_table = #topic_table


m:publish("/lffs/status", "Rcbd: " .. tostring(data), 0, 0, function(client) end)
	var = (tostring(data))


	if var=="1" then
			--led_state=1
			gpio.write(pin,gpio.LOW)
	elseif var == "0" then
			--data=0
			gpio.write(pin,gpio.HIGH)
	end



	if topic_table[tam_topic_table] == "set_water_time" then
		set_watering_time(data)
		print("water set")

	elseif topic_table[tam_topic_table] == "set_light" then
		set_light(data)

	end
collectgarbage()
end)
---------------------------------------------------------------------------------------
function emalaivemqtt()

end

--m:close();
