\newpage
## Activation Options {#sec:taproot_activation}

![Ep. 03 {l0pt}](qr/ep/03.png)

The Taproot soft fork was activated on November 13, 2021, approximately one year after the finalized code was merged.^[<https://github.com/bitcoin/bitcoin/commit/3caee16946575e71e90ead9ac531f5a3a1259307>] It happened much more quickly than SegWit did, and with far less drama, but it wasn't an uneventful year. This chapter discusses how soft forks were activated in the past and what options were reasonably expected to be available for Taproot.

### Soft Forks: A Primer

As Taproot's deployment grew close, the question of how to activate soft forks once again became a topic up for debate in the Bitcoin community.

Soft forks, if you recall, are changes to the protocol that are backward compatible. In other words, anyone who has upgraded will reap the benefits of new changes, but those who don't upgrade will still find their software working.

Additionally, a soft fork gets rid of things that are no longer useful and makes improvements to things that were problematic or vulnerable before. In the context of Bitcoin, it's a nice and elegant way to make the rules stricter without suddenly freezing anybody's coins.

What this means is that people can keep using Bitcoin as they did before; they don't have to upgrade, and they can keep using the old rules if they want to. An exchange can basically ignore SegWit for years and it's perfectly fine, as far as the blockchain is concerned.

There are a few different ways to introduce a soft fork. You can do it randomly, usually only as the result of an accident, you can announce a date or block height, and you can have miners signal up to a certain threshold.

But what perhaps matters more than the mechanics of activation, is how a decision is reached to deploy in the soft fork in the first place.

### The earliest soft forks

Probably the most infamous soft fork of all times is the one-megabyte block size limit introduced by Satoshi in 2010.^[<https://en.bitcoin.it/wiki/Block_size_limit_controversy>] It was deployed unilaterally and nobody paid much attention to it until many years later, when this limit became a practical issue in the form of increasing fees for scarce block space.

Not only was it a unilateral decision by Satoshi to impose this limit, he initially did it secretly. He probably found it safer to keep this change under wraps, because he did not want to alert potential attackers to the gaping security hole, where massive blocks could have ground the network to a halt.

But outside some existential emergency, there's a general consensus that this isn't an acceptable way of introducing a soft fork now. If there had been a debate on the block size limit back then, perhaps much later drama could have been prevented.

Although the term did not yet exist, in those early days there were many soft forks, mostly related to closing security holes in the early prototype.^[<https://blog.bitmex.com/bitcoins-consensus-forks/>] In 2013 there was even an accidental soft fork, and in 2015 a near-miss accidental softfork due to OpenSSL changes that we covered in chapter @sec:libsecp.

Most of the above examples used a flag day or block height as their method of activation. In other words, you'd say, "From this moment forward, this new rule shall apply." And you announce that in advance, giving people plenty of time to upgrade. For a "secret" soft fork you would simply insist that people upgrade, explaining the reason afterwards.

### How does a softfork work?

But there's still a problem there, which is that you want to make sure everybody's actually running the new software — especially miners, because they kind of have to enforce those new rules.

So everyone who's upgraded is enforcing the new rules, but if a majority of hash power does it, that means they always reclaim the launch chain even for the non-upgraded nodes. So then everyone, old and new nodes, will converge on this chain. So that's why it's very nice if a majority hash power enforces the rules as well.

### Who decides?

Nobody. Initially Satoshi would unilaterally decide what to change, though ultimately he could not force anyone to run the new versions he released, so he could not make completely arbitrary controversial changes. Nowadays, without going to deep in the weeds here, the Bitcoin development follows a process of "rough consensus", as described in RFC 7282. ^[<https://datatracker.ietf.org/doc/html/rfc7282>]

Anyone can propose a change to the rules of Bitcoin. But not only do they need to convince other of the usefulness, they also need to address all technical objections that are raised to it. E.g. if someone complains that a proposal would break their (wallet) software, the proposal author can't simply say "tough". Instead they have to address the issue. Maybe they can propose a simple fix for the wallet in question, or they can modify their own proposal so it doesn't break stuff.

This and a few other requirements usually involve much back and forth on technical mailinglists, and many iterations of improving the proposal. Many proposals don't survive this process at all, because it turns out they cause too many problems. Hard-fork proposals often get rejected based on just the fact that they break existing software, require every participant to upgrade, and to do so at the same time. A soft fork variant of the same proposal addresses all these concerns, so they are generally preferred instead.

In addition to not having any unaddressed objections, there's also the need to get enough experienced developers to review a proposal. Lack of enthusiasm amongst a very small group of such experienced developers can cause a perfectly fine soft fork to never see the light of day. Or, more often, a lack of reviewer enthusiasm combined with difficult to address technical problems keeps a proposal in limbo.

But if all this goes well, and the code ends up merged into the Bitcoin Core software, there's still the matter of what activation procedure to apply. This is subject to the same kind of rough consensus discussion as a proposal itself; peole may love a proposal, but a flag day might cause a problem for them. To avoid proposals from getting stuck in a discussion about their activation, ideally the community agrees on a single activation mechansism that's applied for every softfork. Well, that turns out to be a challenge.

### Signalling (BIP 9)

There's a risk for miners: If a majority of miners enforces the new rules, but a minority doesn't, the minority could accidentally mine an invalid block and then have their block orphaned. And they might not even know why this happens if they haven't upgraded.

This is where miner signaling comes in. Signaling works as a coordination mechanism for the network to figure out that enough miners have upgraded. This signals to everyone the network is ready. And through this signaling mechanism, which is embedded in the code, a date or a time or a block height is communicated. And if enough signals are included in the blockchain, then we all know at block height X, the new rules will go into effect.

Usually it's every two weeks you count the number of blocks that have the signal. And if it's above a certain threshold, for example, 95 percent, then you know that two weeks later the new rule is active.

In 201X, BIP 9^[<https://github.com/bitcoin/bips/blob/master/bip-0009.mediawiki>] arrived on the scene, and it allowed deployment of soft forks in parallel.

It was used succesfully to deploy the CSV and SegWit soft fork. It could have been used for Taproot as well. The first deployment went smoothly, but the second one involved much drama and took much longer than many people considered necessary. This led to worries that perhaps BIP 9 is not a future-proof deployment mechanism. So several other  mechanisms were proposed, as well as variations on those mechanisms.

### The first drama, and BIP 148/91

<!-- in the title above, I mean to say that the drama was there _before_ BIP148. But then things got worse. -->

but when it was time to deploy SegWit, it took a long time. The code was ready, but it didn't activate, because fewer than 95 percent of miners were signaling for it.^[With BIP 9, many miners were blocking the upgrade, either because they wanted political leverage, or because they were secretly benefiting from something that the upgrade would've fixed without telling anyone that that was the case — or both. In short, there were bad reasons for the miners to block this upgrade, and this made Bitcoin core developers and others realize that depending on them gave the miners leverage, which they shouldn't have at all. They were treating it like a vote — when it's just meant to be a coordination mechanism — and abusing their vote in ways that were bad.]

At this point, a number of different things happened outside the blockchain. There was basically a group of people that said, "Hey, you know what? Instead of the signaling, we're just going to go back to the old flag day approach." And that was called BIP 148.^[<https://github.com/bitcoin/bips/blob/master/bip-0148.mediawiki>] They picked August 1, 2017 as a date and said that on that day, their nodes would enforce the rules.

So essentially what happened was a bit of a standoff between the two groups. And no one knows quite how it resolved, because if you just look at the blockchain, what you'd see is that, all of a sudden, 95 percent started signaling and it was activated.

Now it's of course very remarkable that this activated exactly before August 1 and not some random other date that it could have happened. But there were no blocks rejected that we could still point at saying, "Hey look, there was actually a fight between miners and et cetera." At the same time, there was an initiative from the New York Agreement Group.^[<https://dcgco.medium.com/bitcoin-scaling-agreement-at-consensus-2017-133521fe9a77>] And they had a whole bunch of things that they were planning to do. But one thing they were doing is called BIP 91, which was aimed at lowering the threshold. So they said, "Instead of having 95 percent, we're just going to accept 75 percent."

What they did in the end was use 75 percent forced signaling. So it was like BIP 148, but it was like a soft fork to activate a soft fork — basically, you had to signal that you were going to activate the soft fork. And then because there was more signaling, it would activate. But you couldn't chain, because immediately people started signaling at 95 percent.

In the end, you can't really tell what happened. It didn't go wrong, and nobody called each other's bluff. But what did come out of it is that everyone realized it was important to rethink how to actually activate soft forks. Because if you have chain splits — and especially if you have multiple chain splits with people having different opinions about what the blockchain should be — it defeats the purpose of a well-functioning blockchain.

### Rethinking Activation, BIP 8

![BIP 8 flow. Full specification and image source: <https://github.com/bitcoin/bips/blob/master/bip-0008.mediawiki>](taproot/bip8.svg)

In rethinking how activation should work, BIP 8^[<https://github.com/bitcoin/bips/blob/master/bip-0008.mediawiki>] proponents came out with a flag date proposal and revamped it. The new idea was to have a combination of a flag date and what was proposed in BIP 9: Signaling still exists, with some tweaks, but there's also a built-in option for having a flag date.

With this option, a flag date is a one-way mechanism. In other words, you could propose a new soft fork and not set a flag date, and then later on set a flag date. But you can't propose a flag date and then unset it.

What this means is it doesn't activate the soft fork itself. Rather, it means that if, closer to the date, there's a block that isn't mining support for the soft fork, that block will be orphaned: It forces signaling toward the end.

In other words, if you have two groups of BIP 8 nodes, one of them has the forced signaling on and one of them has the forced signaling off. But miners go along with the forced signaling on, and the nodes that have forced signaling off will still accept the soft fork because they're still seeing the signaling.^[There's a caveat to all of this though. If you have a flag date in mind, you may still need to include it, because you don't want different people to have different flag dates. In the end, if you force people to signal and then they don't signal, and then you just decide to not accept all their blocks, it becomes a mess. In that sense, it's not completely thought out, but you probably still want to have some consensus. If you decide on the flag date, you want to have a very large consensus on what that flag date is and ensure that really everybody goes along with it.]

### Playing with Parameters

<!-- much of the text below goes very deep into the weeds of trade-offs between proposals. Maybe that should get its own section, so we can first list the different options. On the other hand, the options make more sense in the context of explaining the trade-offs.  -->

So there are multiple ways of enforcing activation, but you can also tweak the parameters. For example, with a flag day, you can play with how long or how far into the future it should be. You can also play with a parameter of what the hash power should be. It could be 95 percent, but you could potentially lower this:  You could say 75 percent is enough. 50 percent is enough. Even 1 percent is enough.

However, doing so is ultimately useless, but the point is you can play around with these permutations in all sorts of ways. So now you have pieces of the puzzle, and you can begin thinking of ways to put these pieces together to come up with a concrete activation strategy that will be used for Taproot.^[You can also imagine that there's going to be a lot of permutations, so this could also be a byte shedding nightmare.]

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

The problem with this is, as mentioned before, if you have multiple dates, whoever picks the most aggressive date is the party you kind of have to listen to. But that might be a recklessly early date.

So here's a bad scenario. Let's say we ship the completely ready Taproot code ready for main net in two months. And say the code has this one-year miner signaling stipulation and then it expires. And now the most aggressive group comes out and says, "No, no, no, we're going to activate this like one month later." That's going to be the consensus of the loudest people.

So then, two weeks into that scheme, the miners actually start reviewing it, because people might only review code when it's ready. Now they find a critical bug. And most of the core developers would agree, "OK, this is actually a bug. We should abort. Soft fork miners, please don't signal for it."

But at the same time, you have this super loud group that's already canceled everybody who doesn't agree with them to activate this thing. So that's why there should be at least some decent amount of time and some community agreement on, "When are we going to flag date this thing?" And it shouldn't be within a few months. You should give people a decent amount of time.

This was a very extreme example. A less extreme example would be that miners should have some time to review this code after it's shipped. But some people might say, "No, they should have reviewed it earlier, because we don't want to set a precedent."

Moving on, yet another idea is that of BIP 8 plus BIP 91. This deploys BIP 9, with a long signaling period. After that amount of time, the activation is triggered. However, in the meantime. you're going to see what happens. So, for example, if after a year, it's still not activated, then developers can sort of try to find out why it hasn't activated again, sort of similar to Matt's idea. Developers take their time. They figure out, "OK, there's actually no good reason that it's not being X failed." At that point, they can deploy a new client that has sort of BIP 91 in it, which forces miners to signal support for it before the specified time period is over — in other words, the update is shipped with a lower threshold, which in turn triggers the higher threshold.

The reason you might want mandatory signaling here, is to avoid a problem for people who are running the first version. Those nodes are just waiting for the 95 percent, and they will assume the soft fork failed to activate. If those users decide to upgrade later on, there's also the complication that the new node has to reprocess a potentially large chunk of blockchain, first to see if the softfork was activated under its (looser) rules, and then to retroactively enforce the new rules. This makes the software more complicated and it's a bad user experience.

But the reason you might _not_ want mandatory signalling, is for when there is a bug fix. With mandatory signalling there is no way to call of the soft fork once its code is released. This would require releasing another soft fork, this time with a flag date, that activates at the same as the original soft fork, and undoes it. This is also not a deseriable scenario.

So a one-year signaling thing is nice, because that means that you can say, "OK, if this thing doesn't activate in a year because there's a bug, we wait a year and we try again, and then we know for sure we're not going to accidentally activate the old version after that year."

Of course, it's kind of annoying to have to wait for a year. But if there really is a bug in something that was ready to be deployed, that really warrants a year of thinking really, really well about how that could happen.

Another idea is similar to the initial BIP 8, which has the option of allowing soft fork signaling. In other words, there's a long period, but without forced signaling at the end. Then you still keep an eye on what's happening. If, after a while, you find that there's no problem with it, but miners aren't signaling for it because they're just apathetic or they have another bad reason, then you can deploy another client with BIP 8 — this time with forced signaling that starts forced signaling before the end of the current signaling period, or at least not later than that.

If it starts before that, then you have two groups of nodes online on the network: the BIP 8 nodes you deployed first that don't have forced signaling on the end, and now the new group of BIP 8 nodes that do have forced signaling. So if they do forced signaling, the older BIP 8 nodes will also accept that as an upgrade.

Overall, it's difficult to say which approach is best. In the short run, it's nice to have all this stuff fast, because being slow for the sake of being slow doesn't make any sense. In the long run, it's kind of scary if something can happen fast, because it gives you less time to stop something if it's bad.

### The mother of all parameters: LOT

![Ep. 29 {l0pt}](qr/ep/29.png)

<!-- The transcript link is mentioned here so the volunteer effort gets credit. But it can be moved to where it makes sense in the flow. -->

The transcript for the accompanying episode can be found here.^[This transcript was written by Michael Folkson. The site contains many other transcripts from technical Bitcoin podcast, conference talks and even group conversations. Many of them are written by Bryan Bishop a.k.a. Kanzure, quite possibly one of the fastest typists on Earth.  <https://diyhpl.us/wiki/transcripts/bitcoin-magazine/2021-02-26-taproot-activation-lockinontimeout/>]


discuss activation of the Taproot soft fork upgrade, and more specifically, the lock-in on timeout (LOT) parameter. The LOT parameter can be set to either “true” (LOT=true) or “false” (LOT=false).

LOT=false resembles how several previous soft forks were activated. Miners would have one year to coordinate Taproot activation through hash power; if and when a supermajority (probably 90 percent) of miners signal readiness for the upgrade, the soft fork will activate. But if this doesn’t happen within (probably) a year, the upgrade will expire. (After which it could be redeployed.)LOT=true also lets miners activate the soft fork through hash power, but if they fail to do this within that year, nodes will activate the soft fork regardless.Aaron and Sjors discuss the benefits and detriments of each option. This also includes some possible scenarios of what could happen if some users set LOT to true, while other users set LOT to false, and the associated risks. Finally, Aaron and Sjors discuss what they think is most likely going to happen with Taproot activation.

<!--

### Intro

Aaron van Wirdum (AvW): Live from Utrecht, this is the van Wirdum Sjorsnado. Sjors, make the pun.

Sjors Provoost (SP): We have a “lot” to talk about.

AvW: We have a “lot” to discuss. In this episode we are going to discuss the Taproot activation process and the debate surrounding it on the parameter lot, lockinontimeout which can be set to true and false.

SP: Maybe as a reminder to the listener we have talked about Taproot in general multiple times but especially in Episode 2. And we have talked about activating Taproot, activating soft forks in general in Episode 3 so we might skip over a few things.

AvW: In Episode 3 we discussed all sorts of different proposals to activate Taproot but it has been over half a year at least right?

SP: That was on September 25th so about 5 months, yeah.

AvW: It has been a while and by now the discussion has reached its final stage I would say. At this point the discussion is about the lot parameter, true or false. First to recap very briefly Sjors can you explain what are we doing here? What is a soft fork?

### What is a soft fork?

SP: The idea of a soft fork is you make the rules more strict. That means that from the point of view of a node that doesn’t upgrade nothing has changed. They are just seeing transactions that are valid to them from the nodes that do upgrade. Because they have stricter rules they do care about what happens. The nice thing about soft forks is that as a node user you can upgrade whenever you want. If you don’t care about this feature you can upgrade whenever you want.

AvW: A soft fork is a backwards compatible protocol upgrade and the nice thing about it is that if a majority of miners enforce the rules then that automatically means all nodes on the network will follow the same blockchain.

SP: That’s right. The older nodes don’t know about these new rules but they do know that they’ll follow the chain with the most proof of work, as long as it is valid. If most of the miners are following the new rules then most of the proof of work will be following the new rules. And so an old node will by definition follow that.

AvW: The nice thing about soft forks is that if a majority of hashpower enforces the new rules the network will remain in consensus. Therefore the last couple of soft forks were activated through hash power coordination. That means that miners could include a bit in the blocks they mined signaling that they were ready for the upgrade. Once most miners, 95 percent in most cases, indicated that they were ready nodes would recognize this and enforce the upgrade.

SP: That’s right. A node would check, for example every two weeks, how many blocks signaled this thing and if yes, then it says “Ok the soft fork is now active. I am going to assume that the miners will enforce this.”

### The ability for miners to block a soft fork upgrade

AvW: Right. The problem with this upgrade mechanism is that it also means miners can block the upgrade.

SP: Yeah that’s the downside.

AvW: Even if everyone agrees with the upgrade, for example in this case Taproot, it seems to have broad consensus, but despite that broad consensus miners could still block the upgrade, which is what happened with SegWit a couple of years ago.

SP: Back then there was a lot of debate about the block size and lots of hard fork proposals and lots of hurt feelings. Eventually it was very difficult to get SegWit activated because miners were not signaling for it, probably mostly intentionally. Now it could also happen that miners just ignore an update, not because they don’t like it, just because they’re busy.

AvW: Yeah. In the case of SegWit that was in the end resolved through UASF, or at least that was part of it. We are not going to get into that in depth. That basically meant that a group of users said “On this day (some date in the future, it was August 1st 2017) we are going to activate the SegWit rules no matter how much hash power supports it.”

SP: Right, at the same time and perhaps as a consequence as that, a group of miners and other companies agreed that they would start signaling for SegWit. There were a whole bunch of other things going on at the same time. Whatever happened on 1st August, the thing activated, or a little bit earlier I think.

### The lockinontimeout (LOT) parameter

AvW: Now we are four years ahead in time, it is four years later and now the Taproot upgrade is ready to go. What happened a couple of years ago is now spurring new debate on the Taproot upgrade. That brings us to the lockinontimeout (LOT) parameter which is a new parameter. Although it is inspired by things from that SegWit upgrade period.

SP: It is basically a built in UASF option which you can decide to use or not. There is now a formal way in the protocol to do this to activate a soft fork at a cut off date.

AvW: LOT has two options. The first option is false, LOT is false. That means that miners can signal for the upgrade for one year and then in that year if the 90 percent threshold for the upgrade is met it will activate as we just explained. By the way 1 year and 90 percent isn’t set in stone but it is what people seem to settle on. For convenience sake that is what I’m going to use for discussing this. Miners have 1 year to activate the upgrade. If after that year they have not upgraded the Taproot upgrade will expire. It will just not happen, that is LOT is false.

SP: And of course there is always the option then of shipping a new release, trying again. It is not a “no” vote, it is just nothing happens.

AvW: Exactly. Then there is LOT=true which again miners have 1 year to signal support (readiness) for the upgrade. If a 90 percent threshold is met then the upgrade will activate. However the big difference is what happens if miners don’t reach this threshold. If they don’t signal for the upgrade. In that case when the year is almost over nodes that have LOT=true will start to reject all blocks that don’t signal for the upgrade. In other words they will only accept blocks that will signal for the upgrade which means of course that the 90 percent threshold will be met and therefore Taproot, or any other soft fork in this mechanism, will activate.

SP: If enough blocks are produced.

AvW: If enough blocks are produced, yes, that’s true. A little bit of nuance for those who find it interesting, even LOT=true nodes will accept up to 10 percent of blocks that don’t signal. That’s to avoid weird chain split scenarios.

SP: Yeah. If it activates in the normal way only 90 percent has to signal. If you mandate signaling then it would be weird to have a different percentage suddenly.

AvW: They are going to accept the first 10 percent of non-signaling blocks but after that every block that doesn’t signal is going to be rejected. So the 90 percent threshold will definitely be reached. The big reason for LOT=-true, to set it to true, is that this way miners cannot block the upgrade. Even if they try to block the upgrade, once the year is over nodes will still enforce Taproot. So it is guaranteed to happen.

SP: If enough blocks are produced. We can get into some of the risks with this but I think you want to continue explaining a bit.

AvW: The reason some people like LOT=true is because that way miners don’t have a veto. The counterargument there, you already suggested that, is that miners don’t have a veto anyway even if we use LOT=false the upgrade will expire after a year but after that year we can just deploy a new upgrade mechanism and a new signaling period. This time maybe use LOT=true.

SP: Or even while this thing is going on. You could wait half a year with LOT=false and half a year later say “This is taking too long. Let’s take a little more risk and set LOT=true.” Or lower the threshold or some other permutation that slightly increases the risk but also increases the likeliness of activation.

AvW: Yeah, you’re right. But that is actually also one of the arguments against using LOT=false. LOT=true proponents say that as you’ve suggested we can do it after 6 months, but there are another group of users that might say “No. First wait until the year is over and then we will just redeploy again.” Let’s say after 6 months Taproot hasn’t activated. Now all of a sudden you get a new discussion between people that want to start deploying LOT=true clients right away and groups of users that want to wait until the year is over. It is reintroducing the discussion we are having now except by then we only have 6 months to resolve it. It is like a ticking time bomb kind of situation.

SP: Not really to resolve it. If you don’t do anything for 6 months then there is only one option left which is to try again with a new activation bit.

AvW: But then you need to agree on when you are going to do that. Are you going to do that after 6 months or are you going to do that later? People might disagree.

SP: Then you’d be back to where we are now except you’d know a little bit more because now you know that the miners weren’t signaling.

AvW: And you don’t have a lot of time to resolve it because after 6 months might happen. Some group of users might run LOT=true or….

SP: The thing you’re talking about here is the possibility of say anarchy in the sense that there is no consensus about when to activate this thing. One group, I think we discussed this at length in the third episode, just gets really aggressive and says “No we are going to activate this earlier.” Then nobody knows when it is going to happen.

AvW: Let me put it differently. If right now we are saying “If after 6 months miners haven’t activated Taproot then we will just upgrade to LOT=true clients” then LOT=true proponents will say “If that’s the plan anyways let’s just do it now. That’s much easier. Why do we have to do that halfway?” That is the counterargument to the counterargument.

SP: I can see that. But of course there is also the scenario where we never do this, Taproot just doesn’t activate. It depends on what people want. There is something to be said for a status quo bias where you don’t do anything if it is too controversial for whatever reason. There is another side case here that is useful to keep in mind. There might be a very good reason to cancel Taproot. There might be a bug that is revealed after.

AvW: You are getting ahead of me. There are a bunch of arguments in favor of LOT=false. One argument is we’ve already done LOT=false a bunch of times, the previous miner activated soft forks, and most of the times it went fine. There was just this one time with SegWit in the midst of a big war, we don’t have a big war now. There is no reason to change what we’ve been doing successfully until now. That is one argument. The counterargument would for example be “Yeah but if you choose LOT=false now that could draw controversy itself. It could be used to drive a wedge. We are not in a war right now but it could cause a war.”

SP: I don’t see how that argument doesn’t apply to LOT=true. Anything could cause controversy.

AvW: That is probably fair. I tend to agree with that. The other argument for LOT=false is that miners and especially mining pools have already indicated that they are supportive of Taproot, they’ll activate it. It is not necessary to do the LOT=true thing as far as we can tell. The third argument is what you just mentioned. It is possible that someone finds a bug with Taproot, a software bug or some other problem is possible. If you do LOT=false it is fairly easy to just let it expire and users won’t have to upgrade their software again.

SP: The only thing there is that you’d have to recommend that miners do not install that upgrade. It is worth noting, I think we pointed this out in Episode 3, people don’t always review things very early. A lot of people have reviewed Taproot code but others might not bother to review it until the activation code is there because they just wait for the last minute. It is not implausible that someone very smart starts reviewing this very late, perhaps some exchange that is about to deploy it.

AvW: Something like that happened with P2SH, the predecessor to P2SH. OP_EVAL was just about to be deployed and then a pretty horrible bug was found.

SP: We’ve seen it with certain altcoins too, right before deployment people find zero days, either because they were… or just because the code was shipped in a rush and nobody checked it. There is definitely always a risk, whatever soft fork mechanism you use, that a bug is discovered at the last minute. If you are really unlucky then it is too late, it is deployed and you need a hard fork to get rid of it which would be really, really bad.

AvW: I don’t think that’s true. There are other ways to get rid of it.

SP: Depending on what the bug is you may be able to soft fork it out.

AvW: There are ways to fix it even in that case. The other counterargument to that point would be “If we are not sure that it is bug free and we are not sure that this upgrade is correct then it shouldn’t be deployed either way, LOT=true or LOT=false or anything. We need to be sure of that anyway.”

SP: Yeah but like I said some people won’t review something until it is inevitable.

AvW: I am just listing the arguments. Fourth argument against LOT=true is that LOT=true could feed into the perception that Bitcoin and especially Bitcoin Core developers control the protocol, have power of the protocol. They are shipping code and that necessarily becomes the new protocol rules in the case of Taproot.

SP: There could be some future soft fork where really nobody in the community cares about it, just a handful of Bitcoin Core developers do, and they force it onto the community. Then you get a bunch of chaos. The nice thing about having at least the miners signal is that they are part of the community and at least they are ok with it. The problem is it doesn’t reflect what other people in the community think about it. It just reflects what they think about it. There are a bunch of mechanisms. There is discussion on the mailing list, you see if people have problems. Then there is miner signaling which is a nice indication that people are happy. You get to see that, there are as many people consenting as possible. It would be nice if there were other mechanisms of course.

AvW: The other point that Bitcoin Core developers, while they decide which code they include in Bitcoin Core they don’t decide what users actually end up running.

SP: Nobody might download it.

AvW: Exactly. They don’t actually have power over the network. In that sense the argument is bunk but it could still feed into the perception that they do. Even that perception, if you can avoid it maybe that’s better. That is an argument.

SP: And the precedent. What if Bitcoin Core is compromised at some point and ships an update and says “If you don’t stop it then it is going to activate.” Then it is nice if the miners can say “No I don’t think so.”

AvW: Users could say that as well by not downloading it like you said. Now we get to the fifth argument. This is where it gets pretty complex. The fifth argument against LOT=true is that it could cause all sorts of network instability. If it happens that the year is over and there are LOT=true clients on the network it is possible that they would split off from the main chain and there could be re-orgs. People could lose money and miners could mine an invalid block and lose their block reward and all that sort of stuff. The LOT=true proponents argue that that risk is actually best mitigated if people adopt LOT=true.

SP: I’m skeptical, that sounds very circular. Maybe it is useful to explain what these bad scenarios look like? Then others can decide whether a) they think those bad scenarios are worth risking and b) how to make them less likely. Some of that is almost political. You all have these discussions in society, should people have guns or not, what are the incentives, you may never figure that out. But we can talk about some of the mechanics here.

AvW: To be clear, if somehow there would be complete consensus on the network over either LOT=true, all nodes run LOT=true, or all nodes run LOT=false then I think that would be totally fine. Either way.

SP: Yeah. The irony is of course that if there is complete consensus and everybody runs LOT=true then it will never be used. You’re right in theory. I don’t see a scenario where miners would say “We are happy with LOT=true but we are deliberately not going to signal and then signal at the very last moment.”

AvW: You are right but we are digressing. The point is that the really complicated scenarios arise when some parts of the network are running LOT=true, some parts of the network are running LOT=false or some parts of the network are running neither because they haven’t upgraded. Or some combination of these, half of the network has LOT=true, half of the network has neither. That’s where things get very complicated and Sjors, you’ve thought about it, what do you think? Tell me what the risks are.

### The chain split scenario

SP: I thought about this stuff during the SegWit2x debacle as well as the UASF debacle which were similar in a way but also very different because of who was explaining and whether it was a hard fork or a soft fork. Let’s say you are running the LOT=true version of Bitcoin Core. You downloaded it, maybe it was released by Bitcoin Core or maybe you self compiled it, but it says LOT=true. You want Taproot to activate. But the scenario here is that the rest of the world, the miners aren’t really doing this. The day arrives and you see a block, it is not signaling correctly but you want it to signal correctly so you say “This block is now invalid. I am not going to accept this block.” I’m just going to wait until another miner comes with a block that does meet my criteria. Maybe that happens once in every 10 blocks for example. You are seeing new blocks but they are coming in very, very slowly. So somebody sends you a transaction, you want Bitcoin from somebody, they send you a transaction and this transaction has a fee and it is probably going to be wrong. Let’s say you are receiving a transaction from somebody who is running a node with LOT=false. They are on a chain that is going ten times faster than you are, in this intermediate state. Their blocks might be just full, their fees are pretty low, and you are receiving it. But you are on this shorter, slower moving chain so your mempool is really full and your blocks are completely full, so that transaction probably won’t confirm on your side. It is just going to be sitting in the mempool, that is one complexity. That’s actually a relatively good scenario because you don’t accept unconfirmed transactions. You will have a disagreement with your counterparty, you’ll say “It hasn’t confirmed” and they’ll say “It has confirmed”. Then at least you might realize what is going on, you read about the LOT war or whatever. So that’s one scenario. The other scenario is where somehow it does confirm on your side and it also confirms on the other side. That is kind of good because then you are safe either way. If it is confirmed on both sides then whatever happens in a future re-org that transaction is actually on the chain, maybe in a different block. Another scenario could be because there are two chains, one short chain and one long chain, but they are different. If you are receiving coins that are sent from a coinbase transaction on one side or the other then there is no way it can be valid on your side. This can also be a feature, it is called replay protection essentially. You receive a transaction and you don’t even see it in your mempool, you call the other person and say “This doesn’t make any sense.” That’s good. But now suddenly the world changes its mind and says “No we do want Taproot, we do want LOT=true, we are now LOT=true diehards” and all the miners start mining on top of your shorter chain. Your short chain becomes the very long chain. In that case you are pretty happy in most of the scenarios we’ve discussed.

AvW: Sounds good to me.

SP: You had a transaction that was in maybe in your tenth block and on the other side it was in the first block. It is still yours. There were some transactions floating in the mempool for a very long time, they finally confirm. I think you are fairly happy. We were talking about the LOT=true node. As a LOT=true node user, in these scenarios you are happy. Maybe not if you’re paying someone.

AvW: You are starting to make the case for LOT=true Sjors, I know that is not your intention but you are doing a good job at it.

SP: For the full node user who knows what they are doing in general. If you are a full node user and you know what you are doing then I think you are going to be fine in general. This is not too bad. Now let’s say you are a LOT=false user and let’s say you don’t know what you are doing. In the same scenario you are on the longest chain, you are receiving coins from an exchange and you’ve seen these headers out there for this shorter chain. You might have seen them, depends on whether they reach you or not. But it is a shorter chain and it is valid according to you because it is a more strict ruleset. You are fine, this other chain has Taproot and you don’t probably. You are accepting transactions and you are a happy camper but then all of a sudden because the world changes everything disappears from under you. All the transactions you’ve seen confirmed in a block are now back in the mempool and they might have been double spent even.

AvW: Yeah the reason for that is that we are talking about a chain split that has happened. You have a LOT=false node but at any point the LOT=true chain becomes the longest chain then your LOT=false node would still accept that chain. It would still consider it valid. The other way round is not true. But the LOT=false node will always consider the LOT=true chain valid. So in your scenario where you are using Bitcoin on the longest chain, on the LOT=false chain, we’re happy, we received money, we did a hard day’s work and got our paycheck at the end, paid in Bitcoin. We think we’re safe, we got a bunch of confirmations but then all of a sudden the LOT=true chain becomes longer which means your node switches to a LOT=true chain. That money you received on the LOT=false chain which you thought was the Bitcoin chain is just gone. Poof. That is the problem you are talking about.

SP: Exactly.

AvW: I will add to this very briefly. I think this is an even bigger problem for non-upgraded nodes.

SP: I was about to get to that. Now we are talking about the LOT=false people. You could still say “Why did you download the LOT=false version?” Because you didn’t know. Now we are talking about an unupgraded node. For the unupgraded node Taproot does not exist so it has no preference for which of the chains, it will just pick the longest one.

AvW: It is someone in Korea, he doesn’t keep up with discussion.

SP: Let’s not be mean to Korea.

AvW: Pick a country where they don’t speak English.

SP: North Korea.

AvW: Someone doesn’t keep up with their Bitcoin discussion forums, maybe doesn’t read English, doesn’t really care. He just likes this Bitcoin thing, downloaded the software a couple of years ago, put in his hard day’s work, gets paid and the money disappears.

SP: Or his node might be in a nuclear bunker that he put it in 5 years ago under 15 meters of concrete, airgapped, and somehow it can download blocks because it is watching the Blockstream satellite or something but it cannot be upgraded. And he doesn’t know about this upgrade. Which would be odd if you are into nuclear bunkers and full nodes. Anyway somebody is running an out of date node, in Bitcoin we have the policy that you don’t have to upgrade, it is not a mandatory thing. It should be safe or at least relatively safe to run an unupgraded node. You are receiving a salary, the same as the LOT=false person, then suddenly there’s a giant re-org that comes out of nowhere. You have no idea why people bother to re-org because you don’t know about this rule change.

AvW: You don’t see the difference.

SP: And poof your salary just disappeared.

AvW: That’s bad. That’s basically the worst case scenario that no one wants I think.

SP: Yeah. You can translate this also to people who are using hardware wallet software that hasn’t been updated, they are using remote nodes or they are using SPV nodes that don’t check the rules but only check the work. They’ll have similar experiences where suddenly the longest chain changes so your SPV wallet, which we explained in an earlier episode, its history disappears. At least for the lightweight nodes you could do some victim shaming and say “You should be running a full node. If bad things happen you should have run a full node.” But I still don’t think that’s good safety engineering, to tell people “If you don’t use your safety belt in the correct position the car might explode.” But at least for the unupgraded full node that is an explicit case that Bitcoiners want to support. You want to support people not upgrading and not suddenly losing their coins in a situation like this. That is why I’m not a LOT=true person.

### Avoiding a chain split scenario

AvW: That’s what I want to get that. Everyone agrees or at least we both agree and I think most people would agree that this scenario we just painted, that’s horrible, we don’t want that. So the next question is how do you avoid this scenario? That’s also one of the things where LOT=true and LOT=false people differ in their opinions. LOT=false proponents like yourself argue against LOT=true because the chain split was caused by LOT=true and therefore if we don’t want chain splits we don’t want LOT=true and the thing we just described won’t happened. The worst case scenario is that we don’t have Taproot, it will just expire. That’s not as bad as this poor Korean guy losing his honest day’s work.

SP: Exactly and we might have Taproot later.

AvW: The LOT=true proponents will argue Bitcoin is an open network and any peer can run any software they want. For better or worse LOT=true is a thing that exists. If we want to avoid a chain split the best way to avoid that is to make sure that everyone uses LOT=true or at least the majority of miners upgrade in time and LOT=true is the best way to ensure that. Getting critical mass for LOT=true is actually the safer option despite the fact that LOT=true also introduced the risk. If I want to give an analogy it is kind of like the world would be a safer place without nuclear weapons but there are nuclear weapons. It seems like it is safer to actually have one in that case.

SP: I think that analogy breaks down very quickly but yeah I get the idea.

AvW: It is not a perfect analogy I’m sure. The point is LOT=true exists and now we have to deal with that. It might be a better world, a safer place if LOT=true didn’t exist, if UASFs didn’t exist. But it does and now we have to deal with that fact. There is an argument to be made that making sure the soft fork succeeds is actually the best way to go to save that poor Korean guy.

SP: I am always very skeptical of this type of game theory because it sounds rhetorically nice but I’m not sure it is really true. One of the obvious problems is how do you know you’ve reached the entire Bitcoin community. We talked about this hypothetical person in this other country who is not reading Twitter and Reddit, has no idea that this is going on let alone most of the lightweight wallet users. The number of people who use Bitcoin is much, much greater than the number of people who are even remotely interested in these discussions. Also to even explain the risk to those people, even if we could reach them, to explain why they should upgrade, that alone is a rather big challenge. In this episode we roughly try to explain what would go wrong if they don’t upgrade. We can’t just tell them they must upgrade. That violates the idea that you persuade people with arguments and let them decide what they want to do rather than tell them based on authority.

AvW: Keep in mind that in the end all of this is avoided if a majority of hash power upgrades. With LOT=true it actually is any majority would be fine in the end. If miners themselves use LOT=true then they’ll definitely get the longest chain by the end of the year.

SP: The game theory is kind of narrowed to say you want to convince the miners to do this. The problem though is if it fails we just explained the disaster that happens. Then the question is what is that risk? Can you put a percentage on that? Can you somehow simulate the world and find out what happens?

AvW: I am on the fence on this. I see compelling arguments on both sides. I was leaning towards lot=false at first but the more I think about it… The argument is if you include lot=true in Bitcoin Core then that practically guarantees that everything will be fine because the economic majority will almost certainly run it. Exchanges and most users.

SP: I’m not even sure that is true. That assumes that this economic majority is quick to upgrade and not ignoring things.

AvW: At least within a year.

SP: There might be companies that are running 3 or 4 year old nodes because they have 16 different s***coins. Even that, I would not assume that. We know from the network in general that lots of people don’t upgrade nodes and one year is pretty short. You can’t tell from the nodes whether they are the economic majority or not. That might be a few critical players that would do the trick here.

AvW: Yes I can’t be sure. I’m not sure. I am speculating, I am explaining the argument. But the opposite is also true, now that lot=true exists some group of users will almost certainly run it and that introduces maybe greater risks than if it was included in Core. That would increase the chances of success for LOT=true, the majority upgrading.

SP: It really depends on who that group is. Because if that group is just some random people who are not economically important then they are experiencing the problems and nobody else notices anything.

AvW: That is true. If it is a very small group that might be true but the question is how small or how big does that group need to be for this to become a problem. They have an asymmetry, this advantage because their chain can never be re-orged away while the LOT=false chain can be re-orged away.

SP: But their chain may never grow so that’s also a risk. It is not a strict advantage.

AvW: I think it is definitely a strict advantage.

SP: The advantage is you can’t be re-orged. The disadvantage is your chain might never grow. I don’t know which of those two…

AvW: It would probably grow. It depends on how big that group is again. That’s not something we can objectively measure. I guess that’s what it comes down to.

SP: Even retroactively we can’t. We still don’t know what really caused the SegWit activation even four years afterwards. That gives you an idea of how difficult it is to know what these forces really are.

AvW: Yes, that’s where we agree. It is very difficult to know either way. I am on the fence about it.

SP: The safest thing to do is to do nothing.

AvW: Not even that. There might still be a LOT=true minority or maybe even majority that might still happen.

SP: Another interesting thought experiment then is to say “There is always going to be a LOT=true group for any soft fork. What about a soft fork that has no community support? What if an arbitrary group of people decides to run their own soft fork because they want to? Maybe someone wants to shrink the coin supply. Set the coin issuance to zero tomorrow or reduce the block size to 300 kilobytes.” They could say “Because it is a soft fork and because I run a LOT=true node, there could be others who run a LOT=true. Therefore it must activate and everybody should run this node.” That would be absurd. There is a limit to this game theory. You can always think of some soft fork and some small community that will say this and completely fail. You have to estimate how big and how powerful this thing is. I don’t even know what the metric is.

AvW: But also how harmful the upgrade is because I would say that is the answer to your point there. If the upgrade itself is considered valuable then there is very little cost for people to just switch to the other chain, the chain that can’t be re-orged and that has the upgrade that is valuable. That’s a pretty good reason to actually switch. While switching to a chain even if it can’t be re-orged that screws with the coin limit or that kind of stuff, that is a much bigger disincentive and also a disincentive for miners to switch.

SP: Some people might say that a smaller block size is safer.

AvW: They are free to fork off, that is also possible. We didn’t even discuss that but it is possible that the chain split is lasting, that it will forever be a LOT=true minority chain and a LOT=false majority chain. Then we have the Bitcoin, Bitcoin Cash split or something like that. We just have two coins.

SP: With the big scary sword of Damocles hanging above it.

AvW: Then maybe a checkpoint would have to be included in the majority chain which would be very ugly.

SP: You could come up with some sort of incompatible soft fork to prevent a re-org in the future.

AvW: Let’s work towards the end of this episode.

SP: I think we have covered a lot of different arguments and explained that this is pretty complicated.

AvW: What do you think is going to happen? How do you anticipate this playing out?

SP: I started looking a little bit at the nitty gritty, one of the pull requests that Luke Dashjr opened to implement BIP 8 in general, not specifically for Taproot I believe. There’s already complexity with this LOT=true thing engaged because you need to think about how the peer-to-peer network should behave. From a principle of least action, what is the least work for developers to do, setting LOT to false probably results in easier code which will get merged earlier. And even if Luke is like “I will only do this if it is set to true” then somebody else will make a pull request that sets it to false and gets merged earlier. I think from a what happens when lazy people, I mean lazy in the most respectful way, what is the path of least resistance? It is probably a LOT=false, just from an engineering point of view.

AvW: So LOT=false in Bitcoin Core is what you would expect in that case.

SP: Yes. And somebody else would implement LOT=true.

AvW: In some alt client for sure.

SP: Yeah. And that might have no code review.

AvW: It is just a parameter setting right?

SP: No it is more complicated because how it is going to interact with its peers and what it is going to do when there’s a chain split etc.

AvW: What do you think about this scenario that neither is implemented in Bitcoin Core? Do you see that happening?

SP: Neither. LOT=null?

AvW: Just no activation mechanism because there is no consensus for one.

SP: No I think it will be fine. I can’t predict the future but my guess is that a LOT=false won’t be objected to as much as some people might think.

AvW: We’ll see then I guess.

SP: Yeah we’ll see. This might be the dumbest thing I’ve ever said.

-->

### LOT=true client, rogue?

![Ep. 36 {l0pt}](qr/ep/36.png)

<!-- Dramatically shorten, maybe even just stick to episode summary. What is important here
is this alternative client was released, similar to UASF. But we've mostly covered the pros and cons of that above in the LOT section.

This also introduces the speedy trial, which should be moved below.

---
comment: transcript https://diyhpl.us/wiki/transcripts/bitcoin-magazine/2021-04-23-taproot-activation-update/
...

discussed the final implementation details of Speedy Trial, the Taproot activation mechanism included in Bitcoin Core 0.21.1. Van Wirdum and Provoost also compared Speedy Trial to the alternative BIP 8 LOT=true activation client.

After more than a year of deliberation, the Bitcoin Core project has merged Speedy Trial as the (first) activation mechanism for the Taproot protocol upgrade. Although van Wirdum and Provoost had already covered Taproot, the different possible activation mechanisms and Speedy Trial specifically in previous episodes, in this episode they laid out the final implementation details of Speedy Trial.

00:00 - 4:20 Intro and brief explanation of taproot activation
4:20 - 10:02 How Bitcoin core is going to upgrade to taproot/speedy trial
10:02 - 12:58 LOT=True Client
12:59 - 15:10 Differences between speedy trial and LOT=True
15:10 - 16:20 The naming of the clients
16:20 - 17:44 Potential incompatability with the two clients
17:44 - 23:01 If miners signal readiness after the speedy trial fails
23:01 - 25:06 More potential risks with a soft fork
25:13 - 27:03 Recap of the clients and previous topics
27:03 - 32:02 Potential incompatability (cont.)
32:05 - 34:35 If the majority of miners don't signal when the 18 months are up for LOT=True and the collective wisdom of the market
34:36 - 38:44 Concerns about development process of LOT=True client
38:48 - 43:23 Different activation methods
43:25 - 47:28 Block height vs. block time
42:28 - 51:03 The time warp attack/consensus amongst developers
51:03 - 51:53 Wrapping up

<!--

### Intro

Aaron van Wirdum (AvW): Live from Utrecht this is the van Wirdum Sjorsnado.

Sjors Provoost (SP): Hello

AvW: Sjors, today we have a “lot” more to discuss.

SP: We’ve already made this pun.

AvW: We’ve already made it twice I think. It doesn’t matter. We are going to discuss the final implementation details of Speedy Trial today. We have already covered Speedy Trial in a previous episode. This time we are also going to contrast it to the LOT=true client which is an alternative that has been released by a couple of community members. We are going to discuss how they compare.

SP: That sounds like a good idea. We also talked about Taproot activation options in general in a much earlier episode.

AvW: One of the first ones?

SP: We also talked about this idea of this cowboy mentality where somebody would eventually release a LOT=true client whatever you do.

AvW: That is where we are.

SP: We also predicted correctly that there would be a lot of bikeshedding.

AvW: Yes, this is also something we will get into. First of all as a very brief recap, we are talking about Taproot activation. Taproot is a proposed protocol upgrade for compact and potentially privacy preserving smart contracts on the Bitcoin protocol. Is that a good summary?

SP: Yeah I think so.

AvW: The discussion on how to upgrade has been going on for a while now. The challenge is that on a decentralized open network like Bitcoin without a central dictator to tell everyone what to run when, you are not going to get everyone to upgrade at the same time. But we do want to keep the network in consensus somehow or other.

SP: Yeah. The other thing that can work when it is a distributed system is some sort of conventions, ways that you are used to doing things. But unfortunately the convention we had ran into problems with the SegWit deployment. Then the question is “Should we try something else or was it just a freak accident and we should try the same thing again?”

AvW: I think the last preface before we really start getting into Speedy Trial, I’d like to point out the general idea with a soft fork, a backwards compatible upgrade which Taproot is, is that if a majority of hash power is enforcing the new rules that means that the network will stay in consensus.

SP: Yeah. We can repeat that if you keep making transactions that are pre-Taproot then those transactions are still valid. In that sense, as a user you can ignore soft forks. Unfortunately if there is a problem you cannot ignore that as a user even if your transactions don’t use Taproot.

AvW: I think everyone agrees that it is very nice if a majority of hash power enforces the rules. There are coordination mechanisms to measure how many miners are on board with an upgrade. That is how you can coordinate a fairly safe soft fork. That is something everyone agrees on. Where people start to disagree on what happens if miners don’t actually cooperate with this coordination. We are not going to rehash all of that. There are previous episodes about that. What we are going to explain is that in the end the Bitcoin Core development community settled on a solution called “Speedy Trial.” We already mentioned that as well in a previous episode. Now it is finalized and we are going to explain what the finalized parameters are for this.

SP: There was a slight change.

AvW: Let’s hear it Sjors. What are the finalized parameters for Speedy Trial? How is Bitcoin Core going to upgrade to Taproot?

### Bitcoin Core finalized activation parameters

Bitcoin Core 0.21.1 release notes: https://github.com/bitcoin/bitcoin/blob/0.21/doc/release-notes.md

Speedy Trial activation parameters merged into Core: https://github.com/bitcoin/bitcoin/pull/21686

SP: Starting on I think it is this Sunday (April 25th, midnight) the first time the difficult readjusts, that happens every two weeks, probably one week after Sunday…

AvW: It is Saturday

SP:… the signaling starts. In about two weeks the signaling starts, no earlier than one week from now.

AvW: Just to be clear, that’s the earliest it can start.

SP: The earliest it can start is April 24th but because it only starts at a new difficulty adjustment period, a new retargeting period, it probably won’t start until two weeks from now.

AvW: It will start at the first new difficulty period after April 24th which is estimated I think somewhere early May. May 4th, may the fourth be with you Sjors.

SP: That would be a cool date. That is when the signaling starts and the signaling happens in you could say voting rounds. A voting round is two weeks or one difficulty adjustment period, one retargeting period. If 90 percent of the blocks in that voting period signal on bit number 2, if that happens Taproot is locked in. Locked in means that it is going to happen, imagine the little gif with Ron Paul, “It’s happening.” But the actual Taproot rules won’t take effect immediately, they will take effect at block number 709632.

AvW: Which is estimated to be mined when?

SP: That will be November 12th this year.

AvW: That is going to differ a bit of course based on how fast blocks are going to be mined over the coming months. It is going to be November almost certainly.

SP: Which would be 4 years after the SegWit2x effort imploded.

AvW: Right, nice timing in that sense.

SP: Every date is nice. That’s what the Speedy Trial does. Every two weeks there is a vote, if 90 percent of the vote is reached then that’s the activation date. It doesn’t happen immediately and because it is a “Speedy” Trial it could also fail quickly and that is in August, around August 11th. If the difficulty period after that or before that, I always forget, doesn’t reach the goal, I think it is after…

AvW: The difficulty period must have ended by August 11th right?

SP: When August 11th is passed it could still activate but then the next difficulty period, it cannot. I think the rule is at the end of the difficulty period you start counting and if the result is a failure then if it is after August 11th you give up but if it is not yet August 11th you enter the next round.

AvW: If the first block of a new difficulty period is mined on August 10th will that difficulty period still count?

SP: That’s right. I think that’s one of the subtle changes made to BIP 9 to make BIP 9 easier to reason about. I think it used to be the other way around where you first check the date but if it was past the date you would give up but if it was before the date you would still count. Now I think it is the other way round, it is a bit simpler.

AvW: I see. There is going to be a signaling window of about 3 months.

SP: That’s right.

AvW: If in any difficulty period within that signaling window of 3 months 90 percent of hash power is reached Taproot will activate in November of this year.

SP: Yes

AvW: I think that covers Speedy Trial.

SP: The threshold is 90 percent as we said. Normally with BIP 9 it is 95 percent, it has been lowered to 90.

AvW: What happens if the threshold is not met?

SP: Nothing. Which means anything could still happen. People could deploy new versions of software, try another bit etc

AvW: I just wanted to clarify that.

SP: It does not mean that Taproot is cancelled.

AvW: If the threshold isn’t met then this specific software client will just do nothing but Bitcoin Core developers and the rest of the Bitcoin community can still figure out new ways to activate Taproot.

SP: Exactly. It is a low cost experiment. If it wins we get Taproot. If not then we have some more information as to why we don’t…

AvW: I also want to clarify. We don’t know what it is going to look like yet. That will have to be figured out then. We could start figuring it out now but that hasn’t been decided yet, what the deployment would look like.

### Alternative to Bitcoin Core (Bitcoin Core 0.21.0-based Taproot Client)

Update on Taproot activation releases: https://lists.linuxfoundation.org/pipermail/bitcoin-dev/2021-April/018790.html

AvW: Another client was also launched. There is a lot of debate on the name. We are going to call it the LOT=true client.

SP: That sounds good to me.

AvW: It derives from this technical and philosophical difference about how soft forks should be activated in the first place. This client uses, you guessed it, LOT=true. LOT=true means that if the signaling window is over, by the end of the signaling window nodes will start to reject any blocks that don’t signal. They only accept blocks that signal. That is the main difference. Let’s get into the specifics of the LOT=true client.

SP: In the beginning it is the same, in principle it is the same. There is a theoretical possibility that it is not if miners do something really crazy. It starts at a certain block height…

AvW: We just mentioned that Bitcoin Core 0.21.1 starts its signaling window on the first difficulty period after April 24th. This LOT=true client will also in practice start its signaling window on the first difficulty period after April 24th except that April 24th isn’t specified specifically. They just picked the specific block height that is expected to be the first one after April 24th.

SP: Exactly, they picked block 681,408.

AvW: It is specified as a block height instead of indirectly through using a date.

SP: But in all likelihood that is going to be the exact same moment. Both Speedy Trial (Core) and the LOT=true client will start the signaling, the voting periods at the same time. The voting periods themselves, they vote on the same bit. They both vote on bit 2. They both have a threshold of 90 percent. Also if the vote is true then it also has a delayed activation. The delayed activation is a block height in both scenarios in both the Speedy Trial (Core) and the LOT=true variant.

AvW: Botha are November 12th, a November activation anyway. If miners signal readiness for Taproot within the Speedy Trial period both of these clients will activate Taproot in November on that exact same date, exact same block.

SP: So in that sense they are identical. But they are also different.

AvW: Let’s get into the first big difference. We already mentioned one difference which is the very subtle difference between starting it at height, the thing we just mentioned. Let’s get into a bigger difference.

SP: There is also a height for a timeout in this LOT=true and that is also a block. But not only is that a block, that could be a slight difference especially when it is a long time period. At the beginning if you use block height or time, date you can guess very accurately but if it is a year ahead then you can’t. But this is almost two years ahead, this block height (762048, approximately November 10th 2022) that they have in there. It goes on much longer.

AvW: Two years from now you mean, well one and a half.

SP: Exactly. In that sense it doesn’t really matter that they are using height because it is such a big difference anyway. But this is important. They will keep signaling much longer than the Speedy Trial. We can get into the implications later but basically they will signal much later.

AvW: Let’s stick to the facts first and the implications later. Speedy Trial (Bitcoin Core), it will last for 3 months. And this one, the LOT=true client will allow signaling for 18 months.

SP: The other big difference is that at the end of that 18 months, where the Speedy Trial will simply give up and continue, the LOT=true will wait for miners who do signal. This could be nobody or could be everybody.

AvW: They will only accept signaling blocks after these 18 months. For those who are aware of the whole block size war, it is a little bit like the BIP 148 client.

SP: It is pretty much the same with slightly better tolerance. The UASF client required every single block to signal whereas this one requires 90 percent to signal. In practice if you are the miners at the last 10 percent of that window you need to pay a bit more attention. Other than that it is the same.

AvW: That is why some people would call this the UASF client. The BIP 148 client was the UASF client for SegWit, this is the UASF client for Taproot. I know that for example Luke Dashjr has been contributing to this client doesn’t like the term UASF in this context because there is 18 months of regular miner signaling.

SP: So did the UASF. It is a bit more patient than the UASF.

AvW: There is a lot of discussion on the name of the client and what people should call it or not call it. In general some people have been calling it the UASF client and this is why.

SP: You could call it the “Slow UASF” or something.

### Implications of having two alternative clients

AvW: I have also seen the name User Enforced Miner Activated Soft Fork (UEMASF). People are coming up with names. The basic facts are clear now I hope. Let’s get into the implications. There are some potential incompatibilities between these two activation clients. Everyone agrees that Taproot is great. Everyone wants Taproot. Everyone agrees that it would be preferable if miners activate it. The only thing where there is some disagreement on is what’s the backup plan. That is where the incompatibilities come in. Do you agree?

SP: I think so.

AvW: What are the incompatibilities? First of all and I already mentioned this, to emphasize this, if Speedy Trial activates Taproot there are no incompatibilities. Both clients are happily using Taproot starting in November. This seems pretty likely because 90 percent of mining pools have already indicated that they support Taproot. Likely there is no big deal here, everything will turn out fine. If Speedy Trial doesn’t succeed in activating Taproot that is where we enter a phase where we are going to start to look at potential incompatibilities.

SP: For sure. Imagine one scenario where Speedy Trial fails. Probably Bitcoin Core people will think about that for a while and think about some other possibilities. For some reason miners get wildly enthusiastic right after Speedy Trial fails and start signaling at 90 percent. As far as Bitcoin Core is concerned Taproot never activated. As far as the UASF or LOT=true client Taproot did just activate.

AvW: Let’s say in month 4, we have 3 months of Speedy Trial and then in month 4 miners suddenly signal readiness for Taproot. Bitcoin Core doesn’t care anymore, Bitcoin Core 0.21.1 isn’t looking at the signaling anymore. But this LOT=true client is. On the LOT=true client Taproot will be activated in November while on this Bitcoin Core client it will not.

SP: Then of course if you are using that LOT=true client and you start immediately using Taproot at that moment because you are very excited, you see all these blocks coming in, you may or may not lose your money. Anybody who is running the regular Bitcoin Core client will accept those thefts from Taproot addresses essentially.

AvW: In this case it matters what miners are doing as well. If miners signal readiness because they are actually ready and they are actually going to enforce Taproot then it is fine. There is no issue because they will enforce the soft fork and even Bitcoin Core 0.21.1 nodes will follow this chain. The LOT=true client will enforce and everybody is happy on the same chain. The only scenario where this is a problem, what you just described, is if miners do signal readiness but they aren’t actually going to enforce the Taproot rules.

SP: The problem is of course in general with soft forks, but especially if everyone is not on exactly the same page about what the rules are, you only know that it is enforced when it is actually enforced. You don’t know if it is going to be enforced in the future. This will create a conundrum for everybody else because then the question is what to do? One thing you could do at that point is say “Obviously Taproot is activated so let’s just release a new version of Bitcoin Core that just says retroactively it activated.” It could just be a BIP 9 soft fork repeating the same bit but slightly later or it could just say “We know it activated. We will just hardcode the flag date.”

AvW: It could just be a second Speedy Trial. Everything would work in that case?

SP: There is a problem with reusing the same bit number within a short period of time. (Note: AJ Towns stated on IRC that this would only be a problem if multiple soft forks were being deployed in parallel.) Because it would be exactly the week after in the scenario we talked about it may not be possible to use the same bit. Then you will have a problem because you can’t actually check that specific bit but there’s no signal on any of the other bits. That would create a bit of a headache. The other solution would be very simple, to say it apparently activated so we will just hardcode the block date and activate it then. The problem is what if between the time that the community decides “Let’s do this” and the moment that software is released and somewhat widely deployed one or more miners say “Actually we are going to start stealing these Taproot coins.” You get a massive clusterf*** in terms of agreeing on the chain. Now miners will not be incentivized to do this because why would you deliberately create complete chaos if you just signaled for a soft fork? But it is a very scary situation and it might make it scary to make the release. If you do make the release but miners start playing these shenanigans what do you do then? Do you accept a huge re-org at some point? Or do you give up and consider it not deployed? But then people lose their money and you’ve released a client that you now have to hard fork from technically. It is not a good scenario.

AvW: It gets complicated in scenarios like this, also with game theory and economics. Even if miners would choose to steal they risk stealing coins on a chain that could be re-orged. They have just mined a chain that could be re-orged if other miners do enforce these Taproot rules. It gets weird, it is a discussion about economic incentives and game theory in that scenario. Personally I think it is pretty unlikely that something like this would happen but it is at least technically possible and it is something to be aware of.

SP: It does make you wonder whether as a miner it is smart to signal immediately after this Speedy Trial. This LOT=true client allows for two years anyway. If the only reason you are signaling is because this client exists then I would strongly suggest not doing it immediately after the Speedy Trial. Maybe wait a little bit until there is some consensus about what to do next.

AvW: One thing you mentioned and I want to quickly address that, this risk always exists for any soft fork. Miners can always false signal, they could have done it with SegWit for example, false signal and then steal coins from SegWit outputs. Old nodes wouldn’t notice the difference. That is always a risk. I think the difference here is that Bitcoin Core 0.21.1 users in this scenario might think they are running a new node, from their perspective they are running an updated node. They are running the same risks as previously only outdated nodes would run.

SP: I would be mostly worried about the potential 0.21.2 users who are installing the successor to Speedy Trial which retroactively activates Taproot perhaps. That group is very uncertain of what the rules are.

AvW: Which group is this?

SP: If the Speedy Trial fails and then it is signaled, there might be a new release and people would install that new release, but then it is not clear whether that new release would be safe or not. That very new release would be the only one that would actually think that Taproot is active, as well as the LOT=true client. But now we don’t know what the miners are running and we don’t know what the exchanges are running because this is very new. This would be done in a period of weeks. Right now we have a 6 month… I guess the activation date would still be November.

AvW: It would still be November so there is still room to prepare in that case.

SP: Ok, then I guess what I said before is nonsense. The easier solution would be to do a flag date where the new release would say “It is going to activate on November 12th or whatever that block height is without any signaling.” Signaling exists but people have different interpretations about it. That could be a way.

### Recap

AvW: I am still completely clear about what we are talking about it here but I am not sure if our listeners are catching up at this point. Shall we recap? If miners activate during the Speedy Trial then everything is fine, everyone is in consensus.

SP: And the new rules take effect in November.

AvW: If miners activate after the Speedy Trial period then there is a possibility that the LOT=true client and the Bitcoin Core 0.21.1 client won’t be in consensus if an invalid Taproot block is ever mined.

SP: They have no forced signaling, you’re right. If an invalid Taproot transaction shows up after November 12th….

AvW:…. and if that is mined and enforced by a majority of miners, a majority of miners must have false signaled, then the two clients can get out of consensus. Technically this is true, I personally think it is fairly unlikely. I am not too concerned about this but it is at least technically true and something people should be aware of.

SP: That scenario could be prevented by saying “If we see this “false” signaling, if we see this massive signaling a week after the Speedy Trial then you could decide to release a flag date client which just says we are going to activate this November 12th because apparently the miners want this. Otherwise we have no idea what to make of this signal.”

AvW: I find it very hard to predict what Bitcoin Core developers in this case are going to decide.

SP: I agree but this is one possibility.

### A likelier way that the two clients could be incompatible?

AvW: That was one way the two clients can become incompatible potentially. There is another way which is maybe more likely or at least it is not as complicated.

SP: The other one is “Let’s imagine that the Speedy Trial fails and the community does not have consensus over how to proceed next.” Bitcoin Core developers can see that, there is ongoing discussion and nobody agrees. Maybe Bitcoin Core developers decide to wait and see.

AvW: Miners aren’t signaling…

SP: Or erratically etc. Miners aren’t signaling. The discussion still goes on. Nothing happens. Then this LOT=true mechanism kicks in…

AvW: After 18 months. We are talking about November 2022, it is a long way off but at some point the LOT=true mechanism will kick in.

SP: Exactly. Those nodes will then, assuming that the miners are still not signaling, they will stop…

AvW: That is if there are literally no LOT=true signaling blocks.

SP: In the other scenario where miners do massively start signaling, now we are back to that previous scenario where suddenly there is a lot of miner signaling on bit 2. Maybe the soft fork is active but now there is no delay. If the signaling happens anywhere after November 12th the LOT=true client will activate Taproot after one adjustment period.

AvW: I am not sure I am following you.

SP: Let’s say in this case in December of this year the miners suddenly start signaling. After the minimum activation height. In December they all start signaling. The Bitcoin Core client will ignore it but the LOT=true client will say “Ok Taproot is active.”

AvW: This is the same scenario we just discussed? There is only a problem if there is a false signaling. Otherwise it is fine.

SP: There is a problem if there is false signaling but it is more complicated to resolve this one because that option of just releasing a new client with a flag day in it that is far enough into the future, that is not longer there. It is potentially active immediately. If you do a release but then suddenly a miner starts not enforcing the rules you get this confusion that we talked about earlier. Then we are able to solve it by just making a flag date. This would be even messier. Maybe it is also even less likely.

AvW: It is pretty similar to the previous scenario but a little more difficult, less obvious how to solve this.

SP: I think it is messier because it is less obvious how you would do a flag day release in Bitcoin Core in that scenario because it immediately activates.

AvW: That is not where I wanted to go with this.

SP: You wanted to go for some scenario where miners wait all the way to the end until they start signaling?

AvW: Yes that is where I wanted to go.

SP: This is where the mandatory signaling kicks in. If there is no mandatory signaling then the LOT=true nodes will stop until somebody mines a block that they’d like to see, a block that signals. If they do see this block that signals we are back in the previous example where suddenly the regular Bitcoin Core nodes see this signaling but they ignore it. Now there is a group of nodes that believe that Taproot is active and there is a group of nodes that don’t. Somebody then has to decide what to do with it.

AvW: You are still talking about false signaling here?

SP: Even if the signaling is genuine you still want there to be a Bitcoin Core release, probably, that actually says “We have Taproot now.” But the question is when do we have Taproot according to that release? What is a safe date to put in there? You could do it retroactively.

AvW: Whenever they want. The point is if miners are actually enforcing the new rules then the chain will stay together. It is up to Bitcoin Core to implement whenever they feel like it.

SP: The problem with this signaling is you don’t know if it is active until somebody decides to try to break the rules.

AvW: My assumption was that there wasn’t false signaling. They’ll just create the longest chain with the valid rules anyway.

SP: The problem with that is that it is unknowable.

AvW: The scenario I really wanted to get to Sjors is the very simple scenario where the majority of miners doesn’t signal when the 18 months are up. In that case they are going to create the longest chain that the Bitcoin Core 0.21.1 nodes are going to follow while the LOT=true nodes are only going to accept blocks that do signal which maybe zero or at least fewer. If it is a majority then there is no split. But if it is not a majority then we have a split.

SP: And that chain would get further and further behind. The incentive to make a release to account for that would be quite small I think. It depends, this is where your game theory comes in. From a safety point of view, if you now make a release that says “By the way we retroactively consider Taproot active” that would cause a giant re-org. If you just activate it that wouldn’t cause a giant re-org. But if you say “By the way we are going to retroactively mandate that signaling that you guys care about” that would cause a massive re-org. This would be unsafe, that would not be something that would be released probably. That is a very messy situation.

AvW: There are messy potential scenarios. I want to emphasize to our dear listeners, none of this is going to happen in the next couple of months.

SP: And hopefully never. We will throw in a few other bad scenarios and then I guess we can go onto some other topics.

AvW: I want to mention real quick is the reason I’m not too concerned about these really bad scenarios playing out is because I think if it seems even slightly likely that there might be a coin split or anything like that there will probably be futures markets. These futures markets will probably make it very clear to everyone the alternative chain that stands a chance, that will inform miners on what to mine and prevent a split that way. I feel pretty confident about the collective wisdom of the market to warn everyone about potential scenarios so it will probably work out fine. That’s my general perception.

SP: The problem with this sort of stuff is if it doesn’t work out fine it is really, really bad. Then we get to say retroactively “I guess it didn’t work out fine.”

### Development process of LOT=true client

AvW: I want to bring something up before you bring up whatever you wanted to bring up. I have seen some concerns by Bitcoin Core developers about the development process of the LOT=true client. I think this gets down to the Gitian building, Gitian signing which we also discussed in another episode.

SP: We talked about the need for software to be open source, to be easy to audit.

AvW: Can you give your view on that in this context?

SP; The change that they made relative to the main Bitcoin Core client is not huge. You can see it on GitHub. In that sense that part of open source is reasonably doable to verify. I think that code has had less review but not zero review.

AvW: Less than Bitcoin Core’s?

SP: Exactly but much more than the UASF, much more than the 2017 UASF.

AvW: More than that?

SP: I would say. The idea has been studied a bit longer. But the second problem is how do you know that what you are downloading isn’t malware. There are two measures there. There is release signatures, the website explains pretty well how to check those. I think they were signed by Luke Dashjr and by the other developer. You can check that.

AvW: Bitcoin Mechanic is the other developer. Actually it is released by Bitcoin Mechanic and Shinobi and Luke Dashjr is the advisor, contributor.

SP: Usually there is a binary file that you download and then there is a file with checksums in it and that file with checksums is also signed by a known person. If you have Luke’s key or whoever, their key and you know them, you can check that at least the binary you downloaded is not coming from a hacked website. The second thing, you just have a binary and you know they signed it but who are they? The second thing is you want to check that this code matches the binary and that is where Gitian building comes in which we talked about in an earlier episode. Basically deterministic builds. It takes the source code and it produces the binary. Multiple people can then sign that indeed according to them this source code produces this binary. The more people that confirm that the more likely it is that they are not colluding. I think there are only two Gitian signatures for this other release.

AvW: So the Bitcoin Core software is being Gitian signed by…

SP: I think 10 or 20 people.

AvW: A lot of the experienced Bitcoin Core developers that have been developing the Bitcoin Core software for a while. Including you? Did you sign it?

SP: The most recent release, yes.

AvW: You are trusting that they are not all colluding and spreading malware. It still comes down to trust in that sense for most people.

SP: If you are really contemplating running this alternative software you really should know what you are doing in terms of all these re-org scenarios. If you already know what you are doing in those terms then just compile the thing from source. Why not? If you are not able to compile things from source you probably shouldn’t be running this. But that is up to you. I am not worried that they are shipping malware but in general it is just a matter of time before somebody says “I have a different version with LOT=happy and please download it here” and it steals all your Bitcoin. It is more the precedent this is setting that I’m worried about than that this thing might actually have malware in it.

AvW: That is fair. Maybe sign it Sjors?

SP: No because I don’t think this is a sane thing to release.

AvW: Fair enough.

SP: That’s just my opinion. Everyone is free to run whatever they want to run.

AvW: Was there anything else you wanted to bring up?

### What would Bitcoin Core release if Speedy Trial failed to activate?

SP: Yeah we talked about true signaling or false signaling on bit 1 but a very real possibility I think if this activation fails and we want to try something else then we probably don’t want to use the same bit if it is before the timeout window. That could create a scenario where you might start saying “Let’s use another bit to do signaling.” Then you could get some confusion where there is a new Bitcoin Core release that activates using bit 3 for example but the LOT=true folks don’t see it because they are looking at bit 1. That may or may not be an actual problem. The other thing is that there could be all sorts of other ways to activate this thing. One could be a flag day. If Bitcoin Core were to release a flag day then there won’t be any signaling. The LOT=true client won’t know that Taproot is active and they will demand signaling at some point even though Taproot is already active.

AvW: Your point being that we don’t know what Bitcoin Core will release after Speedy Trial and what they might release might not necessarily be compatible with the LOT=true client. That works both ways of course.

SP: Sure. I am just reasoning from one point here. I would also say that in the event that Bitcoin Core releases something else that has pretty wide community support, I would imagine the people who are running the BIP 8 clients are not sitting in a cave somewhere. They are probably relatively active users that can decide “I am going to run this Bitcoin Core version again because there is a flag day in it which is earlier than the forced signaling.” I could imagine they would decide to run it or not.

AvW: That also works both ways.

SP: No, not really. I am much more worried about people who are not following this discussion who just default to whatever the newest version of Core is. Or don’t upgrade at all, they are still running say Bitcoin Core v0.15. I am much more worried about that group than about the group that actively takes a stance on this thing. If you actively take a stance by running something else then you know what you are doing. It is up to you to stay up to date. But we have a commitment towards all the users that if you are still running in your bunker the 0.15 version of Bitcoin Core that nothing bad should happen to you if you follow the most proof of work within the rules that you know.

AvW: That could also mean making it compatible with the LOT=true client.

SP: No, as far as the v0.15 node is concerned there is no LOT=true client.

AvW: Do we want to get into all sorts of scenarios? The scenario that I am most concerned about is the LOT=true chain to call it that if there is ever a split will win but only after a while because you get long re-orgs. This gets back to the LOT=true versus LOT=false discussion in the first place.

SP: I can only see that happening with a massive price collapse of Bitcoin itself. If the scenario comes to be where LOT=true starts winning after a delay which requires a big re-org… if it is more likely to win its relative price will go up because it is more likely to win. But because a bigger re-org is more disastrous for Bitcoin the longer the re-org the lower the Bitcoin price. That would be the bad scenario. If there is a 1000 block re-org or more then I think the Bitcoin price will collapse to something very low. We don’t really care whether the LOT=true client wins or not. That doesn’t matter anymore.

AvW: I agree with that. The reason I am not concerned is what I mentioned before, I think these things will be sorted out by futures markets well before it actually happens.

SP: I guess the futures market would predict exactly that. That would not be good. Depending on your confidence in futures markets which for me is not that amazing.

### Block height versus MTP

https://github.com/bitcoin/bitcoin/pull/21377#issuecomment-818758277

SP: We could still talk about this nitty difference between block height versus block time. There was a fiasco but I don’t think it is an interesting difference.

AvW: We might as well mention it.

SP: When we first described the Speedy Trial we assumed everything would be based on block height. There would be a transformation from the way soft forks work right now which is based on these median times to block heights which is conceptually simpler. Later on there was some discussion between the people who were working on that, considering maybe the only Speedy Trial difference should be the activation height and none of the other changes. From the point of the view of the existing codebase it is easier to make the Speedy Trial adjust one parameter which is a minimum activation height versus the change where you change everything into block heights which is a bigger change from the existing code. Even though the end result is easier. A purely block height based approach is easier to understand, easier to explain what it is going to do, when it is going to do it. Some edge cases are also easier. But to stay closer to the existing codebase is easier for reviewers somewhat. The difference is pretty small so I think some people decided on a coin toss and other people I think agreed without the coin toss.

AvW: There are arguments on both sides but they seem to be pretty subtle, pretty nuanced. Like we mentioned Speedy Trial is going to start on the same date anyway so it doesn’t seem to matter that much. At some point some developers were seriously considering deciding through a coin flip using the Bitcoin blockchain for that, picking a block in the near future and seeing if it ends with an even or odd number. I don’t know if that was literally what they did but that would be one way of doing it. I think they did do the coin flip but then after that the champions for both solutions ended up agreeing anyway.

SP: They agreed on the same thing that the coin flip said.

AvW: The main dissenter was Luke Dashjr who feels strongly about using block heights consistently. He also is of the opinion that the community had found consensus on that and that Bitcoin Core developers not using that is going back or breaking community consensus.

SP: That is his perspective. If you look at the person who wrote the original pull request that was purely height based, I think that was Andrew Chow, he closed his own pull request in favor of the mixed solution that we have now. If the person writing the code removes it himself I think that’s pretty clear. From my point of view the people who are putting in the most effort should probably decide when it is something this trivial. I don’t think it matters that much.

AvW: It seems like a minor point to me but clearly not everyone agrees it is a minor point.

SP: That is what bikeshedding is about right? It wouldn’t be bikeshedding if everybody thought it was irrelevant which color the bike shed had.

AvW: Let’s leave the coin flip and the time, block height thing behind us Sjors because I think we covered anything and maybe we shouldn’t dwell on this last point. Is that it? I hope this was clear.

SP: I think we can very briefly still interject one thing that was brought up which is the timewarp attack.

AvW: We didn’t mention that, that is somewhat relevant in this context. An argument against using block time is that it opens the door to timewarp attacks where miners are faking the timestamps on the blocks they mine to pretend it is a different time and date. That way they can for example just skip the signaling period altogether, if they collude in doing that.

SP: That sounds like an enormous amount of effort for no good reason but it is an interesting scenario. We did an episode about the timewarp attack a long time ago, back when I understood it. There is a soft fork proposal to get rid of it that I don’t think anyone objected to but also nobody bothered to actually implement. One way to deal with this hypothetical scenario is if it were to happen then we deploy the soft fork against the timewarp attack first and then we try Taproot activation again.

AvW: The argument against that from someone like Luke is of course you can fix any bug but you can also just not include the bug in the first place.

SP: It is nice to know that miners would be willing to use it. If we know that miners are actually willing to exploit the timewarp attack that is incredibly valuable information. If they have a way to collude and a motivation to use that attack… The cost of that attack would be pretty low, it would be delaying Taproot by a few months but we would have this massive conspiracy unveiled. I think that is a win.

AvW: The way Luke sees it is that there was already consensus on all sorts of things, using BIP 8 and this LOT=true thing, he saw this as somewhat of a consensus effort. Using block times is frustrating that in his opinion. I don’t want to speak for him but if I am trying to channel Luke a little bit or explain his perspective that would be it. In his view consensus was already forming and now it is a different path.

SP: I don’t think this new approach blocks any of the LOT=true stuff that much. We went through all the scenarios here and the confusion wasn’t around block height versus time, it was on all sorts of things that could go wrong depending on how things evolved. But not that particular issue. As for consensus, consensus is in the eye of the beholder. I would say if multiple people disagree then there isn’t consensus.

AvW: That would also work the other way around. Where Luke disagrees using block time.

SP: But he cannot say there was consensus on something. If people disagree by definition there wasn’t consensus.

AvW: It was my impression that there was no consensus because people disagree. Let’s wrap up. For our listeners that are confused and worried I am going to emphasize the next 3 months Speedy Trial is going to run on both clients. If miners activate through Speedy Trial we are going to have Taproot in November and everyone is going to be happy. We will continue the soft fork discussion with the next soft fork.

SP: We’ll have the same arguments all over again because we’ve learnt absolutely nothing.

-->

### The Speedy Trial Proposal

![Ep. 31 {l0pt}](qr/ep/31.png)

Speedy Trial was born out of a compromise between developers and users who preferred different upgrade mechanisms for the Taproot soft fork. What Speedy Trial proposed^[<https://lists.linuxfoundation.org/pipermail/bitcoin-dev/2021-March/018583.html>] was to say “Rather than discussing whether or not there's going to be signaling and having lots of arguments about it, let’s just try it quickly.” The proposed timeline^[<https://lists.linuxfoundation.org/pipermail/bitcoin-dev/2021-March/018594.html>] suggested the signaling would start in early May, last three months (until August) and then be activated three months later, in November.

![speedy trial flow](taproot/speedy_trial.svg)

<!--

AvW: We talked a lot two weeks ago. LOT was the parameter we discussed two weeks ago, LOT=true, LOT=false, about Taproot activation. We are two weeks further in and now it seems like the community is somewhat reaching consensus on an activation solution called “Speedy Trial”. That is what we are going to discuss today.
-->

<!--
AvW: That was LOT=true or LOT=false. The debate was on whether or not it should end with forced signaling or not. That’s the LOT=true, LOT=false thing.
-->

<!--
AvW: It would end on LOT=false basically.

SP: Yes. It is the equivalent of LOT=false or just how it used to be with soft forks. It signals but only for a couple of months.
-->

Even though the name implies it's a fast process, you want to give everybody plenty of time to upgrade, so the idea is to start the signaling quickly — and note that miners can signal without installing the software. Once the signal threshold has been reached, the soft fork is set in stone, meaning it's going to happen, at least if people run the full nodes.

Then, there's still some time for people to upgrade and for miners to really upgrade and run that new software rather than just signal for it. They could run that software but they might not. That is why it's sort of OK to release a bit early.

This process made it so Taproot would activate six months after the initial release of the software, assuming 90 percent of miners were signaling. If that threshold wasn't met, the proposal would have expired, and activation options would have been discussed more, albiet with more data to back up decision making.

### The Evolution of the Speedy Trial Proposal

As mentioned above, there wasn't a consensus for how to activate the proposal. One reason it came to this gridlock situation has a lot to do what happened during the SegWit upgrade.

In that scenario, some people feel that users showed their muscles: They claimed their sovereignty, theu claimed back the protocol, and they basically forced miners to activate the SegWit upgrade. In that sense, it was a huge victory for Bitcoin users.

But then, other people felt that Bitcoin came near to a complete disaster with a fractured network and people losing money.

<!--

 The first group of people really likes doing a UASF again or starting with LOT=false and switching to LOT=true or maybe just starting with LOT=true. The people who think it was a big mess, they prefer to use a flag day this time. Nice and safe in a way, use a flag day, none of this miner signaling, miners can’t be forced to signal and all of that.

-->

These different views on what actually happened a couple of years ago meant people couldn't really agree on a new activation proposal. After a lot of discussion, all factions were sort of willing to settle on Speedy Trial, even though no one really liked it. The first group, the UASF people, were OK with Speedy Trial because it didn’t get in the way of the UASF, and if it failed, they'd still do the UASF the following year. Meanwhile, the flag day people were OK with it because the three months likely wouldn't have allowed for a big enough window to do the UASF.

<!--
SP: There is also still the LOT=false, let’s just do soft forks the way we’ve done them before where they might just expire. A group of people that were quietly continuing to work on the actual code that could do that. Just from mailing lists and Twitter it is hard to gauge what is really going on. This is a very short timescale.

AvW: The LOT=false people, this is basically LOT=false just on a shorter timescale. Everyone is sort of willing to settle on this even though no one really likes it.

-->

Once this was decided on, what became apparent is more people came out of the woodwork and started writing code that could actually get Speedy Trial done. In turn, because there were more developers from different angles cooperating on it and getting things done a little bit more quickly, it demonstrated that Speedy Trial was a good idea. When you have some disagreement, then people start procrastinating, not reviewing things, or not writing things. But if people begin working on something quickly and it's making progress, that’s a vague indicator that it was a good choice.

### Different Approaches of Implementing Speedy Trial

Stack Exchange on block height versus mix of block height and MTP: https://bitcoin.stackexchange.com/questions/103854/should-block-height-or-mtp-or-a-mixture-of-both-be-used-in-a-soft-fork-activatio/

Deciding on Speedy Trial was just one part of the equation. The next was determining how to implement it, and for that, there were two different ways: block height,^[<https://github.com/bitcoin/bitcoin/pull/21392>] and median time past (MTP).^[<https://github.com/bitcoin/bitcoin/pull/21377>]

MTP used the existing BIP 9 system. The argument in support of it is it’s far less code because it already works.

As an example, let’s say the signaling deadline of this soft fork is on September 1 at midnight UTC. A miner mines block number 2,016 or some multiple of 2,016 one second before midnight and signals "yes." Everyone who sees that block says, “OK, we have the required percentage of signaling right before the deadline, so Taproot is active.” They also have this automatic script that says “I am now going to put all my savings in a Taproot address because I want to be in the first block and I am feeling reckless, and I love being reckless.”

Then, there's another miner who mine two seconds later because they didn’t see that recent block. Their block arrives one second past midnight. It votes positive too, but it's too late, and so the soft fork doesn't activate because the signaling wasn't done before midnight, the deadline. That is the subtlety you get with BIP 9, and with shorter signaling periods, because with a longer signaling period, it's less likely the signal arrives at the edge of a cutoff point. Usually it isn't a problem, but it's difficult to explain these edge cases to people.

The alternative is to use BIP 8, which is based on height and is much simpler overall, because signaling ends once a specified block height is reached. That height is always at the edge of retargeting periods, making it easier to reason about.

In other words, you'd say, “If the signaling is achieved by block 700,321 then it happens, or it doesn’t happen.” In terms of edge cases, if there's a reorganization — in other words, if a block if removed from the blockchain^[<https://en.bitcoin.it/wiki/Chain_Reorganization>] — that could create problems.

With both proposals, you could have the same scenario of exactly one vote at the edge of the cutoff being problematic. But the much bigger problem with BIP 9 and time-based activiation is that whether the time on the block is one second before midnight or after matters. Because even if support is way over the threshold, if the last block comes in too late, the entire period is disqualified.

### The Hash Power Threshold

What's being implemented now in Bitcoin Core is the general mechanism, which says that for any soft fork that you call Speedy Trial, you could, for example, use 90 percent. But the code for Taproot in Bitcoin Core just says “It never activates.” That is the way you indicate that this soft fork is in the code but isn't going to happen yet. These numbers are arbitrary. The code will support 70 percent or 95 percent, as long as it is not some imaginary number or more than 100 percent.

In the end, it's always 51 percent effictively, because 51 percent of miners can always decide to orphan non-signaling blocks.

The benefit of having the higher threshold is a lower risk of orphan blocks after activation.

However, because Taproot called for a delayed activation, there was a long time between signaling and activation, whereas normally you signal and it activates immediately — or at least within two weeks. Right now it can take much, much longer. That means miners have a longer time to upgrade. As a result, there's a little less risk of orphaning, even if you have a lower signaling threshold.

### Delayed Activation

![Ep. 40 {l0pt}](qr/ep/40.png)

Normally, what happens is you tally the votes in the last difficulty period. If it's more than whatever the threshold is, then the state of the soft fork goes from `STARTED`, as in we know about it and we are counting, to `LOCKED_IN`. The  `LOCKED_IN` state normally lasts for two weeks — or one retargeting period — and then the rules actually take effect.

What's different with Speedy Trial is that with the delayed activation part, this `LOCKED_IN` state will be much longer. It might go on for months, and then the rules will actually take effect. This change is only two lines of code which is quite nice.

### Downsides and Risks

Of course, nothing comes without potential downsides and risks, and Speedy Trial is no exception.

First off, because it's deployed quickly, and because it's clear that the activation of the rules is delayed, there's incentive for miners to just signal rather than actually install the code. This could lead to them procrastinating on actually installing the software, which is fine in theory, unless they wait so long that they forget to actually enforce the rules.

It's always possible for miners to just signal and not actually enforce the rules, which is a risk with any soft fork deployment. This kind of fake signaling has happened in the past — specifically with the BIP 66 soft fork, where we learned miners were fake signaling only because we saw big reorganizations on the network.

If you use Bitcoin Core to create your blocks as a miner, there are some safety mechanisms in place to make sure you don't create an invalid block. However, if another miner creates a block that's invalid, you'll mine on top of it. Then you have a problem because the full nodes that are enforcing Taproot will reject your block.

<!--

For example, you could have a troll user who creates a transaction that looks like a Taproot transaction but is actually invalid according to Taproot rules. This is done because

The way that works, the mechanism in Bitcoin to do soft forks is you have this version number in your SegWit transaction. You say “This is a SegWit version 1 transaction.” Nodes know that when you see a higher SegWit version that you don’t know about…

SP: SegWit version. The current version of SegWit is version 0 because we are nerds. If you see a SegWit version transaction with 1 or higher you assume that anybody can spend that money. That means that if somebody is spending from that address you don’t care. You don’t consider the block invalid as an old node. But a node that is aware of the version will check the rules. What you could do as a troll is create a broken Schnorr signature for example. You take a Schnorr signature and you swap one byte. Then if that is seen by an old node it says “This is SegWit version 1. I don’t know what that is. It is fine. Anybody can spend this so I am not going to check the signature.” But the Taproot nodes will say “Hey, wait a minute. That is an invalid signature, therefore that is an invalid block.” And we have a problem. There is a protection mechanism there that normal miners will not mine SegWit transactions that they don’t know about. They will not mine SegWit version 1 if they are not upgraded.

AvW: Isn’t it also the case that regular nodes will just not forward the transaction to other nodes?

SP: That is correct, that is another safety mechanism.

AvW: There are two safety mechanisms.

SP: They are basically saying “Hey other node, I don’t think you want to just give your money away.” Or alternatively “You are trying to do something super sophisticated that I don’t understand”, something called standardness. If you are doing something that is not standard I am not going to relay it. That is not a consensus rule. That’s important. It means you can compile your node to relay those things and you can compile your miner to mine these things but it is a footgun if you don’t know what you are doing. But it is not against consensus. However, when a transaction is in a block then you are dealing with consensus rules. That again means that old nodes will look at it and say “I don’t care. I’m not going to check the signature because that is a higher version than I know about.” But the nodes that are upgraded will say “Hey, wait a minute. This block contains a transaction that is invalid. This block is invalid.” And so a troll user doesn’t really stand a chance to do much damage.

AvW: Because the transaction won’t make it over the peer-to-peer network and even if it does it would only make it to miners that will still reject it. A troll user probably can’t do much harm.

SP: Our troll example of a user that swaps one byte in a Schnorr signature, he tries to send this transaction, he sends it to a node that is upgraded. That node will say “That’s invalid, go away. I am going to ban you now.” Maybe not ban but definitely gets angry. But if he sends it to a node that is not upgraded, that node will say “ I don’t know about this whole new SegWit version of yours. Go away. Don’t send me this modern stuff. I am really old school. Send me old stuff.” So the transaction doesn’t go anywhere but maybe somehow it does end up with a miner. Then the miner says “ I am not going to mine this thing that I don’t know about. That is dangerous because I might lose all my money.” However you might have a troll miner. That would be very, very expensive trolling but we have billionaires in this ecosystem. If you mine a block that is invalid it is going to cost you a few hundred thousand euros, I think at the current prices, maybe even more.

AvW: Yeah, 300,000 something.

SP: If you have 300,000 euros to burn you could make a block like that and challenge the ecosystem, say “Hey, here’s a block. Let me see if you actually verify it.” Then if that block goes to nodes that are upgraded, those will reject it. If that block goes to nodes that are not upgraded, it is fine, it is accepted. But then if somebody mines on top of it, if that miner has not upgraded they will not check it, they will build on top of it. Eventually the ecosystem will probably reject that entire chain and it becomes a mess. Then you really, really, really want a very large majority of miners to check the blocks, not just mine blindly. In general, there are already problems with miners just blindly mining on top of other miners, even for a few seconds, for economic reasons.

AvW: That was a long tangent on the problems with false signaling. All of this would only happen if miners are false signaling?

SP: To be clear false signaling is not some malicious act, it is just a lazy, convenient thing. You say “Don’t worry, I’ll do my homework. I will send you that memo in time, don’t worry.”

AvW: I haven’t upgraded yet but I will upgrade. That’s the risk of false signaling.

SP: It could be deliberate too but that would have to be a pretty large conspiracy.

-->

<!--

AvW: One other concern, one risk that has been mentioned is that using LOT=false in general could help users launch a UASF because they could run a UASF client with LOT=true and incentivize miners to signal, like we just mentioned. That would not only mean they would fork off to their own soft fork themselves but basically activate a soft fork for the entire economy. That’s not a problem in itself but some people consider it a problem if users are incentivized to try a UASF. Do you understand that problem?

SP: If we go for this BIP 8 approach, if we switch to using block height rather than timestamps…

AvW: Or flag day.

SP: The Speedy Trial doesn’t use a flag day.

AvW: I know. I am saying that if you do a flag day you cannot do a UASF that triggers something else.

SP: You could maybe, why not?

AvW: What would you trigger?

SP: There is a flag day out there but you deploy software that requires signaling.

AvW: That is what UASF people would be running.

SP: They can run that anyway. Even if there is a flag day they can decide to run software that requires signaling, even though nobody would signal probably. But they could.

AvW: Absolutely but they cannot “co-opt” to call it that LOT=false nodes if there is only a flag day out there.

SP: That’s true. They would require the signaling but the flag day nodes that are out there would be like “I don’t know why you’re not accepting these blocks. There’s no signal, there’s nothing to activate. There is just my flag day and I am going to wait for my flag day.”

AvW: I don’t want to get into the weeds too much but if there are no LOT=false nodes to “co-opt” then miners could just false signal. The UASF nodes are activating Taproot but the rest of the network still hasn’t got Taproot activated. If the UASF nodes ever send coins to a Taproot address they are going to lose their coins at least on the rest of the network.

SP: And they wouldn’t get this re-org advantage that they think they have. This sounds even more complicated than the stuff we talked about 2 weeks ago.

AvW: Yes, that’s why I mentioned I’m getting a little bit into the weeds now. But do you get the problem?

SP: Is this an argument for or against a flag day?

AvW: It depends on your perspective Sjors.

SP: That of somebody who does not want Bitcoin to implode in a huge fire and would like to see Taproot activated.

AvW: If you don’t like UASFs, if you don’t want people to do UASFs then you might also not want LOT=false nodes out there.

SP: Yeah ok, you’re saying “If you really want to not see UASF exist at all.” I’m not terribly worried about these things existing. What I talked about 2 weeks ago, I am not going to contribute to them probably.

AvW: I just wanted to mention that that is one argument against LOT=false that I’ve seen out there. Not an argument I agree with myself either but I have seen the argument.

SP: Accurately what you are saying is it is an argument for not using signaling but using a flag day.

AvW: Yes. Even Speedy Trial uses signaling. While it is shorter, it might still be long enough to throw a UASF against it for example.

SP: And it is compatible with that. Because it uses signaling it is perfectly compatible with somebody deploying a LOT=true system and making a lot of noise about it. But I guess in this case, even the strongest LOT=true proponents, one of them at least, argued that would be completely reckless to do that.

AvW: There are no UASF proponents out there right now who think this is a good idea. As far as I know at least.

SP: So far there are not. But we talked about, in September I think, this cowboy theory. I am sure there is somebody out there that will try a UASF even on the Speedy Trial.

-->

### Speedy Trial as a Template

Because Speedy Trial was successful, it's possible we can use it as a template for soft fork activation moving forward.

We had a soft fork, Taproot, that everyone seemed to love: users, developers, and miners alike. But the problem was how to upgrade. By agreeing on what soft forks are exactly, and what the best way to deploy a soft fork is, everyone can come to a consensus on what kind of template can be used in more contentious times.

One scenario I could see is where the Speedy Trial goes through, activates successfully and the Taproot deployment goes through and everything is fine. Then I think that would remove that trauma. The next soft fork would be done in the nice traditional LOT=false BIP 8. We’ll release something and then several months later miners start signaling and it will activate. So maybe it is a way to get over the trauma.

SP: It might be good to get rid of that tension because the downside of releasing regular say BIP 8 LOT=false mechanism is that it is going to be 6 months of hoping that miners are going to signal and then hopefully just 2 weeks and it is done. That 6 months where everybody is anticipating it, people are going to go even crazier than they are now perhaps. I guess it is a nice way to say “Let’s get this trauma over with” But I think there are downsides. For one thing, what if in the next 6 months we find a bug in Taproot? We have 6 months to think about something that is already activated.

AvW: We can soft fork it out.

SP: If that is a bug that can be fixed in a soft fork, yes.

AvW: I think any Taproot, you could just burn that type.

SP: I guess you could add a soft fork that says “No version 1 addresses can be mined.”

AvW: Yes exactly. I think that should be possible right?

SP: Yeah. I guess it is possible to nuke Taproot but it is still scary because old nodes will think it is active.

AvW: This is a pretty minor concern for me.

SP: It is and it isn’t. Old nodes, nodes that are released now basically who know about this Speedy Trial, they will think Taproot is active. They might create receive addresses and send coins. But their transactions won’t confirm or they will confirm and then get unconfirmed. They won’t get swept away because the soft fork will say “You cannot spend this money.” It is not anyone-can-spend, it is “You cannot spend this.” It is protected in that sense. I suppose there are soft fork ways out of a mess but that are not as nice as saying “Abort, abort, abort. Don’t signal.” If we use the normal BIP 8 mechanism, until miners start signaling you can just say “Do not signal.”