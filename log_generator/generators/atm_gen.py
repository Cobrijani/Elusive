from generators.generator import Generator
import numpy as np
import random
from datetime import datetime


class AtmGen(Generator):
  def __init__(self, file_path):
    Generator.__init__(self, file_path)

    self.atm_ids = ['atm-1', 'atm-2', 'atm-3', 'atm-4', 'atm-5']
    self.credit_cards = ['kartica-1', 'kartica-2', 'kartica-3', 'kartica-4', 'kartica-5']
    self.combination_table = {
      'kartica-1': [self.atm_ids[0]],
      'kartica-2': [self.atm_ids[1]],
      'kartica-3': [self.atm_ids[2]],
      'kartica-4': [self.atm_ids[3]],
      'kartica-5': self.atm_ids
    }

    self.withdraw_amount = random.randrange(500, 20000, 500)

    self.logs = [self.__create_limit_reached_log, self.__create_with_draw_log]

  def __generate_combination(self):
    credit_card = np.random.choice(self.credit_cards)
    atm = np.random.choice(self.combination_table[credit_card])
    withdraw = np.random.choice(self.withdraw_amount)

    return credit_card, withdraw, atm

  def __create_with_draw_log(self):
    c, w, d = self.__generate_combination()
    return 'INFO r.a.u.f.c.AtmService:200 - Credit card: {}, withdraw amount: {}, ATM id: {}, result: Success!'.format(
      c,
      w,
      d
    )

  def __create_limit_reached_log(self):
    c, w, d = self.__generate_combination()
    return 'WARN r.a.u.f.c.AtmService:60 - Credit card: {}, withdraw amount: {}, ATM id: {}, result: Limit reached!'.format(
      c,
      w,
      d
    )

  def generate_log_row(self):
    dt = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    log = np.random.choice(self.logs, p=[0.2, 0.8])

    return "{} {}".format(
      dt,
      log()
    )
