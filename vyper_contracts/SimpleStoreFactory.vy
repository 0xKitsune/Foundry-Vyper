
@external
def deploy(blueprint: address) -> address:
    arg1: uint256 = 18
    return create_from_blueprint(blueprint, arg1, code_offset=3)
