funcao_cod={}
funcao_cod["NOME"]="0"
funcao_cod["PWM"]="1"
funcao_cod["AI"]="2"
funcao_cod["DO"]="3"
funcao_cod["DI"]="4"
funcao_cod["READ"]="5"
funcao_cod["HELP"]="6"

pino={}
pino["bomba1"]="02" 	-- digital
pino["bomba2"]="04" 	-- digital
pino["bomba3"]="07" 	-- digital
pino["bomba4"]="08" 	-- digital
pino["led1"]="03"	-- pwm
pino["led2"]="05"	-- pwm
pino["led3"]="06"	-- pwm
pino["led4"]="09"	-- pwm
pino["coolers"]="12"	-- digital


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

function escreve_i_led(led_id,valor)
	led_index="led"..led_id
	led_pino=pino[led_index]
	
	fn=funcao_cod["PWM"]
	
	p=led_pino..valor
	com(fn,p)
end

function escreve_coolers(valor)
	-- valor 1: liga, 0:desliga
	coolers_pino=pino["coolers"]

	fn=funcao_cod["DO"]
	
	valor_formatado=string.format("%03d",valor)
	p=coolers_pino..valor_formatado
	com(fn,p)
end

