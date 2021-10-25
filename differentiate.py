def differentiate(f, h=1e-5):
    """
    Returns the derivative of f.
    """
    return lambda x: (f(x + h) - f(x)) / h
