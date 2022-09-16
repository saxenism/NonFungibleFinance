// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./VestingTemplate.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Multicall.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";

contract VestingFactory is ERC721("Vestings", "Vestings"), Multicall
{
    address public immutable template = address(new VestingTemplate());

    function newVesting(
        address beneficiaryAddress,
        uint64 startTimestamp,
        uint64 cliffDuration,
        uint64 vestingDuration
    )
        external
        returns (address)
    {
        address instance = Clones.clone(template);
        VestingTemplate(payable(instance)).initialize(startTimestamp, cliffDuration, vestingDuration);
        _mint(beneficiaryAddress, uint256(uint160((instance))));
        return instance;
    }

    function _isApprovedOrOwner(address spender, uint256 tokenId)
        internal
        view
        override
        returns (bool)
    {
        return uint256(uint160((spender))) == tokenId || super._isApprovedOrOwner(spender, tokenId);
    }
}