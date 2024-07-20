
val: uint256

@external
@payable
def __init__():
    self.val = msg.value

@external
def get() -> uint256:
    return self.val
