function set_light(data)
	data = split(data,",")
	a = tonumber(data[1])
	c = tonumber(data[2])

	han_luz = {}
	for i=0,1440 do
		gaussian = a*2.718282^(-(i-12*60)^2/(2*(c*60)^2))

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






no = [[
	if publish_ind<=4 then  --i dos led1,led2,led3,led4
		led_id=publish_ind
		leitura=le_i_led(led_id)
		m:publish(topicos_status[publish_ind],leitura,0,0,function(client) end)
		--print("mqtt: intensidade do led"..led_id.." igual a "..leitura)
		publish_ind=publish_ind+1
	elseif publish_ind<=8 then --bombas vaso1,vaso2,vaso3,vaso4
		vaso_id=publish_ind-4
		leitura=le_bomba(vaso_id)
		m:publish(topicos_status[publish_ind],leitura,0,0,function(client) end)
		--print("mqtt: valor da bomba do vaso"..vaso_id.." igual a "..leitura)
		publish_ind=publish_ind+1
	elseif publish_ind==9 then --coolers
		leitura=le_coolers()
		m:publish(topicos_status[publish_ind],leitura,0,0,function(client) end)
		--print("mqtt: valor dos coolers igual a "..leitura)
		publish_ind=publish_ind+1
	elseif publish_ind<=13 then --t dos led1, led2, led3, led4
		led_id=publish_ind-9
		leitura=le_t_led(led_id)
		m:publish(topicos_status[publish_ind],leitura,0,0,function(client) end)
		--print("mqtt: valor de temperatura do led"..led_id.." igual a "..leitura)
		publish_ind=publish_ind+1
	elseif publish_ind==14 then --power
		m:publish(topicos_status[publish_ind],"estufa ligada",0,0,function(client) end)
		--print("mqtt: estufa ligada")
		publish_ind=1
	end
]]

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

no = [[
  topic_table=split(topic,"/")
	if topic_table[3]=="i" then 
		led_id=string.sub(topic_table[2],4,4)
		valor=data
		escreve_i_led(led_id,valor)
		--print("mqtt: escrevendo na intensidade do led"..led_id.." o valor "..valor)
	elseif topic_table[3]=="bomba" then
		vaso_id=string.sub(topic_table[2],5,5)
		tempo=data
		escreve_bomba(vaso_id,tempo)
		--print("mqtt: escrevendo na bomba do vaso"..vaso_id.." por "..tempo.." segundos")
	elseif topic_table[2]=="coolers" then
		valor=data
		escreve_coolers(valor)
		--print("mqtt: escrevendo nos coolers o valor "..valor)
	elseif topic_table[2]=="power" then
		--print("mqtt: desligando a estufa")
		m:publish(estufa.."/power/status","desligando os componentes da estufa",0,0,function(client) end)
		desliga_estufa()
		-- talvez seja util acrescentar um para_publish() aqui
		-- desligar estufa
	elseif topic_table[2]=="stop_status" then
		if data=="1" then
			--print("mqtt: desligando a publicacao de status")
			para_publish()
		elseif data=="0" then
			--print("mqtt: ligando a publicacao de status")
			inicia_publish()
		end

	end
]]
end)
---------------------------------------------------------------------------------------


--m:close();

