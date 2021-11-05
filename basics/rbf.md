\newpage
## Replace by Fee (RBF)

![Ep. 26 {l0pt}](qr/26.png)

discuss Replace By Fee (RBF). RBF is a trick that lets unconfirmed transactions be replaced by conflicting transactions that include a higher fee.

With RBF, users can essentially bump a transaction fee to incentivize miners to include the transaction in a block. Aaron and Sjors explain three advantages of RBF: the option the “speed up” a transaction (1), which can in turn result in a more effective fee market for block space (2), as well as the potential to make more efficient use of block space by updating transactions to include more recipients (3).

The main disadvantage of RBF is that it makes it slightly easier to double spend unconfirmed transactions, which was also at the root of last week’s “double spend” controversy that dominated headlines. Aaron and Sjors discuss some solutions to diminish this risk, including “opt-in RBF” which is currently implemented in Bitcoin Core.

Finally, Sjors explains in detail how opt-in RBF works in Bitcoin Core, and which conditions must be met before a transaction is considered replaceable. He also notes some complications with this version of RBF, for example in the context of the Lightning Network.

<!--
Transcript (computer generated):

Aaron:
Aari heard Bitcoin is broken. It is again. Yeah, it was absolutely terrible. A double spend happens ruined, and this is because a fatal flaw in the Bitcoin protocol. Yup. That's how it was reported. I think in the Bloomberg,

Sjors:
Yeah. I couldn't find the original report by Bloomberg thing. Coin Telegraph reported it more or less in that way. And then Bloomberg referred to it.

Aaron:
Oh yeah. I think that's what happens, but

Sjors:
At least more recent articles I saw from Bloomberg was saying, oh, newbs thought it was broken. And they were all Googling double spins. Oh, they corrected it. I don't know. I wouldn't say corrected it. They were more like, you know, going meta on it,

Aaron:
On their, on their own mistake. So I

Sjors:
Don't know if it was their own mistake because I've only seen the haters basically saying that they made that mistake.

Aaron:
Fair enough. Okay. So to be clear, Bitcoin is not actually broken. Nope.

Sjors:
It's working as expected. It's working

Aaron:
Exactly as expected. Now we could get into a discussion on whether or not the double spend happens or not. And that gets into the definition of double spend, but we're not going to do that shores. No, instead we're going to explain what was sort of this alleged fetal floor on the protocol, which was replaced by fee RBF. Yes. That was sort of why this alleged double spent could have happened.

Sjors:
Yeah. It could have happened even without that, but

Aaron:
Ah sure. Yeah. And that's, I guess that's the sort of stuff we're going to discuss in this great podcast today.

Sjors:
Exactly. So stay with us and you'll learn more.

Aaron:
Okay. First of all, show us this thing is called replaced by fee, just in brief terms, what does it mean? What is replaced by fee?

Sjors:
So it means you have a transaction that might be going from B and you're paying a fee to the miners and you decide it's taking too long because minus well, mind the biggest fee first, generally. And so you can send the nutrients action with the same origin, same destination, if you like, and you increase the fee and then that gets propagated to your peers.

Aaron:
Yeah. Well now you've already sort of described the use case. If we want to put it in more abstract terms, it basically means that if there are conflicting transactions, the miner will pick the highest one. Right?

Sjors:
Exactly. So conflicting transactions means spending the same input.

Aaron:
I said highest one. I mean highest the transaction with the highest transaction fee. Yes, that's right. Yeah. So, and you just described one use case, you're sending a transaction and it's taking too long to confirm. So you send the new transaction with the higher fee.

Sjors:
Yeah. And that's a very, you know, reasonable use case, you know, you're sending a transaction with maybe once or twice per bite because you're not in a hurry. But then after a couple of days you're like, okay, this is ridiculous. And you bump it to a hundred Satoshi provide and it goes into the next block.

Aaron:
Yeah. Or after a month, right now we have transaction in the mental that have been there for a month that pay wants a two sheet. This is the first time ever, I think this has happened. Okay. So fee market is working, which shores is the next point I want to make. This is another argument in favor of replaced by fee is that it actually allows for more effective few markets to happen.

Sjors:
Yeah, that's right. Because in 2017, what we saw is that because people did not use replace by fee, they saw the pool was quite full. They thought, okay, currently the fees might be 50 Satoshi per bite, but I can't change it anymore. So I'm just going to be safe and I'm going to set it to a hundred Satoshi for bait. And then the next person would say, oh, well that looks really expensive. Let's make it two. And it's a Toshiba bite. So people were really bidding up against each other much more than, than was necessary. Exactly.

Aaron:
With replace by fee. They could have instead paid, say one Satoshi and then keep an eye on the [inaudible] maybe, and see, okay, you know what? It looks like my one Satoshi transaction, isn't going to confirm in the next block. So in the, what I'm going to bump it to five and then sort of keep an eye on the mental or weights, you know, half an hour or however much in a hurry they are. And in that way, sort of make sure that transaction confirms fast enough, but not overpaid to make sure

Sjors:
Exactly.

Aaron:
Yeah. So we've got two benefits already. One of the benefits is your transaction gets stuck. You want to get it unstuck. Second benefit is it allows for better fee markets. There's a third interesting benefits. And I think they're more if we want to get into the, into the details, but what one pretty obvious one is that with replaced by fee, you can make more efficient use of the Bitcoin blockchain. So for example, I'm paying you shorts and then next I'm paying Rubin. Who's not here today, but I'm also paying Rubin. And the way I could do that with replaced by fi is I send you one transaction first. And after it, I decided that I wanted central minutes resection. So now I create a transaction that pays shoe both and then include a good fee in that. So now instead of using two different resections, I can use one transaction, which is more efficient Blackspace

Sjors:
Yeah. And exchanges can do this at a much larger scale, right? So they have lots of customers that they need to pay out. And so they create one transaction and that's going to be an example for awhile. And so every time a user withdrawals, another user redraws coins that just expand that transaction. And then whichever gets into block, gets into block and the rest will just make a new transaction. Okay.

Aaron:
Exactly. They can sort of keep updating this front section by including more and more recipients.

Sjors:
Yeah. Which also again, means more efficient use of the blockchain. So you get more value for your fee bites.

Aaron:
So there are free, pretty good benefits. One of them is getting transactions on stock. The second one is allowing for a more effective fee market. And the first one is more block space efficiency. Yeah.

Sjors:
And I can mention a fourth one that will actually create a nice bridge to the downside, which is, let's say you make a, once a Toshiba provide transaction to an exchange. And that exchange is called Mt. Gox. And you read on Twitter that, you know, this is maybe not a very good exchange. So you're like, okay, maybe I don't want to do this anymore. And so you can cancel a transaction because you can create a transaction with a higher fee that just goes back to you. Right?

Aaron:
Yeah. So you're describing it as a benefit now, but like you said, this is, was critics of replaced by fee would consider a detriment.

Sjors:
And it is of course

Aaron:
In a way there aren't that many critics of RBF anymore, I think. But yeah, the detriment, the downside is that it allows for double spending, if the recipient isn't going to wait for confirmations. So it's easier to double spend unconfirmed transactions with RBF. Yeah.

Sjors:
Of course. A big discussions, a in 20 15, 20 16, when this, what we're going to talk about was introduced, you know, a lot of merchant applications would like to be able to just have an instant confirmation essentially, but it wouldn't be confirmed so that that's inherently risky. But as, I guess, we'll explain by default, if everybody played reasonably nice, it wasn't very risky, but of course in Bitcoin we think long-term, and we don't want to rely on something that just requires too much kumbaya.

Aaron:
Yeah. So that was a need, a big discussion on whether or not we should allow RBF in the protocol. I'm saying protocol, but to be clear either way, it's not actually a consensus rule.

Sjors:
Yeah. So there's a difference between consensus as in what is allowed inside of a block. So if you see a block with something in it, that's not consensus compatible, you will not accept the block. And so the minus won't get that reward and it's really bad.

Aaron:
It's just an invalid transaction, valid block. Yeah. But

Sjors:
There's all sorts of rules that pertain to how the network works. Things that, which transactions a note will relay or which ones that will reject. And those rules are, you know, they're written into code. So if you run the code, as it comes, it'll do that. But there's, there's not really any enforcement. Other than that, you can change the code or change the setting and it will behave different.

Aaron:
Yeah. These are like peer to peer layer rules. Yeah. And importantly, this is also for miners. This is how they decide which transactions they include in blocks.

Sjors:
Yeah. But there it's even more important to realize that minors, of course, you know, are very conscious of their revenue. So they, they will probably change something if the code does something that's not favorable for them economically and they can get away with it, they will do it. Presumably if it's not some education.

Aaron:
Yeah. So the reason it was sort of controversial at all in the first place is because it was going to be, the discussion was on whether or not RBF replaced by fee was to be included in Bitcoin core. And most Bitcoin nodes on the network are Bitcoin core. So if all Bitcoin core nodes would, for example, rejects, replaced by feed transactions, then it would actually be very hard to get your replacement feature section to minor because nodes wouldn't relate over the network.

Sjors:
Right. So you'd have to know who the minor is or does it have to be some notes that that would relate to

Aaron:
Yeah. Or we would have to be a minor or something like that. Yeah. So by including replaced by fee in Bitcoin core, that's by including it, that's how it would become a bit more easy to make an unconfirmed double spend. Yes. Okay. So that's sort of the arguments against through place by fee. Now let's debunk that arguments yours. Can we go ahead?

Sjors:
Well, I

Aaron:
Will finish. I will first mention the way, well, we,

Sjors:
We at least brought up the point that we don't want to rely on people being nice and people using default settings. Sure.

Aaron:
That's the most obvious arguments that it's possible, whether you like it or not. But like I said, whether it's included in Bitcoin core kind of makes a difference on how easy it's going to be. Yeah. Okay. Well, I will mention, first of all, there's a thing calls first seen safe, replaced by fee, which people were discussing back in like 2015, 16. Okay. How does that work? The idea behind first safe, replaced by fee is that you can only replace transactions if the outputs, if the recipients get at least the same amount of money. So that way even an unconfirmed transaction is relatively safe. Under this context, what we're talking about is right, because the transaction can be replaced, but only by adding even more recipients. Yeah.

Sjors:
But there's a huge problem with that, which is that the blockchain has no idea who they change addresses. So normally

Aaron:
What happens is there's no change of address at all. Well, yeah,

Sjors:
But that's all, that's already a problem with, with replaced by fee. But let's say I'm sending you 0.1 Bitcoin and I use a coin worth 0.2.

Aaron:
Oh sorry. There is a change of address. There isn't a fee address. I was confused.

Sjors:
Exactly. So, yeah. So that's good to remind the listener. There is no fee address. There is just how much I'm sending you and then how much I'm sending myself as change. And the difference between that is the fee, right? The problem is if I sent you 0.1 using a point to coin, the change is going to be 0.1. And then if I want to raise the fee, well, normally what I would do is I would just lower the change amount. But with this rule that you just explained, you can't lower the change amount because the blockchain doesn't know, they might think I'm, I'm actually cheating the intended recipient rather than myself. Right? That's a good point. So that means you have to add another input every time you want to bump the transaction fee, but that actually uses more block space. So, you know, it gets really expensive, really fast.

Aaron:
It could still work in the situation we described where an exchange adds new recipients in the payout to theirs, for example,

Sjors:
No, it, if they would have the same problem, that every time they add a new recipient, they would have to add a new input, but that's fine. Well, they'd have to have like a Sahara desert of dust to be able to keep doing that because if they have, if they want to pay a thousand people, they need a thousand inputs, right? So it not sound very practical. I've never seen this proposal myself. I was not very active in the, I was not active at all in Vic Encore when this played out. So maybe this argument has been mentioned, maybe not

Aaron:
And heard it actually, but you're right. Then there is upstate and replace by fee. Okay. This is what's actually in Bitcoin core, right? That's right. So opt in and replace by fee is replaced by fee. Well, what it means is the only way Bitcoin core knows will replace a transaction, even includes a higher fee is if the first transaction includes a special flag. So assign that's tells these nodes, it's fine to replace this transaction if it has an IFE.

Sjors:
Right? And so this is still a way to be nice basically, but, but if you're a merchant and you're relying on this zero confirmation, if you see this flag, you know, that this, you know, this thing might disappear from on the you and Bitcoin core nodes, won't try to stop that.

Aaron:
Yeah. So the most practical sort of use case for this is if you are a merchant like Beth Casa in the Netherlands, I think they will accept an uncle from transaction. So if you're at a bar and you're buying a beer, they have a payment terminal and they will accept unconfirmed transactions unless it has a RBF flack, because in that case, they're just going to say, we're not sure enough that this transaction is not going to be replaced. So this is a rejection from us.

Sjors:
Yeah. And they have to do that in addition to checking the fee, because if you're sending a transaction with a very low fee, then it might also never get confirmed and you have a lot of time to try and replace it. So it's still a can of worms, I think, as a merchant to do this, it's fine for small amounts, I guess. But then if it's fine for small amounts, why worry about RBF? But also I guess the discussion now is not as critical as it was then because now we have lightning and we, you know, we have pretty user-friendly wallets to the point where if you really want to accept something fast, lightning is just much safer and better privacy too. So definitely then that wasn't ready yet. So

Aaron:
Yeah, there are still some proponents of full RBF as well. I think Peter towels is an obvious example and I'm sure there are more, I probably would consider myself one. I think

Sjors:
We remember a mailing list post maybe a year ago where somebody suggested just turning on full RBF, right. At some point in the future, I think that didn't end up happening, right? Yeah.

Aaron:
His arguments, Peter talks to arguments from, I dunno if these are arguments have changed because it's been a couple of years since I wrote this article and spoke with him about this. But his argument was that the way these types of merchants can be relatively short, a double spend, isn't going to happen with an uncle from transaction is monitoring the network. So check in, you know, having nodes on different parts of the network and see if there are any conflict transactions going on, and this is in itself a problem that they feel the needs to do this because for one it's bad for privacy, arguably, well, that's his argument anyways, because these notes now have a better idea of where transactions originated. And two it's requiring resources from nodes on the network because you know, these spying nodes or whatever you want to call them, these double spend checking notes stay after two gets blocks, intersections from different nodes on the network. So, you know, there's sort of wasting resources. Yeah. So it's, so it would be better. Peter developed would argue to just go for full RBF to make this kind of practices useless.

Sjors:
Yeah. But then those practices don't seem to be happening at a scale. That's problematic as far as I know. So I don't know whether you want to change it or not. The other thing is now that everybody's running lightning notes, those notes will have pretty much all of the same problems that you just described. They have to make sure that nobody's trying to close the channel on them, et cetera, does anything fancy. So I think we're already at the place where you really need to pay attention to what's happening in the mental.

Aaron:
Right. Okay. So there is now a version of ops and RBF in big Concor. Yep. And by the way, mentioning Peter, Todd, I think he still maintains like a bunch of nodes that do full RBF.

Sjors:
Yeah. He used to have a separate release that was Lil RBF. And if you were sure that he wasn't trying to Accu, then I don't know if he released binary's or just the code, it's just a one-line change.

Aaron:
Right. So, and the idea was there that people could still use full RBF if they wants to. And I'm pretty sure that some miners actually do use for RBF. Yeah. Which makes sense because it's incentive compatible for them to do so. They make the most money if they do so, so anyways, but in Bitcoin core, there is the opt-in RBF version. And I think you have some more details about what it actually does. Yeah. So,

Sjors:
Oh, I guess it's, it's fun to describe it in a little bit more detail. So given a transaction, like I said, I sent you money and I have some change back to myself. There are five rules that bit conquerable check, if I want to replace that transaction. And this has been the case since zero point 12. So

Aaron:
It quite a while, five

Sjors:
Years ago, something like that. Yeah. 2016. Yeah. So if a transaction spends one or more of the same inputs, right. That's the first condition. So

Aaron:
Remember I that's what makes it RBF in the first place? Yeah.

Sjors:
If I, because I can, you know, there's a, I can spend twice, that's bad idea. I could send you 0.1 Bitcoin and, and have a fee and then create a new transaction that uses different inputs. Then of course the blockchain will just mine, both of them. And I have a problem, so I have to replace the input. And if I do that, then first of all, I have to opt into this thing with the flag and we talked about that's rule number one. And then the rule is the replacement transaction may only include an unconfirmed input if that input was included in one of the original, which is a kind of a roundabout way of saying the opposite. I can add new inputs to this new transaction because maybe I want to increase the fee. So I need some extra inputs or I want to add other people, but this input has to be confirmed if it's a new one. And I, my guess is that this is just to prevent a can of worms where I have a transaction that is, you know, unconfirmed and sending it across all the nodes. And it doesn't depend on any unconfirmed inputs and now I bump it, but now it does depend on all sorts of unconfirmed inputs and now enforcing everybody to figure out where those unconfirmed inputs are. And maybe they have a super low fee and I guess it's too complicated to implement, right?

Aaron:
Like I see that

Sjors:
Because, you know, think about what this code looks like on the Bitcoin core end you have to, right. You know, you see this new transaction and what are you going to do? Oh, now some of these dependencies are unconfirmed. I have to traverse that whole tree. I don't want to think about that. I only want to think about my descendants.

Aaron:
Yeah. It would basically allow for types of denial of service attacks, I guess, where you're just, yeah.

Sjors:
I think it's my guess is it's both for denial of service, but also just to make the code easier to implement for anybody who writes this design or note software, then rule number three, the replacement transaction pays an absolute fee of at least the sum of the original transactions, because you can replace, you know, one transaction plus a bunch of its descendants, the things spending from that. But the absolute fee has to be the same. So if I paid or higher, yeah. The same or higher. Exactly. Which also means that if I paid you and then you paid somebody else and I want to replace my transaction, then there's action that you paid to somebody else. I have to at least pay the same fee that was in there. It's kind of a disincentive for me to reorg from under you, because that's one of the annoying things that RBF, right. I'm paying you, you paying somebody else. Now I bumped the fee, oh, oops. The transaction, you paid to somebody else's now gone. Right. And well, I would have to really deliberately do that because I would have to increase the fee on my own transaction by enough, that it also covers that transaction of yours that I just destroyed. So in practice, this wouldn't happen. We would either both agree to send a new transaction and somehow packaged him or not. Yeah. There are

Aaron:
Probably very little, if any sort of real world examples where an RBF transaction would have a lower fee. So it's just to prevent weird. Yeah.

Sjors:
It isn't annoying and maybe we'll get to it, but it's probably necessary. And then the fourth rule is it has to increase the fee rate by the minimum relay fee. Sure. So usually at least once a Toshiba bite, but if a maple is full, then the minimum relay fee is going to be higher. So if the members are very full, then you cannot bump by just once a Toshiba bite may have to bump by 10 Satoshi, provide

Aaron:
This could differ from note to note, if they have different members for whatever reason, then they might have a different idea for the minimum relay fee is so it might make its way for parts of the network, but not ours. It's possible.

Sjors:
Yeah. This is a tricky bit, right? Because you know, from your own note, how much is in the men pool. And so you have to estimate what the minimum fee rate is that still goes into your mentor. But if you just start your node after stopping it in, the mentor might be incomplete. And so you might be more optimistic about how low the fee increment can be. So it's kind of annoying, but it does make sense that you don't want people to spam the network and you want to keep. Yep. So, and the fifth rule, once the number of original transactions to be replaced and their transcendent transactions will be evicted from maple must not exceed a total of 100 transactions. So I guess a simple way to say is that if you do something convoluted, that touches more than a hundred transactions, it's not going to work.

Sjors:
Right. And another caveat that I don't think is in these rules, but it is there is that if you replace a transaction, it has to opt into it, right? Every, every one of its inputs has to opt into allowing this fee bump, but also for all the descendants, this has to be true. So if, if I sent a transaction to you and you sent somebody else, but your transaction does not opt into RBF, then I can't replace my own. Right. And also I can opt out of RBF. I can bump the fee once and then I can say, now it's final. So I opt out in the, in the last bump.

Aaron:
Oh, that's actually possible. Yeah.

Sjors:
Right. And this is probably also why there's so many problems because we can talk about problems.

Aaron:
Oh, Darryl problems.

Sjors:
There are problems. Barn is specially. Well, let's start with a simple problem that I don't think I've seen a solution for. Let's say why I'm sending you a transaction, but I'm also sending Rubin a transaction. I think we mentioned that example. And those are two separate transactions, but now I think, oh my God, what if I combine those transactions? Because that will be more efficient. It would be. Yeah. But because maybe I can, yeah. I can use fewer inputs in particular because I have one input that goes to you and I have one, I put the ghost of Ruben and if I combine them, then they go to both of you. Right. So that saves me a number of bites, but we talked about rule number three. So I don't think we can do that.

Aaron:
Oh. Because it has a lower absolute fee in that case. Right. So there actually is a normal example where it would be handy.

Sjors:
Yeah, exactly. So, because I've increased the fee rate, right. Because I have to increase the fee rate, but unless I double the fee rate, or I don't know what the factor is because I've made the transaction smaller, the absolute fee is going to be lower. So generally merging two transactions is not, yeah. It's not going to work. Right. The current RBF.

Aaron:
So yeah. The way to go then would be my solution to just make, not make two separate transactions, but the second one would have already needs to already be the RBF one. The downside of that needs to be already combined. The two.

Sjors:
Yeah. The downside of that is it needs to, you need to track a little bit more things of what's going on because in the example I, I gave you is either if one of them confirms. So if, if the one, you know, if, if the one with the combined one, if it confirms, then you're done. If one of the original two confirms, then the combined one won't happen. So it's more clear which one you need to bump. But if you start combining things you need to track, I guess, because one of those versions will confirm. You need to remember which ones to add, but you're probably gonna have to do something like that anyway. And a wallet can automate it. Yeah. And this is not really a consumer use case that often, because you know, you, you might send more than one transaction per unit of time, but usually it'll probably be confirmed before you get to the next one.

Sjors:
Sure. But for exchanges, this is relevant. But for exchanges, they can build the automatic tracking software, maybe just as a non-issue. But I just wanted to bring it up to illustrate the rule. And then there is transaction pinning, which is a problem with lightning. And here, I think the simplest way to say is with lightning, you, you have two parties that craft a transaction together, but they have to decide in advance what the fee is going to be. That's annoying because fees can go all over the place. So when two lightning notes are connected, they are constantly sort of renegotiating those transactions and creating new ones just because they want to take into account the fee, whether

Aaron:
Yeah, well what you mean, I think is so yeah, to be clear, enlightening, you need to create a transaction with your channel partner, but then sometimes you'll only broadcast that transaction months later, while at the time of negotiating the transaction, that's when you're deciding on what the is going to be, while months later, maybe that fees not going to be enough, that's the problem.

Sjors:
Yeah. But as your lightening notice running, it's talking to the other side and it will, we negotiate. So it's not too bad. Okay. Regardless. Yeah. If the channel closes, you know, maybe you don't reach each other and it might be very unfavorable fee. So the idea here would be, wouldn't it be nice if you can agree on a very low fee, but you can RBF it yourself later. And so there was some complicated thing done with these lightning transactions, as well as a rule in Bitcoin core, that would let you add extra outputs to it. And then each of the parties could RVF that you wanted to, but the weakness in that story is that if I'm evil, I could basically add a transaction to RBF ed. And it would say opt out of RBF and the fee would be very low because we talked about this rule that all of the descendants have to opt into RBF. Does that make sense? Repeat the last part. So I'm, I'm doing this RPF transaction, but I'm opting out of it in that RBF transaction. We'll see. So now you want to bump that, oh,

Sjors:
Got it. You can't even add your own RBF anymore because one of the descendants is now opting out and there's this very shenanigans like that. Like you could add 99 transact, a chain of 99 transactions to it. So you violate the 100 maximum rule. You know, you add 99 transactions with a super low fee. Now the other side can not add number 100 or 101. Right. And all sorts of knowing shenanigans that if you go to a lightening developer mailing list, it is full of this sort of pure headache. And I don't think, I don't think that just going for a full RBF would really solve that because the other problem we talked about in another episode, it's just packaged really in general, like what do you do with these? If somebody wants to replace a chain of a hundred transactions. Yeah. That kind of worm. I'm just going to leave it open. Just saying that this is every now and then on the mailing list, you'll see threads and people proposing different solutions and then people explaining why that doesn't work. Yeah.

Aaron:
Yeah. Okay. Well that was getting very into the weeds. Let's get back to the beginning. What actually happened with this double spent concrete

Sjors:
Back to our amazing adventure that made it all the way to Bloomberg and crashed the market by 7% allegedly

Aaron:
Maybe no, I

Sjors:
Don't actually believe in astrology. So basically what happened is fork monitored at info is a site that I also work on by BitMEX research detected two blocks at the same height, let's call this steel block or at least one of them is going to be stable.

Aaron:
One of them is definitely going to be still because, well, for obvious reasons,

Sjors:
Yeah, because other miners will see two blocks and then there's some heuristics like just build on the first one you saw, for example, also notes will do that. They will, if, if all things equal, they'll pick the first one they saw. And at some point miners will build on one side or the other and that's going to be the final blockchain. But what happens if in one of those blocks is a transaction that sends money to you and in the other block is the same input. But it goes to me that that will be a double spent right now, in this case, what was seemed to be happening is that there was a fee. Somebody did an RBF fee bump basically, but the winning, like the higher fee ended up in the shortest chain and the lower fee ended up in the longest chain. And this probably wasn't any nefarious thing. It's just that those transactions and the fee bumps are moving around the menthol's all over the Bitcoin network. And you find a block just before you see the increased fee and you miss it.

Aaron:
That's probably what happened. They stance that was one fee. And then there was a replacement fee. And while the replacement fee was still making its way over the network and reached one miner that mined the block, it hadn't yet reached another minor that also mined to block at the same time. So now there will conflicting transactions in the toolbox.

Sjors:
If I remember correctly, this particular transaction also had an opportune script. So it was probably some sort of protocol like that's doing some sort of token thing and the opportunity scape was also changing. So that's why it was marked as a double spend and not as a fee bump because I brought the detection code for that. And one of the rules was like, if the fee changes by a little bit, I'll consider it a few bump with, or without the RBF flag, because maybe people use it or they don't. But if something weird changes, then it just says, just manually investigate. This might be double spend and that crashed the market. Right. But yeah, there was nothing going on. Yeah. It was resolved exactly. Like you would expect it to resolve exactly like how Bitcoin is designed. Alrighty. Anything else then? Nope. All right. Thank you for listening to the event. Weird. I'm sure as NATO, there you go.
-->
