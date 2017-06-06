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
        with open(self.file_path, 'a') as f:
            log = self.generate_log_row()
            print log
            f.write(log + '\n')
        print("Writing content to file: {}".format(self.file_path))
        threading.Timer(self.waiting, self.generate).start()

    def generate_log_row(self):
        raise NotImplementedError("Please Implement this method")
