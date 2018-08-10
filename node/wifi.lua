
-- wifi connection
wifi.sta.sethostname("autocouveNODE")
wifi.setmode(wifi.STATION)
wifi.sta.config(station_cfg)
--wifi.sta.autoconnect(1)


local function connection(conn)
  conn:on ("receive",function(sck,req)
    print("request memory:",node.heap())
    print(req)
    
    local _, _, method, path, vars = string.find(req, "([A-Z]+) (.+)?(.+) HTTP");
    if(method == nil)then
        _, _, method, path = string.find(req, "([A-Z]+) (.+) HTTP");
    end
    local _GET = {}
    if (vars ~= nil)then
      for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
          _GET[k] = v
      end
    end
    help_page = [[<!doctype html>
  <html lang="en">
  <head>
    <meta charset="utf-8">
  </head>
  <body>
    <title>Ajuda autocouve</title>
    <meta name="description" content="Access page">
    <meta name="author" content="autocouve">
    ]]
    --hasMQTT = function () return 1 end
    cmd_table = {
        ["restart"] = node.restart,
        ["hasIP"]   = wifi.sta.status,
        ["hasMQTT"] = node.random
      }
    help_page2 = [[</body>]]
    if( _GET["cmd"] ~= nil) then
      print("CMD:",_GET["cmd"])
      local cmd = cmd_table[_GET["cmd"]]--cmd_table[]
      if(cmd) then
        print("FUN:",cmd)
        --manda página de ajuda com os comandos por HTTP        
        sck:on("sent", function(sck) sck:close() end)
        local str = cmd()
        local response = help_page..str..help_page2     
        print(response)
        sck:send(response)
      end
    else
      local t = cmd_table
      local str = ""
      for k,v in pairs(t) do
          str = str.."<p>"..k.." : ".."\n"
      end
      --manda página de ajuda com os comandos por HTTP        
      sck:on("sent", function(sck) sck:close() end)
      local response = help_page..str..help_page2     
      print(response)
      sck:send(response)
    end
    end)
  collectgarbage();
end


local srv=net.createServer(net.TCP) 
srv:listen(80, connection)

