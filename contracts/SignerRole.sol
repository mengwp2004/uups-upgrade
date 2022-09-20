
import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";

library Roles {
    struct Role {
        mapping (address => bool) bearer;
    }

    
    function add(Role storage role, address account) internal {
        require(!has(role, account), "Roles: account already has role");
        role.bearer[account] = true;
    }

    
    function remove(Role storage role, address account) internal {
        require(has(role, account), "Roles: account does not have role");
        role.bearer[account] = false;
    }

    
    function has(Role storage role, address account) internal view returns (bool) {
        require(account != address(0), "Roles: account is the zero address");
        return role.bearer[account];
    }
}

contract SignerRole is ContextUpgradeable {
    using Roles for Roles.Role;

    event MinerAdded(address indexed account);
    event MinerRemoved(address indexed account);

    Roles.Role private _signers;

    function __Role_init() internal onlyInitializing {
        __Role_INIT_unchained();
    }

    function __Role_INIT_unchained() internal onlyInitializing{
         _addSigner(_msgSender());
    }

    modifier onlySigner() {
        require(isSigner(_msgSender()), "MinerRole: caller does not have the Miner role");
        _;
    }

    function isSigner(address account) public view returns (bool) {
        return _signers.has(account);
    }

    function addSigner(address account) public virtual onlySigner {
        _addSigner(account);
    }

    function renounceSigner() public {
        _removeSigner(_msgSender());
    }

    function _addSigner(address account) internal {
        _signers.add(account);
        emit MinerAdded(account);
    }

    function _removeSigner(address account) internal {
        _signers.remove(account);
        emit MinerRemoved(account);
    }
}
