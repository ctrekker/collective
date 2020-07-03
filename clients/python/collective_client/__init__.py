import socket
import numpy as np
import struct


def read_line(stream):
    buf = b''
    while True:
        c = stream.recv(1)
        if c == b'\n':
            return buf
        else:
            buf += c


def read_array(stream):
    dimensions = int.from_bytes(stream.recv(2), 'little')

    if dimensions == 0:
        return np.zeros(0)
    
    sizes = []
    totalSize = 1
    for i in range(dimensions):
        n = int.from_bytes(stream.recv(8), 'little')
        sizes.append(n)
        totalSize *= n
    
    arr = np.zeros(totalSize)
    
    for i in range(totalSize):
        n = stream.recv(8)
        arr[i] = struct.unpack_from('d', n)[0]

    return arr.reshape(tuple(sizes), order='F')


def write_array(stream, arr):
    stream.send(struct.pack('H', len(arr.shape)))
    for size in arr.shape:
        stream.send(struct.pack('Q', size))
    
    for e in arr.reshape(arr.size, order='F'):
        stream.send(struct.pack('d', e))


class CollectiveClient:
    def __init__(self, host, port):
        self.host = host
        self.port = port
        self.conn = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.conn.connect((host, port))

    def execute_command(self, cmd, body=np.zeros(0)):
        self.conn.send(cmd.encode('ascii'))
        self.conn.send(b'\n')
        write_array(self.conn, body)
        return read_line(self.conn), read_array(self.conn)

    def set_buf(self, buf_id, arr):
        return self.execute_command('set_buf %d' % buf_id, arr)[0]

    def get_buf(self, buf_id):
        return self.execute_command('get_buf %d' % buf_id)[1]

    def save(self, buf_id, name):
        return self.execute_command('save %d %s' % (buf_id, name))[0]

    def load(self, name, buf_id):
        return self.execute_command('load %s %d' % (name, buf_id))[0]

    def del(self, name):
        return self.execute_command('del %s' % name)[0]

    def cat(self, buf_id, name):
        return self.execute_command('cat %d %s' % (buf_id, name))[0]
        