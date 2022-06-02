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

    function setUp() public {

        ///@notice deploy a new instance of ISimplestore by passing in the address of the deployed Vyper contract
        simpleStore = ISimpleStore(vyperDeployer.deployContract("SimpleStore"));
    }

    function testGet() public {
        simpleStore.get();
    }

    function testStore() public {
        simpleStore.store(482723498134);
    }
}
