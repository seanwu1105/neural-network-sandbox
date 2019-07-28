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
