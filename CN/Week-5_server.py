import socket
import time

host = socket.gethostname()
port = 1234

s = socket.socket()
s.bind((host, port))
s.listen(1)
print("Server listening on port", port)

conn, addr = s.accept()
print("Connected to:", addr)

count = 1
while True:
    data = conn.recv(1024).decode()
    if not data:
        break

    # Simulate lost packet every 4th message
    if count % 4 == 0:
        time.sleep(2)  # delay to simulate lost packet
        conn.send("Not Received".encode())
    else:
        print("Received:", data)
        conn.send(("Data received: " + data).encode())

    count += 1

conn.close()
s.close()


# import socket

# s=socket.socket()
# host = socket.gethostname()
# port=1234

# s.bind((host,port))

# s.listen(1)

# conn,addr = s.accept()

# count=1

# while True:
#     data=conn.recv(1024).decode()
#     if not data:
#         break
    
#     print("Packet received ", data)

#     conn.send(("Data received: " + data).encode())

# conn.close()
# s.close()
