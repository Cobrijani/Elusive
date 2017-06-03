from generator import Generator
import random
from datetime import datetime

class FirewallGenerator(Generator):
    def __init__(self, file_path, waiting):
        Generator.__init__(self, file_path, waiting)
        self.actions = ["ALLOW", "DROP", "REJECT"]
        self.protocols = ["TCP", "UDP", "ICMP", "ICMPv6"]
        self.tcp_flags = ["Ack", "Fin", "Psh", "Rst", "Syn", "Urg", "-"]
        self.paths = ["SEND", "RECEIVE"]
        random.seed(43)

    def get_rand(self, num_from, num_to, minus = False):
        rand_num =  random.randrange(num_from, num_to)
        if not minus:
            return str(rand_num)
        return random.choice([str(rand_num), "-"])

    def get_ip(self):
        return self.get_rand(127, 129) + "." + self.get_rand(168, 170) + "." + self.get_rand(0, 4) + "." + self.get_rand(64, 66)

    def generate_log_row(self):
        return datetime.now().strftime('%Y-%m-%d %H:%M:%S') +  " " + \
                random.choice(self.actions) + " " + random.choice(self.protocols) + " " + \
                self.get_ip() + " " + self.get_ip() + " " + self.get_rand(0, 20) + " " + \
                self.get_rand(0, 20) + " " + self.get_rand(0, 20, True) + " " + \
               random.choice(self.tcp_flags) + " " + self.get_rand(0, 20, True) + " " + \
               self.get_rand(0, 20, True) + " " + self.get_rand(0, 20, True) + " " + \
               self.get_rand(0, 20, True) + " " + self.get_rand(0, 20, True) + " " + \
               self.get_rand(0, 20, True) + " " + random.choice(self.paths)