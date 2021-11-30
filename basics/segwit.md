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

### SegWit as a Soft Fork

So SegWit offered a modest block size limit increase by discounting the “weight” of witness data, most notably signatures. But the question is, how can SegWit be deployed as a soft fork (backward-compatible upgrade)?

Well, old nodes still recognize the SegWit chain, as long as it has majority hash power. They do this because this new data that was added isn't communicated to old nodes. And every transaction has a little piece of witness that isn't communicated to old nodes, and every block has a part that's the witness that's not communicated to old nodes.

The new data is appended to the end of the block, but it's also referred to in the coinbase transaction. This is to ensure that the block hash just refers to the things that are in the block, but it only refers to the things that are in a block as far as legacy notes are concerned.

However, you don't want to tell the legacy notes about the SegWit stuff. So what happens is there's an op return statement in the coinbase — which isn't just a company, but also the transaction that pays the miner their rewards. The coinbase is the first transaction in any block, and it refers to a hash of all the witness stuff.

The transaction can spend the money however it wants, but it has to contain at least one output with an op return in it, and that op return must refer to the witness blocks. An op return signifies that verification is done, but it can be followed by text, which is then ignored. So old nodes just see an op return statement and they don't care. The exception is with new nodes, which will check it. This allows nodes to communicate blocks and transactions to both new and old nodes, and they all agree on what's there.

Another reason why SegWit can be a soft fork is because when sending coins, you're using a special address type, and this address type is on the blockchain. That is what an output says. So an output of a transaction tells you how to spend the new transaction by putting a constraint on it. This script up key with SegWit starts with a zero, but with Taboo, it'll start with a one.

It's followed by the hash of a public key or the hash of a script, and new nodes know what to do with this. They see it's version zero, so they know it's SegWit. And they see a public key hash and they know that whoever wants to spend it needs to actually provide the public key and a signature. Meanwhile, what old nodes see is that there's a condition that they don't recognize, but as long as it's not a zero, it doesn't fail. This is called the script up key.

Old nodes think anybody can spend that coin, but new nodes know exactly who can spend it and who can not spend it.

In a hypothetical situation with only old nodes on the network, it'd mean that the coins in these addresses could be spent by anyone, which is why the activation of Taproot was important.

### Taproot

The topic of Taproot is covered in depth in chapter TODO. But what's important to know here is SegWit’s script versioning allows for easier upgrades to new transactions types, and the anticipated Taproot upgrade could be a first example of this feature.

There's a lot that can go wrong with soft fork activation and this is one example of it. But luckily, it didn't go wrong because if there's a mix of all the new nodes on the network, but most miners have forced the new rules, then most miners will ensure that these coins in anyone can spend outputs from this perspective of old nodes, won't actually get spent.

They'll consider blocks that spend these coins invalid. And as long as they're in the majority, they'll also create the longest chain. So now the new nodes are happy because all the new rules are being followed, and the old nodes are happy because no rules are being broken from their perspective and they just follow the longest chain. So everyone's still in consensus.

However, this aforementioned rule — script up key — is a hack. It's just leveraging some ugly aspect of ancient ways that Bitcoin scripts work. But with SegWit, the first thing will be the number zero or the number one, etc. And this actually introduces a cleaner variant of the same principle, which is that, as far as a SegWit note is concerned, if it starts with the number zero, it's going to enforce the rules. If it starts with the number one or higher, it'll allow anyone to spend it.

And if we get Taproot, then the new nodes will see version zero and they'll enforce the rules, and they'll see version one and they'll enforce the rules. But if they see version two or higher, they would just consider it valid, and that means that moving forward, it's much easier to introduce soft forks like Taproot without having to find another hack in the old scripting system to exploit.

SegWit was a little bit of a hack, but it was in that sense a one-time hack, because now we can use versioning, and every time we want to introduce a new rule for spending coins, it's going to be pretty clean and easy moving forward.

And within Taproot, there are multiple branches that can have their own condition, and those scripts also have a versioning mechanism. So there's even more versioning that can be done.

### Merkle Trees

Signatures are appended to the end of a block, but there's a reference in the coinbase. But all these transactions included in one little transaction because of something called the Merkle tree TODO INCLUDE CHAPTER REFERENCE IF THERE IS ONE.

A Merkle tree is a little bit more elegant than a hash because it allows you to point to specific elements inside the tree. A hash will just say yes or no for everything that's in it. However, with a Merkle tree, you can say, "OK, I can actually prove that this specific transaction exists inside that tree at that position," without having to reveal everything else in it.

It's essentially a mirror of the actual transactions, which are also included in the Merkle tree in the block. There's one Merkle tree for regular transaction data, and then there's a mirroring Merkle tree for all the references to the signatures in the coinbase block.

This idea could be generalized to something called extension blocks, where you could add something else to transactions in the future and just refer to them in a coinbase output. And so you could increase block size through soft forks to a degree, but you can't really go super far with that. Because as far as the old nodes is concerned, there still has to be a valid transaction out there. And a valid transaction probably has to have at least an input and at least an output, even if the output says, "Do whatever you want with this." Can't make it smaller than that, and there's still the one megabyte limit as far as these old nodes are concerned. You can't use extension blocks just to add data to transactions. You can use it to add data to transactions, but you can't use it to create an infinite number of transactions because those transactions have a minimum size, probably about 60 bytes.

### Hardware Wallets

In addition to all the aforementioned benefits — changes in block size, an increase in limits, versioning, etc. — there's also committing to the inputs, which primarily applies to hardware wallets.

If you're a hardware wallet and you want to sign something, you want to look at the output amounts TODO. You can do that, but you want to make sure the input amounts actually add up to the same as the output amounts so that money isn't just disappearing into fees.

However, the only way to do that is to actually have the input transactions and look at their output amounts. In the past, that meant you'd have to send all the input transactions to the hardware wallet as well, which would, in turn, process them. This was potentially a lot of work, especially if the transactions were big.

To be clear, this is always the case for any wallet. You always have inputs, which are coins you own. And then you have the outputs, which are coins you're sending, including a change output to yourself usually. The difference between them is the fee the miner keeps, and the fee isn't mentioned in the transaction, so you calculate it yourself.

This works for a regular wallet, because it knows how much all of the inputs are worth. But a hardware wallet is signing from private keys, and it doesn't necessarily know how much all the inputs are worth. It's sending money away, but it's actually not sure how much money it's sending, and therefore a hardware wallet has the risk that it's sending 10 million coins as a fee without realizing it.

The main problem with this is the fee could be arbitrary. And so if somebody colludes with the miner or just wants to take your coins hostage in some weird way, that's not good. So what SegWit does is it commits to those inputs.

A transaction has multiple outputs, so you'd say the suspending output zero of this and this transaction. And with SegWit, what's added to that is the entire transaction. So take the transaction and hash it, and that's what you're committing to now. And that includes the output amounts of that transaction. So now when you're signing it, you can check it. It could still be entirely fake, by the way; you could craft a fake transaction with fake inputs and any output amount you want, but then if the hardware wallet signs it and you put it on the blockchain, well, it's not going to be valid. So that's kind of a useless cheat.

In summary, this input signing resolved some edge case problems where wallets needed to make sure they don’t overpay in transaction fees, and hardware wallets benefit from this solution in particular.

### Recap

In total, there are four main benefits of SegWit. The first and most important is malleability, which enables things like Lightning, resulting in a pretty big capacity increase potential.

The second is an increase in block size. The third is versioning, which makes it easier to deploy future upgrades. And fourth is the hardware wallet fee issue is solved.

There are some minor tweaks as well in there, but it was a pretty big change; compared to that, Taproot is relatively simple.

There are of course some people who take issue with SegWit, claiming it would have been simpler to do as a hard fork, or that there would've been a clearer place to put the signature hash tree.
