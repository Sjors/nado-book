\newpage
## Utreexo {#sec:utreexo}


![Ep. 15 {l0pt}](qr/ep/15.png)

Whenever a new Bitcoin transaction is made, Bitcoin nodes use a UTXO set to determine that the coins being spent really exist (see chapter @sec:assume). This UTXO set is currently several gigabytes in size and continues to grow over time, and there’s no upper limit to how big it can potentially get.

Because Bitcoin nodes perform best if the UTXO set is kept in RAM, and because RAM is usually a relatively scarce resource for most computers, it would benefit a node’s performance if the UTXO set could be stored in a more compact format. This is the promise of Utreexo.^[Pronounced U Tree X O. See also: <https://bitcoinmagazine.com/articles/bitcoins-growing-utxo-problem-and-how-utreexo-can-help-solve-it>]

Utreexo would take all the UTXOs in existence and include them in a Merkle tree, which is a data structure consisting only of hashes. This chapter explains how the compact Utreexo structure could suffice in proving that a particular UTXO is included when a new transaction is made. It also covers the potential benefits that could surface if this solution becomes available, along with some of the potential tradeoffs.


### The Challenge

When syncing a new Bitcoin node, one of the challenges is the amount of random-access memory (RAM) you have. In general, you don’t need a lot of RAM on your computer, but if you want to sync fast, you do.

The reason this is necessary is due to the UTXO set, which is a list of all coins in existence, including the ones you own. Every time a new block comes in, for every transaction in it, you check that it spends coins that actually exist. You also remember which new coins the transaction created, so that you’re aware of this when it gets spent in a later block. This information is held in a database, and if it’s located on your hard disk, this checking is a slow process. However, if the database is located in your RAM, it’s extremely fast.

The time it take varies, but say you had a newer MacBook Pro, and you stored this information in your RAM; it’d take maybe seven hours and 15GB of RAM to sync the entire chain.^[In late 2020, Bitcoin Core developer and maintainer Jonas Schnelli synced the chain on an Apple M1 in five hours and eleven minutes. It would’ve been faster if he allocated more than 5GB of RAM. In the meantime, the chain has grown, hence the more conservative estimate.<https://twitter.com/_jonasschnelli_/status/1333303029370675201>] However, let’s say you had a Raspberry Pi with only 2GB of RAM. You’d sync the chain and keep as much as possible in RAM, but at some point, it’d overflow. Then it’d write everything to disk, clear everything, and start caching again.^[Worse still, if the blockchain doesn’t fit on your hard drive, then your node has to delete old blocks to make room for new ones. A side effect of this is that the coin database in RAM must be written to disk, further slowing down the sync process.] This could take several weeks.

The key point here is that if you can keep more of the UTXO set in RAM, you’ll sync faster. It’d be nice if the size of the UTXO set could be decreased, but that’s not necessarily possible. Of course, if you’re spending more coins than you’re creating, then the number of UTXOs and the RAM usage both go down. However, there’s a lot of junk in the UTXO set, because in the past, people created transactions to multi-sig addresses that were fake just to e.g. put pictures of Obama in the blockchain. And those are all sitting in your RAM because your node has no idea they’re nonsense.

However, if we expect everybody in the world to eventually use Bitcoin and to have at least one or two UTXOs each, that would take terabytes of RAM, and Moore’s Law^[<https://en.wikipedia.org/wiki/Moore%27s_law>] isn’t going to catch up to this anytime soon. But even without the entire world using Bitcoin, it could get to the point where fewer and fewer people have enough RAM to sync it quickly, which is a problem. If fewer people run their own node, the system becomes less decentralized.

### Utreexo

One way to address this issue is with Tadge Dryja’s proposal, the Utreexo.^[<https://dci.mit.edu/utreexo>, <https://www.youtube.com/watch?v=6Y6n88DmkjU>] Dryja is a research scientist at the MIT Digital Currency Initiative.

Currently with Bitcoin, you can prune the archival block storage to save disk space. After your node downloads a block, processes it, and updates the UTXO set, it no longer has any use for the block. Your node knows exactly which coins exist, in the UTXO set, which is all it needs to validate future transactions.

When pruning is enabled, your node holds on to the block for a few more days and then deletes it. This way, you need less than a gigabyte of storage, even though the blockchain itself is hundreds of gigabytes. The downside is that you don’t have the blocks, so you can’t share them with other nodes. This is acceptable as long as enough other nodes still have the full archive.

With Utreexo, you’re pruning the UTXO set. Instead of throwing away transactions (along with the blocks they’re in), you throw away the list of coins that exist. The only thing you keep is a Merkle root, i.e. a hash that represents all the coins in existence. Every leaf of this Merkle tree represents a single UTXO. The Merkle root commits to all of them. For each coin that you care about, e.g. because it’s in your wallet, your node keeps a Merkle proof. When spending a coin, you need to attach this proof to your transaction, so other nodes can verify that the coin exists. We discuss Merkle trees in more detail in chapter @sec:miniscript and @sec:taproot_basics.

To put it another way, normally, when somebody sends you a transaction, the transaction says, “I’m spending this input, and you, the person running a node, have the responsibility to check whether that input exists in your own database.” And here, you’re flipping this around and telling the other node, “I have no idea which coins exist, because I don’t have enough RAM to track all that. You prove to me that this coin actually existed.” So the burden of evidence is reversed, which begs the question of how.

![Merkle tree. To prove the existence of Coin 3 you need to provide a merkle proof consisting of the three marked items.^[Modified from: <https://commons.wikimedia.org/wiki/File:Hash_Tree.svg>]](resources/tree.svg)

The figure illustrates how you prove the existence of coin 3 using a merkle proof, given a verifier who only knows the merkle root (top). First you reveal the coin itself, which is just a transaction output with an amount and `scriptPubKey`. The verifier hashes this to obtain Hash 1-0 (directly above Coin 3 in the figure). You then provide Hash 1-1. Even though you probably don't own Coin 4 and you may not even its amount and `scriptPubKey`, you do know it's hash, because your wallet kept track of such relevant information. With that the verifier can calculate Hash 1. You then provide Hash 0 and now the verifier can see that your proof results in the same merkle root hash they knew about. You have now demonstrated ownership of Coin 3, without the need for the verifier to know the entire UTXO set. 

### Seeing the Forest for the Trees

Usually, if someone sends a transaction to you, you check inside your node and the database with your UTXO set to see if the transaction is spending valid UTXOs. But now, the sender will have to provide you with the proof that their transaction is spending existing UTXOs. However, you still need something to make sure the proof is valid. And that’s Utreexo, which is a Merkle tree — or several trees — of hashes.

All the UTXOs in existence would be put into this tree and everybody can construct this tree if they replay the whole blockchain. Basically what the tree would look like is you have the first and second UTXO next to each other. Then, you take the hash of those two — basically combined — which is one new hash. You can do that again for another two UTXOs that exist and combine their hashes. So, for example, you have four UTXOs. Two of them are shared, and then those two are shared again, and you end up with one hash.

They’re called perfect trees, which means they’re always a multiple of two. So now the challenge is that for every new block, the tree needs to be updated. You end up with a forest of trees, because every tree has to be a power of two, so there can be four, or eight, or sixteen things at the bottom. When you have a number of transactions that doesn’t fit that way, you’ll have multiple trees that look like that. So you have a collection of trees for which you really only need to remember the top hashes.

How do you add something to that tree? You can actually take the UTXO you’re spending out of the tree and put the new one into the tree. To do that, you need to recalculate the tree, and that’s done by knowing its neighbors. So, the way you prove that something is inside a Merkle tree is to say, “Well, at the bottom of the tree, there are these two pairs and I’m going to give you the other side. And then at the next level, again, there’s a pair and I’m going to give you the other side.” And again and again and again, and that proves that something is actually in the tree. And that’s exactly the same information that you need to put something else at the bottom of the tree and then provide the new hash.

When you’re syncing the blockchain, you could keep track of the entire tree, but then you’d need a lot of RAM, just like in the original scenario. But what you’ll actually do is remember the top of every tree. Then, when somebody has a new transaction that you want to verify, they need to give you the Merkle proofs for all the inputs they’re spending to prove that they exist. They’ll also tell you which outputs are there — these will be swapped in at the same places where those inputs were — and they’ll tell you about any new trees being made.

This is all very elegant, in that the same proofs that are proving that these UTXOs are in the UTXO set are also exactly what you need to remove them from the set, update your root hash, and add the new UTXOs from the latest block.

### Bridge Nodes

Now consider someone wants to send a transaction to the network and you have a node and want to validate the transaction. With Utreexo, you have the top of the trees in your RAM. The sender is responsible for sending the transaction, as well as the proof that the transaction is valid, which also includes information for you so you know where to find it in the forest.

Another way you could get a transaction is if it’s already in the block. So if a miner mines a block and the transaction is in there, you still have the Utreexo on your node. But to get the proof, you’d need a bridge node. This is a node that has the actual UTXO set, the old-fashioned way, so it has lots of RAM or it’s just slow. And it produces all these proofs and it sends them around to whoever wants them.

This bridge node receives a transaction, and this transaction doesn’t have a Merkle proof, so it takes the proof it has, attaches it to the transaction, and sends it to other Utreexo nodes: It’s a bridge between Utreexo nodes and non-Utreexo nodes.

Of course, if users have the original UTXO set in memory somewhere, they can construct the proof for any transaction without the use of a bridge node.

Most likely, a node connects to either a “native” Utreexo node or to a bridge node. It then receives each block, along with the proofs; if you have to call a node for every single individual transaction, that’s a lot of overhead, whereas just downloading a couple hundred kilobytes is easier. A potential improvement on that design — especially to prevent eclipse attacks — would have a Utreexo node connect to regular nodes as well, and then request proofs separately from another node.

The problem is, when you’re the first Utreexo node and you’re pruning all the data and everybody else on the network is an old-fashioned node, nobody’s going to give you the proofs. What you need is at least a single bridge node to connect to. Other people are also connecting to the bridge node, because it speaks both languages: Utreexo, and the old-fashioned pre-Utreexo.

This does the translation for you, and as long as one bridge node exists, it can bootstrap the network. From the perspective of the Utreexo node, the bridge node is just also an Utreexo node, and from the perspective of the old-fashioned nodes, it’s just an old-fashioned node.

However, not everyone needs to do this translation, because someone can do it for others. And the other nodes know how to relay that information even if they can’t produce it. However, you’re relying on these bridge nodes to be backed by people with good intentions. But these nodes could change, or disappear, or run out of battery.

Looking at the long-term picture, if people like this given the advantages — or even if they don’t like it — if the UTXO set gets too big and takes too long to sync on any normal computer, then you could basically make a soft fork that contains the proofs.^[You’d include the hash of the proofs somewhere in the coinbase transaction.] So the proofs become part of the blockchain, just like SegWit added the whole bunch of data to blocks. You could then add these proofs to the blocks, making the blocks even bigger. The tradeoff there is you have more bandwidth, but less RAM is used.

However, this isn’t likely to happen until we really get a UTXO set bloating issue where the UTXO set becomes so big that people start liking this tradeoff to the point where it’s preferable.

### Cool Things

With this solution, because you wouldn’t need a lot of RAM, you could start doing things in specialized hardware. For example, smartphones tend to have very little RAM, so they could get a big performance boost from Utreexo. Or, you could even have a specialized chip — like a GPU — with a tiny on-board memory that validates Bitcoin blocks.

But even without specialized hardware, there’s a potential speedup if the CPU can do most of the block validation work without the back and forth to and from the RAM.

Then you have the protocol literally set in stone, or at least set in silicon. And of course, soft forks can still happen under that circumstance, but if somebody wants to do a hard fork, you’d have to break all the node hardware, and not just all the mining hardware. So, that’s a nice extra barrier to not do hard forks. And with soft forks, you can’t verify them — at least not with the accelerated hardware — so your computer would have to slow down to check all the new rules whenever it encounters it.

In chapter @sec:assume, we described how the source code contains a hash that represents the UTXO set a given snapshot height. The node still needs to obtain that UTXO set, which is several gigabytes in size, and it’d probably download it from its peers. With Utreexo, the UTXO set is so small that it can be put in the source code, thus removing the need to download the UTXO set for the snapshot.

One other thing we can also mention is that the general name for what Utreexo would do is called an accumulator. It’s something that you can use to add stuff to, and in this case also remove stuff from. But there are all sorts of mathematical tricks you can deploy to do this. This is just something that’s conceptually simple. If other people than us explain it and you see it in front of you, it’s very simple with the Merkle trees, but there’s been other proposals, like an RSA accumulator. There’s all sorts of cool cryptographic math you can do to just add things to a set and remove them from a set, essentially. Perhaps another mechanism would be used eventually.

### A Couple Tradeoffs

Although Utreexo has the potential to be cool, there are some tradeoffs. The most apparent is that if you start using this, and then later, somebody finds a better accumulator, you’d have to switch. This is OK, so long as you don’t commit it into a block. But once you make this an actual soft fork, you’re stuck, because you can’t undo a soft fork — at least not unless you put in some kind of sunset date or similar, which generally isn’t done.

Another downside is that bandwidth seems to be the bottleneck for Bitcoin right now, and this could make it worse. For that reason, Utreexo is more of an option that people can opt into if, in their case, bandwidth isn’t a problem. However, if the UTXO set grows to a significant degree where it does become a burden and slows down validation, then this might be more appealing.
