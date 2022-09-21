// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

// Open Zeppelin libraries for controlling upgradability and access.
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "./SignerRole.sol";

contract CapitalDepotV3 is Initializable, UUPSUpgradeable, SignerRole,OwnableUpgradeable {
    
    struct ClaimInfo{
        address user;   // user address
        uint256 time; // claim time
        uint256 balance;  // nft balance
        bool claimed;   // true or false
    }

    //
    // storage
    address public token;
    uint256 public maxClaimBalance;
    uint256 public minClaimInterval;

    mapping(address => uint256) claimTimes;
    mapping(uint256 => ClaimInfo) claimInfos;

    // evnet
    event SetToken(address);
    event SetClaimBalance(uint256);
    event SetClaimInterval(uint256);
    event Claim(address indexed from,address indexed to,uint256 _id,uint256 _balance,uint256 _time);
    event AdminClaim(address indexed from,address indexed to,uint256 _id,uint256 _balance,uint256 _time);
    event WithdrawTo(address indexed from,address indexed to,uint256 _id,uint256 _balance,uint256 _time);

    ///@dev no constructor in upgradable contracts. Instead we have initializers
    function initialize(address _token,uint256 _maxClaimBalance,uint256 _maxClaimInterval ) public initializer {
        ///@dev as there is no constructor, we need to inititalze the OwnableUpgradeable explicitly
        
        __Role_INIT_unchained();
        __Ownable_init();
        __CapitalDepot_init_unchained(_token,_maxClaimBalance,_maxClaimInterval);
    }

    function addSigner(address account) public override  onlyOwner {
        _addSigner(account);
    }

    function removeSigner(address account) public   onlyOwner  {
        _removeSigner(account);
    }

    function __CapitalDepot_init_unchained(address _token,uint256 _maxClaimBalance,uint256 _minClaimInterval) internal onlyInitializing{
        token = _token;
        maxClaimBalance = _maxClaimBalance;
        minClaimInterval = _minClaimInterval;
    }

    function setToken(address _token) public onlyOwner{
        token = _token;
        emit SetToken(_token);
    }

    function setClaimBalance(uint256 _maxClaimBalance) public onlyOwner{
        maxClaimBalance = _maxClaimBalance;
        emit SetClaimBalance(_maxClaimBalance);
    }

    function setClaimInterval(uint256 _minClaimInterval) public {
        minClaimInterval = _minClaimInterval;
        emit SetClaimInterval(_minClaimInterval);
    }

    function claim(uint256 _id,uint256 _balance,uint256 _salt, uint8 v, bytes32 r, bytes32 s) external payable { 
    
          require(_balance < maxClaimBalance,"exceed max claim balance ");
          require(claimTimes[msg.sender] + minClaimInterval < block.timestamp ,"less min interval");
          require(IERC20(token).balanceOf(address(this)) > _balance,"exeed balance");
          require(!claimInfos[_id].claimed,"have claimed");
          require(isSigner(ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(abi.encodePacked(this,token,msg.sender,_id,_balance,_salt)))), v, r, s)), "claim should sign");
          claimTimes[msg.sender] = block.timestamp;
          claimInfos[_id] = ClaimInfo(msg.sender,block.timestamp,_balance,true);
          transfer(token,msg.sender,_balance);   
          emit Claim(address(this),msg.sender,_id,_balance,block.timestamp);
           
    }

    function adminClaim(address _to,uint256 _id,uint256 _balance) public payable onlyOwner{ 
    
          require(_balance < maxClaimBalance,"exceed max claim balance ");
          require(claimTimes[_to] + minClaimInterval < block.timestamp ,"less min interval");
          require(!claimInfos[_id].claimed,"have claimed");
          claimTimes[_to] = block.timestamp;
          claimInfos[_id] = ClaimInfo(_to,block.timestamp,_balance,true);
          transfer(token,_to,_balance);
          emit AdminClaim(address(this),_to,_id,_balance,block.timestamp);
    }

    function withdrawTo(address _to,uint256 _id,uint256 _balance,uint256 _salt, uint8 v, bytes32 r, bytes32 s) external payable { 
    
          require(_balance < maxClaimBalance,"exceed max claim balance ");
          require(claimTimes[_to] + minClaimInterval < block.timestamp ,"less min interval");
          require(IERC20(token).balanceOf(address(this)) > _balance,"exeed balance");
          require(!claimInfos[_id].claimed,"have claimed");
          require(isSigner(ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(abi.encodePacked(this,token,_to,_id,_balance,_salt)))), v, r, s)), "claim should sign");
          claimTimes[_to] = block.timestamp;
          claimInfos[_id] = ClaimInfo(_to,block.timestamp,_balance,true);
          transfer(token,_to,_balance);   
          emit WithdrawTo(address(this),_to,_id,_balance,block.timestamp);
           
    }

    function getLastClaimTime() public view returns (uint256){
        return claimTimes[msg.sender];
    }

    function getClaim(uint256 _id) public view returns (ClaimInfo memory){
        return claimInfos[_id];
    }

    function erc20safeTransferFrom(IERC20 _token, address _to, uint256 _value) internal  {
        require(_token.transfer(_to, _value), "failure while transferring");
    }

    function transfer(address _token, address _to,uint _value ) internal {
        erc20safeTransferFrom(IERC20(_token), _to, _value);
    }
    
    ///@dev required by the OZ UUPS module
    function _authorizeUpgrade(address) internal override onlyOwner {}
}
