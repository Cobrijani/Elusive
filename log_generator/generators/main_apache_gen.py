from generators.generator import Generator
import datetime
import numpy
import random
from faker import Faker
from tzlocal import get_localzone


class MainApacheGen(Generator):
  def __init__(self, file_path):
    Generator.__init__(self, file_path)

    self.faker = Faker()
    self.local = get_localzone()

    self.response = ["200",
                     "404",
                     "500",
                     "301",
                     '401',
                     '403']
    self.verb = ["GET",
                 "POST",
                 "DELETE",
                 "PUT"]

    self.resources = [
      "/bank/account/info?acc-id="
      "/bank/account/balance?acc-id=",
      "/bank/account/withdraw?acc-id=",
      "/bank/account/payments?acc-id=",
      "/bank/account/deposit?acc-id=",
      "/bank/account/account-security?acc-id="]

    self.allowedIps = ["179.56.180.34",
                       "200.212.60.122",
                       "14.239.240.22",
                       "72.191.193.38",
                       "121.126.201.93",
                       "225.226.62.0"]

  def generate_log_row(self):
    ip = numpy.random.choice(self.allowedIps + [self.faker.ipv4()], p=[0.15, 0.15, 0.15, 0.15, 0.15, 0.2, 0.05])
    dt = datetime.datetime.now().strftime('%d/%b/%Y:%H:%M:%S')
    tz = datetime.datetime.now(self.local).strftime('%z')
    vrb = numpy.random.choice(self.verb, p=[0.6, 0.1, 0.1, 0.2])
    uri = random.choice(self.resources)
    if uri.find("?acc-id=") > 0:
      uri += repr(random.randint(1000, 10000))

    resp = numpy.random.choice(self.response, p=[0.9, 0.02, 0.02, 0.02, 0.02, 0.02])
    byt = int(random.gauss(5000, 50))
    referer = '-'
    useragent = '-'

    return '{} - - [{} {}] "{} {} HTTP/1.0" {} {} "{}" "{}"\n'.format(ip, dt, tz, vrb, uri, resp, byt, referer,
                                                                      useragent)
