import socket
import argparse
# import requests


class DeviceTplinkOutlet:
    device_ip = '10.0.0.46'
    service_port = 9999
    # service_url = 'http://' + device_ip + ':' + str(service_port)
    headers = {'Content-type': 'application/json', 'Accept': 'text/plain'}
    # Predefined Smart Plug Commands
    # For a full list of commands, consult tplink_commands.txt
    commands = {'info': '{"system":{"get_sysinfo":{}}}',
                'on': '{"system":{"set_relay_state":{"state":1}}}',
                'off': '{"system":{"set_relay_state":{"state":0}}}',
                'cloudinfo': '{"cnCloud":{"get_info":{}}}',
                'wlanscan': '{"netif":{"get_scaninfo":{"refresh":0}}}',
                'time': '{"time":{"get_time":{}}}',
                'schedule': '{"schedule":{"get_rules":{}}}',
                'countdown': '{"count_down":{"get_rules":{}}}',
                'antitheft': '{"anti_theft":{"get_rules":{}}}',
                'reboot': '{"system":{"reboot":{"delay":1}}}',
                'reset': '{"system":{"reset":{"delay":1}}}'
                }

    def switch_off(self):
        cmd_json = '{"system":{"set_relay_state":{"state":0}}}'
        self.send_cmd(cmd_json)

    def switch_on(self):
        cmd_json = '{"system":{"set_relay_state":{"state":1}}}'
        self.send_cmd(cmd_json)

    def send_cmd(self, json):
        # r = requests.post(self.service_url, data=json, headers=self.headers)
        print('trying')
        # https://github.com/softScheck/tplink-smartplug/blob/master/tplink-smartplug.py
        try:
            cmd = self.commands['off']

            sock_tcp = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            # with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock_tcp:
            sock_tcp.settimeout(15)
            sock_tcp.connect((self.device_ip, self.service_port))
            # sock_tcp.create_connection(self.device_ip + str(self.service_port), 15)
            sock_tcp.send('HTTP/1.0 200 OK\r\n'.encode('utf-8'))
            sock_tcp.send("Content-Type: application/json\r\n\r\n".encode('utf-8'))
            # sock_tcp.send("Accept: text/plain\r\n\r\n".encode('utf-8'))
            # sock_tcp.send(self.encrypt(json).encode('utf-8'))
            # sock_tcp.send(self.encrypt(cmd))
            sock_tcp.send(cmd.encode('utf-8'))
            data = sock_tcp.recv(2048)
            sock_tcp.close()

            # print("Sent:     ", self.encrypt(json))
            print("Sent:     ", cmd)
            # print("Received: ", self.decrypt(data[4:]))
            print(data)
        except socket.error:
            quit("Cound not connect to host " + self.device_ip + ":" + str(self.service_port))
        return True

    # Encryption and Decryption of TP-Link Smart Home Protocol
    # XOR Autokey Cipher with starting key = 171
    def encrypt(self, string):
        key = 171
        result = "\0\0\0\0"
        for i in string:
            a = key ^ ord(i)
            key = a
            result += chr(a)
        return result

    def decrypt(self, string):
        key = 171
        result = ""
        for i in string:
            a = key ^ ord(i)
            key = ord(i)
            result += chr(a)
        return result