\newpage
## Eclipse Attacks {#sec:eclipse}

![Ep. 17 {l0pt}](qr/ep/17.png)

An eclipse attack is a type of attack that isolates a Bitcoin node by occupying all of its connection slots to block the node from receiving any transactions, in turn barring it from transactions other than those sent to it by the attacker. This prevents the node from seeing what’s going on in the Bitcoin network, and potentially even tricks the node into accepting an alternative (invalid) version of the Bitcoin blockchain.

This chapter discusses how this type of attack could be used to dupe users and miners. It also talks about solutions to counter this type of attack, some of which were outlined in the 2015 paper “Eclipse Attacks on Bitcoin’s Peer-to-Peer Network,” which was written by Ethan Heilman, Alison Kendler, Aviv Zohar, and Sharon Goldberg, from Boston University and Hebrew University/MSR Israel.^[<https://cs-people.bu.edu/heilman/eclipse/>] Many of the solutions proposed by this paper have already been implemented in Bitcoin Core software — the most recent of which was included in Bitcoin Core 0.21.0. This chapter also discusses a potential solution that wasn't in the paper.

### What an Eclipse Attack Is

Under normal circumstances, your node connects to the outside world — via up to eight peers outbound and up to 117 inbound, on average. In the case of an eclipse attack, your node only sees and connects to your enemy or attacker. So you might think you're talking to the whole world, but you're actually only talking to one person. In other words, that person is eclipsing your view of the world.

The reason you connect to all these nodes is because you want to ask them for new transactions and blocks, and they'll spontaneously give these to you. But if you're only talking to one person, that person can decide not to give you certain transactions and blocks.

What they can't do is fake signatures. But they can do a double spend attack on you.

So let's say you're expecting money from somebody, and you see this transaction appear in your mempool — which is where valid transactions wait to be confirmed — but it's not yet in a block.

Then, it turns out this person is actually sending you that transaction over the wire, but to the outside world, they're sending a very different transaction. And so then a new block arrives, but you're not going to see that block because the user is sending a conflicting transaction — most likely coins to themselves.

Nowadays, people know that accepting zero confirmation transactions is a bad idea for various reasons, but this is the easiest thing you can do when you can basically hide what's happening: You can tell this person one thing that you paid them and tell other people another thing.

If you do wait for a confirmation, they can still attack you using an eclipse attack, but it's going to get a lot more expensive, so they'll have to produce a valid block.

When they give you that block, it includes the transaction, so you think it's confirmed. However, the outside world of normal miners is also producing blocks, and the attacker is hiding those normal blocks from you. And for the normal miners, your transaction never happened, because there's a longer chain that's not paying you. Instead, you've just accepted the one block or maybe multiple blocks. And the attack gets more expensive as they have to produce more blocks.

The idea is: If you're a miner and you want to launch this attack on someone, but you only control 10 percent of hash power, then usually it wouldn't work, because even the blocks you produce with the fake transaction will just be orphans. However, if you also have an eclipse attack, then it could actually work, because the person you're attacking won't see the competing chain.

This is a good reminder of why it's important for Bitcoin to be somewhat expensive, because it's really expensive to produce blocks like that, whereas back in 2015, this would've been cheaper. So, the attacker is only going to attack you if the cost of making a fake block is lower than the amount of money they're scamming you for.

But it turns out they can do something else: They can actually try to split miners. The way this works is that while they're trying to scam you, they're also scamming miners at the same time. And then you might have one miner producing the block attacker ones and one miner producing the block that goes to you. The miners don't even know this is going on, and they're wasting a giant amount of money and the attacker just robs you of $100. So there's a lot of economic damage, but they still scam you.

To simplify this example, let's say there are two miners on the network. Someone launches an eclipse attack on one of them and source launches an eclipse attack on another. What happens is the first minor produces blocks but can't see their competitor's blocks. The attacker then sends those blocks from the first miner to the second miner. The result is the miner wasting money, and people being cheated with fake transactions. So the attacker doesn't necessarily have to produce the blocks themselves to profit from an eclipse attack.

Mining is still somewhat centralized, so there are specialized networks that connect miners, making this difficult to do. But this shouldn't be the only thing we're relying on to avoid eclipse attacks. Luckily, it's becoming more difficult to do, largely because we're introducing more solutions designed to make this attacks more difficult.

### How an Eclipse Attack Works

Nodes are becoming a little bit hardened, but to understand that, it's important to understand how the aforementioned paper proposes that one does an eclipse attack.

There are a couple of ingredients. First, as mentioned in chapter X, when a node starts, it tries to find other peers, and once it's been running for a while, it has a list of addresses it got from other peers and it stores them in a file. Then, when the node restarts, it looks at this file for all the addresses it knows, and it starts randomly connecting to them.

As an attacker, the idea is to pollute this file by giving the node either addresses you control or addresses that don't exist. Either way, the goal is to exploit the way the node picks the addresses, so that every time it makes a connection, it either fails because there's nothing there, or it connects to you — and eventually it only connects to you.

This happens due to the nature of how a node collects and organizes IP addresses: by sorting them into various "buckets" based on things like the starting number or ???

Imagine someone has 1,000 real IP addresses of other nodes. Then you, the attacker, feed them 10 gazillion fake IP addresses or IP addresses that are yours. Then, as the person's nodes start to pick IP addresses, the odds are it'll pick some of those IP addresses, and possibly not any real ones.

Part of the trick is that there's a list of IP addresses that are known, but every time a node learns new ones, it starts throwing away the older ones.

Here's where the paper comes into play. It ran a simulation to see how difficult it was to actually overflow all these buckets, and it found that, within a matter of days, it can be successful.

At this point, the node still has outbound connections to the real world, so the question for the attacker is: How can you get rid of those connections? The trick is to try and make the node crash.

This is one reason why it's extremely important for developers to ensure they don't write code that can make a node crash, because crashable nodes are an important ingredient in these type of attacks.

TODO And another attacks. So whenever there is a bug that allows Bitcoin Core to crash, it's a pretty serious one, but you can overload somehow overload its ram usage, there's been lots of problems like that, but when it crashes and it starts again, hopefully, usually automatically if you've configured a server correctly and when it starts automatically, when it starts, it's going to look at that file of peers it knows, and it's going to try and connect to them. So it's going to look in all these buckets and it's only going to find the attacker. And then the attacker also makes sure that it makes sure it's connecting to you. So all your inbound connections are full and then you're just only talking to the attacker. That's all that's needed for the eclipse attack to be in play.

### How to Solve It

It's important to understand that attacks like these are a numbers game. If you're the attacker, you need to give a lot of spam addresses to a node to fill up all the buckets and make sure it only connects to you.

One very simple solution for avoiding an attack like this is to have more buckets. Another is to remove the bias toward selecting more recent peers and discarding the old ones. However, the tradeoff is you don't want to prioritize old IP addresses, because they might not be there any longer.

What you can do is this: If you hear of a new address and you want to put it in a bucket and remove something else, you first check the address that's already in the bucket. That entails connecting to it to see if it still exists. If it does exist, you don't replace it. This is called the feeler connection.

A couple years ago, what was merged is something where every now and then, Bitcoin Core looks at a bucket, quickly connects to a node, sees if it's real, and remembers that and then disconnects. This is a way of prioritizing all the addresses in a more intelligent way.

Bitcoin Core 0.21.0 was released in January 2021, and it included a new method to prevent eclipse attacks that was suggested in the 2015 paper.^[To give you an idea about the speed of Bitcoin development, a person can write a paper in 2015, and improvements based on that paper can happen gradually for the next five or more years.] What happens is that when you restart, you try to remember some of the last connections you had. Your node remembers the two connections that it only exchanges blocks with, and it tries to reconnect to those — but not too often, because it's not a good idea to always try to reconnect to the same nodes again when you restart, as, for all you know, the reason you crashed in the first place is because one of those nodes was evil. And in that case, if you connect to the last connect and it goes wrong again, then you don't try reconnecting again.

Another thing you can do instead of having more buckets is have more outbound connections. This is because the more outbound connections you have, the more likely you are to be connecting to honest nodes, and the more difficult it is for an attacker to control all of the IP addresses you're connected to.

You may be wondering: Why wouldn't you just have as many connections as possible from the get-go? But the problem is that it requires a lot of data exchange — especially for the transactions in a mempool — and that's extremely data intense, so you can't just add more connections without also increasing bandwidth use.

That said, there are some new proposals for reducing the bandwidth needed for these mempool synchronizations that would allow more connections — so there's an incentive to make this data exchange more efficient. 

Plus, there's the solution that some of the connections you connect to, you don't share mempool stuff with; instead, you only connect to blocks.

One of the ways to have the upside of more connections without the downside of more bandwidth is to only exchange blocks with those extra connections, because that happens much less frequently. This still costs a little bit of an extra bandwidth, but much less.

This. reminds us that you need to wait for confirmations because those extra connections will tell you about new blocks. They won't tell you about new stuff in a Mempool, but that's fine if you wait for confirmations.

Well, I mean, you can always use the block stream satellite or something like that as another source of data. Of course that's not a universal solution, but it is a really-

Sjors:
But there is an incentive for Bitcoin blocks to be broadcast in general, over satellite or AM, or for multiple sources so it's more difficult to eclipse someone because you'd have to eclipse the whole planet, right? If the signal is coming from a satellite, you want to eclipse somebody who's listening to that satellite and you either have to blow up the satellite connection to them or blow up the satellite itself, which everybody would notice and it'd be in the news and you'd say, "Hey, there's probably something going on here."

Aaron:
I like your [inaudible 00:18:00] mindset though, that you do recognize that that's actually a risk that someone blows up the satellite.

Sjors:
Well, I mean, you don't actually physically have to blow it up, I guess. You can just tell people to stop broadcasting to it. One more solution is to have more nodes, basically, that other people don't know are yours. So if you have multiple nodes that you're using for-... your, whatever your services and you make sure that the outside world doesn't know all of them, and they might try to eclipse one of them, but they forgot to eclipse the other ones.

### Erebus Attack

![{l0pt}](qr/ep/18.png)

If you want to learn more about eclipse attacks, you might be interested in the Erebus attack^[<https://erebus-attack.comp.nus.edu.sg>]: an eclipse attack where an attacker essentially spoofs an entire part of the internet.

How this works is the internet is made up of Autonomous Systems (AS), which are basically clusters of IP addresses owned by the same entity, like an ISP. As explained above, Bitcoin Core nodes can counter eclipse attacks by ensuring they're connected to a variety of IP addresses from different Autonomous Systems.

As it turns out, however, some Autonomous Systems can effectively act as bottlenecks when trying to reach other Autonomous Systems. This allows an attacker controlling such a bottleneck to launch a successful eclipse attack — even against nodes that connect with multiple Autonomous Systems.

Recent versions of Bitcoin Core include an optional feature — ASMAP — to counter these types of eclipse attacks. The episode explains how mapping of the internet has allowed Bitcoin Core contributors to create a tool which ensures that Bitcoin nodes not only connect to various Autonomous Systems, but also ensures that they avoid being trapped behind said bottlenecks.
