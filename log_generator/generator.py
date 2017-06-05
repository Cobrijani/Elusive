import threading

class LogGenerator:
    def __init__(self):
        self.generators = []

    def add_generator(self, generator):
        self.generators.append(generator)

    def generate(self):
        for gen in self.generators:
            gen.generate()


class Generator:
    def __init__(self, file_path, waiting):
        self.file_path = file_path
        self.waiting = waiting

    def generate(self):
        threading.Timer(self.waiting, self.generate).start()
        with open(self.file_path, 'ab') as f:
            log = self.generate_log_row()
            f.write(log + '\n')

    def generate_log_row(self):
        raise NotImplementedError("Please Implement this method")