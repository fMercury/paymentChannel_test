# paymentChannel_test

Let’s say Alice and Bob want to set up a payment channel for something that requires micropayments that they don’t want to commit on chain to save on transaction fees. In this case, Bob may be paying Alice to manage a social media presence, and he pays her 0.001 ETH per tweet(24 cents) — if Bob were to make an on-chain transaction for each tweet, 20% of Alice’s income would be eaten up by fees.

On one hand, Alice does not want to do 100 tweets of work and trust Bob will pay her at the end for all 100 tweets, and on the other hand, Bob doesn’t want to pay Alice for 100 tweets all at once for her to just disappear and not do any work.

We can solve this with a payment channel where Bob commits 100*0.001 = 0.1 ETH to the channel smart contract, where the money can only either go to Alice or back to Bob. We see the constructor here:

(Contract & Constructor)

Bob sends 0.1 ETH when creating the contract, and sets a timeout of 1 day, assuming the work will be done by then, or he can cancel the payment channel and return the funds to himself.

Alice now sees that through the payment channel the funds are locked and begins tweeting. For each tweet, Bob signs a hash of (contract_address, value) with the private key he used to set up the channel, and sends it to Alice. So for the first tweet Bob signs (0x123…, 0.001 ETH), for the second (0x123, 0.002 ETH), etc…

Each time Alice receives this, she also signs it but she does not send it to the blockchain. At any moment if Alice decides she has received enough and no longer needs to tweet, she can submit the multi-signed (by both Bob and Alice) message to the smart contract and the smart contract will send the agreed upon value to Alice (say, 0.05 ETH) and send the rest back to Bob.

(Close Channel)

Because the function requires both signatures to successfully execute, neither Bob or Alice can run it without submitting a value they both signed (and hence agreed to).

If Alice is malicious and wants to extort Bob once he’s locked his funds, by not doing any work and saying she’ll only sign a tx that sends her half the money — the timeout protects Bob in this scenario. He can simply wait for the day to end and he can call ChannelTimeout, which destroys the contracts and returns all funds back to him.

(Channel Timeout)

Also, because Bob never has Alice’s signatures until they’re submitted to the blockchain, he cannot close the channel in a way that cheats Alice out of money. If Alice sees Bob stops paying her, she can simply close the channel, receive her funds, and be done with it. This way, at most, Alice is only at risk of not being paid for 1 tweet — or losing out 24 cents. Neither party is at risk of more than 24 cents of loss, compared to 20 dollars in the non-payment channel example. They also both massively save in tx fees!

That’s it! This contract is enough for a payment channel between two individuals.

Future Lectures

https://medium.com/statechannels/counterfactual-generalized-state-channels-on-ethereum-d38a36d25fc6
