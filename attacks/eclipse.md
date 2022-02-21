\newpage
## Eclipse Attacks {#sec:eclipse}

![Ep. 17 {l0pt}](qr/ep/17.png)

An eclipse attack is a type of attack that isolates a Bitcoin node by occupying all of its connection slots to block the node from receiving any transactions and blocks, other than those sent to it by the attacker. This prevents the node from seeing what’s going on in the Bitcoin network, and it potentially even tricks the node into accepting an alternative branch of the Bitcoin blockchain. Although nodes will never accept an invalid transaction or block, an eclipse attack can still cause harm, as we’ll see.

This chapter discusses how this type of attack could be used to dupe users and miners. It also talks about solutions to counter this type of attack, some of which were outlined in the 2015 paper “Eclipse Attacks on Bitcoin’s Peer-to-Peer Network,” which was written by Ethan Heilman, Alison Kendler, Aviv Zohar, and Sharon Goldberg from Boston University and Hebrew University/MSR Israel.^[<https://cs-people.bu.edu/heilman/eclipse/>] Many of the solutions proposed by this paper have gradually been implemented in Bitcoin Core software in the past few years. This chapter also discusses a potential solution that wasn’t in the paper.

### Why an Eclipse Attack Hurts

Under normal circumstances, your node connects to the outside world via up to eight so-called “outbound peers.” The outside world can also connect to you, and for that, your node allows a maximum of 117 inbound peers. In the case of an eclipse attack, your node only sees and connects to your attacker. So you might think you’re talking to the whole world, but you’re actually only talking to one person. In other words, that person is eclipsing your view of the world.

The reason you connect to all these nodes is because you want to ask them for new transactions and blocks. Data flows in both directions, no matter if the peer is inbound or outbound. Your peers may spontaneously send you blocks and transactions, and your node will in turn forward them to others. As long as you’re connected to at least one honest peer, you won’t miss out on the latest blocks and transactions.

An eclipse attack occurs if all of the peers you’re connected to are controlled by a single entity, your attacker. Now they decide which blocks and transactions your node gets to see, and you may very well be missing out on the latest and greatest out there.

But why does this matter? They can’t send you an invalid block with a fake signature that makes them a billionaire. Your node still checks all the rules and would never accept that. But what they can do is perform a double-spend attack on you.

So let’s say you’re expecting money from somebody, in this case from your attacker or someone they're colluding with^[In practice victims often know who double-spent them. For example it's not a good idea to double-spend an exchange if you just uploaded a copy of your passport. The author refers to this as Proof of Prison. This is probably why double-spend attacks are rare, even on altcoins with a much lower mining security budget than Bitcoin (we'll get to the role of Proof of Work below). When evaluating claims about new and unproven technologies, such as Proof of Stake, bear in mind the role Proof of Prison plays in deterring attacks.], and you see their transaction appear in your mempool — which is where valid transactions wait to be confirmed — but it’s not yet in a block.

You might consider this payment complete and deliver a product or service for it. But it turns out that, behind your back, they sent an alternative transaction to the rest of the network that _doesn’t_ pay you. This alternative, double-spend^[The thing that gets double spent is one or more of the coins that form the input for the transaction. A Bitcoin transaction takes coins as its input and creates new coins as its output. An input can only ever be spent once. When a node sees two transactions that spend the same input, they have to pick one and ignore the other. The same goes for miners.] transaction gets included in a block, but your attacker hides this block from you. So from your point of view, this transaction is still in the mempool, and you remain oblivious to the fact that you’ll never truly receive these coins.

This is the most straightforward example of an eclipse attack. It’s yet another reason that accepting zero confirmation transactions is a bad idea. Preventing double-spends is the raison d’être for proof of work, so a transaction must be included in a block in order to enjoy the protection of the work in that block, and every block on top of it.

In the days before Bitcoin, the double-spend problem was everywhere, and it was only considered solvable by introducing a trusted third party. For example, when receiving any amount of Chaumian e-cash, the software on your computer would immediately inform your bank that you received the tokens. The bank’s computer would then verify that these tokens were never seen before. Without that step, the same e-cash could’ve been spent to many different recipients.^[Here’s a brief explanation of Chaumian e-cash <https://bitcoin.stackexchange.com/a/10666/4948>. For a longer explanation and a proposed Bitcoin-backed variation of it, listen to episode 52 of Bitcoin, Explained: <https://nadobtc.libsyn.com/federated-ecash-episode-52>]

But even if you do wait for a confirmation, you’re not out of the woods. An eclipse attack is still possible, as we’ll see, but it’ll be a lot more expensive. This is because the attacker has to produce a valid block, and part of what determines the validity of a block is that it contains sufficient proof of work (most of time, the same as the previous block).

So let’s say you sold something expensive. Like in the previous example, the attacker first sends you their transaction, and then they send a conflicting transaction to the rest of world, while making sure you never see it. That conflicting transaction gets confirmed, but your attacker doesn’t forward this new block to you. Instead, they mine their own block with the original transaction in it. Your node tells you the transaction is confirmed, and you provide the goods or service.

Meanwhile, the outside world of normal miners keeps producing blocks, and the attacker continuous to hide those normal blocks from you. The attacker won’t bother to produce any new blocks, because they have what they need from you. At some point, they stop the attack, or you figure out what happened and intervene. Either way, your node connects to legitimate peers again. It then learns about this longer chain that continued to grow during the attack. Even though, in this longer chain, you never got paid, your node switches to it anyway. In turn, the coins you received disappear.

A double-spend attack is also possible without an eclipse attack, but it’s far less likely to succeed. First of all, you might notice the conflicting transaction in your own mempool and exercise additional caution before delivering any goods or services. And second, let’s say an attacker controls 10 percent of hash power; their attack would fail 90 percent of the time, because the blocks they produce with the conflicting transaction all become stale.^[When two blocks build on top of the same block, both are equally valid. As miners continue to generate more blocks, they’ll pick one of those blocks to build on top of (usually whichever they saw first). Eventually, the tie is broken and one chain becomes longer. The block that is now no longer part of the longest chain is called stale. The website <https://forkmonitor.info/> keeps track of these events and shows an alert as soon as two blocks appear at the same height. It also keeps track of how many blocks are built on each side, until one side falls behind and becomes stale.]

If you wait for two confirmations, the odds for your attacker drop to 1 percent. This is a good reminder of why it’s important for Bitcoin to be somewhat expensive, so that it’s not too easy to produce blocks on alternative branches that double-spend coins. Back in 2015, when the paper we mentioned above was written, these attacks were a lot cheaper: $5,000–$10,000 per block^[<https://bitcoinvisuals.com/chain-block-reward>]. So, the attacker is only going to attack you if the cost of making a fake block is lower than the amount of money they’re scamming you for. Note that, in practice, someone can’t just order a tailormade block for their attack, unless they _are_ a miner. Since any double-spend attack would harm Bitcoin’s reputation, which would reduce miner revenue, they aren’t particularly incentivized to facilitate such attacks.^[However, when the same equipment can be used to mine multiple coins, then causing some reputation damage on one coin, leaves plenty of other coins to mine. There are platforms where people can rent hash power, and those have sometimes been used to perform a double-spend attack. Especially when a coin enjoys very little hash power, such an attack can be very cheap. See e.g. <https://www.coindesk.com/markets/2020/08/07/ethereum-classic-attacker-successfully-double-spends-168m-in-second-attack-report/>]

Producing a block costs money, mainly for equipment and electricity. An honest miner recoups this by selling the coins created in the coinbase transaction. This is the first transaction in every block, and it has special rules. Unlike regular transactions, a coinbase transaction doesn’t have inputs. It creates money out of nowhere, but the amount is capped by the block subsidy (currently 6.25 BTC and halving every four years), plus all the fees paid by transactions included in the block. The output side of the transaction sends this to wherever the miner wants, but usually an address managed by a mining pool, which then redistributes it.

Normally a miner produces a block that builds on top of the most recently mined block that they’re aware of. The coinbase transaction has a second special rule, enforced by all nodes, which says that it can’t be spent until it has 101 confirmations, i.e. until there are 101 blocks built on top of it. This is called coinbase maturity.^[<https://bitcoin.stackexchange.com/a/1992/4948>]

The attacker doesn’t care about the coinbase reward, because they stand to make more from scamming you (hypothetically). Instead of building on top of the most recent block out there, they create a block on top of the last block _you_ know of. And they don’t broadcast this block to the world, so no other miners will mine on top of it. This means their coinbase transaction never reaches maturity, so the costs of producing the block can’t be recouped directly. It makes no economic sense for a miner to do this, unless they benefit from the attack in some other way... or unless they’re duped, as we explain below.

It turns out an attacker can also use miners against you without their cooperation by trying to split miners. They do this by not just eclipsing you, but also by eclipsing one or more miners. The eclipsed miners, presumably a minority, would see the same transaction as you, the actual target victim. Once they mine it, the attacker ensures that your node is the only one that gets to see this block. This miner is a victim too, because just like your transaction ends up disappearing once the block eventually goes stale, their coinbase transaction disappears too. For all this economic damage, the attacker might only rob you of $100. So we really want eclipse attacks to be very difficult.

Miners and pool operators are of course not naive. They might run multiple nodes in different countries and take precautions so that an attacker won’t know which node to eclipse. In addition, mining is still somewhat centralized, so there are specialized networks that connect them, making eclipse attacks even more difficult. But this shouldn’t be the only thing we’re relying on to prevent these attacks. Luckily, these attacks are becoming more difficult to do, largely because we’re introducing more solutions designed to make them more difficult.

### How an Eclipse Attack Works

So far, we’ve taken for granted that an eclipse attack can be done, and we’ve explained how it’s used to trick you into parting with your hard-earned coins. But how is it actually done?

Recall from above that, in order to eclipse your node, the attacker needs to take over all eight of your outbound connections and whatever number of inbound connections your node has. This is a cat and mouse game, and even before the above-mentioned paper was written, the Bitcoin Core software was hardened to prevent eclipse attacks. But let’s see how the paper proposed overcoming the existing defenses.

There are a couple of ingredients. First, as mentioned in chapter @sec:dns, when a node starts, it tries to find other peers, and once it’s been running for a while, it has a list of addresses it learned from other peers and it stores them in a file. Then, whenever a node loses one of its eight outbound connections, or when it restarts, it looks at this file with all the addresses it’s ever heard of, and it starts randomly connecting to them.

As an attacker, the idea is to pollute this file by giving your node a bunch of addresses that either don’t exist or that they (the attacker) control. This way, whatever address your node picks, every time it makes a connection, it either fails because there’s nothing there, or it connects to the attacker — and eventually all connections are to the attacker.

The attacker also needs to control all inbound connections to your node. Without going into too much detail in this chapter, one approach is to just make lots and lots of connection attempts until all your 117 inbound slots are full. Over time, perhaps weeks, as honest peers occasionally disconnect from you, the attacker quickly fills up the open inbound slots, so that no new honest peers get through.

As early as 2012, developers realized it was possible for an attacker to give your node huge numbers of IP addresses, all controlled by them. Let’s say your node has 1,000 real IP addresses of other nodes. Then the attacker feeds you 10,000 addresses that they control. As your node starts to pick IP addresses, the odds are 90 percent that it will connect to the attacker.

But as long as these addresses were closely related, e.g. because they were all in the same data center, there was something that could be done. A bucket system was introduced, which puts all IP addresses with the same two starting digits, e.g. `172.67.*.*` into the same bucket. The node would then pick from different buckets for each of its outbound connections.^[<https://github.com/bitcoin/bitcoin/pull/787>]

In the example above, all the attacker’s IP addresses end up in one bucket, and there are 256 such buckets, so the odds of connecting to even a single attacker node drop dramatically. Keep in mind that you only need _one_ honest peer to be protected against eclipse attacks.

Each bucket is also limited in size, so most of the 10,000 addresses in the example above would be thrown out of their bucket almost as soon as they entered it.

Finally, in the same pull request, nodes also started remembering which nodes they previously connected to. Whenever they needed a new connection, they would toss a coin, and either connect to one of those, or pick a new one from one of the 256 buckets.

### The Botnet

You might think this would do the trick, but here’s where the paper comes into play. It ran a simulation to see how difficult it was to actually overflow all these buckets, and it found that, within a matter of days, it can be successful.

How did it do this? By using a botnet^[<https://en.wikipedia.org/wiki/Botnet>] — not a real one of course, as that would probably be unethical for university researchers, not to mention potentially illegal. But they simulated one. A botnet is a group of random computers in the world that have been hacked and can be remote controlled. Because they’re not all in the same data center as our example above, their IP address have many different starting digits, so they end up in different buckets.

The paper estimated that a botnet with less than 5,000 computers can successfully pull off an eclipse attack. That might sound like a lot, but an unscrupulous person can rent that from various nefarious “companies” for probably less than $100.^[Business Model of a Botnet: <https://arxiv.org/pdf/1804.10848.pdf>]

In addition to attacking your node from many different directions, thereby defeating the bucket system, the hypothetical attacker in the paper also exploited other weaknesses.

First, they would flood your node with IP addresses that are known to be fake. This would flush all buckets with fake nodes. Remember that when your node needs a new peer, it’ll toss a coin to either connect to familiar node or try a new one. Well, there wouldn’t be any new ones to try.^[We’ll revisit the problem of fake nodes in chapter @sec:fake_nodes.]

For the other side of the coin flip — connecting to a familiar node — the attackers exploited another weakness. It turns out your node considers any node it ever connected to “familiar.” That includes botnet nodes that connected _to_ it, even if only briefly. There’s a separate 64-bucket system for these familiar nodes, and over time, those get filled up by botnet IPs.

### Don’t Crash

At this point, your node still has long-lived connections to the real world from before the attack began, so the attacker still needs to get rid of those. The trick is to either wait for your node to restart, or to try and crash it.

Whenever your node restarts^[Nodes that run on a server are typically automatically restarted after a crash or system reboot, using something like systemd: <https://en.wikipedia.org/wiki/Systemd>], it starts out with zero connections. Firstly, this creates an opportunity to very quickly fill up all 117 inbound slots. And secondly, it’s going to look at that file of peers it knows, and it’s going to try and connect to them. If an attacker succeeded at dominating these buckets, your node is going to connect to attacker IP addresses. That’s all that’s needed for the eclipse attack to be in play.

So although crashing a Bitcoin node isn’t a very useful attack on its own, it can help when performing an eclipse attack. This is one reason why it’s important for developers to ensure they don’t write code that can make a node crash.

### How to Solve It

It’s important to understand that attacks like these are a numbers game. An attacker needs to give your node a lot of spam addresses to fill up all the buckets and make sure it only connects to you.

So one obvious mitigation^[mitigate — “to cause to become less harsh or hostile”: <https://www.merriam-webster.com/dictionary/mitigate>\
A mitigation isn’t a complete solution. Although a bit redundant, the term “partial mitigation” is often used as well.] of an attack like this is to have more buckets. Unfortunately, this doesn’t help much with isolation, because the number of buckets only doubles the attack cost, and we already saw how cheap it is. Still, the number of buckets was quadrupled almost immediately after the paper was published.^[<https://github.com/bitcoin/bitcoin/pull/5941/commits/1d21ba2f5ecbf03086d0b65c4c4c80a39a94c2ee>]

Another countermeasure lies in the aforementioned coin toss. This toss was actually biased toward trying new nodes and toward those that we most recently learned about. This was changed to just a coin toss (in that same early pull request). Why not go further and only connect to nodes you’ve known the longest? There are always tradeoffs — in this case, your node might spend too much time going through a list of no-longer-reachable IP addresses.

But there was another proposed mitigation that also provided a bias toward familiar nodes, only in a safer way. It pertained to how buckets are handled when they’re about to overflow. When you hear of a new address and you want to put it in a bucket and remove something else, you first check the address that’s already in the bucket. That entails connecting to it to see if it still exists. If it does exist, you don’t replace it. This is called the feeler connection. This was more complicated and it took until mid-2016 to be implemented.^[By one of the authors in fact: <https://github.com/bitcoin/bitcoin/pull/8282>]

Still, other mitigations took much longer. When Bitcoin Core 0.21.0 was released in January 2021, it included a new method to prevent eclipse attacks that was suggested in this same 2015 paper.^[Anchor connections: <https://github.com/bitcoin/bitcoin/pull/17428>] What happens is that when you restart, you try to remember some of the last connections you had. Your node remembers the two connections that it only exchanges blocks with, and it tries to reconnect to those.

Why two? It’s not a good idea to always try to reconnect to the same nodes again when you restart, as, for all you know, the reason you crashed in the first place is because one of those nodes was evil. The same logic applies to the scenario where you’re _already_ being eclipsed.^[<https://github.com/bitcoin/bitcoin/issues/17326#issuecomment-550521262>]

### What Else Can Be Done?

In addition to the many suggestions from the paper, there are other things that can be done, and some have been implemented.

You may be wondering: Why wouldn’t you just have as many connections as possible from the get-go? But the problem is that it requires a lot of data exchange — especially for the transactions in a mempool — and that’s extremely data intensive, so you can’t just add more connections without also increasing bandwidth use.

Erlay (see Appendix @sec:more_eps) is a proposal for reducing the bandwidth needed for these mempool synchronizations. It reduces the main cost (bandwidth) _per connection_. A lower cost per connection allows nodes to have more connections. Having more connections makes any eclipse attack scheme more difficult.

Another way to have more connections without increasing bandwidth too much is to constrain some connections to blocks only, and to not sync the mempool with those peers. This was implemented in 2019.^[<https://github.com/bitcoin/bitcoin/pull/15759>]

Finally, there’s the Blockstream Satellite^[<https://blockstream.com/satellite/>], or any other satellite or even radio broadcast.^[<https://www.wired.com/story/cypherpunks-bitcoin-ham-radio/>] These allow anyone in the world to receive the latest blocks. This is mainly useful for people with very low bandwidth internet connections in remote areas. But it can also offer protection against an eclipse attack. This is because when your node receives the satellite signal, even if all inbound and outbound connections are taken over by an attacker, you’ll still learn about new blocks.

Note, however, that you shouldn’t blindly trust the satellite either, for _it_ might try to eclipse you. But remember that you only need a single honest peer, and you achieve this by having as diverse a set of connections as possible.

### Erebus Attack

![{l0pt}](qr/ep/18.png)

If you want to learn more about eclipse attacks, you might be interested in the Erebus attack^[<https://erebus-attack.comp.nus.edu.sg>]: an eclipse attack where an attacker essentially spoofs an entire part of the internet.

How this works is the internet is made up of Autonomous Systems (AS), which are basically clusters of IP addresses owned by the same entity, like an ISP.^[<https://www.cloudflare.com/learning/network-layer/what-is-an-autonomous-system/>]

As it turns out, however, some Autonomous Systems can effectively act as bottlenecks when trying to reach other Autonomous Systems. This allows an attacker controlling such a bottleneck to launch a successful eclipse attack — even against nodes that connect with multiple Autonomous Systems.

As explained above, Bitcoin Core nodes already counter eclipse attacks by ensuring they’re connected to a variety of IP addresses, based on the first two digits of the IP address. This can be further improved by separating buckets by Autonomous Systems instead.

But this doesn’t thwart the Erebus attack. For that, recent versions of Bitcoin Core include an optional feature — ASMAP.^[<https://blog.bitmex.com/call-to-action-testing-and-improving-asmap/>]

The episode explains how mapping the internet has allowed Bitcoin Core contributors to create a tool which ensures that Bitcoin nodes not only connect to various Autonomous Systems, but also that they avoid being trapped behind said bottlenecks.
