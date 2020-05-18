# Neural Network Sandbox

An assignment collection for course _CE5037 Neural Network_ in National Central University, Taiwan.

## Features

* Back-end completely separates from front-end by `setContextProperty()` and [`BridgeProperty`](./nn_sandbox/bridges/bridge.py)
* Animated Qt Chart in QML.
* Automatically update UI when specific variables in back-end changed.
* Modulized UI components.

> Actually, neural networks are not the point.

## Previews

![perceptron preview](https://i.imgur.com/47GYvuU.gif)

![mlp preview](https://i.imgur.com/bl2NqJr.gif)

![rbfn preview](https://i.imgur.com/PFyYhwb.gif)

![som preview](https://i.imgur.com/IhDmror.gif)

## Introduction to Architecture

I created the toy, Neural Network Sandbox, to explore if I could completely separate business logic (algorithms) from UI with Python and QML. Take [`mlp_algorithm.py`](./nn_sandbox/backend/algorithms/mlp_algorithm.py) for example, the class does not know anything about UI but the users still can interact with it via a QML app.

The QML UI needs to automatically observe some variables in the business logic. Thus, I need to inherit each algorithm with the Observable class. For example, [`ObservableMlpAlgorithm`](./nn_sandbox/bridges/mlp_bridge.py) inherits [`Observable`](./nn_sandbox/bridges/observer.py) and [`MlpAlgorithm`](./nn_sandbox/backend/algorithms/mlp_algorithm.py). Whenever a property has changed in the `MlpAlgorithm`, `ObserableMlpAlgorithm.__setattr__(self, name, value)` would be called. I can know which property has changed with the `name` parameter and notify the `Observer` with its new value.

But who is the observer? The [bridge classes](./nn_sandbox/bridges/bridge.py) are the observer in this scenario. I created the bridge classes (e.g. [`mlp_bridge.py`](./nn_sandbox/bridges/mlp_bridge.py)) containing a list of `BridgeProperty`. When a property has been updated by the observable via `setattr(self, name, value)`, the corresponding (having the same name) `BridgeProperty` will get updated. When a `BridgeProperty` has been updated, its setter method will be called and emit PyQt signal to change QML UI.

In the early version of the project, there is no `BridgeProperty` class. For instance, [the old version of `perceptron_bridge.py`](https://github.com/seanwu1105/neural-network-sandbox/blob/3bfe07ba4db2a3f78a273b94860fabc7cf0df34a/nn_sandbox/frontend/bridges/perceptron_bridge.py) having multiple pyqtProperty and its setter. To make the code cleaner, I have to create these `pyqtProperties` dynamically. `BridgeProperty` and [`BridgeMeta`](./nn_sandbox/bridges/bridge.py) classes solve the problem. You can find more details from [this Stackoverflow answer](https://stackoverflow.com/questions/48425316/how-to-create-pyqt-properties-dynamically/48432653#48432653) about creating `pyqtProperty` dynamically and [this Stackoverflow answer](https://stackoverflow.com/questions/54695976/how-can-i-update-a-qml-objects-property-from-my-python-file/54697414#54697414) about different ways to communicate between QML and Python.

Actually, after I finished the project, I feel it is a little bit over-engineered, and there are still many boilerplates scattering in the project. __My solution to separate business logic (algorithms) from UI is definitely NOT the best way__, which can be further improved. Hence, if you have a better idea about the architecture, feel free to create a pull request.

By the way, as far as I know, the architecture mentioned above cannot be applied to PySide2 currently [due to this issue](https://bugreports.qt.io/browse/PYSIDE-900). I hope the Qt company would provide a cleaner and simpler solution regarding the interaction between Python and QML in [the future (Qt 6)](https://www.qt.io/blog/2019/08/07/technical-vision-qt-6).

## Installation

Clone the project.

``` shell
git clone https://github.com/seanwu1105/neural-network-sandbox
```

Install requirements.

``` shell
pip install -r requirements.txt
```

Start the application.

``` shell
python main.py
```