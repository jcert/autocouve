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
pino["bomba2"]="04" 		-- digital
pino["bomba3"]="07" 		-- digital
pino["bomba4"]="08" 		-- digital
pino["i_led1"]="03"		-- pwm
pino["i_led2"]="05"		-- pwm
pino["i_led3"]="06"		-- pwm
pino["i_led4"]="09"		-- pwm
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
	tmr.delay(tempo*1000000)
	p=bomba_pino.."000"
	com(fn,p)
end

function le_bomba(vaso_id)
	bomba_index="bomba"..vaso_id
	bomba_pino=pino[bomba_index]
	fn=funcao_cod["DI"]
	p=bomba_pino
	com(fn,p)
end

function le_umid_vaso(vaso_id)
	umid_vaso_index="umid_vaso"..vaso_id
	umid_vaso_pino=pino[umid_vaso_index]
	fn=funcao_cod["AI"]
	p=umid_vaso_pino
	com(fn,p)
end

function escreve_i_led(led_id,valor)
	i_led_index="i_led"..led_id
	i_led_pino=pino[i_led_index]
	fn=funcao_cod["PWM"]
	p=i_led_pino..valor
	com(fn,p)
end

function le_i_led(led_id)
	i_led_index="i_led"..i_led_id
	i_led_pino=pino[i_led_index]
	fn=funcao_cod["AI"]
	p=i_led_pino
	com(fn,p)
end

function le_t_led(led_id)
	t_led_index="t_led"..t_led_id
	t_led_pino=pino[t_led_index]
	fn=funcao_cod["AI"]
	p=t_led_pino
	com(fn,p)
end

function escreve_coolers(valor)
	coolers_pino=pino["coolers"]
	fn=funcao_cod["DO"]
	valor_formatado=string.format("%03d",valor)
	p=coolers_pino..valor_formatado
	com(fn,p)
end

function le_coolers()
	coolers_pino=pino["coolers"]
	fn=funcao_cod["DI"]
	p=coolers_pino
	com(fn,p)
end

function le_nivel_reserv(reserv_id)
	nivel_reserv_index="nivel_reserv"..reserv_id
	nivel_reserv_pino=pino[nivel_reserv_index]
	fn=funcao_cod["DI"]
	p=nivel_reserv_pino
	com(fn,p)
end





