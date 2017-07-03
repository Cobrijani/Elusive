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

  def get_rand(self, num_from, num_to, minus=False):
    rand_num = random.randrange(num_from, num_to)
    if not minus:
      return str(rand_num)
    return random.choice([str(rand_num), "-"])

  def generate_log_row(self):
    src_ip = self.faker.ipv4()
    dst_ip = self.faker.ipv4()
    dt = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    action = numpy.random.choice(self.actions, p=[0.4, 0.3, 0.3])
    protocol = numpy.random.choice(self.protocols, p=[0.3, 0.3, 0.2, 0.2])
    tcp_f = random.choice(self.tcp_flags)
    path = random.choice(self.paths)

    return '{} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {}'.format(
      dt,
      action,
      protocol,
      src_ip,
      dst_ip,
      self.get_rand(0, 20),
      self.get_rand(0, 20),
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
