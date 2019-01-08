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



local no = [[
funcao_cod={}
funcao_cod["NOME"]="0"
funcao_cod["PWM"]="1"
funcao_cod["AI"]="2"
funcao_cod["DO"]="3"
funcao_cod["DI"]="4"
funcao_cod["READ"]="5"
funcao_cod["HELP"]="6"

pino={}
arduino2
pino["bomba1"]="03" 	-- pwm
pino["bomba2"]="05" 	-- pwm
pino["bomba3"]="06" 	-- pwm
pino["bomba4"]="09" 	-- pwm

arduino1
pino["ldr"]="06"      -- analogica
pino["i_led1"]="09"		-- pwm
pino["i_led2"]="06"		-- pwm
pino["i_led3"]="05"		-- pwm
pino["i_led4"]="03"		-- pwm
pino["coolers"]="10"		-- digital
pino["t_led1"]="00"		-- analogica
pino["t_led2"]="01"		-- analogica
pino["t_led3"]="02"		-- analogica
pino["t_led4"]="03"		-- analogica	
pino["umid_vaso1"]="06" 	-- analogica
pino["umid_vaso2"]="07" 	-- analogica
pino["nivel_reserv1"]="10"	-- digital
pino["nivel_reserv2"]="11"	-- digital

]]


local no = ""


