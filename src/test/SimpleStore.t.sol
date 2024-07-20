// SPDX-License-Identifier: MIT
pragma solidity >=0.8.13;

import "../../lib/ds-test/test.sol";
import "../../lib/utils/Console.sol";
import "../../lib/utils/VyperDeployer.sol";

import "../ISimpleStore.sol";

contract SimpleStoreTest is DSTest {

    ISimpleStore simpleStore;
    ISimpleStore simpleStorePayable;
    ISimpleStore simpleStoreBlueprint;
    ISimpleStoreFactory simpleStoreFactory;

    function setUp() public {
        ///@notice deploy a new instance of ISimplestore by passing in the address of the deployed Vyper contract
        simpleStore = ISimpleStore(VyperDeployer.deployContract("SimpleStore", abi.encode(1234)));

        simpleStorePayable = ISimpleStore(VyperDeployer.deployContract("SimpleStorePayable", 4321));

        simpleStoreBlueprint = ISimpleStore(VyperDeployer.deployBlueprint("ExampleBlueprint"));

        simpleStoreFactory = ISimpleStoreFactory(VyperDeployer.deployContract("SimpleStoreFactory"));
    }

    function testGet() public {
        uint256 val = simpleStore.get();

        require(val == 1234);
    }

    function testBalance() public {
        uint256 balance = address(simpleStorePayable).balance;
        uint256 val = simpleStorePayable.get();

        require(balance == val);
    }

    function testStore(uint256 _val) public {
        simpleStore.store(_val);
        uint256 val = simpleStore.get();

        require(_val == val);
    }

    function testFactory() public {
        address deployedAddress = simpleStoreFactory.deploy(address(simpleStoreBlueprint), 1354);

        ISimpleStore deployedSimpleStore = ISimpleStore(deployedAddress);

        uint256 val = deployedSimpleStore.get();

        require(val == 1354);

        deployedSimpleStore.store(1234);

        val = deployedSimpleStore.get();

        require(val == 1234);
    }
}
