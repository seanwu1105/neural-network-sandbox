import abc


class Observer(abc.ABC):

    @abc.abstractmethod
    def update(self):
        pass


class Observable(abc.ABC):

    @abc.abstractmethod
    def notify(self):
        pass
