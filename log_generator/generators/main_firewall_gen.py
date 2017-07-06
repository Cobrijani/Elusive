from generators.generator import Generator
import datetime
import numpy
import random
from faker import Faker
from tzlocal import get_localzone


class MainFirewallGen(Generator):
  def __init__(self, file_path):
    Generator.__init__(self, file_path)
    self.actions = ["ALLOW", "DROP", "REJECT"]
    self.protocols = ["TCP", "UDP", "ICMP", "ICMPv6"]
    self.tcp_flags = ["Ack", "Fin", "Psh", "Rst", "Syn", "Urg", "-"]
    self.paths = ["SEND", "RECEIVE"]
    self.faker = Faker()

    self.allowedPorts = [0, 3, 7, 14, 18]
    self.allowedIps = ["179.56.180.34",
                       "200.212.60.122",
                       "14.239.240.22",
                       "72.191.193.38",
                       "121.126.201.93",
                       "225.226.62.0"]

  def get_rand(self, num_from, num_to, optional=False):
    rand_num = random.randrange(num_from, num_to)
    if not optional:
      return str(rand_num)
    return random.choice([str(rand_num), "-"])

  def generate_log_row(self):
    src_ip = numpy.random.choice(self.allowedIps + [self.faker.ipv4()])
    dst_ip = numpy.random.choice(self.allowedIps + [self.faker.ipv4()])
    dt = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    action = numpy.random.choice(self.actions, p=[0.4, 0.3, 0.3])
    protocol = numpy.random.choice(self.protocols, p=[0.3, 0.3, 0.2, 0.2])
    tcp_f = random.choice(self.tcp_flags)
    path = random.choice(self.paths)

    src_port = numpy.random.choice(self.allowedPorts + [self.get_rand(0, 20)])
    dst_port = numpy.random.choice(self.allowedPorts + [self.get_rand(0, 20)])

    return '{} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {}'.format(
      dt,
      action,
      protocol,
      src_ip,
      dst_ip,
      src_port,
      dst_port,
      self.get_rand(0, 20, True),
      tcp_f,
      self.get_rand(0, 20, True),
      self.get_rand(0, 20, True),
      self.get_rand(0, 20, True),
      self.get_rand(0, 20, True),
      self.get_rand(0, 20, True),
      self.get_rand(0, 20, True),
      path
    )
