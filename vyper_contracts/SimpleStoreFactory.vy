
@external
def deploy(blueprint: address, arg1: uint256) -> address:
    return create_from_blueprint(blueprint, arg1, code_offset=3)
