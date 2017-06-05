from generator import Generator
import random
from datetime import datetime

class AppGenerator(Generator):
    def __init__(self, file_path, waiting):
        Generator.__init__(self, file_path, waiting)
        self.authorities=["ROLE_ADMIN", "COMPANY_ADVERTISER", "PRIVATE_ADVERTISER", "CUSTOMER", "VERIFIER"]
        self.usernames = ["pera", "marko", "bob", "admin"]
        random.seed(43)

    def get_logging_log(self):
        if random.randrange(0, 2):
            return "INFO r.a.u.f.c.UserJWTController:70 - User " + random.choice(self.usernames) + " succesfully logged in with authorities: [" + random.choice(self.authorities) + "]."
        else:
            return "INFO r.a.u.f.c.UserJWTController:72 - User " + random.choice(self.usernames) + " failed to log in." 

    def generate_log_row(self):
        possible_logs = [self.get_logging_log]
        return datetime.now().strftime('%Y-%m-%d %H:%M:%S') +  " " + random.choice(possible_logs)()