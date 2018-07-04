-- mqtt 

server=""
port=
client_id=""
mqtt_user=""
mqtt_pwd=""

m = mqtt.Client(client_id,120,mqtt_user,mqtt_pwd)


-- publicacao dos status  -------------------------------------------------------------
topicos_status={}
topicos_status[1]="/estufa1/led1/i/status" 
topicos_status[2]="/estufa1/led2/i/status"
topicos_status[3]="/estufa1/led3/i/status"
topicos_status[4]="/estufa1/led4/i/status"
topicos_status[5]="/estufa1/vaso1/bomba/status"
topicos_status[6]="/estufa1/vaso2/bomba/status"
topicos_status[7]="/estufa1/vaso3/bomba/status"
topicos_status[8]="/estufa1/vaso4/bomba/status"
topicos_status[9]="/estufa1/coolers/status"
topicos_status[10]="/estufa1/led1/t/status"
topicos_status[11]="/estufa1/led2/t/status"
topicos_status[12]="/estufa1/led3/t/status"
topicos_status[13]="/estufa1/led4/t/status"
topicos_status[14]="/estufa1/power/status"

publish_ind=1
espera=1000 -- em ms
timer_publish=tmr.create()
timer_publish:register(espera,tmr.ALARM_AUTO,function()
	if publish_ind<=4 then  --i dos led1,led2,led3,led4
		led_id=publish_ind
		leitura=le_i_led(led_id)
		m:publish(topicos_status[publish_ind],leitura,0,0,function(client) end)
		print("mqtt: intensidade do led"..led_id.." igual a "..leitura)
		publish_ind=publish_ind+1
	elseif publish_ind<=8 then --bombas vaso1,vaso2,vaso3,vaso4
		vaso_id=publish_ind-4
		leitura=le_bomba(vaso_id)
		m:publish(topicos_status[publish_ind],leitura,0,0,function(client) end)
		print("mqtt: valor da bomba do vaso"..vaso_id.." igual a "..leitura)
		publish_ind=publish_ind+1
	elseif publish_ind==9 then --coolers
		leitura=le_coolers()
		m:publish(topicos_status[publish_ind],leitura,0,0,function(client) end)
		print("mqtt: valor dos coolers igual a "..leitura)
		publish_ind=publish_ind+1
	elseif publish_ind<=13 then --t dos led1, led2, led3, led4
		led_id=publish_ind-9
		leitura=le_t_led(led_id)
		m:publish(topicos_status[publish_ind],leitura,0,0,function(client) end)
		print("mqtt: valor de temperatura do led"..led_id.." igual a "..leitura)
		publish_ind=publish_ind+1
	elseif publish_ind==14 then --power
		m:publish(topicos_status[publish_ind],"estufa ligada",0,0,function(client) end)
		print("mqtt: estufa ligada")
		publish_ind=1
	end
end)

function inicia_publish()
	timer_publish:start()
end

function para_publish()
	timer_publish:stop()
end

---------------------------------------------------------------------------------------

m:on("connect", function(client) print("mqtt: conectado 1") end)
m:on("offline", function(client) print("mqtt: offline") end)


-- leitura de comandos ----------------------------------------------------------------
topicos_comando={}
topicos_comando["/estufa1/led1/i/comando"]=2
topicos_comando["/estufa1/led2/i/comando"]=2
topicos_comando["/estufa1/led3/i/comando"]=2
topicos_comando["/estufa1/led4/i/comando"]=2
topicos_comando["/estufa1/vaso1/bomba/comando"]=2
topicos_comando["/estufa1/vaso2/bomba/comando"]=2
topicos_comando["/estufa1/vaso3/bomba/comando"]=2
topicos_comando["/estufa1/vaso4/bomba/comando"]=2
topicos_comando["/estufa1/coolers/comando"]=2
topicos_comando["/estufa1/power/comando"]=2
topicos_comando["/estufa1/stop_status/comando"]=2


m:connect(server,port, 0, function(client)
        print("mqtt: conectado")
        client:subscribe(topicos_comando, function(conn) 
		print("mqtt: inscrito nos topicos") 
		inicia_publish()
		end)
        end, function(client, reason)
        	print("mqtt: failed reason " .. reason)
end)

m:on("message", function(client, topic, data)
        topic_table=split(topic,"/")
	if topic_table[3]=="i" then 
		led_id=string.sub(topic_table[2],4,4)
		valor=data
		escreve_i_led(led_id,valor)
		print("mqtt: escrevendo na intensidade do led"..led_id.." o valor "..valor)
	elseif topic_table[3]=="bomba" then
		vaso_id=string.sub(topic_table[2],5,5)
		tempo=data
		escreve_bomba(vaso_id,tempo)
		print("mqtt: escrevendo na bomba do vaso"..vaso_id.." por "..tempo.." segundos")
	elseif topic_table[2]=="coolers" then
		valor=data
		escreve_coolers(valor)
		print("mqtt: escrevendo nos coolers o valor "..valor)
	elseif topic_table[2]=="power" then
		print("mqtt: desligando a estufa")
		m:publish("/estufa1/power/status","estufa desligada",0,0,function(client) end)
		-- talvez seja util acrescentar um para_publish() aqui
		-- desligar estufa
	elseif topic_table[2]=="stop_status" then
		if data=="1" then
			print("mqtt: desligando a publicacao de status")
			para_publish()
		elseif data=="0" then
			print("mqtt: ligando a publicacao de status")
			inicia_publish()
		end

	end
end)
---------------------------------------------------------------------------------------


m:close();

