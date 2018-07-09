# -*- coding: utf-8 -*-
#Script em Python para salvar os dados de um servidor mqtt
"""
Created on Thu Jun 28 20:02:41 2018

@author: luisf
"""
import os, sys
import datetime
import paho.mqtt.client as mqtt


#Evento de conexão
def on_connect(client, userdata, flags, rc):
    #print("Connected with result code "+str(rc))
    # Subscribing in on_connect() means that if we lose the connection and
    # reconnect then subscriptions will be renewed.
    client.subscribe("/estufa1/#")

# Evento: recebimento de mensagem servidor
def on_message(t1, userdata, msg):
    #print(msg.topic+" "+str(msg.payload))
    #salvar caminho
    raiz = os.getcwd()
    #print("Raiz: "+raiz)
    dest = raiz + msg.topic
    #print(dest)

    #split the topic
    topic_split = msg.topic.split('/')
    topic_split = topic_split[1:]

    #get last split to save de
    var_name = topic_split[-1]

    #Cria caminho para os diretórios
    for i in topic_split:
        #print('pwd i',os.getcwd())
        try:
            #print('making ',i)
            #cria direttório
            os.mkdir(i)
        #se erro: ignora
        except OSError :
            pass
        #muda o dietório para o caminho especificado no tópico
        os.chdir(i)

    os.chdir(raiz)
    #print(os.getcwd(),"asdasdsdsadasd____",dest + '/'+var_name+'.csv','a+')

    #hora e data
    agora = datetime.datetime.now()

    #salva dado recebido na memómria e grava no arquivo
    var = str(msg.payload)
    #grava data e hora no dado recebido
    var = var + agora.strftime(";%H:%M:%S;%d/%m/%Y")
    file = open(dest + '/'+var_name+'.txt','a+')
    file.write(var + '\n')
    file.close()





#print('---------Inicialização---------')

client = mqtt.Client("blblbadad12232")#must be unique
client.username_pw_set("user", "password")
client.on_connect = on_connect
client.on_message = on_message

client.connect("m12.cloudmqtt.com", 18372, 60)


# Blocking call that processes network traffic, dispatches callbacks and
# handles reconnecting.
# Other loop*() functions are available that give a threaded interface and a
# manual interface.
client.loop_forever()
