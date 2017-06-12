from firewall_generator import FirewallGenerator
from apache_generator import ApacheGenerator
from app_generator import AppGenerator
from linux_generator import LinuxGenerator
from generator import LogGenerator
import sys
import os

log_out = './../test_logs'

if __name__ == '__main__':
    if len(sys.argv) == 1:
        file_firewall = log_out + '/firewall/firewall.log'
        file_apache = log_out + '/apache/apache.log'
        file_app = log_out + '/application/app.log'
        file_linux = log_out + '/linux/linux.log'
    else:
        file_firewall = sys.argv[1]
        file_apache = sys.argv[2]
        file_app = sys.argv[3]
        file_linux = sys.argv[4]

    output_files = [file_apache, file_app, file_firewall, file_linux]
    print("Generator started")
    print("Output locations {}", output_files)

    lg = LogGenerator(sleep = 0.5)
    lg.add_generator(FirewallGenerator(file_firewall))
    lg.add_generator(ApacheGenerator(file_apache))
    lg.add_generator(AppGenerator(file_app))
    lg.add_generator(LinuxGenerator(file_linux))

    try:
      lg.generate()
    except KeyboardInterrupt:
      print("Program stop deleting log files")
      for file in output_files:
        if os.path.exists(file):
          os.remove(file)
