from collective_client import CollectiveClient
import json
import numpy as np

print('Collective CLI Version 0.1.0')
print('Type "connect" to perform actions on an external server')

client = CollectiveClient('localhost', 31512)

def get_ndarray():
    input_str = ''
    first = True
    while True:
        latest = input()
        input_str += latest
        if first and len(input_str) == 0:
            break
        if len(input_str) > 0 and input_str[-1] == ';':
            input_str = input_str[:-1]
            break
        first = False
    if len(input_str) == 0:
        return np.zeros(0)
    arr = json.loads(input_str)
    return np.array(arr)


while True:
    cmd = input('> ').lower()
    if cmd == 'connect':
        host = 'localhost'
        port = 31512
        while True:
            try:
                host = input('Host: ')
                port = int(input('Port (31512): ') or 31512)
                break
            except:
                continue
        client = CollectiveClient(host, port)
    elif cmd == 'exit':
        exit(0)
    else:
        arr = get_ndarray()
        res, body = client.execute_command(cmd, arr)
        if res == b'false':
            print('Error processing or unrecognized command')
        elif res != b'true':
            print('Response: %s' % res)
            print(body)
        else:
            print(body)
