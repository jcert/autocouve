Instruções para upar os codes no nodemcu

1 - Adicionar o PiP no $PATH (Ubuntu 18):
export PATH=~/.local/bin:$PATH
2-Comunicação:
miniterm /dev/ttyUSB0 115200

3- Atualização de firmware:
bash fix.sh

4- Atualização código:
bash upload.sh
