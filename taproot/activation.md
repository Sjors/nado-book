\newpage
## Activation Options

![Ep. 03 {l0pt}](qr/03.png)

The Taproot soft fork was activated on November 13, 2021, approximately one year after the finalized code was merged.^[<https://github.com/bitcoin/bitcoin/commit/3caee16946575e71e90ead9ac531f5a3a1259307>] It happened much more quickly than SegWit did, and with far less drama, but it wasn't an uneventful year. This chapter discusses how soft forks were activated in the past and what options were reasonably expected to be available for Taproot.

### Soft Forks: A Primer

As Taproot's deployment grew close, the question of how to activate soft forks once again became a topic up for debate in the Bitcoin community.

Soft forks, if you recall, are changes to the protocol that are backward compatible. In other words, anyone who has upgraded will reap the benefits of new changes, but those who don't upgrade will still find their software working.

Additionally, a soft fork gets rid of things that are no longer useful and makes improvements to things that were problematic or vulnerable before. In the context of Bitcoin, it's a nice and elegant way to make the rules stricter without suddenly freezing anybody's coins.

What this means is that people can keep using Bitcoin as they did before; they don't have to upgrade, and they can keep using the old rules if they want to. An exchange can basically ignore SegWit for years and it's perfectly fine, as far as the blockchain is concerned.

### Upgrade Strategies

There are a few different ways to introduce a soft fork. You can do it randomly, you can announce a date, and you can have miners signal up to a certain threshold.

Satoshi initially introduced a soft fork in 2010,^[<https://en.bitcoin.it/wiki/Block_size_limit_controversy>] but it was done in a way that we'd no longer do it, which is randomly. Essentially, there wasn't a limit before, so he introduced a one-megabyte limit, and then it wasn't discovered until 2013.

Of course, it could have been that, in his mind, he was fixing an attack factor, in which case it makes sense not to mention it in advance, or else it increases the chances of that attack factor being exploited. But there's a general consensus that this isn't an acceptable way of introducing a soft fork now.

Another way soft forks can occur is with a flag day. In other words, you'd say, "From this day forward, this new rule shall apply." And you announce that in advance, giving people plenty of time to upgrade.

But there's still a problem there, which is that you want to make sure everybody's actually running the new software — especially miners, because they kind of have to enforce those new rules.

So everyone who's upgraded is enforcing the new rules, but if a majority of hash power does it, that means they always reclaim the launch chain even for the non-upgraded nodes. So then everyone, old and new nodes, will converge on this chain. So that's why it's very nice if a majority hash power enforces the rules as well.

There's a risk for miners: If a majority of miners enforces the new rules, but a minority doesn't, the minority could accidentally mine an invalid block and then have their block orphaned. And they might not even know why this happens if they haven't upgraded.

Finally, there's miner activation, or signaling. Signaling works as a coordination mechanism for the network to figure out that enough miners have upgraded. This signals to everyone the network is ready. And through this signaling mechanism, which is embedded in the code, a date or a time or a block height is communicated. And if enough signals are included in the blockchain, then we all know at block height X, the new rules will go into effect.

Usually it's every two weeks you count the number of blocks that have the signal. And if it's above a certain threshold, for example, 95 percent, then you know that two weeks later the new rule is active.

But the question is: What will be done for Taproot? And what was done in the past?

### BIP 9

In 201X, BIP 9^[<https://github.com/bitcoin/bips/blob/master/bip-0009.mediawiki>] arrived on the scene, and it allowed deployment of soft forks in parallel.

It was used a couple of times to deploy some features, but when it was time to deploy SegWit, it took a long time. The code was ready, but it didn't activate, because fewer than 95 percent of miners were signaling for it.^[With BIP 9, many miners were blocking the upgrade, either because they wanted political leverage, or because they were secretly benefiting from something that the upgrade would've fixed without telling anyone that that was the case — or both. In short, there were bad reasons for the miners to block this upgrade, and this made Bitcoin core developers and others realize that depending on them gave the miners leverage, which they shouldn't have at all. They were treating it like a vote — when it's just meant to be a coordination mechanism — and abusing their vote in ways that were bad.]

At this point, a number of different things happened outside the blockchain. There was basically a group of people that said, "Hey, you know what? Instead of the signaling, we're just going to go back to the old flag day approach." And that was called BIP 148.^[<https://github.com/bitcoin/bips/blob/master/bip-0148.mediawiki>] They picked April 1, 2017 as a date and said that on that day, their nodes would enforce the rules.

So essentially what happened was a bit of a standoff between the two groups. And no one knows quite how it resolved, because if you just look at the blockchain, what you'd see is that, all of a sudden, 95 percent started signaling and it was activated.

Now it's of course very remarkable that this activated exactly before August 1 and not some random other date that it could have happened. But there were no blocks rejected that we could still point at saying, "Hey look, there was actually a fight between miners and et cetera." At the same time, there was an initiative from the New York Agreement Group. And they had a whole bunch of things that they were planning to do. But one thing they were doing is called BIP 91, which was aimed at lowering the threshold. So they said, "Instead of having 95 percent, we're just going to accept 75 percent."

What they did in the end was use 75 percent forced signaling. So it was like BIP 148, but it was like a soft fork to activate a soft fork — basically, you had to signal that you were going to activate the soft fork. And then because there was more signaling, it would activate. But you couldn't chain, because immediately people started signaling at 95 percent.

In the end, you can't really tell what happened. It didn't go wrong, and nobody called each other's bluff. But what did come out of it is that everyone realized it was important to rethink how to actually activate soft forks. Because if you have chain splits — and especially if you have multiple chain splits with people having different opinions about what the blockchain should be — it defeats the purpose of a well-functioning blockchain.

### Rethinking Activation

In rethinking how activation should work, they took a proposal, BIP 8,^[<https://github.com/bitcoin/bips/blob/master/bip-0008.mediawiki>] which was a flag date proposal, and revamped it. The new idea was to have a combination of a flag date and what was proposed in BIP 9: Signaling still exists, with some tweaks, but there's also a built-in option for having a flag date.

With this option, a flag date is a one-way mechanism. In other words, you could propose a new soft fork and not set a flag date, and then later on set a flag date. But you can't propose a flag date and then unset it.

What this means is it doesn't activate the soft fork itself. Rather, it means that if, closer to the date, there's a block that isn't mining support for the soft fork, that block will be orphaned: It forces signaling toward the end.

In other words, if you have two groups of BIP 8 nodes, one of them has the forced signaling on and one of them has the forced signaling off. But miners go along with the forced signaling on, and the nodes that have forced signaling off will still accept the soft fork because they're still seeing the signaling.^[There's a caveat to all of this though. If you have a flag date in mind, you may still need to include it, because you don't want different people to have different flag dates. In the end, if you force people to signal and then they don't signal, and then you just decide to not accept all their blocks, it becomes a mess. In that sense, it's not completely thought out, but you probably still want to have some consensus. If you decide on the flag date, you want to have a very large consensus on what that flag date is and ensure that really everybody goes along with it.]

### Playing with Parameters

So there are multiple ways of enforcing activation, but you can also tweak the parameters. For example, with a flag day, you can play with how long or how far into the future it should be. You can also play with a parameter of what the hash power should be. It could be 95 percent, but you could potentially lower this:  You could say 75 percent is enough. 50 percent is enough. Even 1 percent is enough.

However, doing so is ultimately useless, but the point is you can play around with these permutations in all sorts of ways. So now you have pieces of the puzzle, and you can begin thinking of ways to put these pieces together to come up with a concrete activation strategy that will be used for Taproot.^[You can also imagine that there's going to be a lot of permutations, so this could also be a byte shedding nightmare.]

### Proposed Options

One idea, which was proposed by Matt Corallo, a well-known core contributor, is what he calls modern soft fork activation. He proposes using BIP 8 without forced signaling on the end, or without forced activation on the end for a year. This is more along the lines of BIP 9, which is what used to be done.

In this scenario, you'd see if miners activate a soft fork at the requirement of a 95 percent hash power. If they do it, great, and the soft fork has been activated. If they don't, then phase two of this proposal comes into play, which is six months of developer reconsideration.

At this point, the developers see if there was a good reason for miners to block the soft fork. For example, maybe there was a problem with the proposal — in this case, Taproot — that they hadn't considered before.

If after six months they haven't found anything wrong with the proposal and they conclude that it was actually just miner apathy or there was no good reason, they'll deploy it again, either with forced signaling or a flag day.

On the flag day, what you do is either enforce the soft fork, or else force the signaling, which then triggers the soft fork.

The benefit of this proposed approach is not rushing things but instead reconsidering if there's maybe something wrong with a proposal — and if there is something wrong with the proposal, people don't have to actually need to upgrade their soft fork; they can just keep running whatever they were running.

The downside is that if miners don't cooperate, it'll take a long time before the soft fork is actually live on the network, which means everyone is stuck waiting for essentially no good reason.

Overall, it's nice if you can have improvements ship quickly. That said, if developers decide on a soft fork and activate it quickly, it could result in putting too much power in the hands of the developers. It's a difficult tradeoff, because on the time scale of 200 years, it really doesn't matter if the soft fork takes three years longer. But we have no idea what the right time is.

Another idea for activation is having a deadline of a year, at which point, forced signaling happens. This ultimately sounds easy enough, but the problem with a forced signal is, if you ship something and say, "OK, miners can signal for it, but if they don't, it's going to activate," you kind of lock yourself into that outcome.

And in that scenario, there's no real way to object anymore. Because even if miners come up and say, "Hey, wait a minute, there's a problem," you can't cancel it anymore, because people have this new soft fork and they have the forced signaling in. So lots of people would see their nodes just stop. And so you're essentially ending up with a hard fork if you decide to not do it.

In other words, if you remove any ability to object, then why even bother with the miner signaling? Because once you put a flag date in the code and you ship that code, that's it. It's just going to activate.

Yet another idea is that of Luke Dashjr, which supports BIP 8 with forced signaling toward the end, but he prefers it to be deployed in forks for clients and not in Bitcoin core. In other words, he thinks soft fork activation should happen through different clients. That sort of takes away this pressure on Bitcoin core developers.

The problem with this is, as mentioned before, if you have multiple dates, you're going to get the cowboy bias. Because whoever picks the most aggressive date is the party you kind of have to listen to. But that might be a recklessly early date.

So here's a bad scenario. Let's say we ship the completely ready Taproot code ready for main net in two months. And say the code has this one-year miner signaling stipulation and then it expires. And now the most aggressive group comes out and says, "No, no, no, we're going to activate this like one month later." That's going to be the consensus of the loudest people.

So then, two weeks into that scheme, the miners actually start reviewing it, because people might only review code when it's ready. Now they find a critical bug. And most of the core developers would agree, "OK, this is actually a bug. We should abort. Soft fork miners, please don't signal for it."

But at the same time, you have this super loud group that's already canceled everybody who doesn't agree with them to activate this thing. So that's why there should be at least some decent amount of time and some community agreement on, "When are we going to flag date this thing?" And it shouldn't be within a few months. You should give people a decent amount of time.

This was a very extreme example. A less extreme example would be that miners should have some time to review this code after it's shipped. But some people might say, "No, they should have reviewed it earlier, because we don't want to set the incentive."

Moving on, yet another idea is that of BIP 8 plus BIP 91. This deploys BIP 9, with a long signaling period. After that amount of time, the activation is triggered. However, in the meantime. you're going to see what happens. So, for example, if after a year, it's still not activated, then developers can sort of try to find out why it hasn't activated again, sort of similar to Matt's idea. Developers take their time. They figure out, "OK, there's actually no good reason that it's not being X failed." At that point, they can deploy a new client that has sort of BIP 91 in it, which forces miners to signal support for it before the specified time period is over — in other words, the update is shipped with a lower threshold, which in turn triggers the higher threshold.

The downside of this is what if there's a bug? Because if this thing has a specified time period, that means it could activate during that time period even though everybody agrees it shouldn't. The answer is to deploy a new client that includes a soft fork that undoes the Taproot soft fork in that case.

If you undo a soft fork, it's a hard fork — unless it isn't yet activated. But you don't know that. The problem is people who are running the first version are just waiting for that 95 percent. But then if there's a bug fix, then you need to have a new signal flag to indicate the new version of Taproot that you're going to activate. And you have to make sure the old version never activates.

So a one-year signaling thing is nice, because that means that you can say, "OK, if this thing doesn't activate in a year because there's a bug, we wait a year and we try again, and then we know for sure we're not going to accidentally activate the old version after that year."

Of course, it's kind of annoying to have to wait for a year. But if there really is a bug in something that was ready to be deployed, that really warrants a year of thinking really, really well about how that could happen.

Another idea is similar to the initial BIP 8, which has the option of allowing soft fork signaling. In other words, there's a long period, but without forced signaling at the end. Then you still keep an eye on what's happening. If, after a while, you find that there's no problem with it, but miners aren't signaling for it because they're just apathetic or they have another bad reason, then you can deploy another client with BIP 8 — this time with forced signaling that starts forced signaling before the end of the current signaling period, or at least not later than that.

If it starts before that, then you have two groups of nodes online on the network: the BIP 8 nodes you deployed first that don't have forced signaling on the end, and now the new group of BIP 8 nodes that do have forced signaling. So if they do forced signaling, the older BIP 8 nodes will also accept that as an upgrade.

Overall, it's difficult to say which approach is best. In the short run, it's nice to have all this stuff fast, because being slow for the sake of being slow doesn't make any sense. In the long run, it's kind of scary if something can happen fast, because it gives you less time to stop something if it's bad.

### Why Activation Matters

When looking at all the options above, it's not entirely clear that one way is the best way. However, one thing that is apparent is the longer the activation takes, the harder it's going to get probably, and the more controversial the whole topic might become.

In turn, we'd end up with a whole holy war over the exact details of how to activate a soft fork. The reason this is problematic is some people think that it's a very important precedent to the way you're enforcing a soft fork. It matters going forward for the next soft fork.
