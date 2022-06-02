# Foundry x Vyper

A Foundry template to compile and test Vyper Contracts.

```
██    ██ ██    ██ ██████  ███████ ██████  
██    ██  ██  ██  ██   ██ ██      ██   ██ 
██    ██   ████   ██████  █████   ██████  
 ██  ██     ██    ██      ██      ██   ██ 
  ████      ██    ██      ███████ ██   ██ 

  ```

## Installation / Setup

To set up Foundry x Vyper, first make sure you have [Vyper](https://vyper.readthedocs.io/en/stable/installing-vyper.html) installed.

Then set up a new Foundry project with the following command (replacing `vyper_project_name` with your new project's name).

```
forge init --template https://github.com/0xKitsune/Foundry-Vyper vyper_project_name
```

Now you are all set up and ready to go! Below is a quick example of how to set up, deploy and test Vyper contracts.
<br>

## Compiling/Testing Vyper Contracts

In order to compile and test Vyper contracts with Foundry, there are two simple steps. First make sure to put your `.vy` files in the directory named vyper_contracts`. This way, the Vyper compiler will know where to look when compiling your contracts.

Next, you will need to create an interface for your contract. This will allow Foundry to interact with your Vyper contract, enabling the full testing capabilities that Foundry has to offer.

Once you have an interface set up for your contract, you are ready to use the VyperDeployer!

The VyperDeployer is a pre-built contract that takes a filename and deploys the corresponding Vyper contract, returning the address that the bytecode was deployed to. If you want, you can check out [how the VyperDeployer works under the hood](https://github.com/0xKitsune/Foundry-Vyper/blob/main/lib/utils/VyperDeployer.sol).

From here, you can simply initialize a new contract through the interface you made and pass in the address of the deployed Vyper contract bytecode. Now your Vyper contract is fully functional within Foundry!

<br>

## Example

Here is a quick example of how to setup and deploy a SimpleStore contract written in Vyper.

Here is the `SimpleStore.vy` file, which should be within the `vyper_contracts` directory.

### SimpleStore.Vyper

```py
# @version ^0.2.0

val: uint256

def store(_val: uint256):
    self.val = _val

def get() -> uint256:
    return self.val

```

Next, here is an example interface for the SimpleStore contract.

### SimpleStore Interface

```js

interface SimpleStore {
    function store(uint256 val) external;
    function get() external returns (uint256);
}
```

Lastly, here is the test file that deploys the Vyper contract and tests its functions.

### SimpleStore Test

```js
import "../../lib/ds-test/test.sol";
import "../../lib/utils/VyperDeployer.sol";

import "../ISimpleStore.sol";

contract SimpleStoreTest is DSTest {
    ///@notice create a new instance of VyperDeployer
    VyperDeployer VyperDeployer = new VyperDeployer();

    ISimpleStore simpleStore;

    function setUp() public {
        ///@notice deploy a new instance of ISimplestore by passing in the address of the deployed Vyper contract
        simpleStore = ISimpleStore(VyperDeployer.deployContract("SimpleStore"));
    }

    function testGet() public {
        simpleStore.get();
    }

    function testStore() public {
        simpleStore.store(482723498134);
    }
}

```

First, the file imports `ISimpleStore.sol` as well as the `VyperDeployer.sol` contract.

To deploy the contract, simply create a new instance of `VyperDeployer` and call `VyperDeployer.deployContract(fileName)` method, passing in the file name of the contract you want to deploy. In this example, `SimpleStore` is passed in to deploy the `SimpleStore.vy` contract. the `deployContract` function compiles the Vyper contract and deploys the newly compiled bytecode, returning the address that the contract was deployed to.

The deployed address is then used to initialize the ISimpleStore interface. Once the interface has been initialized, your Vyper contract can be used within Foundry like any other Solidity contract.

To test any Vyper contract deployed with VyperDeployer, simply run `forge test --ffi`. You can use this command with any additional flags. For example: `forge test --ffi -f <url> -vvvv`.
