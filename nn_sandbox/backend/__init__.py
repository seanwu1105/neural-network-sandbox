import threading


class Task(threading.Thread):  # this should be totally separated from frontend
    def __init__(self):
        super().__init__()
        self.num = 0

    def run(self):
        for i in range(35):
            self.num = fib(i)


def fib(N):
    if N <= 1:
        return 1
    return fib(N - 1) + fib(N - 2)
