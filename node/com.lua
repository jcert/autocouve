-- comunicacao com o nano
-- baseado no protocolo do jair

-- i2c setup
-- id:0
-- SDA: pino D1
-- SCL: pino D2
-- endereco do nano 0x8
id=0
nano_addr=8
i2c.setup(id,1,2,i2c.SLOW) --pinos foram trocados no layout da placa, por isso troquei no código, será arrumado ná próxima atualização 

--for i=1,10 do
--	print(i,estado[i])
--end
--com("3","10001")

--com("3","03001")
--com("3","05001")
--com("3","06001")
--com("3","09001")


function pedir_status()
estado[1] = com("5","C05") --pedir T_led1 READ.C.05
estado[2] = com("5","C06") --pedir T_led2 READ.C.06
estado[3] = com("5","C07") --pedir T_led3 READ.C.07
estado[4] = com("5","C08") --pedir T_led4 READ.C.08

estado[5] = com("5","P09") --pedir i_led1 READ.P.09
estado[6] = com("5","P05") --pedir i_led2 READ.P.05
estado[7] = com("5","P06") --pedir i_led3 READ.P.06
estado[8] = com("5","P03") --pedir i_led4 READ.P.03

estado[9] = com("5","C03") --pedir Umid_G READ.C.03
estado[10] = com("5","C04") --pedir Temp_G READ.C.04

--estado[11] = com("5","C01") --pedir Umid_v1 READ.C.01
--estado[12] = com("5","C02") --pedir Umid_v2 READ.C.02
--estado[13] = com("5","C05") --pedir Umid_v3 READ.C.XX não existe ainda
--estado[14] = com("5","C05") --pedir Umid_v4 READ.C.XX

estado[15] = com("5","D12") --pedir Cooler READ.D.12

--estado[16] = com("5","C??") --pedir Reservatorio READ.C.10
end

--descrição dos possíveis 'fn' - funções do arduino slave
--"NOME"-"0" "PWM"-"1" "AI"-"2" "DO"-"3" "DI"-"4" "READ"-"5" "HELP"-"6"

----complex read
--usolo1,
--usolo2,
--u,
--t,
--temperatura1,
--temperatura2,
--temperatura3,
--temperatura4

--descrição dos possíveis 'p' - pinos do arduino slave
--concatenar o valor a ser passado para a função, ex: PWM.09.200 ou READ.C.07
--bomba1 02 digital	bomba2 07 digital	bomba3 04 digital	bomba4 08 digital 
--i_led1 09 pwm		i_led2 05 pwm 		i_led3 06 pwm		i_led4 03 pwm 	
--coolers 12 digital	
--t_led1 00 analogica	t_led2 01 analogica 	t_led3 02 analogica	t_led4 03 analogica	
--umid_vaso1 06 analogica 	umid_vaso2 07 analogica 
--nivel_reserv1 10 digital 	nivel_reserv2 11 digital


function com(fn,p)
	--deixar essa função o mais slim possível

	-- send request to nano
	i2c.start(id)
	i2c.address(id,nano_addr,i2c.TRANSMITTER)
	message="&"..fn..p.."!"
	-- i2c.start(0) i2c.address(0,8,i2c.TRANSMITTER) i2c.write(0,"&600000!") i2c.stop(0)
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
