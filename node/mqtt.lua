function set_light(data)
	data = split(data,";")
	a = tonumber(data[1])
	c = tonumber(data[2])

	han_luz = {}
	for i=0,144 do
		gaussian = a*2.718282^(-(10*i-12*60)^2/(2*(c*60)^2))

		han_luz[i] = math.floor(gaussian)
	end

	return han_luz
end


m = mqtt.Client(client_id,120,mqtt_user,mqtt_pwd)

m:lwt("/lwt", "offline", 0, 0)

m:on("connect", function(client) print ("connected") end)
m:on("offline", function(client) print ("offline - lugar do retry") end)

function connect_MQTT()
  return m:connect(server,port, 0, function(client)
    print("mqtt: conectado")
no = [[
    client:subscribe(topicos_comando, function(conn) 
		  print("mqtt: inscrito nos topicos") 
		  inicia_publish()
		end)
  end, function(client, reason)
    print("mqtt: failed reason " .. reason)
]]
  end)
end



estufa="/estufa1"
-- publicacao dos status  -------------------------------------------------------------

no = [[
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

publish_ind=1
espera=1000 -- em ms
timer_publish=tmr.create()
timer_publish:register(espera,tmr.ALARM_AUTO,function()
  --print("mqtt memory:",node.heap())
  collectgarbage();

    --input de curva solar

    --input da irrigação	
				
				
end)


function inicia_publish()
	timer_publish:start()
end

function para_publish()
	timer_publish:stop()
end

---------------------------------------------------------------------------------------

m:on("connect", function(client) print("mqtt: conectado 1") end)
function try_reconnect()
print("mqtt: offline")
timer_reMQTT=tmr.create()
end
m:on("offline", function(client) 
  tmr.create():alarm(5000, tmr.ALARM_AUTO, function()
  end)
end)


-- leitura de comandos ----------------------------------------------------------------
no = [[
topicos_comando={
[estufa.."/led1/i/comando"]=2,
[estufa.."/led2/i/comando"]=2,
[estufa.."/led3/i/comando"]=2,
[estufa.."/led4/i/comando"]=2,
[estufa.."/vaso1/bomba/comando"]=2,
[estufa.."/vaso2/bomba/comando"]=2,
[estufa.."/vaso3/bomba/comando"]=2,
[estufa.."/vaso4/bomba/comando"]=2,
[estufa.."/coolers/comando"]=2,
[estufa.."/power/comando"]=2,
[estufa.."/stop_status/comando"]=2
}
]]

connect_MQTT()

m:on("message", function(client, topic, data)
	topic_table=split(topic,"/")
	tam_topic_table = #topic_table

	if topic_table[tam_topic_table-1] == "set_water_time" then
		set_watering(data)

	elseif topic_table[tam_topic_table-1] == "set_light" then
		set_light(data)

	end

end)
---------------------------------------------------------------------------------------


--m:close();

