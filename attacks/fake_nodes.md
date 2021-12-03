\newpage
## Fake Nodes


![Ep. 49 {l0pt}](qr/49.png)

TODO Chapter summary

<!--
Chaincode podcast that also covers this attack: https://podcast.chaincode.com/2021/10/26/pieter-wuille-amiti-uttarwar-p2p.html
Explanation of ADDR message: https://developer.bitcoin.org/reference/p2p_networking.html#addr
-->

In mid 2021, people who run nodes started noticing that random people were connecting to them.^[To read the thread where people mention noticing this attack, see <https://bitcointalk.org/index.php?topic=5348856.0>] Of course, on its own, this isn't too bizarre. That's because nodes essentially bootstrap to the network, which is how Bitcoin nodes find other Bitcoin nodes. In turn, those nodes share IP addresses with one another, enabling more connection, which is how the network forms.

However, what was unusual about this instance was these random people would connect to them and then send 500 messages, and each of those 500 messages would contain 10 IP addresses that were supposed to represent other nodes in the network.

When they connected, they'd say "Hey did you know about these 10 IP addresses? And did you know about these 10 IP addresses?" They'd do this 500 times and then disconnect. It certainly didn't seem malicious, but it was a bit weird.

These messages were real, but the contents was nonsense, meaning the IP addresses these nodes sent were just randomly generated numbers. So if you were to map them out, you'd see they were all over the spectrum, which isn't what the internet looks like, because a lot of IP addresses aren't used at all. So they ended up including IP addresses that just cannot exist.

The problem with artificial IP addresses is that the odds of there actually being a node located at that address isn't high. You could try random IP addresses if you want, but the whole point of gossiping nodes is that you get actual nodes.

As people looked into this more, they discovered it was happening on a fairly large scale, classifying it as an attack. In reality, this kind of attack isn't a big problem for an individual node, especially if it already has lots of IP addresses from honest nodes. It might connect to a few nodes that don't exist, but it's mostly a waste of time and resources, since it's connecting to and storing IP addresses that aren't real Bitcoin node IP addresses. So on the individual level, it's like a kid throwing a little pebble at you.

Furthermore, not many people noticed what was happening, as most people who aren't actively looking at their node wouldn't have even known this attack had happened. So in the overall scheme of things, it wasn't harmful, but it was strange.

### Why Would Someone Attack?

A couple weeks after this attack, Matthias Grundmann and Max Baumstark wrote a paper^[<https://arxiv.org/abs/2108.00815>] describing the attack and speculating about the reasoning behind it.

TODO the show nodes from, I believe, the Council Institute of Technology. And the department is the Institute of Information Security and Dependability.

What they're guessing is that this attacker wasn't so much trying to destroy the network, as they were trying to map the network to get a sense of how well nodes are connected to each other. And the reason they can do that is because when you receive 10 IP addresses, you'll forward some — but not all — of them to some of your peers. So you get some exponential decay where you send them to your neighbors and their neighbors send some of them to their neighbors.

If you're the attacker and you're also just running regular nodes, eventually you'll hear some of the echo of your own attack, because your peers will eventually relay it back to you. And by looking at this echo, you can determine a little bit of what the network looks like, including the shape of it, how well connected it is, how robust it is, etc. This information could potentially be used for future attacks, or it could just be for research purposes.

### Defense Mechanisms

That said, there are some existing defense mechanisms in nodes that make it more difficult to use this information. For example, if you're telling a node a bunch of IP addresses, it's not going to immediately connect to all of them, because that would be kind of obvious. It also doesn't relay all of them, and there's some time delay in when it relays some of them. So, it makes it very difficult to say specifically which node connects to which node connects to which node.

These defense mechanisms are added to Bitcoin Core incrementally. Essentially, when people do these types of attacks — probing the network in weird ways — people like Greg Maxwell and Pieter Wuille will look at it and see how they can add something against it.

In this instance, they added a counter measure.^[<https://github.com/bitcoin/bitcoin/pull/22387>] Normally, when people are acting nice, they'll connect to you and send you one IP address — namely their own. Occasionally, they'll send you some other IP addresses, but not very frequently — the average node will share an IP address with a peer maybe once every 20 seconds.

But the counter measure introduces a rate limiter. This basically says, "OK, when a new node connects to me, I'll allow it to send me one address immediately, and then I'll allow up to one address every 20 seconds." It tracks how many seconds have gone by, and if it's sending too many addresses, it'll ignore the new ones that go over the rate limit. So the "attackers" don't get punished, but rather ignored.

Of course, there are cases where nodes actually want to receive addresses from their peers. For example, if somebody connects to you and you say, "Please tell me addresses, and give me up to a thousand," then of course the response won't be rate limited. You'll make sure that they can actually give you those addresses, but if it's unsolicited, then you rate limit it.

Now, the interesting part is that apparently this fix was added in the weeks before the attack happened — not in Bitcoin Core, but as an open pool request, or proposed change. It remained open until shortly after the attack, but then it was merged and has been released in version 22.0.

 So it almost sounds like somebody saw the solution and saw an opportunity to carry out this specific attack. Or perhaps somebody was already planning this attack and then figured they should do it soon, before it was no longer possible.

### Other Examples

There have been other examples of this, like back in the Bitcoin Unlimited days, where they had an alternative implementation that had a bug in it, and then the bug was fixed, but before the fix was deployed, the bug was exploited by somebody. In turn, that brought down all the Bitcoin Unlimited nodes at that time.

Additionally, around 2013, something similar didn't happen, but could have happened, on Bitcoin. This is because the OpenSSL library was made stricter in its software by imposing constraints on signatures. It was presented as nice cleanup software, but it was actually also a patch for a security vulnerability where somebody could have posted a slightly different kind of signature and caused a fork because some nodes would accept it and other nodes wouldn't accept it.

Scenarios like this make it seem as though the overall solution from Bitcoin Core developers is to pretend that something isn't a big deal until people have actually downloaded and used the software, and then later they'll reveal it was actually a much bigger problem that they were fixing before someone discovered the vulnerability.

Overall, it's not ideal, because in open source development, you want to be very transparent about things you're changing. For example, if you're being not transparent about fixing a critical bug, then maybe you're also not transparent about adding inflation. It's a delicate balance.

A final example is that of an inflation bug a couple years ago. It was presented as a fix to a bug that will crash your node. And that was true — it could crash your node — but it could also create inflation. The latter fact was a bit more important, and it was of course not announced, because somebody could have exploited it in that window of opportunity.
