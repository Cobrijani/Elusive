from generators.generator import Generator
import numpy as np
import random
from datetime import datetime


class AtmGen(Generator):
  def __init__(self, file_path):
    Generator.__init__(self, file_path)

    self.atm_ids = ['atm-1', 'atm-2', 'atm-3', 'atm-4', 'atm-5']
    self.credit_cards = ['kartica-1', 'kartica-2', 'kartica-3', 'kartica-4', 'kartica-5']

    self.withdraw_amount = random.randrange(500, 20000, 500)

    self.logs = [self.__create_limit_reached_log, self.__create_with_draw_log]

  def __create_with_draw_log(self):
    return 'INFO r.a.u.f.c.AtmService:200 - Credit card: {}, withdraw amount: {}, ATM id: {}, result: Success!'.format(
      np.random.choice(self.credit_cards),
      np.random.choice(self.withdraw_amount),
      np.random.choice(self.atm_ids)
    )

  def __create_limit_reached_log(self):
    return 'WARN r.a.u.f.c.AtmService:60 - Credit card: {}, withdraw amount: {}, ATM id: {}, result: Limit reached!'.format(
      np.random.choice(self.credit_cards),
      np.random.choice(self.withdraw_amount),
      np.random.choice(self.atm_ids)
    )

  def generate_log_row(self):
    dt = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    log = np.random.choice(self.logs, p=[0.2, 0.8])

    return "{} {}".format(
      dt,
      log()
    )
