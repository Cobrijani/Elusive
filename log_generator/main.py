from firewall_generator import FirewallGenerator
from apache_generator import ApacheGenerator
from app_generator import AppGenerator
from generator import LogGenerator
import sys

log_out = './../test_logs'

if __name__ == '__main__':
    if len(sys.argv) == 1:
        file_firewall = log_out + '/firewall/firewall.log'
        file_apache = log_out + '/apache/apache.log'
        file_app = log_out + '/application/app.log'
    else:
        file_firewall = sys.argv[1]
        file_apache = sys.argv[2]
        file_app = sys.argv[3]

    lg = LogGenerator()
    lg.add_generator(FirewallGenerator(file_firewall, 0.5))
    lg.add_generator(ApacheGenerator(file_apache, 0.5))
    lg.add_generator(AppGenerator(file_app, 0.5))
    lg.generate()