# Foundry x Vyper

A Foundry template to compile and test Vyper contracts. 

```

                       ,,,,,,,,,,,,,                        ,,,,,,,,,,,,
                        *********///.         ////        ,//********** 
                         ,****,*//////       //////      //////******.  
                           ****////////    /////////    ////////****    
                            *//////////// /////////// ////////////*     
                              //////////##///////////#(//////////       
                               ////////####(///////(####////////        
                                ,////(#######/////#######(////          
                                  //##########//(##########//           
                                   (###########&###########*            
                                     #########&&&#########              
                                      ######&&&&&&&#####(               
                                        ###&&&&&&&&&###                 
                                         %&&&&&&&&&&&%                  
                                          %&&&&&&&&&.                   
                                            &&&&&&&                     
                                             %&&&*                      
                                               &

  ```

<br>


# Installation / Setup

To set up Foundry x Vyper, first make sure you have [Vyper](https://vyper.readthedocs.io/en/stable/installing-vyper.html) installed.

Then set up a new Foundry project with the following command (replacing `vyper_project_name` with your new project's name).

```
forge init --template https://github.com/0xKitsune/Foundry-Vyper vyper_project_name
```


Now you are all set up and ready to go! Below is a quick example of how to set up, deploy and test Vyper contracts.


<br>
<br>


# Compiling/Testing Vyper Contracts

The VyperDeployer is a pre-built contract that takes a filename and deploys the corresponding Vyper contract, returning the address that the bytecode was deployed to. If you want, you can check out [how the VyperDeployer works under the hood](https://github.com/0xKitsune/Foundry-Vyper/blob/main/lib/utils/VyperDeployer.sol). Below is a quick example of how to setup and deploy a SimpleStore contract written in Vyper.


## SimpleStore.Vyper

Here is a simple Vyper contract called `SimpleStore.Vyper`, which is stored within the `Vyper_contracts` directory. Make sure to put all of your `.Vyper` files in the `Vyper_contracts` directory so that the Vyper compiler knows where to look when compiling.

```py
val: uint256

@external
def store(_val: uint256):
    self.val = _val

@external
def get() -> uint256:
    return self.val

```

<br>


## SimpleStore Interface

Next, you will need to create an interface for your contract. This will allow Foundry to interact with your Vyper contract, enabling the full testing capabilities that Foundry has to offer.

```js

interface SimpleStore {
    function store(uint256 val) external;
    function get() external returns (uint256);
}
```

<br>


## SimpleStore Test

First, the file imports `ISimpleStore.sol` as well as the `VyperDeployer.sol` contract.

To deploy the contract, simply create a new instance of `VyperDeployer` and call `VyperDeployer.deployContract(fileName)` method, passing in the file name of the contract you want to deploy. Additionally, if the contract requires constructor arguments you can pass them in by supplying an abi encoded representation of the constructor arugments, which looks like this `VyperDeployer.deployContract(fileName, abi.encode(arg0, arg1, arg2...))`.

In this example, `SimpleStore` is passed in to deploy the `SimpleStore.vy` contract. The `deployContract` function compiles the Vyper contract and deploys the newly compiled bytecode, returning the address that the contract was deployed to. Since the `SimpleStore.vy` takes one constructor argument, the argument is wrapped in `abi.encode()` and passed to the `deployContract` function as a second argument.

The deployed address is then used to initialize the ISimpleStore interface. Once the interface has been initialized, your Vyper contract can be used within Foundry like any other Solidity contract.

To test any Vyper contract deployed with VyperDeployer, simply run `forge test`. Since `ffi` is set to `true` in the `foundry.toml` file, you can run `forge test` without needing to pass in the `--ffi` flag. You can also use additional flags as you would with any other Foundry project. For example: `forge test -f <url> -vvvv`.

```js
import "../../lib/ds-test/test.sol";
import "../../lib/utils/VyperDeployer.sol";

import "../ISimpleStore.sol";

contract SimpleStoreTest is DSTest {
    ///@notice create a new instance of VyperDeployer
    VyperDeployer vyperDeployer = new VyperDeployer();

    ISimpleStore simpleStore;

    function setUp() public {
        ///@notice deploy a new instance of ISimplestore by passing in the address of the deployed Vyper contract
        simpleStore = ISimpleStore(
            vyperDeployer.deployContract("SimpleStore", abi.encode(1234))
        );
    }

    function testGet() public {
        uint256 val = simpleStore.get();

        require(val == 1234);
    }

    function testStore(uint256 _val) public {
        simpleStore.store(_val);
        uint256 val = simpleStore.get();

        require(_val == val);
    }
}

```


<br>

# Other Foundry Integrations

- [Foundry-Yul+](https://github.com/ControlCplusControlV/Foundry-Yulp) 
- [Foundry-Huff](https://github.com/0xKitsune/Foundry-Huff)
