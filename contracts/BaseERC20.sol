// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";


contract BaseERC20 is ERC20Upgradeable, UUPSUpgradeable {

  uint256 private maxSupply;

  IERC721 private gating;

  error MaxSupplyReached();
  error ClaimNotAllowed();


  function initialize(
    string memory _name,
    string memory _symbol,
    uint256 _maxSupply,
    address _initialOwner,
    IERC721 _gating
  ) public initializer {
    __ERC20_init(_name, _symbol);

    maxSupply = _maxSupply;
    gating = _gating;
  }


  function claim(uint256 amount) external {

    if(IERC721(gating).balanceOf(_msgSender()) == 0) revert ClaimNotAllowed();

    if(totalSupply() + amount >= maxSupply) revert MaxSupplyReached();

    _mint(_msgSender(), amount);
  }

  function _authorizeUpgrade(address _newImplementation) internal override {}

}
