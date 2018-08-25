fol_n=${PWD##*/} #folder name

rm -r ../tmp
mkdir ../tmp
cp -r * ../tmp/.

cd ../tmp

(cat ../$fol_n.prepend MQTTDatalogger.py) > MQTTDatalogger1.py
cp MQTTDatalogger1.py ../mqtt_log/tmpMQTTDatalogger.py
#no need to compile or upload 
