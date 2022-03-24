\newpage
## Fake Nodes {#sec:fake_nodes}


![Ep. 49 {l0pt}](qr/ep/49.png)

This chapter talks about an attack that took place in the summer of 2021. It discusses what happened, speculates why it may have happened, and shares the fix that will prevent it from happening again.

<!-- Blank line to move the next section header below the QR code -->
\

### Random Connections

In mid 2021, people who run nodes started noticing that random people were connecting to them.^[To read the thread where people mention noticing this attack, see <https://bitcointalk.org/index.php?topic=5348856.0>] This, on its own, is perfectly normal. As we explained in chapter @sec:dns it’s part of how nodes bootstrap to the network. They randomly connect to nodes, and ask for addresses of more nodes to connect to. They also announce their own IP, which gets gossiped around, so soon enough the node will receive inbound connections.

However, what was unusual in this instance was these random people would connect to them and then send 500 messages,^[<https://developer.bitcoin.org/reference/p2p_networking.html#addr>] and each of those 500 messages would contain 10 IP addresses that were supposed to represent other nodes in the network. After that they would just disconnect. It certainly didn’t seem dangerous, but it was not the usual behavior.

Although the messages were perfectly valid, their contents was nonsense, because the IP addresses these nodes sent were just randomly generated numbers. You could tell this if you mapped them out, the pattern would match that of randomly generated numbers. Another way you could tell is because the list would contain IP addresses which simply can’t exist for various reasons, e.g. because they are reserved for private networks such as 192.168.0.1.

The problem with these randomly generated IP addresses is that, if you’re flooded with them, they make it almost impossible to connect to a real node. There are less than a hundred thousands nodes out there that your node can connect to, yet there are four billion IPv4 addresses. The purpose of the address gossip protocol is exactly to prevent this random guessing. But this attack wasn’t big enough to flood individual nodes.

As people looked into this more, they discovered it was happening on a fairly large scale, classifying it as an attack. In reality, this kind of attack isn’t a big problem for an individual node, especially if it already has lots of IP addresses from honest nodes. It might connect to a few nodes that don’t exist, but it’s mostly a waste of time and resources, since it’s connecting to and storing IP addresses that aren’t real Bitcoin node IP addresses. So on the individual level, it’s like a kid throwing a little pebble at you.

Furthermore, we know it wasn’t a big deal just from the fact that hardly anyone even noticed what was happening. But it does deserve investigation.

### Why Would Someone Attack?

A couple weeks after this attack, Matthias Grundmann and Max Baumstark wrote a paper^[<https://arxiv.org/abs/2108.00815>] describing the attack and speculating about the reasoning behind it.

What they’re guessing is that this attacker wasn’t so much trying to destroy the network, as they were trying to map the network to get a sense of how well nodes are connected to each other. And the reason they can do that is because when you receive 10 IP addresses, you’ll forward each of them to exactly two of your peers.^[It will not propagate further. Although you received these spam addresses in neat packages of ten, you node will forward them in bigger packages. Nodes don’t forward any addresses in a package if it was bigger than ten, so the attack fizzles out after just two hops.]

If the attacker also connects to you using a regular (not spamming) node, it will receive some fraction of the spam address that you forward. From that fraction it can calculate how many peers you have. More generally in a surveilance attack like this, it’s like they are monitoring the echo of their own attack. By looking at this echo, they can determine a little bit of what the network looks like, including the shape of it, how well connected it is, how robust it is, etc. This information could potentially be used for future attacks, or it could just be for research purposes.

### Defense Mechanisms

There are some existing defense mechanisms in nodes that make it more difficult to use this information. For example, if you’re telling a node a bunch of IP addresses, it’s not going to immediately connect to all of them — not only because that would make it too easy to invite a node into connecting to a trap, but also because, most of the time, a node already has sufficient connections. It also doesn’t relay all of them, and for those addresses that are relayed, there’s a random time delay. So, it makes it very difficult to say specifically which node connects to which node connects to which node.

These defense mechanisms are added to Bitcoin Core incrementally, often as a defense against eclipse attacks as we explained in chapter @sec:eclipse. Essentially, when people do these types of attacks — probing the network in weird ways — experienced developers and security researchers will look at them and see how they can add something against them.

In this instance, they added a counter measure.^[<https://github.com/bitcoin/bitcoin/pull/22387>] Normally, when people are acting nice, they’ll connect to you and send you one IP address — namely their own. Occasionally, they’ll send you some other IP addresses, but not very frequently — the average node will share an IP address with a peer maybe once every 20 seconds.

Because an attacker will send addresses at a much higher rate, the counter measure is to introduce a rate limiter. This basically says, “OK, when a new node connects to me, I’ll allow it to send me one address immediately, and then I’ll allow up to one address every 20 seconds.” It tracks how many seconds have gone by, and if the node is sending too many addresses, it’ll ignore the new ones that go over the rate limit. So the “attackers” don’t get punished, but rather ignored.^[Overzealously punishing bad behavior can lead to network partitioning, something that an attacker could even exploit by tricking regular nodes into “angering” their peers and getting themselves disconnected.]

Of course, there are cases where nodes actually want to receive lots of addresses from their peers. For example, if somebody connects to you and you say, “Please tell me addresses, and give me up to 1,000,” then of course the response won’t be rate limited. In such a scenario, you’ll make sure that they can actually give you those addresses, but if it’s unsolicited, then you rate limit it.

### Responsible Disclosure

Now, what's really interesting is that this fix was published in the weeks _before_ the attack happened. It wasn’t merged into Bitcoin Core yet, but rather just an open pull request, or proposed change. It remained open until shortly after the attack, but then it was merged and released in version 22.0.

So it almost sounds like somebody saw the solution and saw an opportunity to carry out this specific attack. Or perhaps somebody was already planning this attack and then figured they should do it soon, before it was no longer possible.

For more on this attack and related issues, there’s also a great Chaincode Labs podcast episode.^[From 23:15 “Rate limiting on address gossip”: <https://podcast.chaincode.com/2021/10/26/pieter-wuille-amiti-uttarwar-p2p.html>]

There have been other examples of a situation where publishing a fix may itself have caused the attack. Back in the day there was an alternative node implementation Bitcoin Unlimited. It had a bug which was fixed, but before the fix was deployed, the bug was exploited by somebody. That attack brought down all the Bitcoin Unlimited nodes at that time.^[<https://bitcoinmagazine.com/technical/security-researcher-found-bug-knocked-out-bitcoin-unlimited>]

Additionally, around 2013, something similar didn’t happen, but could have happened, on Bitcoin, which we covered in chapter @sec:libsecp. This is because the OpenSSL library was made stricter in its software by imposing constraints on signatures. Had it been discovered only a few months later, after a Bitcoin Core release was already out there with the bug in it, then it would have been zero-day situation. Perhaps in that case the fix would have been disguised as a nice cleanup software, rather than a patch for a security vulnerability. If someone had found out, they could have posted a slightly different kind of signature and caused a fork because some nodes would accept it and other nodes wouldn’t accept it.

A final example is that of an inflation bug in 2018.^[<https://bitcoincore.org/en/2018/09/20/notice/>] It was presented as a fix to a bug that will crash your node. And that was true — it could crash your node — but it could also create inflation. The latter fact was a bit more important, and it was of course not announced, because somebody could have exploited it in that window of opportunity.

One way to handle scenarios like this, is for developers to pretend that something isn’t a big deal until people have actually downloaded and used the fix. And then to reveal only later that it was actually a much bigger problem that they were fixing. This makes it less likely that attacker detects the vulnerability while it’s still exploitable.

But that’s really not an ideal approach, because in open source development, you want to be very transparent about things you’re changing. Because if you’re being not transparent about fixing a critical bug, then maybe you’re also not transparent about adding inflation. It’s a delicate balance.
