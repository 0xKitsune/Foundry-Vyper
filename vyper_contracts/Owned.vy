
owner: public(address)

event OwnerChanged:
    oldOwner: indexed(address)
    newOwner: indexed(address)

@external
@payable
def __init__():
    self.owner = msg.sender
    log OwnerChanged(ZERO_ADDRESS, msg.sender)

@external
def setOwner(newOwner: address) -> None:
    assert msg.sender == self.owner, "InvalidCaller"
    log OwnerChanged(self.owner, newOwner)
    self.owner = newOwner