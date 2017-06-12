import threading
import sys
import time

class LogGenerator:
    def __init__(self, sleep = 1):
        self.generators = []
        self.sleep = sleep

    def add_generator(self, generator):
        self.generators.append(generator)

    def generate(self):
        while True:
          time.sleep(self.sleep)
          for gen in self.generators:
              gen.generate()


class Generator:
    def __init__(self, file_path):
        self.file_path = file_path

    def generate(self):
        with open(self.file_path, 'a') as f:
          log = self.generate_log_row()
          print (log)
          f.write(log + '\n')
        print("Writing content to file: {}".format(self.file_path))

    def generate_log_row(self):
        raise NotImplementedError("Please Implement this method")
