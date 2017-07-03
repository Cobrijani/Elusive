import argparse
import os

from generators.client_apache_gen import ClientApacheGen
from generators.generator import LogGenerator

log_out = './../test_logs'

if __name__ == '__main__':
  parser = argparse.ArgumentParser(__file__, description="Log generator")
  parser.add_argument('-sleep', '-s', help='Sleep this between lines (in seconds)', default=0.5, type=float)

  args = parser.parse_args()

  file_firewall = log_out + '/firewall/firewall.log'
  file_apache = log_out + '/apache/apache.log'
  file_app = log_out + '/application/app.log'
  file_linux = log_out + '/linux/linux.log'

  output_files = [file_apache, file_app, file_firewall, file_linux]
  print("Generator started")
  print("Output locations {}", output_files)

  lg = LogGenerator(sleep=args.sleep)
  # lg.add_generator(FirewallGenerator(file_firewall))
  # lg.add_generator(ApacheGenerator(file_apache))
  # lg.add_generator(AppGenerator(file_app))
  # lg.add_generator(LinuxGenerator(file_linux))

  lg.add_generator(ClientApacheGen(file_apache))

  try:
    lg.generate()
  except KeyboardInterrupt:
    print("Program stop deleting log files")
    for file in output_files:
      if os.path.exists(file):
        os.remove(file)
