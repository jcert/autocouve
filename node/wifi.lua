nos_es_nada = [[enduser_setup.start(
  function()
    print("Connected to wifi as:") -- .. wifi.sta.getip()) se chamar isso aqui, ainda não vai ter ip, daí dá crash por concatenar string .. nil
    local m = tmr.create()
    m:alarm(5000, tmr.ALARM_SINGLE, function() sntp.sync(nil, nil, nil, 1) end)
  end,
  function(err, str)
    print("enduser_setup: Err #" .. err .. ": " .. str)
  end
);
]]


--station_cfg={}
--station_cfg.ssid=ssid
--station_cfg.pwd= pwd
--station_cfg.auto=true
--set = wifi.sta.config(station_cfg)

wifi.setmode(wifi.STATION)

wifi.sta.connect()

function medaip()
print(wifi.sta.getip())
end
