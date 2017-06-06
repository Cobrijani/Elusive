from generator import Generator
import random
from datetime import datetime

class AppGenerator(Generator):
    def __init__(self, file_path, waiting):
        Generator.__init__(self, file_path, waiting)
        self.authorities_reg=["ROLE_ADMIN", "ROLE_COMPANY_ADVERTISER", "ROLE_PRIVATE_ADVERTISER", "ROLE_USER", "ROLE_VERIFIER"]
        self.authorities=["ROLE_ADMIN", "ROLE_COMPANY_ADVERTISER", "ROLE_PRIVATE_ADVERTISER", "ROLE_USER", "ROLE_VERIFIER", "ROLE_ANONYMOUS"]
        self.usernames = ["pera", "marko", "bob", "admin"]
        self.entities = ["Company, PrivateAdvert, CompanyAdvert"]
        with open('app_error_stacktrace', 'r') as content_file:
            stacktrace = content_file.read()
        self.stack_traces = [stacktrace]
        random.seed(43)

    def get_logging_log(self):
        if random.randrange(0, 2):
            return "INFO r.a.u.f.c.UserJWTController:70 - User " + random.choice(self.usernames) + " succesfully logged in with authorities: [" + random.choice(self.authorities_reg) + "]."
        else:
            return "WARN r.a.u.f.c.UserJWTController:72 - User " + random.choice(self.usernames) + " failed to log in."

    def get_registration_log(self):
        return "INFO r.a.u.f.c.UserController:97 - New User with username "+random.choice(self.usernames)+" has been registered as "+ random.choice(self.authorities_reg) +"."
    
    def get_not_found_exception_log(self):
        entity = random.choice(self.entities)
        return "INFO r.a.u.f.c."+entity+"Controller:70 - "+entity+" with id "+random.randrange(10000000, 99999999)+" not found.
    
    def get_error_log(self):
        entity = random.choice(self.entities)
        return "ERROR r.a.u.f.c."+entity+"Controller:"+str(random.randrange(20, 2000))+" - "+random.choice(self.stack_traces)+"

    def generate_log_row(self):
        possible_logs = [self.get_logging_log, self.get_registration_log, self.get_not_found_exception_log]
        return datetime.now().strftime('%Y-%m-%d %H:%M:%S') +  " " + random.choice(possible_logs)()