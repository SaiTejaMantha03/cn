import socket

host = socket.gethostname()
port = 1234

s = socket.socket()
s.connect((host, port))

n = int(input("Number of packets: "))

for i in range(n):
    data = input("Enter packet data: ")
    s.send(data.encode())
    
    ack = s.recv(1024).decode()
    
    if ack == "Not Received":
        print("Data not received!! Resend the previous data.")
    else:
        print("Server response:", ack)

s.close()
