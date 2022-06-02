# @version ^0.2.0

val: uint256

def store(_val: uint256):
    self.val = _val

def get() -> uint256:
    return self.val
