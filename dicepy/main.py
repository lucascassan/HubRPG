import dicereader
import tcpdice
import os

os.system('cls' if os.name == 'nt' else 'clear')
#dicereader.Init()
tcpdice.Init()

while True:
    con, cliente = tcpdice.tcp.accept()
    print ('  Socket::Conectado:', cliente)
    while True:
        msg = con.recv(1024)
        if not msg: break
        print('  Socket::Recebido: ', msg)
        msg = 'dicepy;'+dicereader.Execute()
        con.sendall(msg.encode()) 
        print('  Socket::Resposta:', msg)
    print('  Socket::Encerrado:', cliente)
    con.close()

