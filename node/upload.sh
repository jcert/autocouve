fol_n=${PWD##*/} #folder name

rm -r ../tmp
mkdir ../tmp
cp -r * ../tmp/.

cd ../tmp

(cat ../$fol_n.prepend init.lua) > init1.lua
mv init1.lua init.lua
# script to upload files to nano
nodemcu-uploader upload init.lua main_loop.lua wifi.lua com.lua hard.lua mqtt.lua aux.lua
