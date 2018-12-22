-- funcoes pra acesso do hardware instalado no nano
-- baseado no protocolo escrito pelo jair

estados_verifica = {}

function verificaLED()
  local a,b = 0
  a = com(nano1_addr,"2","P05000")--leitura analógica do LDR
  
  com(nano1_addr,"1","P05255")
  b = com(nano1_addr,"2","P05000")--leitura analógica do LDR
  com(nano1_addr,"1","P05000")

  estados_verifica[1] = b>a

  com(nano1_addr,"1","P06255")
  b = com(nano1_addr,"2","P05000")--leitura analógica do LDR
  com(nano1_addr,"1","P06000")

  estados_verifica[2] = b>a

  com(nano1_addr,"1","P07255")
  b = com(nano1_addr,"2","P05000")--leitura analógica do LDR
  com(nano1_addr,"1","P07000")

  estados_verifica[3] = b>a

  com(nano1_addr,"1","P08255")
  b = com(nano1_addr,"2","P05000")--leitura analógica do LDR
  com(nano1_addr,"1","P08000")
   
  estados_verifica[4] = b>a
end

function verificaWIFI()
  net.dns.resolve("www.google.com", function(sk, ip)
      if (ip == nil) then print("DNS fail!") else print(ip) end
  end)
end



no = [[
funcao_cod={}
funcao_cod["NOME"]="0"
funcao_cod["PWM"]="1"
funcao_cod["AI"]="2"
funcao_cod["DO"]="3"
funcao_cod["DI"]="4"
funcao_cod["READ"]="5"
funcao_cod["HELP"]="6"

pino={}
pino["bomba1"]="02" 		-- digital
pino["bomba2"]="07" 		-- digital
pino["bomba3"]="04" 		-- digital
pino["bomba4"]="08" 		-- digital
pino["i_led1"]="09"		-- pwm
pino["i_led2"]="05"		-- pwm
pino["i_led3"]="06"		-- pwm
pino["i_led4"]="03"		-- pwm
pino["coolers"]="12"		-- digital
pino["t_led1"]="00"		-- analogica
pino["t_led2"]="01"		-- analogica
pino["t_led3"]="02"		-- analogica
pino["t_led4"]="03"		-- analogica	
pino["umid_vaso1"]="06" 	-- analogica
pino["umid_vaso2"]="07" 	-- analogica
pino["nivel_reserv1"]="10"	-- digital
pino["nivel_reserv2"]="11"	-- digital


function escreve_bomba(vaso_id,tempo)
	--vaso_id=string.format("%02d",vaso_id)
	bomba_index="bomba"..vaso_id
	bomba_pino=pino[bomba_index]
	fn=funcao_cod["DO"]
	p=bomba_pino.."001"
	com(fn,p)
	
	--tmr.delay(tempo*1000000)
	timer=tmr.create()
	timer:register(tempo*1000,tmr.ALARM_SINGLE,function()
		fn=funcao_cod["DO"]
		p=bomba_pino.."000"
		com(fn,p)
	end)
	timer:start()
		
	--return com(fn,p)
end

function le_bomba(vaso_id)
	bomba_index="bomba"..vaso_id
	bomba_pino=pino[bomba_index]
	fn=funcao_cod["READ"]
	p="D"..bomba_pino
	return com(fn,p)
end

function le_umid_vaso(vaso_id)
	umid_vaso_index="umid_vaso"..vaso_id
	umid_vaso_pino=pino[umid_vaso_index]
	fn=funcao_cod["AI"]
	p=umid_vaso_pino
	return com(fn,p)
end

function escreve_i_led(led_id,valor)
	i_led_index="i_led"..led_id
	i_led_pino=pino[i_led_index]
	fn=funcao_cod["PWM"]
	valor_formatado=string.format("%03d",valor)
	p=i_led_pino..valor_formatado
	return com(fn,p)
end

function le_i_led(led_id)
	i_led_index="i_led"..led_id
	i_led_pino=pino[i_led_index]
	fn=funcao_cod["READ"]
	p="P"..i_led_pino
	return com(fn,p)
end

function le_t_led(led_id)
	t_led_index="t_led"..led_id
	t_led_pino=pino[t_led_index]
	fn=funcao_cod["AI"]
	p=t_led_pino
	return com(fn,p)
end

function escreve_coolers(valor)
	coolers_pino=pino["coolers"]
	fn=funcao_cod["DO"]
	valor_formatado=string.format("%03d",valor)
	p=coolers_pino..valor_formatado
	return com(fn,p)
end

function le_coolers()
	coolers_pino=pino["coolers"]
	fn=funcao_cod["READ"]
	p="D"..coolers_pino
	return com(fn,p)
end

function le_nivel_reserv(reserv_id)
	nivel_reserv_index="nivel_reserv"..reserv_id
	nivel_reserv_pino=pino[nivel_reserv_index]
	fn=funcao_cod["DI"]
	p=nivel_reserv_pino
	return com(fn,p)
end

function desliga_estufa()
	-- desliga todas as bombas
	fn=funcao_cod["DO"]
	cont=1
	while cont<=4 do
		bomba_index="bomba"..cont
		bomba_pino=pino[bomba_index]
		p=bomba_pino.."000"
		com(fn,p)
		cont=cont+1
	end

	-- desliga todos os leds
	escreve_i_led(1,0)
	escreve_i_led(2,0)
	escreve_i_led(3,0)
	escreve_i_led(4,0)

	-- desliga os coolers
	escreve_coolers(0)
end	


function init_hard()
	escreve_coolers(1)
	--print("coolers :"..le_coolers())
	
	escreve_i_led(1,255)
	--tmr.delay(1000000*2)
	escreve_i_led(2,255)
	--tmr.delay(1000000*2)
	escreve_i_led(3,255)
	--tmr.delay(1000000*2)
	escreve_i_led(4,255)
	
	--print("i_led1: "..le_i_led(1))
	--print("i_led2: "..le_i_led(2))
	--print("i_led3: "..le_i_led(3))
	--print("i_led4: "..le_i_led(4))
end
]]


