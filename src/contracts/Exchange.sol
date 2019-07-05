pragma solidity ^0.5.0;
import './Token.sol';

//   TODO:
//   [X] Set the fee Account
//   [X] Deposit Ether
//   [X] Withdraw Ether
//   [X] Deposit Tokens
//   [X] Withdraw Tokens
//   [X] Check Balances
//   [] Make Order 
//   [] Cancel Order 
//   [] Fill Order 
//   [] Charge Fees
//   [Xgit ] add safeguard so randoms cant send ether to us ..bc they have no way to withdraw it - Fallback Safety
//   
	contract Exchange {
	using SafeMath for uint;
	address public feeAccount; // Acc receiving the exchaneg fees
	uint256 public feePercent; //fee percentage
	address constant ETHER = address(0); //allows us to store Ether in tokens mapping with blank address
	mapping(address => mapping(address => uint256)) public tokens;

	mapping(uint256 => _Order) public orders;
	uint256 public orderCount;

	event Deposit(address token, address user, uint256 amount, uint256 balance);
	event Withdraw(address token, address user, uint256 amount, uint256 balance);

	event Order(
		uint id,
		address user,
		address tokenGet,
		uint amountGet,
		address tokenGive,
		uint amountGive,
		uint timestamp
		);

	struct _Order {
		uint id;
		address user; //person who made the order
		address tokenGet; //address of the toekn the want
		uint amountGet; // amount of tokens they want
		address tokenGive; //token they are going to give
		uint amountGive; //amount they are going to give
		uint timestamp; 

	}

		//Model the order
		//a way to store the order
		//add the order to storage

	constructor (address _feeAccount, uint256 _feePercent) public {
	feeAccount = _feeAccount;
	feePercent = _feePercent;
}

//fallback function if anyone sends us unrecognized ether
	function() external {
		revert();
	}
	// must use payable modifying to accept Ether with meta
	function depositEther() payable public {
			tokens[ETHER][msg.sender] = tokens[ETHER][msg.sender].add(msg.value);
				emit Deposit(ETHER, msg.sender, msg.value, tokens[ETHER][msg.sender]);
	}
	//same as deposit but we just sub instead of add 
	function withdrawEther(uint _amount) public {
		require(tokens[ETHER][msg.sender] >= _amount);
		tokens[ETHER][msg.sender] = tokens[ETHER][msg.sender].sub(_amount);
		msg.sender.transfer(_amount);
		emit Withdraw(ETHER, msg.sender, _amount, tokens[ETHER][msg.sender]);
	}

	function depositToken(address _token, uint _amount) public {
		//make sure no ether token deposited...check to see if its ether address
	require(_token != ETHER);
	require(Token(_token).transferFrom(msg.sender, address(this), _amount));
	tokens[_token][msg.sender] = tokens[_token][msg.sender].add(_amount);
	emit Deposit(_token, msg.sender, _amount, tokens[_token][msg.sender]);
}

	function withdrawToken(address _token, uint256 _amount) public {
        require(_token != ETHER);
        require(tokens[_token][msg.sender] >= _amount);
        tokens[_token][msg.sender] = tokens[_token][msg.sender].sub(_amount);
        require(Token(_token).transfer(msg.sender, _amount));
        emit Withdraw(_token, msg.sender, _amount, tokens[_token][msg.sender]);
    }

    function balanceOf(address _token, address _user) public view returns (uint256) {
        return tokens[_token][_user];
    }

    function makeOrder(address _tokenGet, uint256 _amountGet, address _tokenGive, uint256 _amountGive) public {
    	orderCount = orderCount.add(1);
    	orders[orderCount] = _Order(orderCount, msg.sender, _tokenGet, _amountGet, _tokenGive, _amountGive, now);
    	emit Order(orderCount, msg.sender, _tokenGet, _amountGet, _tokenGive, _amountGive, now);
    }
}
