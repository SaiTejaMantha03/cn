import socket
import time

def server():
    host = socket.gethostname()
    port = 1234
    s = socket.socket()
    s.bind((host, port))
    s.listen(1)
    conn, addr = s.accept()
    print("Connection from:", addr)

    count = 1
    while True:
        data = conn.recv(1024).decode()
        if not data:
            break
        if count % 4 == 0:
            count += 1
            time.sleep(2)
            conn.send("Not Received".encode())
            continue
        print("Received data:", data)
        response = "Data received: " + data
        conn.send(response.encode())
        count += 1

    conn.close()

server()
