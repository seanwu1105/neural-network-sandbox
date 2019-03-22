import threading


class Task(threading.Thread):
    def __init__(self):
        super().__init__()
        self.num = 0

    def run(self):
        for i in range(35):
            self.num = fib(i)


class Derived(Task):
    def __init__(self):
        super().__init__()

    def __setattr__(self, name, value):
        print(name, value)
        super().__setattr__(name, value)


def fib(N):
    if N <= 1:
        return 1
    return fib(N - 1) + fib(N - 2)


def main():
    d = Derived()
    d.start()
    d.join()


if __name__ == '__main__':
    main()
