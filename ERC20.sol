pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";


contract main is ERC20Upgradeable {
    
    event Deprecate(address newAddress);
    mapping(address => bool) public blacklist;
    bool private pauseflg = false;
    bool public deprecated = false;
    address payable upgradedAddress;
    address public owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    
    
    modifier onlyOwner() {
        require(owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }
    
    modifier deprecatAllow() {
        require(deprecated == false, "Deprecated");
        _;
    }
    
    function transferOwnership(address payable newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _setOwner(newOwner);
    }
    
    function _setOwner(address payable newOwner) private {
        address oldOwner = owner;
        owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
   
    function initialize(string memory _name, string memory _symbol) public initializer {
        __ERC20_init(_name,_symbol);
        _setOwner(payable(msg.sender));
        _mint(msg.sender, 1000000 * 10 * decimals());
        deprecated = true;
    }
    
    modifier processapprove() {
        require(!pauseflg, "Contract paused");
        _;
    }
    
    function _approve(address _owner,address _spender,uint256 _amount) internal override deprecatAllow{
        
    }
    
    function pause() public onlyOwner deprecatAllow{
        pauseflg = true;
    }
    
    function unpause() public onlyOwner deprecatAllow {
        pauseflg = false;
    }
    
    function AddBlacklist(address _blackaddress) public onlyOwner processapprove deprecatAllow {
        blacklist[_blackaddress] = true;
    }
    
    function transfermoney(address _spender, uint256 _amount) public processapprove deprecatAllow {
        require(!blacklist[_spender], "Reciper is blacklist");
        _transfer(owner, _spender, _amount);
    }
 
    
    receive() external payable {
    }
    
    fallback() external {}
}