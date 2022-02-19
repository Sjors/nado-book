\newpage
## Eclipse Attacks {#sec:eclipse}

![Ep. 17 {l0pt}](qr/ep/17.png)

An eclipse attack is a type of attack that isolates a Bitcoin node by occupying all of its connection slots to block the node from receiving any transactions and blocks, other than those sent to it by the attacker. This prevents the node from seeing what’s going on in the Bitcoin network, and potentially even tricks the node into accepting an alternative branch of the Bitcoin blockchain. Although nodes will never accept an invalid transaction or block, an eclipse attack can still cause harm, as we'll see.  

This chapter discusses how this type of attack could be used to dupe users and miners. It also talks about solutions to counter this type of attack, some of which were outlined in the 2015 paper “Eclipse Attacks on Bitcoin’s Peer-to-Peer Network,” which was written by Ethan Heilman, Alison Kendler, Aviv Zohar, and Sharon Goldberg, from Boston University and Hebrew University/MSR Israel.^[<https://cs-people.bu.edu/heilman/eclipse/>] Many of the solutions proposed by this paper have gradually been implemented in Bitcoin Core software in the past few years. This chapter also discusses a potential solution that wasn't in the paper.

### Why an Eclipse Attack Hurts

Under normal circumstances, your node connects to the outside world via up to eight so called "outbound peers". The outside world can also connect to you, and for that your node allows a maximum of 117 inbound peers. In the case of an eclipse attack, your node only sees and connects to your attacker. So you might think you're talking to the whole world, but you're actually only talking to one person. In other words, that person is eclipsing your view of the world.

The reason you connect to all these nodes is because you want to ask them for new transactions and blocks. Data flows in both directions, no matter if the peer is inbound or outbound. Your peers may spontaneously send you blocks and transactions, and your node will in turn forward them to others. As long as you're connected to at least one honest peer, you won't miss out on the latest blocks and transactions.

An eclipse attack occurs if all of the peers you're connected to are controlled by a single entity, your attacker. Now they decide which blocks and transactions your node gets to see, and you may very well be missing out on the latest and greatest out there.

But why does this matter? They can't send you an invalid blocks with a fake signature that makes them a billionaire. Your node still checks all the rules and would never accept that. But what they can do, is perform a double-spend attack on you.

So let's say you're expecting money from somebody, and you see their transaction appear in your mempool — which is where valid transactions wait to be confirmed — but it's not yet in a block.

You might consider this payment complete, and deliver a product or service for it. But it turns out that behind your back they sent an alternative transaction to the rest of the network that _doesn't_ pay you. This alternative, double-spend^[The thing that gets double spent is one or more of the coins that form the input for the transaction. A Bitcoin transaction takes coins as its input and creates new coins as its output. An input can only ever be spent once. When a node sees two transactions that spend the same input, they have to pick one and ignore the other. The same goes for miners.], transaction gets included in a block, but your attacker hides this block from you. So from your point of view this transaction is still in the mempool and you remain oblivious to the fact that you will never truly receive these coins.

This is the most straightforward example of an eclipse attack. It's yet another reason for what most people know these days: accepting zero confirmation transactions is a bad idea. Preventing double-spends is the raison d'être for proof-of-work, so a transaction must be included in a block in order to enjoy the protection of the work in that block, and every block on top of it.

In the days before Bitcoin the double-spend problem was everywhere, and only considered solvable by introducing a trusted third party. For example, when receiving any amount of Chaumian e-cash, the software on your computer would immediately inform your bank that you received the tokens. The bank's computer would then verify that these tokens were never seen before. Without that, the same e-cash could have been spent to many different recipients.^[Brief explanation of Chaumian e-cash <https://bitcoin.stackexchange.com/a/10666/4948>. For a longer explanation and a proposed Bitcoin backed variation on it, listen to episode 52 of Bitcoin, Explained: <https://nadobtc.libsyn.com/federated-ecash-episode-52>]

But even if you do wait for a confirmation, you're not out of the woods. An eclipse attack is still possible, as we'll see, but at it's a lot more expensive. This is because the attacker has to produce a valid block, and part of what determines the validity of a block is that it contains sufficient proof-of-work (most of time the same as the previous block).

So let's say you sold something expensive. Like in the previous example, the attacker first sends you their transaction, and they send a conflicting transaction to the rest of world, while making sure you never see it. That conflicting transaction gets confirmed, but your attacker doesn't forward this new block to you. Instead, they mine their own block with the original transaction in it. Your node tells you the transaction is confirmed, and you provide the goods or service.

Meanwhile the outside world of normal miners keeps producing blocks, and the attacker continuous to hide those normal blocks from you. The attacker won't bother to produce any new blocks, because they have what they need from you. At some point they stop the attack, or you figure out what happened and intervene. Either way your node connects to legitimate peers again. It then learns about this longer chain, which continued to grow during the attack. Even though in this longer chain you never got paid, your node switches to it anyway. The coins you received disappear.

A double-spend attack is also possible without an eclipse attack, but it's far less likely to succeed. First of all you might notice the conflicting transaction in your own mempool and exercise additional caution before delivering any good or service. And then, let's say an attacker controls 10 percent of hash power, their attack would fail 90% of the time, because the blocks they produce with the conflicting transaction all become stale.^[When two blocks build on top of the same block, both are equally valid. As miners continue to generate more blocks, they'll pick one of those blocks to build on top of (usually whichever they saw first). Eventually, the tie is broken and one chain becomes longer. The block that is now no longer part of the longest chain is called stale. The website <https://forkmonitor.info/> keeps track of these events and shows an alert as soon as two blocks appear at the same height. It also keeps track of how many blocks are built on each side, until one side fall behind and becomes stale.]

If you wait for two confirmations the odds for your attacker drop to 1 percent. This is a good reminder of why it's important for Bitcoin to be somewhat expensive, so that it's not too easy to produce blocks on alternative branches that double-spend coins. Back in 2015 when the paper we mentioned above was written, these attacks were a lot cheaper, $5,000 - $10,000 per block^[<https://bitcoinvisuals.com/chain-block-reward>]. So, the attacker is only going to attack you if the cost of making a fake block is lower than the amount of money they're scamming you for. Note that in practice someone can't just order a tailor made block for their attack, unless they _are_ a miner. Since any double-spend attack would harm Bitcoin's reputation, which would reduce miner revenue, they are not particularly incentivized to facilitate such attacks.

Producing a block costs money, mainly for equipment and electricity. An honest miner recoups this by selling the coins created in the coinbase transaction. This is the first transaction in every block and it has special rules. Unlike regular transactions a coinbase transaction does not have inputs. It creates money out of nowhere, but the amount is capped by the block subsidy (currently 6.25 BTC and halving every 4 years) plus all the fees paid by transactions included in the block. The output side of the transaction sends this to wherever the miner wants, but usually an address managed by a mining pool, which then redistributes it.

Normally a miner produces a block that builds on top of the most recently mined block that they're aware of. The coinbase transaction has a second special rule, enforced by all nodes, which says that it can't be spent until it has 101 confirmations, i.e. until there are 101 blocks built on top of it. This is called coinbase maturity.^[<https://bitcoin.stackexchange.com/a/1992/4948>]

The attacker doesn't care about the coinbase reward, because they stand to make more from scamming you (hypothetically). Instead of building on top of the most recent block out there, they create a block on top of the last block _you_ know of. And they don't broadcast this block to the world, so no other miners will mine on top of it. This means their coinbase transaction never reaches maturity, so the costs of producing the block can't be recouped directly. It makes no economic sense for a miner to do this, unless they benefit from the attack in some other way... or unless they're duped, as we explain below.

It turns out an attacker can also use miners against you without their cooperation, by trying to split miners. They do this by not just eclipsing you, but also eclipsing one or more miners. The eclipsed miners, presumably a minority, would see the same transaction as you, the actual target victim. Once they mine it, the attacker ensures that your node is the only one that gets to see this block. This miner is a victim too, because just like your transaction ends up disappearing once the block eventually goes stale, their coinbase transaction disappears too. For all this economic damage, the attacker might only rob you of $100. So we really want eclipse attacks to be very difficult.

Miners and pool operators are of course are not naive. They might run multiple nodes in different countries and take precautions so that an attacker won't know which node to eclipse. In addition mining is still somewhat centralized, so there are specialized networks that connect them, making eclipse attacks even more difficult. But this shouldn't be the only thing we're relying on to these attacks. Luckily, it's becoming more difficult to do, largely because we're introducing more solutions designed to make this attacks more difficult.

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
