import socket
import sys
import threading

BUFFER_SIZE = 4096

def echo(conn, addr):
    print('Server echoing {}.'.format(addr))
    while True:
        data = conn.recv(BUFFER_SIZE)
        if not data:
            return
        print('[{}] {}'.format(addr, data))
        conn.send(data)

def main():
    if len(sys.argv != 1):
        print('Usage: python server.py <port>')
        sys.exit(1)
    port = int(sys.argv[0])

    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    addr = ('localhost', port)
    sock.bind(addr)
    sock.listen(10)

    print('Server listening on {}.'.format(addr))
    while True:
        conn, addr = sock.accept()
        threading.Thread(target=echo, args=[conn, addr]).start()

if __name__ == '__main__':
    main()
