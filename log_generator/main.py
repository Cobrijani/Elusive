from firewall_generator import FirewallGenerator
from apache_generator import ApacheGenerator
from generator import LogGenerator
import sys

if __name__ == '__main__':
    if len(sys.argv) == 1:
        file_firewall = 'file_firewall.txt'
        file_apache = 'file_apache.txt'
    else:
        file_firewall = sys.argv[1]
        file_apache = sys.argv[2]

    lg = LogGenerator()
    lg.add_generator(FirewallGenerator(file_firewall, 0.5))
    lg.add_generator(ApacheGenerator(file_apache, 0.5))
    lg.generate()