\newpage
## SegWit


![Ep. 32 {l0pt}](qr/32.png)

discuss Segregated Witness, also known as SegWit. SegWit was the last soft fork to have been activated on the Bitcoin network in the summer of 2017, and the biggest Bitcoin protocol upgrade to date.

In short, SegWit allowed transaction data and signature data to be separated in Bitcoin blocks. In this episode, Aaron and Sjors explain how this works, and that this offered four main benefits:

First, SegWit solved the transaction malleability issue, where transaction IDs could be altered without invalidating the transactions themselves. Solving the transaction malleability issue itself in turn enabled second layer protocols like the Lightning Network.

Second, SegWit offered a modest block size limit increase by discounting the “weight” of witness data, most notably signatures. Importantly, this could be done without the need for a hard fork.

Third, SegWit’s script versioning allows for easier upgrades to new transactions types. The anticipated Taproot upgrade could be a first example of this feature.

And fourth, input signing resolved some edge case problems where wallets needed to make sure they don’t overpay in transaction fees.. Hardware wallets benefit from this solution in particular.

<!-- Transcript

Aaron:
SegWit.

Sjors:
That's right.

Aaron:
Segregated witness, which was the previous soft fork. Well, was the last soft fork. We're working towards the Taproot soft fork now.

Sjors:
It's the last soft fork we know of.

Aaron:
Yes, I guess so. It activated in 2017.

Sjors:
Mm-hmm (affirmative).

Aaron:
It started being developed in 2015.

Sjors:
I think it was late 2015. Yeah, the final idea came about to turn it into a soft fork.

Aaron:
Yeah and we should say, it's probably the biggest protocol upgrade Bitcoin has seen so far, right?

Sjors:
Well, it's the biggest protocol upgrade we've seen since the days of completely reckless deployments of upgrades. Right?

Aaron:
Wouldn't you say so it's almost the biggest code change, for example?

Sjors:
Yeah, I think so. It's bigger change than P2SH, but I don't know what was done in the very early Satoshi days, when hundreds of opcos were turned off and all that stuff.

Aaron:
So, where do we start? Do we start...

Sjors:
We could start with what the problem was.

Aaron:
Okay. What was the problem? Why do we need SegWit, Sjors?

Sjors:
Yeah. Why do witnesses need to be segregated?

Aaron:
Exactly.

Sjors:
So the problem was transaction malleability and transaction malleability means that if I'm sending you some coins and you are sending them to Ruben, who's not here. Then that transaction that you're sending refers to the transaction that I just sent and that's fine normally. But the problem is that somebody could take our transaction and manipulate it. It could take my transaction and manipulate it. And then your two transaction would no longer refer to my transaction, but refer to a void.

Aaron:
Yeah. And to be more specific, I think what the part of the transaction that's being manipulated is actually the signature. So every transaction is signed with a cryptographic signature and the signature, I don't understand the details, but I know that the signature can be tweaked somehow in a way that it looks different, but it's still valid.

Sjors:
Yeah. And there were lots of ways to do that. So one of the ways that was fixed without SegWit is that you could, I think just multiply the signature with minus one or something or just put an up minus in front of it. And it would still be valid. And so anybody could just put that minus in front of it. So you would broadcast a transaction and it would go from one note to the other. Somebody else could see that transaction and they could say, "Well, I'm just going to flip this bit and send it onwards. And then we'll see which one wins." And this is just for simple signatures, but I think there were other, if you have more complicated scripts, there are also ways that somebody can mess with that script.

Aaron:
Yeah. So someone can mess with it in flight basically. You send a transaction to the network and then it's forwarded from peer to peer until it reaches miner, and it's included in a block, but every peer on the network can basically take the transaction, tweak it a little bit and forward it, or the miner can do that.

Sjors:
Yeah. And I guess even the person making it can do it.

Aaron:
Sure.

Sjors:
Yeah. Or the miner can do it. So you may ask yourself, why is this a problem? Right. Because I sent you some coins and you sent them to Ruben, okay. I ruined your transaction. So you just sent it again. So that's not a big deal.

Aaron:
You didn't really ruin the transaction. You just tweaked it a bit, but it's still valid.

Sjors:
Well, I ruined your transaction. So I sent coins to you and you sent coins to Ruben, but that last transaction, no longer points to an existing transaction because somebody messed with my transaction.

Aaron:
Yeah. It's the second transaction that's getting in trouble.

Sjors:
Yeah, and this is not a problem in the scenario we just described. Right? Because you can just make a new one, except what about if you're not you, but what if I sent a transaction to a super secure vault in the Arctic, like thousands of meters underground. And then I went to the Arctic and I created a redeemed transaction back to my hot wallet, but I didn't broadcast it. I just signed it.

Aaron:
Why are you making such a complicated example with vaults and Arctics?

Sjors:
Well, this one isn't that complicated. I just went to my vault, I created the transaction out of my vault, and then I basically buried the vault in a hundred meters of rock. So it's very difficult for me to go back to the vault and make a new transaction. And then I broadcast my original transaction to send some money to the vault and somebody messes with it. Now I have to go back to Antarctica and this COVID, and it's very complicated.

Aaron:
Cold.

Sjors:
So that's a terribly difficult example. Another example would be Lightning.

Aaron:
Yeah. That's the more obvious one.

Sjors:
Yeah. So with Lightning, what happens and we've explained Lightning in earlier episodes, but the idea is you sent money... two people sent money to a shared address. And then the only way to get money out of that address is with transactions that you've both signed before you sent money into that address. And so you don't want somebody messing with the transaction that goes into the address because then you can't spend from it anymore, or you can, but you both have to sign it again. And so one party could cheat the other party out of the coins.

Aaron:
Yeah. The point with Lightning is that you're building unconfirmed transactions on each other. So then if one of the underlying transactions is tweaked, then the transactions that follow up on that one aren't valid anymore.

Sjors:
Yeah, and people spend lots of time trying to find ways around that problem, because people were thinking about Lightning like solutions for quite a while, and it was just really hard to solve.

Aaron:
Yeah. So to be clear that the concrete attack in this Lightning example is that one of the parties would tweak the transaction they shared between them, send this tweaks transaction to the network, and then I guess the other party probably would wouldn't even recognize that transaction. Or even if he did, he couldn't use his own transaction to get his funds back. Am I saying that right?

Sjors:
Well, yeah. All the transactions that get your funds back are no longer valid. So this could be a problem in all the cheating scenarios.

Aaron:
Yeah, exactly. There's also another well known example, which was the Mount Gox case. And that was a mistake on the part of Mount Gox as well. If we assume that the story we've been told about how the hack happened is really true, but the story was...

Sjors:
The hack or you mean one of the many hacks?

Aaron:
The big one, they claimed that the big one was due to transaction malleability. And the story was that they were basically doing their internal accounting based on transaction IDs. So a customer would withdraw funds, use malleability to change the withdrawal, transaction a little bit, still get the money because the transaction is still valid, but then claim, "Guys, I made a withdrawal, but they never received the money." Mount Gox would take the transaction ID. Look, if it was in the blockchain so that, there's no transaction ID like that in the blockchain, our customer must be right, and then resend the coins.

Sjors:
Yeah. But there are so many other things you have to do wrong for that particular thing to happen.

Aaron:
Yeah.

Sjors:
But anyway, let's blame it on malleability.

Aaron:
I'm just giving an example of something that could go wrong because of malleability. In this case you make other mistakes as well. So, that was malleability.

Sjors:
Yeah.

Aaron:
So that's what we want to solve. Right?

Sjors:
Yeah and there have been partial solutions to this already because it's a much bigger problem than just a signature, I think, but in either way, it turns out that it seems like a whac-a-mole game that's just really hard to solve. And the fundamental problem there seems to be that because you're pointing to something that includes a signature. It just gets too complicated. One thing SegWit does, is it no longer refers to the signature because it refers to... Well, the signature's put somewhere else in a transaction in some sort of extra data and-

Aaron:
To make this very clear in case some of our listeners aren't keeping up, the thing is a transaction consists of all of the transaction data, plus the signature formally or usually, or still the case in some transactions, the transaction data and the signature is hashed together. This case gives you a string of numbers and that's the transaction ID.

Sjors:
Yeah.

Aaron:
Because the signature can be tweaked. That means the hash, meaning the transaction ID can also be tweaked and you end up with basically the same transaction with a different transaction ID and that causes all the problems we just discussed. So that's the problem we needed to solve. Somehow we need to make sure that a transaction would always result in the same transaction ID.

Sjors:
Yeah. And so the solution there is to put the hash... Sorry, put the signature in a separate place inside the transaction that as far as old nodes are concerned, doesn't even exist. And you still refer back to other transactions by the original data. So the original, basically the original part of the transaction, that still creates the hash and the signature is this new data. And you do not use it to create a hash.

Aaron:
Right. So the signature ID can't be tweaked anymore because the signature isn't in there anymore.

Sjors:
Right. So you can still tweak the signature if you wanted to. Although there's some limitations on that too, but if you tweak the signature, that's not part of the hash and this is nice, right? So, that's one thing it does, SegWit. And the other thing it does, is it just... Because this data goes into a place that old nodes don't care about. Well, suddenly you can bypass the one megabyte block size limit without a hard fork because old nodes will see a block with exactly one megabyte in it. But new nodes will see more megabytes.

Aaron:
Yeah. Blocks have a one megabyte limits, and that used to be transaction data, plus all the signatures, plus a little bit of metadata. And now it's basically mostly the signature data and not the signatures, and that's where the block size increase comes from. The signatures is sort of the increase.

Sjors:
Yep. Exactly. And that's theoretically up to four megabyte, but in practice, it's more like two and a half. The total size that you get for blocks.

Aaron:
Yeah. Why is that? There is some new calculation for how data is counted when it comes to the signature?

Sjors:
Well, yeah. So I think what happens is you take the old data and you multiply it by three or something, and then you take the new data and you add it up. So the signature's kind of discounted in a way, and that's kind of an arbitrary number, but at least it creates an incentive to use SegWit.

Aaron:
Right. And that's also why it's a bit more flexible now, the block size limit. If there are many transactions with many signatures, for example, multisig transactions, then the size of the blocks could be a little bit bigger because of how it's all calculated.

Sjors:
Right, because with the usual old fashioned transactions, there's not much going on in terms of signatures. There just aren't that many signatures, but you could conceive of much more complicated transactions that have much longer signatures, like in a multisig situation. And those are nicely discounted in SegWit. Yeah.

Aaron:
Right. So how is it possible that SegWit could be deployed as a soft fork?

Sjors:
Okay. Yeah. So this-

Aaron:
Which means backwards compatible upgrade. So old nodes still recognize the SegWit chain, as long as it has majority hash power, at least.

Sjors:
Yeah. And they do this because this new data that we've added is not communicated to old nodes. So every transaction has a little piece of witness. That's not communicated to old node, and every block has a part that is the witness that's not communicated to old nodes. So basically new node [crosstalk 00:11:49]

Aaron:
First of all, where is this part?

Sjors:
I think it's at the end of the block.

Aaron:
It's in the coinbase transaction, right?

Sjors:
I think it's appended at the end of the block, but it's also referred to in the coinbase transaction, because what you do want to do is you want to make sure that, the block hash just refers to the things that are in the block, but it only refers to the things that are in a block as far as legacy notes are concerned. But you don't want to tell the legacy notes about the SegWit stuff. So what happens is there is an op return statement in the coinbase, which refers to a hash of all the witness stuff.

Aaron:
Yeah. The coinbase, in case listeners don't know this isn't just a company. It's also the transaction that pays the miner, his rewards. So basically the first transaction in any block.

Sjors:
Yeah, and the transaction can just spend the money, however it wants, but it has to contain at least one output with op return in it. And that op return must refer to the witness blocks. So old nodes just see an op return statement and they don't care.

Aaron:
And op return is a little bit of text.

Sjors:
Yeah. Op return basically means, okay, you're done verifying, ignore this, but it can be followed by text, which is then ignored. Except by new nodes, which will actually check this. So this allows nodes to communicate blocks and transactions to new node and to old nodes. And they all agree on what's there. And the other reason why this can be a soft fork and that's more important for the new nodes, is you're spending... Where are you sending the coins to when you're using SegWit? So you're using a special address type now, and this address type or on the blockchain, what you have is a script pop key. That is what an output says. So an output of a transaction tells you how to spend the new transaction. It puts a constraint on it. And so this script up key with SegWit starts with a zero or at least does now, but with Taboo, it'll start with a one.

Sjors:
And then it's followed by the hash of a public key, or the hash of a script. And new nodes know what to do with this. They see this version zero, they know, okay, this is SegWit the way we know it. And they see a public key hash and they know, okay, whoever wants to spend this needs to actually provide the public key and a signature, but old nodes, what they see is, okay, there's this condition, which is put zero on the stack and put this random garbage on the stack that I don't know what it is. And the end result is, there's something on my stack and it's not zero and I did not fail. And so, okay, whatever, this is fine. You can spend this. So old nodes think that anybody can spend that coin, but new nodes know exactly who can spend it and who can not spend it.

Aaron:
Yeah. It's actually called anyone can spend out.

Sjors:
Yes.

Aaron:
So in a hypothetical situation where there would only be old nodes on the network, then it would also literally mean that the coins in these addresses could be spent by anyone.

Sjors:
Yeah. This is why the activation of Taproot was of course, always exciting because yes, the miner signaled, but okay. What happens?

Aaron:
Yeah. We discussed that in the last episode I think, or the one before that.

Sjors:
Well, in general, we've talked about, what can go wrong with soft fork activation and this would be one of it. And so, well, it didn't go wrong. So, that's good.

Aaron:
Yeah, so the reason it didn't go wrong is because if there's a mix of all the new nodes on the network, but most miners have forced the new rules then most miners will ensure that these coins in anyone can spend outputs from this perspective of old nodes, won't actually get spent.

Sjors:
That's right.

Aaron:
They'll consider blocks that spend these coins invalid. And as long as they're in the majority, they'll also create the longest chain. So now new nodes are happy because all the new rules are being followed and old nodes are happy because no rules are being broken from their perspective and they just follow the longest chain. So everyone's still in consensus.

Sjors:
Yeah, and this rule I just told you about, this script up key, that puts things on the stack. And as long as it's not zero, everybody's happy, it's a hack. It's just leveraging some ugly aspect of ancient ways that Bitcoin scripts work. But with SegWit, the first thing will be the number zero or the number one, et cetera. And this actually introduces a cleaner variant of the same principle, which is that as far as a SegWit note is concerned. If it starts with the number zero, it's going to enforce the rules. If it starts with the number one or higher, it'll consider it a, it doesn't matter anybody can spend this. And if we get Taproot, then the new nodes will see version zero, they'll enforce the rules, they'll see version one, they'll enforce the rules. But if they see version two or higher they would just consider it valid, and that means that moving forward, it's much easier to introduce soft forks like Taproot without having to find another hack in the old scripting system to exploit.

Aaron:
Right, so SegWit was a little bit of a hack, but it was in that sense a one time hack, because now we can use versioning and every time we want to introduce a new rule for spending coins, it's going to be pretty clean and easy moving forward.

Sjors:
Yeah, exactly. And within Taproot, I guess it's a little out scope for this one, but within Taproot, we have these multiple branches that can have their own condition and those scripts also have a versioning mechanism. So there's even more versioning that can be done.

Aaron:
Right. One more question Sjors. We mentioned that the signatures, they're included in the end of the block, you mentioned.

Sjors:
I think they're appended.

Aaron:
But there's a reference in the coinbase. So how are all these transactions included in one little transaction?

Sjors:
Well, it's called the Merkle tree.

Aaron:
Merkle tree?

Sjors:
Yeah.

Aaron:
Well this sounds excited.

Sjors:
We talked about Merkel trees in an earlier episode.

Aaron:
I think we did.

Sjors:
Quite at length. We tried to explain them and it was possibly quite terrible, but we've done it and we're not going to do it again, but basically it's essentially just taking a hash, but a Merkle tree is a little bit more elegant than a hash because it allows you to point to specific elements inside the tree. A hash will just say yes or no for everything that's in it. Could be a whole megabyte, is correct or not, but with a Merkle tree, you can say, "Okay, I can actually prove that this specific transaction exists inside that tree at that position." Without having to reveal everything else in it. And that's kind of cool.

Aaron:
Yeah. And I think it's essentially sort of a mirror of the actual transactions right? Which are also included in the Merkle tree in the block. And then there's-

Sjors:
It's the same idea. So it's not rocket science.

Aaron:
So we have one Merkle tree for transactions, the regular transaction data, and then sort of a mirroring Merkle tree for all the references to the signatures in the coinbase block. Right?

Sjors:
Yeah, exactly. And I think you could generalize that to something called extension blocks where you could add something else to transactions in the future and just refer to that in a coinbase output. And so you could increase block size through soft forks to a degree, but you can't really go super far with that. Because as far as the old nodes is concerned, there still has to be a valid transaction out there. And a valid transaction probably has to have at least an input and at least an output, even if the output says, "Do whatever you want with this." Can't make it smaller than that, and there's still the one megabyte limit as far as these old nodes are concerned. You can't use extension blocks just to add data to transactions. You can use it to add data to transactions, but you can't use it to create an infinite number of transactions because those transactions have a minimum size, probably about 60 bytes.

Aaron:
We're going off the rails.

Sjors:
That's fine. All right. Bring us back to the rails. I think there were some other benefits of SegWit that we wanted to mention.

Aaron:
So we mentioned transaction malleability is soft, which was necessary for something like the Lightning network so that's why we have Lightning network now because we had SegWit, the other benefits we mentioned is block size, limit increase.

Sjors:
Yeah, and I guess we had four years almost of low fees, now they're high again.

Aaron:
Yeah, they're stacking up now. Then we had the versioning, so easier to make new upgrades. Were there more benefits than that?

Sjors:
Yeah. There is. There's committing to the inputs. So this is fun for hardware wallets. If you're a hardware wallet and you want to sign something, we talked about that in one of the very first episodes. Where we explained that if you're a hardware wallet and you want to sign a transaction, you want to look at the output amounts. You can do that, but you want to make sure that the input amounts actually sort of add up to the same as the output amounts so that money isn't just disappearing into fees. But the only way to do that is to actually have the input transactions and look at their output amounts. And so that meant that in the old days, you would have to send all the input transactions to the hardware wallet as well. And it would have to process them. And it's a lot of work or it could be a lot of work if they're big transactions.

Aaron:
Yeah. So to be clear, this is always the case for any wallet. You always have inputs, that's the coins you own. And then you have the outputs, that's the coins you're sending, including a change output to yourself usually. And then the difference between them, that's the fee. And that's for the miner to keep.

Sjors:
Yeah. The fee is not actually mentioned in the transaction.

Aaron:
Yeah, exactly. There's no fee amount or anything like that in transaction. You just have to calculate it yourself. That's fine for regular wallet because the regular wallet just knows how much all of the inputs are worth. And the outputs are obvious they're in the transaction and then the difference, it's easy to calculate, but a hardware wallet is basically just signing from private keys and it doesn't necessarily know how much all the inputs are worth. So now it's... Am I saying this right?

Sjors:
Yeah, it's right.

Aaron:
Yeah. It's sending money away, but it's actually not sure how much money it's sending and therefore a hardware wallet has the risk that it's sending 10 million coins as a fee without realizing that.

Sjors:
Right. The main problem there is the fee could be arbitrary. And so if somebody colludes with the miner or just wants to take your coins hostage in some weird way, that's not good. So what SegWit does, is it commits to those inputs. So normally a transaction, in the old days, the transaction would... The input would just be the idea of the transaction that we just talked about with all the malleability stuff and the index basically.

Sjors:
So a transaction has multiple outputs. So you'd say the suspending output zero of this and this transaction. And with SegWit, what's basically added to that is the amount. Actually, not just the amount, I think the entire transaction. So take the transaction and hash it. And that's what you're committing to now. And that includes the output amounts of that transaction. So now when you're signing it, you can check it. Could still be entirely fake, by the way, you could craft a fake transaction with fake inputs and any output amount you want, but then if the hardware wallet signs it and you put it on the blockchain, well, it's not going to be valid. So that's kind of a useless cheat.

Aaron:
Yeah. We talked about that in episode two maybe.

Sjors:
No, I think in the first episode.

Aaron:
Episode one?

Sjors:
Yeah, with the actual tornado.

Aaron:
Right, okay. So now we have four benefits of SegWit. One of them is malleability, which was sort of the main one. I think that was the reason it was included in the elements side chain of Blockstream I think before it even made it to Bitcoin, and I think that was the reason they added was solving malleability. So-

Sjors:
Yeah, it enables things like Lightning, so that's a pretty big capacity increase potential.

Aaron:
Exactly. So that's one, and then we have the block size increase, which is two. Then we have the versioning bits, which makes it easier to deploy future upgrades, which is three. And then four, you just mentioned, is the hardware wallet fee issue is solved.

Sjors:
Yeah, or at least we thought it was solved. We explained it the first episode that there's some gotchas. But yeah, those are, the four main benefits. And I think there's some minor tweaks as well in there, but it was a pretty big change, compared to that Taproot is relatively simple.

Aaron:
Yeah. So I spent a lot of time on reddit.com/rbtc. And all I read there is that SegWit is the awfullest thing ever. How come Sjors?

Sjors:
The awfullest?

Aaron:
Yes. It's horrible.

Sjors:
Okay, well, sorry to hear that. I don't know. I've heard more reasonable objections from non-r/btc places saying, "Well, it would've been slightly simpler to do it as a hard fork." But the more I look at it, the less I'm convinced of that.

Aaron:
Yeah. I guess the argument there would be that the signature hash tree is included in the coinbase and there would've been a cleaner place to put it if-

Sjors:
Well, you wouldn't have had to put it anywhere. If you do a hard fork, you can just add the witness data to the blocks and in the main Merkle tree. So you don't need to do anything in the upper turn.

Aaron:
Right.

Sjors:
But the downside is you need to actually do a hard fork. And just to think through what's involved to do that, that's where all the complexity then goes and all the precedent risk. So I think it's good that this was done as a soft fork.

Aaron:
Yeah. I think I was saying it in jest, but I think that it's probably the only arguments that I've heard that even make slight sense that's also being exposed, in English words.

Sjors:
It's been a while since-

Aaron:
On r/btc I meant.

Sjors:
I think that's one of the more serious ones, but other than that, I think the main arguments were, it was a block stream conspiracy and-

Aaron:
Sure, yeah, yeah, of course you have all that.

Sjors:
Extra complexity so that Bitcoin Core can get paid more and a whole bunch.

Aaron:
Okay. Are you conspiracy denier?

Sjors:
Yes. I'm conspiracy denier.

Aaron:
Wake up sheeple.

Sjors:
I'm sorry. I will keep sleeping. I think that's it, right?

Aaron:
I think so, Sjors.

Sjors:
All right then. Thank you for listening to the Van Wirdum Sjorsnado.

Aaron:
There you go!

-->
