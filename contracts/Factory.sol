// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;


import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import {ERC20Proxy} from "./ERC20Proxy.sol";
import {BaseERC20} from "./BaseERC20.sol";


contract Factory is OwnableUpgradeable, UUPSUpgradeable {


  address public immutable implementation;


  error AddressCannotBeZero();

  event ERC20Created(address newERC20Address, address owner);


  constructor(address _implementation) initializer {
    if(_implementation == address(0)) revert AddressCannotBeZero();

    implementation = _implementation;
  }

  function initialize() external initializer {
    __Ownable_init();
    __UUPSUpgradeable_init();
  }


  function _authorizeUpgrade(address _newImplementation) internal override onlyOwner {}


  function createNewERC20(
    string memory name,
    string memory symbol,
    uint256 maxSupply,
    address initialOwner,
    IERC721 gating
  ) public payable returns (address newERC20Address) {
    ERC20Proxy newERC20 = new ERC20Proxy(implementation, "");

    newERC20Address = address(newERC20);
    BaseERC20(newERC20Address).initialize({
      _name: name,
      _symbol: symbol,
      _maxSupply: maxSupply,
      _initialOwner: initialOwner,
      _gating: gating
    });

    emit ERC20Created({
      newERC20Address: newERC20Address,
      owner: initialOwner
    });

  }

}
