-- wifi config
station_cfg={}
station_cfg.ssid=""
station_cfg.pwd=""


-- wifi connection
wifi.setmode(wifi.STATION)
wifi.sta.config(station_cfg)
--wifi.sta.autoconnect(1)
