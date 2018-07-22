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

function com(fn,p)
	-- send request to nano
	i2c.start(id)
	i2c.address(id,nano_addr,i2c.TRANSMITTER)
	message="&"..fn..p.."!"
	i2c.write(id,message)
	i2c.stop(id)

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

		--last_index=last_index+1
		--buff=string.sub(received6,last_index,last_index)

		received=string.sub(received6,1,last_index)
		--print("i2c: recebeu valor "..received)
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
