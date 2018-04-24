import socket

BUFFER_SIZE = 4096

def main():
    server_addr = ('localhost', 9000)
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect(server_addr)

    while True:
        sock.send(raw_input('> '))
        print(sock.recv(BUFFER_SIZE))

if __name__ == '__main__':
    main()
