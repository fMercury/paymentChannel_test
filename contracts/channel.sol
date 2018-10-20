pragma solidity ^0.4.25;

contract Channel{

  address public channelSender;
  address public channelRecipient;
  uint public startDate;
  uint public channelTimeout;
  mapping (bytes32 => address) signatures;

Constructor(address to, uint timeout) public payable {
  channelRecipient = to;
	channelSender = msg.sender;
	startDate = now;
	channelTimeout = timeout;
  }

// https://web3js.readthedocs.io/en/1.0/web3-eth-personal.html?highlight=ecrecover
//h. hash
//v. value
//r.
function CloseChannel(bytes32 h, uint8 v, bytes32 r, bytes32 s, uint value) public {
  address signer;
	bytes32 proof;

	// get signer from signature
	signer = ecrecover(h, v, r, s);

	// signature is invalid, throw
	if (signer != channelSender && signer != channelRecipient) throw;

	proof = sha3(this, value);

	// signature is valid but doesn't match the data provided
	if (proof != h) throw;

	if (signatures[proof] == 0)
    signatures[proof] = signer;
	else if (signatures[proof] != signer){
		// channel completed, both signatures provided
		if (!channelRecipient.send(value)) throw;
		  selfdestruct(channelSender);
	   }

   }

	function ChannelTimeout() public {
		if (startDate + channelTimeout > now)
			throw;

		selfdestruct(channelSender);
  }

}
