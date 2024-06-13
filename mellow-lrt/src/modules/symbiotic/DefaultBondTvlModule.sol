// SPDX-License-Identifier: BSL-1.1
pragma solidity 0.8.25;

import "../../interfaces/modules/symbiotic/IDefaultBondTvlModule.sol";
import "../DefaultModule.sol";

contract DefaultBondTvlModule is IDefaultBondTvlModule, DefaultModule {
    /// @inheritdoc IDefaultBondTvlModule
    mapping(address => bytes) public vaultParams;

    /// @inheritdoc IDefaultBondTvlModule
    function setParams(
        address vault,
        address[] memory bonds
    ) external noDelegateCall {
        IDefaultAccessControl(vault).requireAdmin(msg.sender);
        for (uint256 i = 0; i < bonds.length; i++)
            if (!IVault(vault).isUnderlyingToken(IBond(bonds[i]).asset()))
                revert InvalidToken();
        vaultParams[vault] = abi.encode(bonds);
        emit DefaultBondTvlModuleSetParams(vault, bonds);
    }

    /// @inheritdoc ITvlModule
    function tvl(
        address vault
    ) external view noDelegateCall returns (Data[] memory data) {
        bytes memory data_ = vaultParams[vault];
        if (data_.length == 0) return data;
        address[] memory bonds = abi.decode(data_, (address[]));
        data = new Data[](bonds.length);
        for (uint256 i = 0; i < bonds.length; i++) {
            data[i].token = bonds[i];
            data[i].underlyingToken = IBond(bonds[i]).asset();
            data[i].amount = IERC20(bonds[i]).balanceOf(vault);
            data[i].underlyingAmount = data[i].amount;
        }
    }
}
