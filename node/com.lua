-- comunicacao com o nano
-- baseado no protocolo do jair

-- i2c setup
-- id:0
-- SDA: pino 5
-- SCL: pino 6
-- endereco do nano 0x8
id=0
nano_addr=8
i2c.setup(id,5,6,i2c.SLOW)

function pedir_status()
--pedir T_led1 READ.C.XX com("5","CXX")
--pedir T_led2 READ.C.XX
--pedir T_led3 READ.C.XX
--pedir T_led4 READ.C.XX

--pedir i_led1 READ.P.XX
--pedir i_led2 READ.P.XX
--pedir i_led3 READ.P.XX
--pedir i_led4 READ.P.XX

--pedir Umid_v1 READ.C.XX
--pedir Umid_v2 READ.C.XX
--pedir Umid_v3 READ.C.XX
--pedir Umid_v4 READ.C.XX

--pedir Cooler READ.C.XX

--pedir Reservatorio READ.C.XX

end

--descrição dos possíveis 'fn' - funções do arduino slave
--"NOME"-"0" "PWM"-"1" "AI"-"2" "DO"-"3" "DI"-"4" "READ"-"5" "HELP"-"6"

--descrição dos possíveis 'p' - pinos do arduino slave
--concatenar o valor a ser passado para a função, ex: PWM.09.200 ou READ.C.07
--bomba1 02 digital	bomba2 07 digital	bomba3 04 digital	bomba4 08 digital 
--i_led1 09 pwm		i_led2 05 pwm 		i_led3 06 pwm		i_led4 03 pwm 	
--coolers 12 digital	
--t_led1 00 analogica	t_led2 01 analogica 	t_led3 02 analogica	t_led4 03 analogica	
--umid_vaso1 06 analogica 	umid_vaso2 07 analogica 
--nivel_reserv1 10 digital 	nivel_reserv2 11 digital


function com(fn,p)
	-- send request to nano
	i2c.start(id)
	i2c.address(id,nano_addr,i2c.TRANSMITTER)
	message="&"..fn..p.."!"
	i2c.write(id,message)
	i2c.stop(id) --precisa parar entre as transmissões?

	-- receive answer
	i2c.start(id)
	i2c.address(id,nano_addr,i2c.RECEIVER)
	received=i2c.read(id,10)
	i2c.stop(id)

	received3=string.sub(received,1,3)
	if received3=="ACK" then
		-- received ack
		print("i2c: recebeu ACK")
		return "ACK"
	else
		-- received data
		received6=string.sub(received,1,6)
		last_index=1
		buff=tohex(string.sub(received6,last_index,last_index))
		
		while buff~="FF" do
			last_index=last_index+1
			buff=tohex(string.sub(received6,last_index,last_index))
		end
		last_index=last_index-1

		received=string.sub(received6,1,last_index)
		
		return received
	end
end

function com_test()
	com("0","")
	com("1","06111")
	com("2","01")
	com("3","02001")
	com("4","03")
	com("5","C1")
	com("6","")
end
