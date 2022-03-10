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

In theory, this isn't necessarily a problem, because your node would compare blockchains and pick the one with the most difficulty. But you'd need to verify the chains first, and it wouldn't necessarily be easy to determine the correct one.

The idea is to instead download the headers, which are much smaller, which makes it easier to determine difficulty.

Instead of downloading and verifying all the chains and then picking the one with the most proof-of-work, you'd first check out which chain has the most proof-of-work and validate that one. In other words, you're inverting the process.

Right. Because so far you just have SPV security. So you just know which one has the most proof of work, but it could be invalid. So in that case, you start downloading one block at a time. Or in fact, because you already have all the headers, you can download lots of blocks at the same time, from different nodes in parallel. But you have to verify them in sequence. And then if you run into an invalid block, okay, then you say this header chain might have the most proof of work, but it's not valid. So I'm going to go to this second most proof of work header chain and ask for the blocks. It's mostly going to be the same maybe except the last few.

With SPV security, it'd be possible to bootstrap your nodes that way, and then after you're done validating all of the blocks, you'd get full security. However, you would nee the blocks to know your transaction history.

The proposal for this was by Jonas Schnelli, I think four or five years ago, an attempt to at least start up in SPV mode. And then I guess if you create a new address from scratch, then you know it's history. So then when the next block comes in and you see a transaction to that address, then you know that you have a balance. You can't rescan any old addresses, but you can see anything new that comes in. Because you're going to download all the real blocks after yeah. Starting at the present basically.

You're at least sure that more miners think it's a valid transaction or at least they're spending hash power telling you it's a valid transaction. So even though you don't have full security, it's a little bit better than nothing. And it's definitely enough to receive it. And then just to assume that it's fake, but you can just sit on it for a while. But in the meantime you would be validating all the older blocks.

Bitcoin Core currently doesn't do this right now, rather it's a trick to avoid having to potentially download fake chains and instead only download the chain that has the most proof of work.

### Assume Valid

Assume Valid is a block hash that's encoded in the software. More specifically, it's a hash of a block from before the release. Many Bitcoin Core developers and anyone on GitHub can see what that hash is, and they can check for themselves whether that hash is real.

If you're a new user and you start Bitcoin Core, it'll sync all the headers and get all the blocks. And if that particular hash is in the chain, it won't verify the signatures. So it's not a checkpoint. The hash doesn't have to be out there, but if it is, you won't verify any of the signatures up to that point. This in turn speeds up syncing.

You're still downloading the whole blockchain, but it's a shortcut for syncing. Instead of validating signatures, you're checking the proof-of-work. In other words, you're checking: that miners actually produce the blocks by expending energy; that it's the longest chain; and all the transactions to construct the UTXO set, which is the current state of balances.

What you're not checking are the signatures. Neither are you checking that the valid owner of each coin in any part of history was actually the correct owner. Instead, you're essetnially trusting the miners and the developers. More specifically, you're trusting that if the developers were to put in something that's not real, somebody would notice.

That's because you can see the source code and it's just one line, and if it has a hash in it that doesn't exist, you should be worried. Even then, it'd be strange, because it would have to be a chain with more proof-of-work, otherwise you'd never see it. So some evil developer would have to produce a chain with more proof of work than the real thing in order to trick some future user, but risk everybody noticing it.

Ultimately, while this is about trusting, what's most important it to verify things.

You're still downloading a piece of software from the internet, which could have a line of code in there that says, “Send all the Bitcoins to me.” So you have to check for sneaky things by the developers in general.

But this particular sneaky thing would be extremely easy to see, because it's one place in the code base that has a hash in it and everybody can reproduce it. And if you don't like this — and you don't have to like this — you start Bitcoin from scratch with dash assume valid is zero, and then it will validate all the signatures.

Although Assume Valid has been in Bitcoin Core since X, there's a new idea that's been proposed, AssumeUTXO.

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
