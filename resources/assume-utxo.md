\newpage
## Headers First, Assume Valid, and AssumeUTXO {#sec:assume}


![Ep. 14 {l0pt}](qr/ep/14.png)

One of the biggest bottlenecks — if not the biggest one — for scaling Bitcoin is initial block download. This is the time it takes for a Bitcoin node to synchronize with the Bitcoin network, as it needs to process all historic transactions and blocks to construct the latest unspent transaction output (UTXO) set, i.e. the current state of Bitcoin ownership.

This chapter will cover some of the ways sync time has been sped up over time. It was first improved through Headers First synchronization, which ensures that new Bitcoin nodes don’t waste time validating (potentially) weaker blockchains. In recent years, synchronizing time has been improved with Assume Valid, a default shortcut that lets nodes skip signature verification of older transactions, instead trusting that the Bitcoin Core development process — in combination with the resource-expensive nature of mining — offers a reliable version of transaction history.

It’ll also discuss how the security assumptions underpinning Assume Valid could be extended to allow for the potential future upgrade, AssumeUTXO, to offer new Bitcoin Core users a speedy solution to get up to speed with the Bitcoin network by syncing the most recent blocks first and checking historical blocks in the background later.

In addition to the accompanying _Bitcoin, Explained_ episode, you can also listen to a _Chaincode Podcast_ episode with AssumeUTXO author James O’Beirne, which covers the same topics as this chapter.^[<https://podcast.chaincode.com/2020/02/12/james-obeirne-4.html>].

### Downloading the Blockchain

When you turn on your Bitcoin Core node, the node needs to first connect to the network, and then it needs to be able to communicate with the network. To do that, it has to download the blockchain.

The most naive way of doing this is connecting to other peers and asking for everything. This results in downloading terabytes of blocks, headers, and other random stuff, most likely resulting in a full hard disk that crashes.

The initial version of Bitcoin would ask nodes for a header. Once it got a header, it’d ask nodes for a block, and it’d get that block. Then, it’d ask for the next header, and it’d get all the headers and blocks sequentially.^[In reality, it was slightly more complicated than this. When a node received a block that didn’t directly build on the tip of its chain, it would, as Satoshi put it in a source code comment, “shunt it off to [a] holding area.” From there, it could be appended to the chain tip later. These were called _orphan blocks_, a term often mixed up with _stale blocks_ (see chapter @sec:eclipse).] Your node would only check the blocks right in front of it, without seeing the big picture.

The problem with this is you don’t know if you’re following a dead end. Someone could feed your node a long branch of blocks that aren’t part of the proof-of-work chain. Nodes that just came online are especially vulnerable to that. This is because the proof-of-work difficulty has historically increased. It’s expensive to create dead-end branches that start from recent blocks, because many miners are competing to produce blocks, pushing up the cost of creating a block. But if an attacker starts from very old block, from a time where there were fewer and less powerful miners, then the cost to produce these blocks is very low.

So an attacker can create a chain of very low difficulty blocks that branch off from some old block. If your node is new in town, when it sees two — or even thousands of — possible branches, it doesn’t which is the real one. If it picks the branch from the attacker first, it can end up wasting lots of time and computer resources to verify the blocks. Even though the proof-of-work difficulty of these blocks is low, it’s not any easier for a node to verify the transactions. These dead-end branches may be filled to their one megabyte maximum with specially crafted transactions that are extra slow to verify.

In addition to bogging down nodes with dead-end branches of low difficulty blocks, there’s also the issue of eclipse attacks, which we’ll cover in chapter @sec:eclipse.

### Checkpoints

One solution to this problem was the use of checkpoints: Developers would put the hash and height of several known valid blocks in the source code, and any new block that didn’t descend from one of these checkpoints would be ignored. This didn’t completely undo dead-end branches, but it limited their maximum length.

The downside of checkpoints is that they potentially give a lot of power to developers. A malicious cabal of developers, or a benevolent dictator doing what’s best for the community — whichever perspective you prefer — could decree that a certain block is valid. Even if an alternative branch with more proof-of-work exists, nodes wouldn’t consider this branch.

Perhaps a developer loses their Bitcoin in a hack; they could then introduce a checkpoint right before the hacked coins moved and move their coins to safety in the revised history. Such an attack can’t happen in secret, and if it ever really happened, users might simply refuse to install new node software with the malicious checkpoint. But prevention would be better.

The last checkpoint was added in late 2014. They were made mostly unnecessary by various means, including the introduction of `nMinimumChainWork` in 2016.^[<https://github.com/bitcoin/bitcoin/pull/9053>] This parameter states how much proof-of-work any chain of headers must demonstrate before even being considered. But for this to work, it requires nodes to be less myopic; they need to consider _where_ a given trail of blocks leads before spending lots of computer power chasing it. And that’s where Headers First comes in.

### Headers First

Given enough time — and if it doesn’t crash — your node would compare all blockchain branches and eventually pick the one with the most difficulty. But because it needs to verify every branch first, it could take a very long time to determine the correct one.

So rather than downloading and verifying entire blocks, the new approach is to download and verify just the headers, which are much smaller. In particular, headers are the only thing you need to determine the cumulative proof-of-work difficulty in any given branch.

Once your node knows which branch has the most proof-of-work, it downloads the blocks for it and starts verifying. This step can’t be skipped, because it’s still possible there’s an invalid block in the chain with the most proof-of-work. Should your node run into such an invalid block, it discards the branch and repeats the process for whichever branch had the second most proof-of-work.

### Assume Valid

Assume Valid is a block hash that’s encoded in the software. More specifically, it’s a hash of a block from just before the last major release. Many Bitcoin Core developers publicly verify this hash, and anyone on GitHub can see the hash, and they can check for themselves whether or not the hash is real.

If you’re a new user and you start Bitcoin Core, it’ll sync all the headers and get all the blocks. And if that particular hash is in the chain, it won’t verify any signatures that came before it. It’ll still verify everything else, e.g. that the proof-of-work is valid and that no coins are created out of thin air. Skipping signature verification mainly saves CPU usage, and this speeds up the whole process.

The Assume Valid mechanism is different from a checkpoint, in that a node doesn’t require that the hash occurs in the blockchain. If your node sees another branch of the blockchain without this hash, and if it has more proof-of-work, it’ll consider that other branch first. The only difference is that it _will_ verify the signatures for that other branch, so it’ll take a bit longer.

What does it mean to not check signatures for blocks before the Assume Valid hash? It means that if somebody stole a coin, i.e. spent a UTXO with an invalid signature, your node wouldn’t notice. But if someone created a coin out of thin air, your node would still see that.

This is where the transparency of source code becomes an important factor. _If_ there ever was a theft of coins that the developers wanted to cover up, they’d only be able to trick new nodes. First, the developers would have to produce a block that steals^[This hypothetical attack can’t create coins out of nowhere, so the victim of this theft might also make some noise. However, many coins are thought to be permanently lost, e.g. because the owner lost their private keys. Those could make a good target. Since Satoshi disappeared, stealing coins that are allegedly his could make sense, but those coins are being very closely monitored by many people. Any block attempting to steal them, even if invalid, would probably get some media attention.] coins by using an invalid signature. Such a block would be considered invalid by all existing nodes. Then, they’d take this invalid block, or a descendant, and use its hash as Assume Valid.

Anyone who already runs a node would be able to see this hash on GitHub and check it against their own node. They’d then either not see the block at all, or their node would point out that it’s invalid (because of the invalid signature). Both would be reason to sound the alarm. Barring some immense social media censorship campaign, anyone about to download a new node might learn what’s going on.

But the hypothetical malicious developers have another problem. No miners are building on top of their invalid block, because the miners already had their node software installed before the invalid hash was produced. Within hours of the developers publishing this hash, and long before they release any software for downloading, miners have already produced a longer chain that doesn’t include this stealing block. So even if a user didn’t notice the social media drama, their node would simply follow the longest chain. It’d be a bit slower because it couldn’t use the Assume Valid feature, but it’d be fine.

What if developers colluded with miners in the theft? If a majority of miners decide to work with the developers and continue building on the invalid stealing block, then they’d be able to trick new users. But they wouldn’t be able to trick existing users, which is generally the vast (economic) majority. Massive drama and probably massive economic losses for these miners would ensue, as no exchange would accept their deposit.

But what if developers, miners, _and_ all existing users conspire to trick new users? Such a conspiracy seems impossible to coordinate secretly. But if you do worry the world is out to get you, rest assured that you can turn the Assume Valid feature off by starting your node with `-assumevalid=0`. Your node would then notice the invalid stealing block, you would yourself see its hash in the source code, and you could run to streets protesting the situation.

What’s important to understand here is that developers can already collude against you and sneak bad things into the code — and not just developers, as we explain in chapter @sec:guix. Developers could also put in a backdoor that gives them access to your private keys. This actually happened with an altcoin called Lucky7coin.^[<https://github.com/alerj78/lucky7coin/issues/1>] These backdoors could be very carefully hidden in the code, in a way that only very skilled developers could detect. The Assume Valid hash, on the other hand, is very clearly visible, and it requires very little skill to verify, as explained above. This is why the Bitcoin Core developers believe that this feature is safe against abuse.

Although Assume Valid has been in Bitcoin Core since v0.14 (2017), there’s a new idea that’s been proposed: AssumeUTXO.

### AssumeUTXO

In early 2019, Chaincode Labs alumni James O’Beirne introduced a proposal^[<https://github.com/bitcoin/bitcoin/issues/15605>] for AssumeUTXO. The UTXO set is the collection of coins that exists right now. Every time you send someone money, it creates an UTXO, and it destroys the UTXO that you sent from. It’s like you have a bank account that’s closed down when you use it, and you get a fresh bank account for the change.

Today, the only way to reconstruct the UTXO set and find out which coins exist right now is to replay all Bitcoin transactions starting from the 2009 genesis block.^[Due to a bug or great benevolence by Satoshi, nodes actually don’t process the genesis block in this manner, so the very first 50 BTC ever created can’t be spent. <https://en.bitcoin.it/wiki/Genesis_block>] You take the first block and see which coins it creates and which coins it destroys. You continue this with every block. Then you take the second block, see which coins it destroys, which coins it creates, etc. etc. etc. You have to start at the beginning and do it until the end, and you can only do it sequentially — all of which takes a long time.

AssumeUTXO instead uses a recent snapshot of the UTXO set and works from there, skipping hundreds of thousands of historical blocks. It starts out just like nodes today by performing a Headers First sync to determine which chain is the longest one. But once it has the headers, it can load the snapshot. This snapshot is of the UTXO set at a certain height — maybe just before the release. From there, it proceeds as normal, checking each new block to see which coins were destroyed and which were created, until finally it reaches the most recent block (tip). So then you know your balances exactly and you can start using it.

But in the meantime, in the background, it starts at the genesis block, goes all the way to the snapshot, and verifies that the snapshot is correct. And if the snapshot isn’t correct, it starts screaming (or it unceremoniously crashes with an error message).

With Assume Valid, it still did all of the UTXO set constructing and replayed all of the transactions; it just didn’t check for the signatures. Now, with AssumeUTXO, it skips the transaction replaying altogether, or more accurately: It defers it. Instead, it takes the UTXO set, and from there on out, it constructs the blockchain based on the newer blocks that have been found since then.

### Does the Past Matter?

One question to ask is whether it’s really useful to check historical blocks after loading the snapshot. If you’re restoring an old wallet from a backup, you’ll need to scan historical blocks for your transaction history, but let’s leave that aside.

Assuming you’re a new user, the first thing you want to do is receive coins. You want to be sure these coins will later be accepted by others. And you may want to make sure there’s really a 21 million BTC limit. Do you need to check historical blocks to know this?

To start with the second question — checking the 21 million limit — the answer is _no_. You can calculate the total amount of Bitcoin in existence right now by adding up all the values in the UTXO set. And then you can look at the source to understand how many coins can be created in the future. There’s no need to see past blocks for that.

However, to know if others will accept the coins you received, you need to know that the person who sent you the coins didn’t create them out of thin air or steal them. This goes back to the question of what a malicious developer can get away with. The answer is: slightly more.

Let’s say developers create some coins out of thin air and add them to the UXO set, or that they reassign existing coins to themselves. Anyone verifying the snapshot would find out, so again, code transparency mitigates some of this.

But where, in the Assume Valid example above, the developers would have to create an invalid block, that’s not necessary here. The new or stolen coins would exist in your UTXO set without ever having been in a block. So miners and existing node operators won’t initially detect this, because there’s no invalid block floating around.

But there’s a catch: When you, as the new user, receive a coin that was created out of nowhere, it never gets confirmed in a block. The new transaction won’t be mined, because miners have the correct UTXO set and recognize the transaction as invalid.

What if miners are in on it? Then the transaction would confirm and you’d have been fooled. However, every other node would reject the new block, and the attack would now be visible to everyone involved.

Developers could be very patient though. Instead of immediately trying to spend the from-thin-air coins, they could wait. They could wait many years. Perhaps by that time, many miners have reinstalled their node, along with the manipulated snapshot, and synced it. Perhaps many exchanges did so as well. And many regular users. So when they finally spend the from-thin-air coins, perhaps the block is only considered invalid by a small group of old school hardcore bitcoiners.

So as before, this attack requires the whole world to conspire against you, but as far as global conspiracies go, this one is slightly easier to pull off, and slightly more difficult to detect.

One way to mitigate this attack is for every block to include a hash of the current UTXO snapshot. This would be a soft fork (see chapter @sec:taproot_activation). That way, every node verifies the snapshot and it wouldn’t have to be included in the software.

Currently, it’s very time consuming to produce a hash for the UTXO set; it would takes minutes rather than seconds to verify a block. A different type of hash has been proposed to address that.^[MuHash: <https://lists.linuxfoundation.org/pipermail/bitcoin-dev/2017-May/014337.html>]

There will probably be a lot more discussion before such a soft fork is even proposed. At the time of writing, AssumeUTXO is still being developed. Nodes can already produce snapshots of their UTXO set, but the code to actually load and use a snapshot is still undergoing review.^[<https://github.com/bitcoin/bitcoin/pull/15606>]
