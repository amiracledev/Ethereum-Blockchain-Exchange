pragma solidity ^0.5.0;
import "openzeppelin-solidity/contracts/math/SafeMath.sol";

contract Token {
	using SafeMath for uint;
	string public name = "Amiracle Token";
	string public symbol = "AMIRACLE";
	uint256 public decimals = 18;
	uint256 public totalSupply;

 	event Transfer(address indexed from, address indexed to, uint256 value);


 //    Tracking Balances
	mapping(address => uint256) public balanceOf;
	// Send Tokens
	
	constructor() public {
		totalSupply = 1000000 * (10 **decimals);
		balanceOf[msg.sender] = totalSupply;
	}

	function transfer(address _to, uint256 _value) public returns (bool success) {
		require(_to != address(0))
		require(balanceOf[msg.sender] >= _value);
       balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
       balanceOf[_to] = balanceOf[_to].add(_value);
       emit Transfer(msg.sender,_to, _value);
       return true;
    }
}