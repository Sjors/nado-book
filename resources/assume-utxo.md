\newpage
## Headers First, Assume Valid, and AssumeUTXO {#sec:assume}


![Ep. 14 {l0pt}](qr/ep/14.png)

One of the biggest bottlenecks — if not the biggest one — for scaling Bitcoin is initial block download. This is the time it takes for a Bitcoin node to synchronize with the Bitcoin network, as it needs to process all historic transactions and blocks to construct the latest unspent transaction output (UTXO) set, i.e. the current state of Bitcoin ownership.

This chapter will cover some of the ways sync time has been sped up over time. It was first improved through Headers First synchronization, which ensures that new Bitcoin nodes don’t waste time validating (potentially) weaker blockchains. In recent years, synchronizing time has been improved with Assume Valid, a default shortcut that lets nodes skip signature verification of older transactions, instead trusting that the Bitcoin Core development process — in combination with the resource-expensive nature of mining — offers a reliable version of transaction history.

It'll also discuss how the security assumptions underpinning Assume Valid could be extended to allow for the potential future upgrade, AssumeUTXO, to offer new Bitcoin Core users a speedy solution to get up to speed with the Bitcoin network by syncing the most recent blocks first and checking historical blocks in the background later.

In addition to the accompanying Bitcoin, Explained episode, you can also listen to a Chaincode podcast episode with AssumeUTXO author James O'Beirne covering the same topics as this chapter.^[<https://podcast.chaincode.com/2020/02/12/james-obeirne-4.html>].

### Downloading the Blockchain

When you turn on your Bitcoin Core node, the node needs to first connect to the network, and then it needs to be able to communicate with the network. To do that, it has to download the blockchain.

The most naive way of doing this is connecting to other peers and asking for everything. This results in downloading terrabytes of blocks, headers, and other random stuff, most likely resulting in a full hard disk that crashes.

The initial version of Bitcoin would ask nodes for a header. Once it got a header, it'd ask nodes for a block and it would get that block. Then it'd ask for the next header, and it'd get all the headers and blocks sequentially.^[It was slighly more complicated. When a node received a block that did not directly build on the tip of its chain, it would, as Satoshi put it in a source code comment, "shunt it off to [a] holding area". From there it could be appended to the chain tip later. These were called _orphan blocks_, a term often mixed up with _stale blocks_ (see chapter @sec:eclipse).] Your node would only check the blocks right in front of it, without seeing the big picture.

The problem with this is you don't know if you're following a dead end. Someone could feed your node a long branch of blocks that are not part of the of most proof-of-work chain. Nodes that just came online are especially vulnerable to that. This is because the proof-of-work difficulty has historically increased. It's expensive to create dead-end branches that start from recent blocks, because many miners are competing to produce blocks, pushing up the cost of creating a block. But if an attacker starts from very old block, from a time where there were fewer and less powerful miners, then the cost to produce these blocks are very low.

So an attacker can create a chain of very low difficulty blocks that branch off from some old block. If your node is new in town, when it sees two - or even thousands - possible branches, it doesn't which is the real one. If it picks the branch from the attacker first, it can end up wasting lots of time and computer resources to verify the blocks. Even though the proof-of-work difficulty of these blocks is low, it's not any easier for a node to verify the transactions. These dead end branches may be filled to their one megabyte maximum with specially crafted transactions that are extra slow to verify.

In addition to bogging down nodes with dead-end branches of low difficulty blocks, there's also the issue of eclipse attacks, which we'll cover in chapter @sec:eclipse.

### Checkpoints

One solution to this problem was the use of checkpoints. Developers would put the hash and height of several known valid blocks in the source code. Any new block that does not descend from one of these checkpoints would be ignored. This didn't completely undo dead-end branches, but it limited their maximum length.

The downside of checkpoints is that they potentially give a lot of power to developers. A malicious cabal of developers, or a benevolent dictator doing what's best for the community - whatever perspective you prefer, could decree that a certain block is valid. Even if an alternative branch with more proof of work exists, nodes would not consider this branch.

Perhaps a developer loses their Bitcoin in a hack, they could then introduce a checkpoint right before the hacked coins moved, and move their coins to safety in the revised history. Such an attack can't happen in secret, and if it ever really happened users might simply refuse to install new node software with the malicious checkpoint. But prevention would be better better.

The last checkpoint was added in late 2014. They were made most unnecessary by various means, including the introduction of `nMinimumChainWork` in 2016.^[<https://github.com/bitcoin/bitcoin/pull/9053>] This parameter states how much proof of work any chain of headers must demonstrate before even being considered. But for this to work, it requires nodes to be less myopic; they need to consider _where_ a given trail of blocks leads before spending lots of computer power chasing it. That's where Headers First comes in, so let's discuss that.

### Headers First

Given enough time - and if it doesn't crash - your node would compare all blockchain branches and eventually pick the one with the most difficulty. But because it needs to verify every branch first, it could a very long time to determine the correct one.

So rather than downloading and verifying entire blocks, the new approach is to download and verify just the headers, which are much smaller. In particular, headers are the only thing you need to determine the cumulative proof-of-work difficulty in any given branch.

Once your node knows which branch has the most work, proof-of-work, it downloads the blocks for it and starts verifying. This step can't be skipped, because it's still possible there's an invalid block in the chain with the most proof-of-work. Should your node run into such an invalid block, it discards the branch and repeats the process for whichever branch had the second most proof-of-work.

### Assume Valid

Assume Valid is a block hash that's encoded in the software. More specifically, it's a hash of a block from just before the last major release. Many Bitcoin Core developers publicly verify this hash, and anyone on GitHub can see the hash, and they can check for themselves whether that hash is real.

If you're a new user and you start Bitcoin Core, it'll sync all the headers and get all the blocks. And if that particular hash is in the chain, it won't verify any signatures that came before it. It will still verify everything else, e.g. that the proof-of-work is valid and that no coins are created out of thin air. Skipping signature verification mainly saves CPU usage, and this speeds up the whole process.

The Assume Valid mechanism is different from a checkpoint. A node does not require that the hash occurs in the blockchain. If your node sees another branch of the blockchain without this hash, and if it has more proof-of-work, it will consider that other branch first. The only difference is that it _will_ verify the signatures for that other branch, so it will take a bit longer.

What does it mean to not check signatures for blocks before the Assume Valid hash? It means that if somebody stole a coin, i.e. spent a UTXO with invalid signature, your node would not notice that. But if someone created a coin out of thin air, your node would still see that.

This is where the transparency of source code becomes an important factor. _If_ there ever was a theft of coins that the developers wanted to cover up, they would only be able to trick new nodes. First the developers would have to produce a block that steals^[This hypothetical attack can't create coins out of nowhere, so the victim of this theft might also make some noise. However many coins are thought to be permanently lost, e.g. because the owner lost their private keys. Those could make a good target. Since Satoshi disappeared, stealing coins that are allegedly his, could make sense, but those coins are being very closely monitored by many people. Any block attempting to steal them, even if invalid, would probably get some media attention.] coins by using an invalid signature. Such a block would be considered invalid by all existing nodes. Then they would take this invalid block, or a descendant, and use its hash as Assume Valid.

Anyone who already runs a node would be able to see this hash on Github, and check it against their own node. They would then either not see the block at all, or their node would point out that it's invalid (because of the invalid signature). Both would be reason to sound the alarm. Barring some immense social media censorship campaign, anyone about to download a new node might learn what's going on.

But the hypothetical malicious developers have another problem. No miners are building on top of their invalid block, because the miners already had their node software installed before the invalid hash was produced. Within hours of the developers publishing this hash, and long before they release any software for downloading, miners have already produced a longer chain that does not include this stealing block. So even if a user didn't notice the social media drama, their node would simply follow the longest chain. It would be a bit slower because it couldn't use the assume valid feature, but it would be fine.

What if developer colluded with miners in the theft? If a majority of miners decide to work with the developers and continue building on the invalid stealing block, then they would be able to trick new users. But they would not be able to trick existing users, which is generally the vast (economic) majority. Massive drama and probably massive economic losses for these miners would ensue, as no exchange would accept their deposit.

But what if developers, miners _and_ all existing users conspire to trick new users? Such a conspiracy seems impossible to coordinate secretly. But if you do worry the world is out to get you, rest assured that you can turn the Assume Valid feature off by starting your node with `-assumevalid=0`. Your node would then notice the invalid stealing block, you would yourself see its hash in the source code, and you can run to streets protesting the situation.

What is important to understand here, is that developers can already collude against you and sneak bad things into the code. And not just developers, as we explain in chapter @sec:guix. Developers could put in a backdoor that gives them access to your private keys. This actually happened with an altcoin called Lucky7coin.^[<https://github.com/alerj78/lucky7coin/issues/1>] These backdoors could be very carefully hidden in the code, in a way that only very skilled developers could detect. The Assume Valid hash on the other hand is very clearly visible, and requires very little skill to verify, as we explained above. This is why the Bitcoin Core developers believe that this feature is safe against abuse.

Although Assume Valid has been in Bitcoin Core since v0.14 (2017), there's a new idea that's been proposed, AssumeUTXO.

### AssumeUTXO

In early 2019, Chaincode Labs alumni James O'Beirne introduced a proposal^[<https://github.com/bitcoin/bitcoin/issues/15605>] for AssumeUTXO. The UTXO set is the collection of coins that exist right now. Everytime you send someone money, it creates an UTXO, and it destroys the UTXO that you sent from. It's like you have a bank account that is closed down when you use it.

The general idea is that the only way you can reconstruct the UTXO set and find out which coins exist right now is to replay everything from scratch. This means you have to take the first block and see which coins it creates and which coins it destroys. You continue this with every block. Then the second block, see which coins it destroys, which coins it creates, et cetera, et cetera, et cetera, You have to start at th beginning and do it until the end, and you can only do it sequentially — all of which takes a long time.

AssumeUTXO starts by doing Headers First syncing to determine which chain is the longest one, and once it has the headers, it can load a snapshot. This snapshot is of the UTXO set at a certain height — maybe just before the release or a bit older. And then when your node starts, it starts from that point. So it initially skips the whole history by starting from this snapshot. Then, it just checks the next block and the next block and the next block and the next block until it reaches the most recent block. So then you know exactly your balances and you can start using it.

But in the meantime, in the background, it starts at the genesis block, goes all the way to the snapshot, and verifies that the snapshot is correct. And if the snapshot isn't correct, it starts screaming.

With Assume Valid, it still did all of the UTXO set constructing and replayed all of the transactions; it just didn't check for the signatures. Now, with AssumeUTXO, it skips the transaction replaying and the signature checking. Instead, it takes the UTXO set, and from there on out, it constructs the blockchain based on the newer blocks that have been found since then.

### Tradeoffs

There are of course some tradeoffs. For exampe, do you really want to check all the history before the snapshot? Because there are a lot of things you can know without checking history. So the question is, could you eventually in the future opt out of doing that? And what are you sacrificing when you do that?

You're also trusting that miners are being honest. The nice thing is if you start at the snapshot and you create a new address and you receive coins on it and they get into a block, then you kind of know that block is valid. At least, unless there's another chain out there, because otherwise, a lot of miners are wasting a lot of proof-of-work on a chain that's not valid.

There could of course be some conspiracy where the core developers and the miners collude and create a fake snapshot that has a couple of extra coins in it, and all the miners agree they'll approve blocks with those coins in it. In this way, they could sneak in a hard fork.

But that reenforces the importance of needing people to check whether the snapshot is real. You can either do it yourself with this back validation, or you can rely on the fact that other people are looking at the source code. And just like with headers, it would still need to match, so somebody would have to spend a whole lot of proof-of-work to sneak in a fake snapshot.

Currently, Bitcoin Core can make snapshot of a UTXO set, but it doesn't actually do anything with it. In an upcoming release, it'll be able to load a UTXO set that you downloaded. And then maybe in the future version after that, it'll complete the package and you might have something called AssumeUTXO in Bitcoin Core.

One way such a future could look is the nodes. Every node that wants to would serve this snapshot, though probably not automatically because it's a couple gigabytes in size. Then, there's a peer-to-peer protocol to download the snapshot automatically. And so when you start a new node, it would automatically find the snapshot, use the snapshot, sync to the tip, show you some orange blinking thing, and then sync from the start to the snapshot and then show you a nice green blinking thing.

### Potential Controvery

A feature like AssumeUTXO is experimental, which means people would likely need to opt in to it. It's too early to determine if it's controversial. However, something that's been an ongoing discussion for ages is the idea of committing to the UTXO set inside the blockchain itself, i.e. a UTXO commitment.

That certainly is controversial, depending on how it'll be done. What you want to prevent is sort of the scenarios where the blockchain is too big to check for everybody and then a bunch of miners and developers decide to give themselves some coins and they get away with it because not enough people verify the entire history. So that's a risky part of it.

With embedding a hash into the block, every block would contain, I guess in the coinbase transaction, a hash of the UTXO set or some other derived thing of the UTXO set.

The benefit of this is that, instead of relying on what's in the source code, this hash, you would rely on what's in the blockchain, this hash. You'd make it part of consensus and a block isn't valid if the hash isn't valid. So you would reject blocks that have an invalid hash rather than reject code that looks fishy. I think it's a different thing, but there are quite... There are very different ways that you can put stuff in a block. It could be straightforward as a hash, but it could also be something a little bit more indirect, something that if you know...

If look at the block and you see this number, you don't know the UTXO set and you can't download the UTXO set using that information. But instead you have to process the whole blockchain from the Genesis block to make sure that that thing in the blockchain is valid. But then the question is what is use going to be? There's some tricky trade ups there. You should ask Peter Todd at some point, because he's thought about that stuff a bit more.
