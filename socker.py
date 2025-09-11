import socket

def client():
    host = socket.gethostname()
    port = 1234
    client_socket = socket.socket()
    client_socket.connect((host, port))

    n = int(input("Enter Number of Packets: "))
    prompt = "Enter Packet of Data: "
    
    for _ in range(n):
        data = input(prompt)
        client_socket.send(data.encode())
        ack = client_socket.recv(1024).decode()
        if ack == "Not Received":
            prompt = "Data not received! Resend the previous data: "
        else:
            prompt = "Enter Packet of Data: "
        print(ack)

    client_socket.close()

client()
