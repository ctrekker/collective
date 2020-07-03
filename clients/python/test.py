from collective_client import CollectiveClient
import collective_client
import numpy as np
client = CollectiveClient("localhost", 31512)

# cmd = bytearray()
# cmd.append(b"ping\n")

# print(cmd)

arr = np.random.random((5, 5))
print(client.set_buf(1, arr))
print(client.get_buf(1))