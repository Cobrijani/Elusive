from generator import Generator
import random
from datetime import datetime

class FirewallGenerator(Generator):
    def __init__(self, file_path):
        Generator.__init__(self, file_path)
        self.actions = ["ALLOW", "DROP", "REJECT"]
        self.protocols = ["TCP", "UDP", "ICMP", "ICMPv6"]
        self.tcp_flags = ["Ack", "Fin", "Psh", "Rst", "Syn", "Urg", "-"]
        self.paths = ["SEND", "RECEIVE"]
        self.ip_adresses = "89.216.18.1,89.216.18.2,89.216.18.3,89.216.18.4,89.216.18.5,89.216.18.6,89.216.18.7,89.216.18.8,89.216.18.9,89.216.18.10,89.216.18.11,89.216.18.12,89.216.18.13,89.216.18.14,89.216.18.15,89.216.18.16,89.216.18.17,89.216.18.18,89.216.18.19,89.216.18.20"
        self.ip_adresses = self.ip_adresses.split(",")
        random.seed(43)

    def get_rand(self, num_from, num_to, minus = False):
        rand_num =  random.randrange(num_from, num_to)
        if not minus:
            return str(rand_num)
        return random.choice([str(rand_num), "-"])

    def get_ip(self):
        return random.choice(self.ip_adresses)

    def generate_log_row(self):
        return datetime.now().strftime('%Y-%m-%d %H:%M:%S') +  " " + \
                random.choice(self.actions) + " " + random.choice(self.protocols) + " " + \
                self.get_ip() + " " + self.get_ip() + " " + self.get_rand(0, 20) + " " + \
                self.get_rand(0, 20) + " " + self.get_rand(0, 20, True) + " " + \
               random.choice(self.tcp_flags) + " " + self.get_rand(0, 20, True) + " " + \
               self.get_rand(0, 20, True) + " " + self.get_rand(0, 20, True) + " " + \
               self.get_rand(0, 20, True) + " " + self.get_rand(0, 20, True) + " " + \
               self.get_rand(0, 20, True) + " " + random.choice(self.paths)
