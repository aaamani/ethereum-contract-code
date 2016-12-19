pragma solidity ^0.4.6;
contract rates{
	address public person;
	function rates(){
		person = msg.sender;
	}

	modifier priorperson{
		if(msg.sender!=person){
			throw;
		}else{
			_;
		}
	}

	function kill() priorperson{
		suicide(person);
	}
}


contract Client is rates{
	string public clientName;

	mapping(address=>activity) public activities;

	struct activity{
		bool alive;
		uint previousactivity;
		uint256 pendingpayment;

	}

	function Client(string _details){
		clientName = _details;
	}

	function registertoservice(address _providerAddress) priorperson{
		activities[_providerAddress] = activity({
			alive: true,
			previousactivity: now,
			pendingpayment: 0
			});
	}
	function remindpayment(uint256 _pendingpayment){
		if(activities[msg.sender].alive){
			activities[msg.sender].previousactivity = now;
			activities[msg.sender].pendingpayment = _pendingpayment;
		}
	
	 else{
			throw;
		}
	}
	function servicepayment(address _provideraddress){
	_provideraddress.send(activities[_provideraddress].pendingpayment);
	}

	function deleteservice(address _provideraddress){
	if(activities[_provideraddress.pendingpayment == 0]){
	activities[_provideraddress].alive = false;

	}
	else{throw;}
	}
}

contract service is rates{
	string public servicename;
	string public information;

	function service(
		string _details,
		string _information){
		servicename = _details;
		information = _information;
	}
	function remindpayment(uint256 _pendingpayment, address _personaddress){
		Client member = Client(_personaddress);
		member.remindpayment(_pendingpayment);

	}
}



