from generator import Generator
import datetime
import numpy
import random
from faker import Faker
from tzlocal import get_localzone


class MainApacheGen(Generator):
  def __init__(self, file_path):
    Generator.__init__(self, file_path)
    self.logs = []

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

    self.resources = ["/bank",
                      "/bank/account",
                      "/bank/account/balance?acc-id=",
                      "/bank/login",
                      "/bank/account/withdraw?acc-id=",
                      "/bank/account/payments?acc-id=",
                      "/bank/account/deposit?acc-id=",
                      "/bank/account/account-security?acc-id="]

    self.ualist = [self.faker.firefox,
                   self.faker.chrome,
                   self.faker.safari,
                   self.faker.internet_explorer,
                   self.faker.opera]

  def generate_log_row(self):
    ip = self.faker.ipv4()
    dt = datetime.datetime.now().strftime('%d/%b/%Y:%H:%M:%S')
    tz = datetime.datetime.now(self.local).strftime('%z')
    vrb = numpy.random.choice(self.verb, p=[0.6, 0.1, 0.1, 0.2])
    uri = random.choice(self.resources)
    if uri.find("?acc-id=") > 0:
      uri += `random.randint(1000, 10000)`

    resp = numpy.random.choice(self.response, p=[0.9, 0.02, 0.02, 0.02, 0.02, 0.02])
    byt = int(random.gauss(5000, 50))
    referer = self.faker.uri()
    useragent = numpy.random.choice(self.ualist, p=[0.5, 0.3, 0.1, 0.05, 0.05])()

    return '{} - - [{} {}] "{} {} HTTP/1.0" {} {} "{}" "{}"\n'.format(ip, dt, tz, vrb, uri, resp, byt, referer,
                                                                      useragent)
