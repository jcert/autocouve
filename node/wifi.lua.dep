enduser_setup.start(
  function()
    print("Connected to wifi as:") -- .. wifi.sta.getip()) se chamar isso aqui, ainda não vai ter ip, daí dá crash por concatenar string .. nil
    local m = tmr.create()
    m:alarm(5000, tmr.ALARM_SINGLE, function() sntp.sync(nil, nil, nil, 1) end)
  end,
  function(err, str)
    print("enduser_setup: Err #" .. err .. ": " .. str)
  end
);



