import socket
from sys import platform

HOST = '192.168.15.150' if 'linux' in platform  else 'localhost'   
PORT = 4321  
tcp = socket.socket(socket.AF_INET, socket.SOCK_STREAM) 

def Init():
    orig = (HOST, PORT)
    tcp.bind(orig)
    tcp.listen(5)
    print('Socket::Iniciado', HOST, PORT)



    