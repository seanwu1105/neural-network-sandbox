import abc

import PyQt5.QtCore
from .observer import Observer


class BridgeProperty(PyQt5.QtCore.pyqtProperty):
    def __init__(self, value, name='', type_=None, notify=None):
        if type_ and notify:
            super().__init__(type_, self.getter, self.setter, notify=notify)
        self.value = value
        self.name = name

    def getter(self, instance=None):
        return self.value

    def setter(self, instance=None, value=None):
        self.value = value
        getattr(instance, f'_{self.name}_prop_signal').emit(value)


class BridgeMeta(type(PyQt5.QtCore.QObject), abc.ABCMeta):
    def __new__(mcs, name, bases, attrs):
        for key in tuple(attrs.keys()):
            # NOTE: To avoid dictionary changed size during iteration causing
            # runtime error, snapshot the keys by saving to tuple at first place.
            if isinstance(attrs[key], BridgeProperty):
                value = attrs[key].value
                signal = PyQt5.QtCore.pyqtSignal(type(value))
                attrs[key] = BridgeProperty(value, key,
                                            _convert2cpp_types(type(value)),
                                            notify=signal)
                attrs[f'_{key}_prop_signal'] = signal
        return super().__new__(mcs, name, bases, attrs)


class Bridge(PyQt5.QtCore.QObject, Observer, metaclass=BridgeMeta):
    pass


def _convert2cpp_types(python_type):
    # XXX: A workaround for PyQt5 5.12.2 not recognizing Python dict.
    if python_type == dict:
        return 'QVariantMap'
    return python_type
