\newpage
## SegWit {#sec:segwit}

![Ep. 32 {l0pt}](qr/32.png)

Segregated Witness, also known as SegWit, was a soft fork activated on the Bitcoin network — in the summer of 2017. It was the last soft-fork before Taproot activated in the fall of 2021, and arguably still the biggest Bitcoin protocol upgrade to date.

In short, SegWit allowed transaction data and signature data to be separated within Bitcoin blocks. This chapter will explain how it works and go into detail about the benefits of it.

### Why Segregate Witnesses?

Before SegWit arrived on the scene, there was a problem with transaction malleability. What this means is if someone sends you coins and you send them to someone else, your transaction (B) will refer their initial transaction (A). In theory, this is fine. However, the problem that arrises is someone else can take transaction A and manipulate it. As a result, transaction B would no longer refer to transaction A, but rather to a void. A transaction that tries to spend from a void is invalid, and thus never makes it into a block. This is a confusing experience in the best case.

More specifically, the part of the transaction being manipulated is the signature: Every transaction is signed with a cryptographic signature, and the signature could be tweaked somehow in a way that it looks different, but it's still valid.

Prior to SegWit there were lots of ways to manipulate a signature. One way was to put a minus in front of the signature - remember that a signature is just a big number - and anybody could do that.^[This was resolved with BIP 66: <https://github.com/bitcoin/bips/blob/master/bip-0066.mediawiki>]

So you'd broadcast a transaction, and it would go from one node to the other. Somebody else could see that transaction and they could say, "Well, I'm just going to flip this bit and send it onward, and then we'll see which one wins."

The above scenario is for simple signatures, but if there were more complicated scripts, there were also ways someone could mess with those (see also chapter @sec:miniscript).

So you may ask yourself, "Why is this a problem?" It's not necessarily a problem in this scenario, but imagine you sent a transaction (A) to a super secure vault in the Arctic located thousands of meters underground. And then you went to the Arctic and created a redeem transaction (B) back to your hot wallet, you signed it, but didn't broadcast it yet. Then, once you broadcast transaction (A) to send some money to the vault and somebody messes with it, suddenly transaction (B) is no longer valid, since it refers to the unaltered (A). Now you have to go back to the Arctic to create a new transaction (B) that refers to the altered version of (A), which is complicated at best.

Another, perhaps more down to earth, example of how this becomes a problem is with Lightning^[The book doesn't cover Lightning, but Appendix @sec:more_eps has some pointers.], which is where you're building unconfirmed transactions on top of each other. So if one of the underlying transactions is tweaked, the transactions that follow up on that one aren't valid anymore.

In such a scenario, two people might send money to a shared address, and the only way to get money out of that address would be using transactions that both people signed before they sent money to that address. You don't want somebody messing with the transaction that goes into the address, because then you can't spend from it anymore — or rather, you can, but you both have to sign it again. That potentially gives one party the power to blackmail the other in order to get their fair share of the coins back.

There's another well-known example, which is what happened with Mt. Gox, a bitcoin exchange from Japan.^[For a deep dive into the demise of Mt. Gox, listen to: <https://www.whatbitcoindid.com/mtgox-interviews>] According to some sources, Mt. Gox was doing its internal accounting based on transaction IDs. A customer would withdraw funds, use malleability to change the withdrawal transaction a little bit, and receive the money because the transaction was still valid, but then claim, "I made a withdrawal, but never received the money." In response, Mt. Gox would use the transaction ID and look to see if it was in the blockchain. It'd see there wasn't a transaction ID in the blockchain that matched, reason the customer was right, and resend the coins.^[<https://en.wikipedia.org/wiki/Mt._Gox#Withdrawals_halted;_trading_suspended;_bitcoin_missing_(2014)>]

### Solving Transaction Malleability

So it's easy to see how much of an issue this was.

A transaction consists of all of the transaction data and the signature. It is identified by the transaction ID, which before SegWit was the hash of these two things. For example the 10 BTC transaction from Satoshi to Hal Finney is f4184fc5...^[f4184fc596403b9d638783cf57adfe4c75c605f6356fbc91338530e9831e9e16 <https://bitcointalk.org/index.php?topic=155054.0>]

However, because the signature can be tweaked, the hash (transaction ID) can also be tweaked, and you end up with basically the same transaction but with a different transaction ID. That's the problem that needed to be solved: Somehow making sure a transaction would always result in the same transaction ID.

The solution was to append the signature to the end of a transaction. This new transaction part is not included when calculating the identifier hash. It's also not given to old nodes. As far as old nodes are concerned, the signature is empty and anyone can spend the transaction.^[
To be more precise: the `scriptSig` is empty, where before it would have put a public key and signature on the stack. In turn the `scriptPubKey` is a `0` followed by a public key hash. To old nodes this combination results in a non-zero item on the stack, i.e. `True`, which is valid spend. SegWit enabled nodes on the other hand will interpret the `scriptPubKey` as a SegWit v0 program and also use the new `witness` field when evaluating. See <https://github.com/bitcoin/bips/blob/master/bip-0141.mediawiki>
] Because the new signature part is not included in the transaction hash, its identifier doesn't change when the signature changes. Old nodes which don't have access to this signature can still calculate the transaction identifier.

In short, SegWit solved the transaction malleability issue, where transaction IDs could be altered without invalidating the transactions themselves. In turn, solving the transaction malleability issue enabled second-layer protocols like the Lightning Network.

### Block Size Limit

Before SegWit, blocks had a one-megabyte limit, and that limit included the transaction data, plus all the signatures, plus a little bit of block header data. Today, because SegWit transactions put their signature data in a separate place that old nodes won't see, blocks can be larger. Theoretically, they can be up to four megabytes, but in practice with typical transactions, it's closer to two and a half.

Because the signature (witness) data goes into a place that old nodes don't care about, we can now bypass the one-megabyte block size limit without a hard fork because old nodes will see a block with exactly one megabyte in it. But new nodes will see more megabytes.

This increase is not unlimited either. SegWit nodes use a new way of calculating how data is counted, which gives a 75 percent discount to this segregated signature data. The percentage was somewhat arbitrary: enough to make SegWit transactions cheaper than their pre-SegWit counterparts, but not so much to incentivise abuse.

Another way to express this discount is by introducing the concept of transaction "weight" rather than size. Witness data, which is the signature and any other data provided by the spender to satisfy the script, is given a lower weight than all the other transaction data.

### SegWit as a Soft Fork

So SegWit offered a modest block size limit increase by discounting the “weight” of witness data. But how could SegWit be deployed as a soft fork (backward-compatible upgrade)?

Well, old nodes still recognize the SegWit chain, as long as it has majority hash power. We already touched on the fact every transaction has a little piece of witness that isn't communicated to old nodes. And that SegWit transactions look like anyone-can-spend to them. Every block has a part where the witness of every transaction is collected. This part of the block is not communicated to old nodes.

The new data is appended to the end of the block, kind of like a sub-block, which is not sent to legacy nodes. A hash of this data is added to the coinbase transaction^[The company Coinbase was named after this first transaction in a block, that creates coins out of nowhere and pays the miner their reward.], in an `OP_RETURN` statement. Old nodes simply ignore this hash. This ensures that the main block hash is still considered valid by old nodes. At same time, SegWit nodes can verify that the witness data is correct, by comparing its hash to that found in the special place inside the coinbase transaction.

This Coinbase transaction can spend the money however it wants, but it has to contain at least one output with an `OP_RETURN` in it, and that `OP_RETURN` must refer to the witness blocks. An `OP_RETURN` typically signifies that transaction verification is done, but it can be followed by text, which is then ignored. So old nodes just see an `OP_RETURN` statement and they don't care. The exception is with new nodes, which will check it. This allows nodes to communicate blocks and transactions to both new and old nodes, and they all agree on what's there.

### Future SegWit versions, e.g. Taproot

The topic of Taproot is covered in depth in chapter @sec:taproot_basics. But what's important to know here is SegWit’s script versioning allows for easier upgrades to new transaction types, and the recent Taproot upgrade is the first example of this feature.

The versioning works as follows, and is also touched on in chapter @sec:address about addresses. The output of each transaction contains the amount and something called the `scriptPubKey`. The latter is a piece of Bitcoin script that constrains how to spend this coin, as explained in chapter @sec:miniscript. With SegWit the `scriptPubKey` always starts with a number, which is interpreted as the SegWit version. The rules for interpreting SegWit version 0 are set in stone, as are those for interpreting SegWit version 1 aka Taproot. But anything following a 2 or higher is up for grabs: those rules may be written later.

Before a new soft-fork activates, anything following an unknown version number is ignored, thus anyone-can-spend. One of the things that could go wrong with soft fork activation, is that a majority of miners is not actually enforcing the new rules. But as long as most miners do enforce the new rules, then they will ensure that these anyone-can-spend outputs, from the perspective of old nodes, won't actually get spent.

They'll consider blocks that spend these coins invalid. And as long as they're in the majority, they'll also create the longest chain. So now the new nodes are happy because all the new rules are being followed, and the old nodes are happy because no rules are being broken from their perspective and they just follow the longest chain. So everyone's still in consensus.

Note that even in the event of a hashpower majority ignoring the new soft-fork rules, despite having initially signalled to enforce them, individual user nodes, and presumably nodes run by various Bitcoin exchanges, would still enforce the new rules. This would result in a chain split, where users who upgraded to the new soft-fork rules will see a different chain than those who didn't.

Perhaps in that case this majority of miners won't be able to sell the coins they generated, because buyers won't accept their blocks. A subset of those miners would then finally update their software, building on top of the shorter chain, enforcing the new rules, so they can sell their coins. If enough miners do this, the short chain with the new rules would eventually overtake the longer chain with the old rules, in a big reorg. Needless to say, this scenario is very undesirable, so when contemplating a soft-fork it's critical to make sure everyone, including miners, is on the same page, and actually ready to enforce the new rules.

### Hardware Wallets

In addition to all the aforementioned benefits — fixing malleability, increasing block size, versioning, etc. — there's also committing to the inputs, which primarily applies to hardware wallets.

If you're a hardware wallet and you want to sign something, you want to look at the output amounts TODO. You can do that, but you want to make sure the input amounts actually add up to the same as the output amounts so that money isn't just disappearing into fees.

However, the only way to do that is to actually have the input transactions and look at their output amounts. In the past, that meant you'd have to send all the input transactions to the hardware wallet as well, which would, in turn, process them. This is problematic when the transactions are big, because these devices tend to be slow and have very limited memory resources.

To be clear, any wallet should perform these checks, not just hardware wallets. You always have inputs, which are coins you own. And then you have the outputs, which are coins you're sending, including a change output to yourself usually. The difference between them is the fee the miner keeps, and the fee isn't mentioned in the transaction, so the wallet calculates it for you.

This works for a regular wallet, because it knows how much all of the inputs are worth. But a hardware wallet is disconnected from the internet, it doesn't necessarily know how much all the inputs are worth. Without that information, it can't be sure how much money it's about to send.

Therefore a hardware wallet has the risk that it's sending 10 million coins as a fee without realizing it. And so if somebody colludes with the miner or just wants to take your coins hostage in some weird way, that's not good. So what SegWit does is it commits to those inputs.^[Unfortunately the approach used by SegWit still left some potential attacks open, which have been addressed by Taproot.]

A transaction can have multiple outputs, so a transaction input has to specify not just the transaction ID it's spending, but also which output. The signature covers this information, so a device has access to the previous transaction, it can check the output amount.

What SegWit adds to this is that, before creating a signature, the output amount is added to the data that is signed. The device now receives these amounts, along with the transaction it needs to sign. It uses that to inform the user and to create the signature. If your computer lied to the device about the amount, then the resulting signature is invalid. So the device no longer needs to look at the actual previous transaction.

Note that nothing is stopping your computer from crafting a fake transaction with fake inputs and any output amount it wants. The hardware wallet will happily sign it. But when your computer then broadcasts it to the network in order to get it included in the blockchain, it's just not going to be valid. So it's pointless for an attacker to try this.

In summary, this input signing resolved some edge case problems where wallets needed to make sure they don’t overpay in transaction fees, and hardware wallets benefit from this solution in particular.

### Recap

In total, there are four main benefits of SegWit. The first and most important is malleability, which enables things like Lightning, resulting in a pretty big capacity increase potential.

The second is an increase in block size. The third is versioning, which makes it easier to deploy future upgrades. And fourth is the hardware wallet fee issue is solved.

There are some minor tweaks as well in there, but it was a pretty big change; compared to that, Taproot is relatively simple.

There are of course some people who take issue with SegWit, claiming it would have been simpler to do as a hard fork, or that there would've been a clearer place to put the signature hash tree.
