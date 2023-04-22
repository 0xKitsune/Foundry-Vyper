// SPDX-License-Identifier: MIT
pragma solidity >=0.8.13;

import "../../lib/ds-test/test.sol";
import "../../lib/utils/Console.sol";
import "../../lib/utils/VyperDeployer.sol";

import "../ISimpleStore.sol";

contract SimpleStoreTest is DSTest {
    ///@notice create a new instance of VyperDeployer
    VyperDeployer vyperDeployer = new VyperDeployer();

    ISimpleStore simpleStore;
    ISimpleStore simpleStoreBlueprint;
    ISimpleStoreFactory simpleStoreFactory;

    function setUp() public {
        ///@notice deploy a new instance of ISimplestore by passing in the address of the deployed Vyper contract
        simpleStore = ISimpleStore(vyperDeployer.deployContract("SimpleStore", abi.encode(1234)));

        simpleStoreBlueprint = ISimpleStore(vyperDeployer.deployBlueprint("ExampleBlueprint"));

        simpleStoreFactory = ISimpleStoreFactory(vyperDeployer.deployContract("SimpleStoreFactory"));
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

    function testFactory() public {
        address deployedAddress = simpleStoreFactory.deploy(address(simpleStoreBlueprint));

        ISimpleStore deployedSimpleStore = ISimpleStore(deployedAddress);

        deployedSimpleStore.store(1234);

        uint256 val = deployedSimpleStore.get();

        require(val == 1234);
    }
}
