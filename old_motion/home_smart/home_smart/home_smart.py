# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
from device import Device
from device_tplink_outlet import DeviceTplinkOutlet

if __name__ == "__main__":
    # network_device = Device()
    # network_device.search_udp()

    tplink = DeviceTplinkOutlet()
    tplink.switch_off()