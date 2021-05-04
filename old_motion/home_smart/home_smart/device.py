# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
import socket
import time


class Device:
    udp_broadcast_address = "239.255.255.250"
    udp_broadcast_port = "1900"
    ssd_search_message = \
    'M-SEARCH * HTTP/1.1\r\n' \
    'HOST:' + udp_broadcast_address + ':' + udp_broadcast_port + '\r\n' \
    'ST:upnp:rootdevice\r\n' \
    'MX:2\r\n' \
    'MAN:"ssdp:discover"\r\n' \
    '\r\n'
    
    def search_udp(self):
        print('called search network')
        # Set up UDP socket
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, socket.IPPROTO_UDP)
        s.settimeout(30)
        s.sendto(self.ssd_search_message.encode('utf-8'), (self.udp_broadcast_address, 1900))

        count = 1
        print(time.strftime("%Y-%m-%d %H:%M:%S"))
        try:
            while True:
                data, addr = s.recvfrom(65507)
                print("count: " + str(count))
                count += 1
                print(addr, data)
        except socket.timeout:
            print(time.strftime("%Y-%m-%d %H:%M:%S") + ": socket timeout exception")
            pass

        print(time.strftime("%Y-%m-%d %H:%M:%S"))
        # return True

