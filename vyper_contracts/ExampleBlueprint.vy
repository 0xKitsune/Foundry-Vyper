
val: uint256

@external
def __init__():
    self.val = 2

@external
def store(_val: uint256):
    self.val = _val

@external
def get() -> uint256:
    return self.val
