# script that erases the node memory and flashes a new firmware to it

# esptool.py can be installed in the following manner
#pip3 install esptool
#sudo usermod -a -G dialout ${whoami}

esptool --port /dev/ttyUSB0 erase_flash 
esptool --port /dev/ttyUSB0 write_flash 0x00000 nodemcu-master-12-modules-2019-01-03-19-54-33-float.bin 

