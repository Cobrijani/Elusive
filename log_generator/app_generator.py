from generator import Generator
import random
from datetime import datetime

class AppGenerator(Generator):
    def __init__(self, file_path):
        Generator.__init__(self, file_path)
        self.authorities_reg=["ROLE_ADMIN", "ROLE_COMPANY_ADVERTISER", "ROLE_PRIVATE_ADVERTISER", "ROLE_USER", "ROLE_VERIFIER"]
        self.authorities=["ROLE_ADMIN", "ROLE_COMPANY_ADVERTISER", "ROLE_PRIVATE_ADVERTISER", "ROLE_USER", "ROLE_VERIFIER", "ROLE_ANONYMOUS"]
        self.usernames = ['marko', 'pera', 'sima', 'admin', 'mika', 'zika', 'misa', 'joca', 'miki', 'ika']
        self.entities = ["Company", "PrivateAdvert", "CompanyAdvert"]
        self.adverts = ["PrivateAdvert", "CompanyAdvert"]
        with open('samples/app_error_stacktrace.txt', 'r') as content_file:
            stacktrace = content_file.read()
        self.stack_traces = [stacktrace]
        random.seed(43)

    def generate_id(self):
        return str(random.randrange(10000000, 99999999))

    def get_username(self):
        return random.choice(self.usernames)+str(random.randrange(1, 5))

    def create_logging_log(self):
        username = self.get_username()
        if random.randrange(0, 2):
            return "INFO r.a.u.f.c.UserJWTController:70 LOGGING "+username+" - User "+username+" succesfully logged in with authority " + random.choice(self.authorities_reg) + "."
        else:
            return "WARN r.a.u.f.c.UserJWTController:72 LOGGING "+username+" - User "+username+" failed to log in."

    def create_registration_log(self):
        username = self.get_username()
        return "INFO r.a.u.f.c.UserController:97 REGISTRATION "+username+" - New user "+username+" has been registered as "+ random.choice(self.authorities_reg) +"."

    def create_not_found_exception_log(self):
        entity = random.choice(self.entities)
        return "ERROR r.a.u.f.c."+entity+"Controller:70 - "+entity+" with id "+self.generate_id()+" not found."

    def create_error_log(self):
        entity = random.choice(self.entities)
        return "ERROR r.a.u.f.c."+entity+"Controller:"+str(random.randrange(20, 2000))+" - "+random.choice(self.stack_traces)

    def get_create_advert_log(self):
        username = self.get_username()
        return "INFO r.a.u.f.c."+random.choice(self.adverts)+"Controller:210 CREATING_ADVERT "+username+" - User "+username+" created an advert with id: "+self.generate_id()+" for realestate with id: "+self.generate_id()+"."

    def create_report_log(self):
        username = self.get_username()
        return "INFO r.a.u.f.c.ReportController:610 CREATING_REPORT "+username+" - User " + username + " created a report for an advert with id: "+self.generate_id()+"."

    def create_edit_profile_log(self):
        username = self.get_username()
        return "INFO r.a.u.f.c.UserController:200 EDITING_PROFILE "+username+" - User "+username+" has edited his profile."

    def generate_log_row(self):
        possible_logs = [self.create_logging_log, self.create_registration_log, self.create_not_found_exception_log, self.create_error_log, self.get_create_advert_log, self.create_report_log]
        return datetime.now().strftime('%Y-%m-%d %H:%M:%S') +  " " + random.choice(possible_logs)()
