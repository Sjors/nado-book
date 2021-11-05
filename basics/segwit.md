\newpage
## SegWit


![Ep. 32 {l0pt}](qr/32.png)

discuss Segregated Witness, also known as SegWit. SegWit was the last soft fork to have been activated on the Bitcoin network in the summer of 2017, and the biggest Bitcoin protocol upgrade to date.

In short, SegWit allowed transaction data and signature data to be separated in Bitcoin blocks. In this episode, Aaron and Sjors explain how this works, and that this offered four main benefits:

First, SegWit solved the transaction malleability issue, where transaction IDs could be altered without invalidating the transactions themselves. Solving the transaction malleability issue itself in turn enabled second layer protocols like the Lightning Network.

Second, SegWit offered a modest block size limit increase by discounting the “weight” of witness data, most notably signatures. Importantly, this could be done without the need for a hard fork.

Third, SegWit’s script versioning allows for easier upgrades to new transactions types. The anticipated Taproot upgrade could be a first example of this feature.

And fourth, input signing resolved some edge case problems where wallets needed to make sure they don’t overpay in transaction fees.. Hardware wallets benefit from this solution in particular.

<!--

Transcript (computer generated):

Aaron:
Segwit that's right. Segregates. It's a witness, which was the previous software work. Well, was the last of work where we're working towards the taproot software. Now

Sjors:
That's the last software we know of. Exactly.

Aaron:
Yes, I guess. So it activated in 2017, it was developed in, it started being developed in 2015.

Sjors:
I think it was late 2015. Yeah. But the final idea came about to turn it into a software.

Aaron:
Probably. Would you say it's probably the biggest protocol upgrade Bitcoin has seen so far? Right?

Sjors:
Well, it's the biggest protocol upgrade we've seen since the days of completely reckless deployments of upgrades.

Aaron:
Right. Wouldn't you say it's almost the biggest change, for example.

Sjors:
Yeah, I think so. It's, it's bigger change then PTO is H but I don't know what was done in the very earliest Satoshi days, you know, when, when hundreds of op codes were turned off and all that stuff.

Aaron:
So where do we start? Do we start?

Sjors:
We could start with what the problem was.

Aaron:
Okay. What was the problem? Why do I need segue?

Sjors:
Yeah. Why do witnesses need to be segregated? Exactly. So the problem was transaction malleability, and just actually malleability means that if you, if I'm sending you some coins and you're sending them to a Lubin, who's not here, then that transaction that you're sending refers to the transaction that I just sent and the problem there, and that that's fine normally. But the problem is that somebody could take our transaction and manipulate it and I could take my transaction and manipulate it. And then your transaction would no longer refer to my transaction, but we've referred

Aaron:
To avoid. Yeah. And to be more specific, I think what the part of the turn section that's being manipulated is actually the signature. So every transaction is signs with a cryptographic signature and the signature. I don't understand the details, but I know that the signature can be tweaked somehow in a way that it looks different, but it's still valid.

Sjors:
And there were lots of ways to, to do that. So one of the ways that was fixed without segwayed is that you could I think just multiply the signature with minus one or something of just put an, a minus in front of it and it would still be valid. And so anybody could just put that mine is in front of it. So you, you would broadcast the transaction and it would go from one note to the other. Somebody else could see that transaction and they could say, well, I'm just going to flip this bit and send it onwards. And then we'll see which one wins. And this is just for simple signatures, but I think there were other, if you have more complicated scripts, there are also ways that somebody can mess with that script.

Aaron:
Yeah. So someone can mess with it in flight. Basically you send the transaction to the network and then it's forwarded from peer to peer. And until it reaches minor and it's included in a block, but every pair on the network, but can basically take the transaction, tweak it a little bit and forwarded or minor can do that. Yeah.

Sjors:
I guess even the person making it can do it. Sure. Yeah. Or the minor can do it. So you may ask yourself, why is this a problem? Right. Because I sent you some coins and you sent them to Ruben, okay. I ruined your transaction. So you just send it again. So that's, that's not a big deal.

Aaron:
It really ruined the transaction. You just tweaked it a bit, but it's still valid.

Sjors:
I ruined your transaction. So, so I send coins to you and using coins to Reuben, but that last transaction, no longer points to an existing transaction because if somebody mess with my transaction,

Aaron:
Yeah. It's the second transaction that's getting in trouble.

Sjors:
Yeah. And this is not a problem in the scenario we just described. Right. Cause you can just make a new one, except what about if you're not you, but what if I sent a transaction to a super secure volt in the Arctic, like thousands of meters underground. And then I went to the Arctic and I created a redeemed transaction back to my hot wallet, but I didn't broadcast it. I just, I just signed it. Why

Aaron:
Are you making such a complicated example with volts? And Arctics,

Sjors:
Isn't that complicated? I just, you know, I went to my vault. I created that transaction out of my vault. And then I basically buried the volt in like, like a hundred meters of rock. So it's very difficult for me to go back to the vault and make a new transaction. And then I brought gas, my original transaction and send some money to the vault and so many messes with it. Now I have to go back to Antarctica and does this COVID and it's very complicated. So that's, that's a terribly difficult example. Another example would be lightening.

Aaron:
Yeah. That's the more obvious one.

Sjors:
Yeah. So it would lightening what happens and we've, we've explained lightning in earlier episodes, but the idea is you sent money to people, send money to a shared address. And then the only way to get money out of that address is with transactions that you've both signed before you sent money into that address. So you don't want somebody messing with the transaction that goes into the address because then you can't spend from it anymore. Or you can, but you'd both have to sign it again. And so one party could kind of cheat the other party out of the coins.

Aaron:
Yeah. The point with lightening is that you're building unconfirmed transactions on each other. So if then if one of the underlying transactions is tweaked, then the transactions that follow up on that one aren't valid anymore. Yeah.

Sjors:
And people spent lots of time trying to find ways around that problem, you know, because people were thinking about lightening like solutions for quite a while, and it was just really hard to solve.

Aaron:
Yeah. So to be clear that the concrete attack in this, in this lightening example is that one of the parties would tweak the transaction. They shared between them send this tweaks transaction to the network. And then I guess the other party probably wouldn't even recognize that transaction. Or even if he did, he couldn't use his own transaction to get his funds back. Am I saying,

Sjors:
Yeah, all the transactions that get your funds back are no longer valid. So this could be a problem you know, in all the cheating scenarios. Yeah, exactly.

Aaron:
So there's also

Sjors:
Another well-known example, which was the Mt. Gox case. And that was, you know, a mistake on the part of Mt. Gox as well. If we assume that the story we've been told about how the heck happened is really true, but the story was he heck or you mean one of the many hacks,

Aaron:
The big one, but they claimed that the big one was due to transaction malleability. And the story was that they were basically doing their internal accounting based on transaction IDs. So a customer would withdraw funds, use malleability to change the withdrawal transaction a little bit, still get the money because it was our section is still valid, but then claim guys, I made a withdrawal, but I never received the money on Gox would take the transaction ID. Look, if it was in the blockchain so that there is no transaction ID like that in the blockchain, our customer must be right. And then we send the coins.

Sjors:
Any other things you have to do wrong for that, for that particular thing to happen. But, but anyway, let's, let's blame it on malleability.

Aaron:
I'm just giving an example of something that could go wrong because of measurability. If yeah. In this case you make other mistakes as well. So that was malleability. Yeah. So that's all we want to solve. Right.

Sjors:
I have been, you know, partial solutions to this already because it's a much bigger problem than just a signature, I think. But in either way, it turns out that it's seems like a whack-a-mole game. It's just really hard to solve. And the fundamental problem there seems to be that because you're, you're, you're pointing to something that includes the signature. It just gets too complicated. One thing segway does, is it no longer refers to the signature because it, it refers to, well, the, the signature is put somewhere else in a transaction in some sort of extra data, right?

Aaron:
To make this very clear in case some of our listeners aren't keeping up the thing is a transaction cost sense of all of the transaction data, plus the signature formally or usually, or still the case. And sometimes actions, the transaction data and the signature is hashed together. This case gives you a string of numbers and that's the transaction ID because the second chair can be tweaked. That means the hash meaning that transaction ID can also be tweaked. And you end up with basically the same transaction with a different transaction ID. And that causes all the problems we just discussed. So that's the problem we needed to solve. Somehow we need to make sure that a transaction would always result in the same transaction ID.

Sjors:
Yeah. So the solution there is to put the hash DEP sorry, put the signature in a separate place inside the transaction that as far as old notes are concerned, doesn't even exist. And you still refer back to other transactions by the original data. So the original basically be original part of the transaction that still creates the hash and the signature is this new data. And you do not use it to create a hash.

Aaron:
So the signature ID can't be tweaked any more because the signature isn't in there anymore.

Sjors:
Right. So you can still tweak a signature if you want it to. Although there's some limitations on that too, but if you tweak the signature, that's not part of the hash and, and this is nice, right? So that's one thing it does SegWit. And the other thing it does, is it just because this data goes into a place that old nodes don't care about? Well, suddenly you can bypass the one megabyte block size limit without a hard fork because old nodes will see a block with exactly one megabyte in it, but new notes we'll see more megabytes.

Aaron:
Yeah. Blox has a one megabyte limit. And that was, that used to be transaction data, plus all the signatures plus a little bit of metadata. And now it's basically mostly the signature data and not the signatures. And that's where the block size increase comes from. The signatures is sort of the increase.

Sjors:
Yep, exactly. And that's theoretically up to four megabyte, but in practice, it's more like two and a half, I guess, the total size that you get for blocks.

Aaron:
Yeah. Why is that there was some new calculation for how data is counted when it comes to the signature. Well,

Sjors:
Yeah, so I think what happens is you take the old data and you multiply it by three or something, and then you take the new data and you add it up. So the signature is kind of discounted in a way, and that's, that's kind of an arbitrary number, but at least it creates an incentive to use SegWit.

Aaron:
Right. And that's also why it's a bit more flexible now that the block size limit, if there are many transactions with many signatures, for example, multi-six resections, then the size of the blocks could be a little bit bigger because of how it's all calculated

Sjors:
With the usual old fashion transactions. There is not much going on in terms of signatures. You know, there just aren't that many signatures, but you could conceive of much more complicated transactions that have much longer signatures, like in a multisig situation. And those are nicely discounted in segue. Yeah.

Aaron:
Right. So how is it possible that with could be deployed as a soft fork?

Sjors:
Okay. Yeah. So this

Aaron:
Which means backwards compatible operate. So old notes still recognize the Secora chain as long as it has majority hash power, at least.

Sjors:
Yeah. And they do this because this new data that we've added is not like it's not communicated to all notes. So every transaction has a little piece of witness. That's not communicated to all nodes. And every block has a part that is, the witness does not communicate it to old notes. So, so basically new notes, first of

Aaron:
All, where is this part?

Sjors:
I think it's at the end of the block,

Aaron:
It's in the Coinbase transaction, right? It's

Sjors:
So it's, I think it's appended at the end of the block, but it's also referred to in the Coinbase transaction, because what you do want to do is you want to make sure that, you know, the block hash just refers to the things that are in the block, but it only refers to the things that are in a block as far as legacy notes are concerned. So, but you don't want to tell the legacy notes about the SegWit stuff. So what happens is there is a opportune statement in the Coinbase do a hash of all the witness stuff.

Aaron:
Yeah. The Coinbase in case listeners don't know this isn't just a company. It's also the transaction that pays the miner is rewards. So basically the first transaction in any block. Yeah.

Sjors:
And the transaction can just spend the money, however it wants, but it has to contain at least one output with opportunity. And that opportunity must refer to the witness blocks. So all nodes just see an opportunity statement and they don't care.

Aaron:
And return is a little bit of text.

Sjors:
Yeah. Opportunity basically means, okay, you're done verifying, ignore this, but it can be followed by text, which is then ignored except by new nodes, which will actually check this. Right? So this allows the notes to communicate blocks and transactions to new nodes and to old nodes. And they all agree on what's there. And the other thing, the other reason why this can be an up soft work and that's more important for the new nodes is, well, you're spending, where are you sending the coins to when you're using segwayed? So you're using a special address type now, and this address type or like on the blockchain, what you have is a script pup key. That is what an output says. So an output of a transaction tells you how to spend the new transaction. It puts a constraint on it. And so this script up key with SegWit starts with a zero or at least does now, but with taproot, it'll start with a one.

Sjors:
And then it's followed by the hash of a public key or the hash of a script and new nodes know what to do with this. They see this version zero, they know, okay, this is what, the way we know it. And they see a public key hash and they know, okay, whoever wants to spent this needs to actually provide the public key and a signature, but all nodes, what they see is okay, there is this condition, which is put zero on the stack and put this random garbage on the stack that I don't know what it is. And the end result is there's something on my stack and it's not zero and I did not fail. And so, okay, whatever, this is fine. You can spend this. So old notes think that anybody can spend that coin, but new nodes know exactly who can spend it and who can not spend it.

Aaron:
Yeah. It's actually called anyone can spend out. Yes. So in a hypothetical situation where there would only be all's nodes on the network, then it would also literally mean that the coins in these addresses could be spent by anyone.

Sjors:
Yeah. This is why the activation of taproot roads. Of course, you know, always exciting because yes, the main are signaled, but okay. What happens?

Aaron:
Yeah. We discussed that in the last episode, I think, or the one before that,

Sjors:
Well, in general, we've talked about, you know, what can go wrong with a software activation and this, this will be one of it. And so, well, it didn't go wrong. So that's good.

Aaron:
Yeah. So the reason that they didn't go wrong is because if there's a mix of all the new notes on the network, but most miners have forced the new rules that most miners will ensure that these coins in the, anyone can spend outputs from this perspective or notes, won't actually get spent, they'll consider blocks that spend these coins and valid. And as long as they're in the majority, they'll also create the longest chain. So now new nodes are happy because all the new rules are being followed and old nodes are happy because no rules are being broken from their perspective and they just follow the lungs. Jane. So everyone's still in consensus. Yeah.

Sjors:
And this rule, I just told you about this script, Bucky, that puts things on the stack. And as long as it's not zero, everybody's happy. It's kind of a hack. It's kind of just leveraging some ugly aspect of, of, you know, ancient ways to Bitcoin scripts work. But with SegWit, the first thing will be the number zero or the number one, et cetera. And this actually introduces a cleaner variant of the same principle, which is that as far as a SegWit note is concerned. If, if it starts with number zero is gonna enforce the rules. If it starts with the number one or higher, it'll consider it a, it doesn't matter. Anybody can spend this. And if we get taproot, then the new nodes will see version zero, though, they'll enforce the rules, still see version one, don't enforce the rules. But if they see version two or higher, they will just consider it valid. And that means that moving forward, you know, it's much easier to introduce soft forks like taproot without having to find another hack in the old scripting system that to exploit, right?

Aaron:
So segue, it was a little bit of a hack, but it was in that sense, a one-time hack because now we can use versioning. And every time we want to introduce a new rule for spending coins, it's going to be pretty clean and easy moving.

Sjors:
Yeah, exactly. And within taproot, I guess there's a little out of scope for this one, but within taboo, we have these multiple branches that can have their own condition and those scripts also have a versioning mechanism. So there's even more versioning that can be done. Right.

Aaron:
One more question. Sure. We mentioned that the signatures they're included in the end of the block, you mentioned, I think those are pended, but there's a reference in, in the Coinbase. So how are all these transactions included in one little transaction, what's called a Merkle tree miracle tree. And this sounds exciting. We talked about miracle

Sjors:
Trees in an earlier episode. I

Aaron:
Think we did

Sjors:
At length. We tried to explain him and it was possibly quite terrible, but we've done it and we're not going to do it again, but basically it's essentially just taking a hash, but the Merkle tree is a little bit more elegant than a hash because it allows you to like point to specific elements inside the tree where, you know, a hash will just say yes or no for everything that's in, it could be a whole megabyte is correct or not, but with a Merkle tree, you can say, okay, I can actually prove that this specific transaction exists inside that tree at that position without having to like reveal everything else in it. And that's kind of cool.

Aaron:
Yeah. And I think it's essentially sort of a mirror of the actual transactions right. Which are also included in the miracle tree in the block.

Sjors:
It's the same, it's the same idea. So it's not, it's not rocket science. So we have

Aaron:
One miracle tree, four transactions, the regular transaction data, and then sort of a mirroring Merkle tree for all the references to the signatures in the coordinates block. Right?

Sjors:
Yeah, exactly. And I think, you know, the, the general you could generalize that to something called extension blocks where you could add something else to transactions in the future and just refer to that in a Coinbase output. And so you could increase block size through software works to a degree, but you can't really go super far with that. Because as far as the old old nodes is concerned, there still has to be a valid transaction out there. And a valid transaction probably has to have at least an input, you know, and at least an output, even if the output says, do whatever you want with this, can't make it smaller than that. And there is still a one megabyte limit. As far as these nodes are concerned, you can't use extension blocks just to add data to transactions. You can add it to, you can use it to add data to transactions, but you can't use it to create an infinite number of transactions because those transactions have a minimum size, probably about 60 bytes.

Aaron:
We're going off the rails. That's fine.

Sjors:
All right. Bring us back to the reels. I think there were some other benefits of SegWit that we wanted to mention.

Aaron:
So we mentioned transaction meld mobility is solved, which was necessary for something like the lightning network so that, you know, that's why we have lighting network now because we had SegWit. The other benefits we mentioned is a block size limit increase.

Sjors:
Yeah. And I guess we had four years almost of low fees now they're high again. Yeah.

Aaron:
They're, they're stacking up now. Then we had the first meeting, so easier to make new upgrades where there were more benefits than that.

Sjors:
Yeah. There is, there is committing to the inputs. So this is fun for hardware wallets. If you're a hardware wallet and you want to sign something, we talked about that in one of the very first episodes where we explained that if you're a hardware wallet and you want to sign the transaction, you want to look at the output amounts. You can do that, but you want to make sure that the input amounts actually sort of add up to the same as the output amounts. So that money isn't just disappearing into fees. But the only way to do that is to actually have the input transactions and look at their output amounts. And so that meant that in the old days, you would have to send all the input transactions to the hardware wallet as well. And they would have to process them. And it's kind of a lot of work or it could be a lot of work if they're big transactions. Yeah.

Aaron:
So to be clear, this is always the case for any wallet. You always, you know, you, you have inputs, that's the coins you own. And then you have to outputs, that's the coins you're sending, including a change output to yourself usually. And then the difference between them, that's the fee and that's for the minor to keep. Yeah. So

Sjors:
It's not actually mentioned in the transaction. Yeah,

Aaron:
Exactly. There's no, there's no fee amount or anything like that in transaction. You just have to calculate it yourself. That's fine for a regular wallet because the regular wallet just knows how much all of the inputs are worth. And, you know, the outputs are obvious there in the transaction. And then the different, you know, it's easy to calculate Bart, a hardware wallet is basically just signing from private keys and it doesn't necessarily know how much all the inputs are worth. So now it's, am I saying this right? Yeah. It's sending money away, but it's actually not sure how much money it's sending and therefore a hardware wallet has the risk that it's sending 10 million coins as a fee without realizing that

Sjors:
Yeah, the main problem there is the fee could be arbitrary. And so if somebody colludes to the miner or just wants to take your coins hostage in some weird way, that's not good. So what SegWit does, is it commits to those inputs? So normally a transaction, you know, in the old days, the transaction would, the input would just be the ID of the transaction that we just talked about with all the malleability stuff and yeah, the, the index basically. So section has multiple outputs. So you'd say this has spending output zero of this and this transaction. And with SegWit, what's basically added to that is the amount, or actually not just the amount, the, I think, the entire transaction. So take the transaction and hash it. And that's what you're committing to now. And that, that includes the output amounts of that transaction. So now when you're signing it, you can check, it could still be entirely fake by the way. Do you know you could craft a fake transaction with fake inputs and any output amount you want, but then if the hardware wallet signs it and you put it on the blockchain, well, it's not going to be valid. So that's kind of a useless cheat.

Aaron:
Yeah. We talked about that in episode two, maybe.

Sjors:
No, I think in the first episode, episode one, yeah. With the actual tornado.

Aaron:
Right. Okay. So now we have four benefits of segway. It's one of them is Malibu LT, which was sort of the main one. I think that was the reason it was included. It was included in the elements side chain of luxury. And I think before even made it to Bitcoin. And I think that was the reason they had, it was solving measurability. So,

Sjors:
I mean, yeah, it enables things like lightning, so that's a pretty big

Aaron:
Exactly. So that's one. And then we have the block size increase, which is two. Then we have to first inning bits, which makes it easier to deploy future upgrades, which is free. And then for you mentioned, is there a hardware, wallet, fee issue is solved.

Sjors:
Yeah. Or at least we thought it was solved. We explained it the first episode that to some gotchas, but yeah, those are, I think the four main benefits. And I think there's some, some minor tweaks as well in there, but it was a pretty big change compared to that taproot is relatively soon.

Aaron:
Yeah. So I spent a lot of time on reddit.com/btc and all I read there is that sequitous the awful thing ever. How come shores, the awful list. Yes. It's horrible. Okay.

Sjors:
Well, sorry to hear that. I don't know. I mean, I've, I've heard more reasonable objections from non RPDC places saying, well, it would have been slightly simpler to do it as a hard fork, but the more I look at it, the less I'm convinced of that.

Aaron:
Yeah. I guess the argument there would be that, that the signature hash reference, the signature or hash tree is included in the Coinbase and there would have been a cleaner place to put it if,

Sjors:
Well, you wouldn't have had to call it anywhere. If you do a hard fork, you can just add the witness data to the blocks and in the main Merkle tree. So you don't need to do anything in the opportunity. Right. But the downside is you need to actually do a hard fork. And just to think through what's involved to do that is that's where all the complexity then goes and all the, the, you know, precedent risk. So I think it's good that, that this was done as a soft fork.

Aaron:
Yeah. I F I think I was, I was saying it in jest, but I think that is probably the only argument that, that, that I've heard, that even makes slight sense that that's also being exposed than English words.

Sjors:
It's been a while since [inaudible] stuff. I think that that's one of the more serious ones, but other than that, I think the main arguments were, you know, it was a block stream conspiracy and sure

Aaron:
That, yeah, of course

Sjors:
You have all that extra complexities or that big and core can get paid more and a whole bunch of,

Aaron:
Okay, are you a conspiracy? Denier? I, you sleep still shores. I make conspiracy. Yeah.

Sjors:
I'm sorry. I will keep sleeping. I think that's

Aaron:
It right? I think so. It's yours. All

Sjors:
Right, then. Thank you for listening to the fan. Weird. I'm sure as NATO, there you go.

-->
