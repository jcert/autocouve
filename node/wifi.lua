-- wifi config
station_cfg={}
station_cfg.ssid = "ssid"
station_cfg.pwd = "pwd"

-- wifi connection
wifi.setmode(wifi.STATION)
wifi.sta.config(station_cfg)
tmr.delay(4000000)
print(wifi.sta.getip())
