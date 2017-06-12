from generator import Generator
import random
from datetime import datetime

class LinuxGenerator(Generator):
    def __init__(self, file_path):
        Generator.__init__(self, file_path)
        self.logs = []
        random.seed(43)
        self.get_log_samples()

    def get_log_samples(self):
        with open('samples/linux_samples.txt', 'r') as f:
            for row in f:
                self.logs.append(row)

    def generate_log_row(self):
        log = random.choice(self.logs)
        log = log.strip()
        new_log = ""
        new_log += datetime.now().strftime('%b %d %H:%M:%S ')
        new_log += " ".join(log.split()[3:])
        return new_log
