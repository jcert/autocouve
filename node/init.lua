-- main lua script

-- provides a function com(fn,p) to communicate with nano. debug with debug_com()
dofile("com.lua")

-- configure wifi and login
dofile("wifi.lua")

-- interface com o nano
dofile("hard.lua")


-- mqtt 
m = mqtt.Client("clientid",120,"user","pwd")

m:on("connect", function(client) print ("connected") end)
m:on("offline", function(client) print ("offline") end)

m:on("message", function(client, topic, data) 
	print(topic .. ":" ) 
	if data ~= nil then
	print(data)
	end
end)

m:connect("server",18372, 0, function(client)
	print("connected")
	client:subscribe("/estufa1", 0, function(client) print("subscribe success") end)
	client:publish("/estufa1", "hello cabeca", 0, 0, function(client) print("sent") end)
	end,
	function(client, reason)
	print("failed reason: " .. reason)
end)

m:close();





