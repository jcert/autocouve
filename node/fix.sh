# script that erases the node memory and flashes a new firmware to it

# esptool.py can be installed in the following manner
#pip3 install esptool
#sudo usermod -a -G dialout ${whoami}

esptool.py --port /dev/ttyUSB0 erase_flash
esptool.py --port /dev/ttyUSB0 write_flash 0x00000 nodemcu-master-9-modules-2018-06-30-16-50-13-float.bin
