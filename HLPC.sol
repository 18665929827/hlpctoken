pragma solidity ^ 0.6.10;
abstract contract Erc20Token{  
    uint256 public totalSupply;
    function balanceOf(address _owner) public view virtual returns (uint256 val);
    function transfer(address _to, uint256 _value) public virtual returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public virtual returns (bool success);
    function approve(address _spender, uint256 _value) public virtual returns (bool success);
    function allowance(address _owner, address _spender) public view virtual returns (uint256 remaining);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256  _value);
}

contract TokenHLPC is Erc20Token {
    using SafeMath for uint256;
    string public name = "Hyperlinked petroleum COINS";//名称 
    string public symbol = "HLPC";  //token简称
    uint8 public decimals = 6; //返回token使用的小数点后几位。比如如果设置为3，就是支持0.001表示.  
    address private ISSUE_ADDR = 0xe180B907E04FCAa479F9d53DD6bde8Fe194186EC; //接收代币的ETH地址
    constructor() public {
        totalSupply = 100000000 * 10 ** uint256(decimals);//设置初始总量
        balance[ISSUE_ADDR] = totalSupply; //将代币数量发给发行地址
    }
  
    function transfer(address _to, uint256 _value) public override returns (bool success) {
        require(balance[msg.sender] >= _value && balance[_to] + _value > balance[_to]);
        require(_to != address(0x0));
        balance[msg.sender] = balance[msg.sender].sub(_value);
        balance[_to] = balance[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool success) {  
        require(balance[_from] >= _value && allowed[_from][msg.sender] >= _value);
        balance[_from] = balance[_from].sub(_value);
        balance[_to] = balance[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        emit Transfer(_from, _to, _value);  
        return true;
    }

    function balanceOf(address _owner) public view override returns (uint256 val) {  
        return balance[_owner];
    }
  
    function approve(address _spender, uint256 _value) public override returns (bool success) {   
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
  
    function allowance(address _owner, address _spender) public view override returns (uint256 remaining) {  
        return allowed[_owner][_spender];
    }

    mapping (address => uint256) balance;  
    mapping (address => mapping (address => uint256)) allowed;  
}

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b);
        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;
        return c;
    }
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }
}
