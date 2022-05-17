\newpage
## SegWit {#sec:segwit}

\EpisodeQR{32}

Segregated Witness, also known as SegWit, was a soft fork activated on the Bitcoin network in the summer of 2017. It was the last soft fork before Taproot activated in the fall of 2021, and it’s arguably still the biggest Bitcoin protocol upgrade to date.

In short, SegWit allowed transaction data and signature data to be separated within Bitcoin blocks. This chapter will explain how it works and go into detail about the benefits of it.

### Why Segregate Witnesses?

Before SegWit arrived on the scene, there was a problem with transaction malleability. Each transaction has a unique identifier. When someone sends you coins and you send them onward to someone else, your transaction (B) uses the identifier (ID) of transaction (A) to refer to it. Now if both transactions are unconfirmed, a problem can arise when a malicious person grabs transaction A and manipulates it. This manipulation changes A's ID. As a result, transaction B now uses an outdated identifier to refer to transaction A, which means it refers to a void. A transaction that tries to spend from a void is invalid and never makes it into a block. This is a confusing experience in the best case.

A well-known example of transaction malleability, is what happened with Mt. Gox, a bitcoin exchange from Japan.^[For a deep dive into the demise of Mt. Gox, listen to <https://www.whatbitcoindid.com/mtgox-interviews>] According to some sources, Mt. Gox was doing its internal accounting based on transaction IDs. A customer would withdraw funds, use malleability to change the withdrawal transaction a little bit and receive the money because the transaction was still valid, but then claim, “I made a withdrawal but never received the money.” In response, Mt. Gox would use the transaction ID and look to see if it was in the blockchain. It’d see there wasn’t a transaction ID in the blockchain that matched, reason the customer was right, and resend the coins.^[<https://en.wikipedia.org/wiki/Mt._Gox#Withdrawals_halted;_trading_suspended;_bitcoin_missing_(2014)>]

More specifically, the part of the transaction being manipulated is the signature: Every transaction is signed with a cryptographic signature. Prior to SegWit, there were lots of ways to tweak this signature so that it looks different but is still valid, with the amount and recipient unchanged. Only the transaction ID changes.

One way was to put a minus in front of the signature — remember a signature is just a big number — and anybody could do that.^[Resolved with BIP 66: <https://en.bitcoin.it/wiki/BIP_0066>] When you broadcast a transaction, it goes from your node to another, and onwards from there. The aforementioned malicious person would see that transaction appear on their node, grab it, flip this bit and send it onward. At that point two versions of the same transaction are being spread through the network, and only one of them will make it into the next block.

So you may ask yourself, “Why is this a problem?” It’s not necessarily a problem in the scenario we started with, where you receive coins and send them onwards. If a malleated version of transaction A makes it into the block, you just make a new transaction (B) that refers to A's new transaction ID.

But imagine you sent a transaction (A) to a super secure vault in the Arctic located thousands of meters underground. And then you went to the Arctic and created a redeem transaction (B) back to your hot wallet, and you signed it, but you didn’t yet broadcast it. Then, once you broadcast the first transaction (A) to send some money to the vault and somebody messes with it, suddenly the second transaction (B) is no longer valid, since it refers to the unaltered one (A). Now you have to go back to the Arctic to create a new transaction (B) that refers to the altered version (A) — a scenario that’s complicated at best.^[This example may seem contrived, but vault designs have to take malleability into account. <https://bitcoinops.org/en/topics/vaults/>]

Another, perhaps more down to earth, example of how this becomes a problem is with the Lightning network,^[The book doesn’t cover Lightning, but see appendix @sec:more_eps.] which is where you’re building unconfirmed transactions on top of each other. So if one of the underlying transactions is tweaked, the transactions that follow up on that one are no longer valid.

In the Lightning protocol two people send money to a shared address, and the only way to get money out of that address is by using a special transaction that both parties signed _before_ they sent money into the shared address. You don’t want somebody messing with the transaction that goes into the address, because then you can’t spend from it anymore — or rather, you can, but you both have to sign it again. That potentially gives one party the power to blackmail the other to get their fair share of the coins back.

### Solving Transaction Malleability

So it’s easy to see how much of an issue this was.

A transaction consists of all the transaction data and the signature. It’s identified by the transaction ID, which, before SegWit, was the hash of those two things. For example, the 10 BTC transaction from Satoshi to Hal Finney is f4184fc5…^[f4184fc596403b9d638783cf57adfe4c75c605f6356fbc91338530e9831e9e16 <https://bitcointalk.org/index.php?topic=155054.0>]

However, because the signature can be tweaked, the hash (transaction ID) can also be tweaked, and you end up with basically the same transaction but with a different transaction ID. That’s the problem that needed to be solved: somehow either making sure the signature can’t be modified, or that such a modification won’t change the transaction hash. The first approach appears to be very difficult if not impossible,^[<https://en.bitcoin.it/wiki/BIP_0062>] so SegWit involves the second approach.

The solution was to append the signature to the end of a transaction. This new transaction part isn’t included when calculating the identifier hash. It’s also not given to old nodes. As far as old nodes are concerned, the signature is empty and anyone can spend the transaction.^[
To be more precise: The `scriptSig` is empty, where before it would’ve put a public key and signature on the stack. In turn, the `scriptPubKey` is a `0` followed by a public key hash. To old nodes, this combination results in a non-zero item on the stack, i.e. `True`, which is a valid spend. On the other hand, SegWit-enabled nodes will interpret the `scriptPubKey` as a SegWit v0 program and use the new `witness` field when evaluating. See <https://en.bitcoin.it/wiki/BIP_0141>
] Because the new signature part isn’t included in the transaction hash, its identifier doesn’t change when the signature changes. Both new nodes, which have the signature, and old nodes which don’t, can calculate the transaction ID and it’s identical for both.

In short, SegWit solved the transaction malleability issue, where transaction IDs could be altered without invalidating the transactions themselves. In turn, solving the transaction malleability issue enabled second-layer protocols like the Lightning network.

### SegWit as a Soft Fork

How could SegWit be deployed as a soft fork (backward-compatible upgrade)? We’ll dive more deeply into how soft forks work in chapter @sec:taproot_activation, but the basic idea is that upgraded nodes are aware of the new rules, while un-upgraded nodes don’t perceive a violation of the rules.

With SegWit this is achieved by appending data to the end of a block, kind of like a subblock, and not sending that data to legacy nodes. A hash of this data is added to the coinbase transaction^[The company Coinbase was named after this first transaction in a block, which creates coins out of nowhere and pays the miner their reward.] in an `OP_RETURN` statement.

An `OP_RETURN` typically signifies that transaction verification is done, but it can be followed by text, which is then ignored. So old nodes just see an `OP_RETURN` statement, they don’t care what follows, and they won’t ask for the additional data. New nodes make an exception to this rule when it comes to the coinbase transaction, they do check the hash. A SegWit node verifies that the witness data is correct by comparing it to this hash. It also expects this extra data to be present, and will request it from other SegWit aware nodes if necessary.

### Block Size Limit

Before SegWit, blocks had a one-megabyte limit, and that limit included the transaction data, plus all the signatures, plus a little bit of block header data. Today, because SegWit transactions put their signature data in a separate place that old nodes won’t see, blocks can be larger. Theoretically, they can be up to four megabytes, but in practice with typical transactions, it’s closer to two and a half.

Because the signature (witness) data is in a place that old nodes don’t see, we can bypass the one-megabyte block size limit without a hard fork. Old nodes will keep seeing a block with no more than one megabyte in it, but new nodes are aware of the witness data, which takes the total size well over one megabyte.

However the increase isn’t unlimited. SegWit nodes use a new way of calculating how data is counted, which gives a 75 percent discount to this segregated signature data. The percentage is somewhat arbitrary — enough to make SegWit transactions cheaper than their pre-SegWit counterparts, but not so much to incentivize abuse.

### Future SegWit Versions, e.g. Taproot

The topic of Taproot is covered in depth in chapter @sec:taproot_basics. But what’s important to know here is SegWit’s script versioning allows for easier upgrades to new transaction types, and the recent Taproot upgrade is the first example of this feature.

The versioning works as follows, and is also touched on in chapter @sec:address, which covers addresses. The output of each transaction contains the amount and something called the `scriptPubKey`. The latter is a piece of Bitcoin script that constrains how to spend this coin, as we briefly mentioned in chapter @sec:address and will explain in more detail in chapter @sec:miniscript. With SegWit, the `scriptPubKey` always starts with a number, which is interpreted as the SegWit version. The rules for interpreting SegWit version 0 are set in stone, as are those for interpreting SegWit version 1, aka Taproot. But anything following a 2 or higher is up for grabs: Those rules may be written later.

Before a new soft fork activates, anything following an unknown version number is ignored, thus it’s anyone-can-spend. As we’ll explain in chapter @sec:taproot_activation one of the things that could go wrong with soft fork activation is that a majority of miners aren’t actually enforcing the new rules. But as long as most miners do enforce the new rules, they’ll ensure that these anyone-can-spend outputs, from the perspective of old nodes, won’t actually get spent.

Miners that run updated node software consider blocks that spend these coins invalid. And as long as they’re in the majority, they’ll also create the longest chain. So now the new nodes are happy because all the new rules are being followed, and the old nodes are happy because no rules are being broken from their perspective and they just follow the longest chain. So the network stays in consensus.

### Hardware Wallets

In addition to all the aforementioned benefits — fixing malleability, increasing block size, versioning, etc. — SegWit introduces a commitment to the inputs, which primarily benefits hardware wallets.

A hardware wallet is an external device that holds your private keys and can sign Bitcoin transactions. Because the device is purpose built and otherwise very simple, it’s less likely than your regular computer to have malware on it. It usually shows you a summary, based on its understanding of a transaction, and then asks you to approve the transaction before it actually signs.

Before signing a transaction, the device shows you the destination address and amount. That way you can verify that an attacker didn’t swap out the address for one they control.

The device also checks that the input amounts add up to the output plus the fee. This protects you against a scenario where an attacker makes you pay an absurd amount of fees (perhaps colluding with a miner).

However, transactions don’t actually specify their input amounts. The only way for the device to learn those is if you give it the input transactions. It can then inspect their output amounts. But having to send all the input transactions to the hardware wallet can be problematic, especially when they’re big, because these devices tend to be slow and have very limited memory resources.

To be clear, any wallet should perform these checks — not just hardware wallets. You always have inputs, which are coins you own. And then you have the outputs, which are coins you’re sending, including a change output to yourself usually. The difference between them is the fee the miner keeps, and the fee isn’t mentioned in the transaction, so the wallet calculates it for you.

This works for a regular wallet, because it knows how much all of the inputs are worth. But a hardware wallet is disconnected from the internet, so it doesn’t necessarily know how much all the inputs are worth. Without that information, it can’t be sure how much money it’s about to send.

Therefore, a hardware wallet has the risk that it’s sending 10 million coins as a fee without realizing it. And if somebody colludes with the miner or just wants to take your coins hostage in some weird way, that’s not good. So what SegWit does is it commits to those inputs.^[Unfortunately, the approach used by SegWit still left some potential attacks open, but these have been addressed by Taproot.]

What SegWit adds to this is that, before creating a signature, the output amount is added to the data that’s signed. The device now receives these amounts, along with the transaction it needs to sign. It uses that to inform the user and to create the signature. If your computer lied to the device about the amount, then the resulting signature is invalid. So the device no longer needs to look at the actual previous transaction.

Note that nothing is stopping your computer from crafting a fake transaction with fake inputs and any output amount it wants — the hardware wallet will happily sign it. But when your computer then broadcasts it to the network to get it included in the blockchain, it’s just not going to be valid. So it’s pointless for an attacker to try this.

### Recap

The main benefit of SegWit is that it fixes malleability, which enables things like the Lightning network, resulting in a pretty big increase in potential transaction throughput.

The second benefit is an increase in block size, even though this is dwarfed by the capacity increase Lightning could achieve. The third is versioning, which makes it easier to deploy future upgrades. And the fourth is improved hardware wallet support.

### Block Size War

If the above sounds great and uncontroversial, it’s because, in my opinion, it is. There was, however, a lot of drama in the years surrounding this soft fork. One account of this is provided in Jonathan Bier’s _The Blocksize War: The battle over who controls Bitcoin’s protocol rules_.^[<https://www.amazon.com/Blocksize-War-controls-Bitcoins-protocol/dp/B08YQMC2WM>]
