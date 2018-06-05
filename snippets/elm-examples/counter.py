from jinja2 import Template


def main():
    return SomeProcessor(model, view, update)


class Msg:

    Increment = "INCREMENT"
    Decrement = "DECREMENT"


class Model(object):

    def __init__(self, count):
        """Initialize a counter.

        args: count (Int)
        """
        self.count = count


def model():
    """Initializes a new model.

    returns: Model
    """
    return Model(0)


def update(msg, model):
    """Updates a model based off the message and existing model state.

    args: msg (Msg)
          model (Model)

    returns: Model
    """
    if msg == Msg.Increment:
        model.count += 1
    elif msg == Msg.Decrement:
        model.count -= 1

    return model


TEMPLATE = """
<div>
  <button onClick="decrement()">-</button>
  <div>{{ count }}
  <button onClick="increment()">+</button>
</div>
"""


def view(model):
    """Renders our view with our template and the passed in model state.

    args: model (Model)

    returns: String
    """
    template = Template(TEMPLATE)
    return template.render(count=model.count)
