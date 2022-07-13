\newpage
## Utreexo {#sec:utreexo}

\EpisodeQR{15}

Whenever a new Bitcoin transaction is made, Bitcoin nodes use a UTXO set to determine that the coins being spent really exist (see chapter @sec:assume). This UTXO set is currently several gigabytes in size and continues to grow over time, and there’s no upper limit to how big it can potentially get.

Because Bitcoin nodes perform best if the UTXO set is kept in RAM, and because RAM is a relatively scarce resource for computers, it would benefit a node’s performance if the UTXO set could be stored in a more compact format. This is the promise of Utreexo.^[Pronounced U Tree X O. See also: <https://bitcoinmagazine.com/articles/bitcoins-growing-utxo-problem-and-how-utreexo-can-help-solve-it>]

Utreexo would take all the UTXOs in existence and include them in a Merkle tree, which is a data structure consisting only of hashes. This chapter explains how the compact Utreexo structure could suffice in proving that a particular UTXO is included when a new transaction is made. It also covers the potential benefits that could surface if this solution were to be used, along with some of the potential tradeoffs.


### The Challenge

When syncing a new Bitcoin node, one of the challenges is the amount of random-access memory (RAM) you have. In general, you don’t need a lot of RAM on your computer, but if you want to sync fast, you do.

The reason this is necessary is due to the UTXO set, which is a list of all coins in existence, including the ones you own. Every time a new block comes in, for every transaction in it, you check that it spends coins that actually exist. You also remember which new coins the transaction created, so that you’re aware of this when it gets spent in a later block. This information is held in a database, and if it’s located on your hard disk, this checking and updating is a slow process. However, if the database is located in your RAM, it’s extremely fast.

The time it take varies, but say you had a newer MacBook Pro with 32GB RAM, and you allowed the node to use half of this; it’d take maybe seven hours to sync the entire chain.^[In late 2020, former Bitcoin Core maintainer Jonas Schnelli synced the chain on an Apple M1 in five hours. It would’ve been faster if he allocated more than 5GB of RAM (using `-dbcache`). In the meantime, the chain has grown, hence the more conservative estimate. <https://twitter.com/_jonasschnelli_/status/1333303029370675201>] However, let’s say you had a Raspberry Pi with only 2GB of RAM and a small hard drive. In this case, it could take several weeks.^[There are two bottlenecks. First, your node keeps as much as possible in RAM during sync, but once it fills up this memory, it has to write the UTXO database to disk, clear its memory, and start caching again. The second problem is that if the blockchain doesn’t fit on the hard drive, then your node has to delete old blocks to make room for new ones. A side effect of this is that the coin database in RAM must be written to disk, further slowing down the sync process.]

The key point here is that if you can keep more of the UTXO set in RAM, you’ll sync faster. It’d be nice if the size of the UTXO set could be decreased, but that’s not necessarily possible. Of course, if you’re spending more coins than you’re creating, then the number of UTXOs and the RAM usage both go down. However, there’s a lot of junk in the UTXO set, because in the past, people created transactions to multisig addresses that were fake just to e.g. put pictures of Obama in the blockchain. And those are all sitting in your RAM because your node has no idea they’re nonsense.

However, if we expect everybody in the world to eventually use Bitcoin and to have at least one or two UTXOs each, that would take terabytes of RAM, and Moore’s Law^[<https://en.wikipedia.org/wiki/Moore%27s_law>] isn’t going to catch up to this anytime soon. But even without the entire world using Bitcoin, it could get to the point where fewer and fewer people have enough RAM to sync it quickly, which is a problem. If fewer people run their own node, the system becomes less decentralized.

### Utreexo

One way to address this issue is with Tadge Dryja’s proposal, the Utreexo.^[<https://dci.mit.edu/utreexo>, <https://www.youtube.com/watch?v=6Y6n88DmkjU>] Dryja is a research scientist at the MIT Digital Currency Initiative.

Currently with Bitcoin, you can prune the archival block storage to save disk space. After your node downloads a block, processes it, and updates the UTXO set, it no longer has any use for the block. Your node knows exactly which coins exist in the UTXO set, which is all the information it needs to validate future transactions.

When pruning is enabled, your node holds on to the block for a few more days and then deletes it. This way, you need less than a gigabyte of storage, even though the blockchain itself is hundreds of gigabytes. The downside is that you don’t have the blocks, so you can’t share them with other nodes. This is acceptable as long as enough other nodes still have the full archive.

With Utreexo, you’re pruning the UTXO set. Instead of throwing away transactions (along with the blocks they’re in), you throw away the list of coins that exist. The only thing you keep is a Merkle root, i.e. a hash that represents all the coins in existence. Every leaf of the Merkle tree represents a single UTXO, and the Merkle root commits to all of them. For each coin that you care about, e.g. because it’s in your wallet, your node keeps a Merkle proof. When spending a coin, you need to attach this proof to your transaction so that other nodes can verify that the coin exists.

To put it another way, normally, when somebody sends you a transaction, the transaction says, “I’m spending this input, and you, the person running a node, have the responsibility to check whether that input exists in your own database.” And here, you’re flipping this around and telling the other node, “I have no idea which coins exist, because I don’t have enough RAM to track all that. You prove to me that this coin actually existed.” So the burden of proof is reversed, which begs the question of how.

\newpage
### Merkle Proof Tutorial

![Merkle tree. To prove the existence of Coin 3, you need to provide a Merkle proof consisting of the three marked items.^[Modified from: <https://commons.wikimedia.org/wiki/File:Hash_Tree.svg>]](resources/tree.svg)

The figure above illustrates how you can prove the existence of Coin 3 using a Merkle proof, given a verifier that only knows the Merkle root (top). First, you reveal the coin itself, which is just a transaction output with an amount and `scriptPubKey`. The verifier hashes this to obtain Hash 1-0 (directly above Coin 3 in the figure). You then provide Hash 1-1. Even though you probably don’t own Coin 4 and you may not even know its amount and `scriptPubKey`, you do know its hash, because your wallet kept track of this information. With that, the verifier can calculate Hash 1. You then provide Hash 0, and now the verifier can see that your proof results in the same Merkle root hash they knew about. You’ve now demonstrated ownership of Coin 3 without the need for the verifier to know the entire UTXO set.

We’ll revisit Merkle trees in chapter @sec:miniscript and chapter @sec:taproot_basics.

### Seeing the Forest for the Trees

Currently, if someone sends a transaction to you, you check inside your node and the database with your UTXO set to see if the transaction is spending valid UTXOs. With Utreexo, the sender will have to provide you with the proof that their transaction is spending existing UTXOs. Although you no longer have to hold on to several gigabytes of UTXO data, you do still need to keep track of a few things, namely a Merkle tree — or several trees — of hashes.

All the UTXOs in existence would be put into this tree and everybody can construct this tree if they replay the whole blockchain. Basically what the tree would look like is you have the first and second UTXO next to each other. Then, you take the hash of those two — basically combined — which is one new hash. You can do that again for another two UTXOs that exist and combine their hashes. So, for example, you have four UTXOs. Two of them are shared, and then those two are shared again, and you end up with one hash.

Utreexo uses perfect trees, which means the number of leaves in each must be a power of two. Because the UTXO set contains an arbitrary number of coins, you end up with a forest of trees. For example, if there are six coins, your forest would have a tree with 2^2^=4 leaves and a tree with two leaves. All your node needs to store is the Merkle root hash of each tree. There are currently a little under 100 million coins in existence.^[<https://txstats.com/dashboard/db/utxo-set-repartition-by-output-type>] Because this is less than 2^27^, it’d take 27 trees to represent them all. Each SHA-256 hash^[<https://qvault.io/cryptography/how-sha-2-works-step-by-step-sha-256/>] is 32 bytes, so your node needs to store 27 * 32 = 864 bytes. If every human owns multiple coins, it’d only grow to one kilobyte.

How do we update the tree for every block as leaves are removed and added, i.e. coins are spent and created? You can actually take the UTXO that’s being spent out of the tree and put the new one into the tree. To do that, you need to recalculate the tree, and that’s done by knowing its neighbors. We already illustrated how to prove that something exists in the tree, and it turns out that’s exactly the same information you need to put something else at the bottom of the tree and then provide the root hash.

When you’re syncing the blockchain, you could keep track of the entire tree, but then you’d need a lot of RAM, just like in the original scenario. This is why you only store the root of each tree. Then, when somebody has a new transaction that you want to verify, they need to give you the Merkle proofs for all the inputs they’re spending to prove that they exist. They’ll also tell you which outputs are there — these will be swapped in at the same places where those inputs were — and they’ll tell you about any new trees being made.

### Bridge Nodes

There are two ways you can learn about a transaction. Someone can send it to you via the network, in which case you add it to your mempool. Or, it can be part of a block you receive.

How would you validate the transaction in the first scenario? With Utreexo, you have the top of the trees in your RAM. The sender is responsible for sending the transaction, as well as the proof that the transaction is valid, which also includes information for you so you know where to find it in the forest. If the sender doesn’t support Utreexo and doesn’t provide the proof, your node could simply ignore the transaction.

But what about the second scenario? If a miner mines a block and a transaction is in there, the block doesn’t contain the proof. To get this proof, you need the help of a bridge node. This is a node that has the actual UTXO set, the old-fashioned way, so it has lots of RAM or it’s just slow. And it produces all these proofs and it sends them around to whoever wants them.

When a bridge node receives a transaction that doesn’t have a Merkle proof, it takes the proof it has, attaches it to the transaction, and sends it to other Utreexo nodes. The same goes for entire blocks. You don’t have to be directly connected to such a bridge node, as other Utreexo-aware nodes can relay blocks with the proofs attached. From the perspective of the Utreexo node, the bridge node is just a Utreexo node, and from the perspective of the old-fashioned nodes, it’s just an old-fashioned node.

There’s nothing magical about bridge nodes. Any node that has the original UTXO set can construct the proof for any transaction. But doing so would defeat the purpose of Utreexo, because keeping track of both the regular UTXO set and these proofs takes a lot of memory.

So these bridge nodes do the translation between the current world of nodes that track the UTXO set in memory and these new Utreexo-enabled nodes that don’t have to. As long as one bridge node exists, it can bootstrap the network. However, this relies on these bridge nodes being backed by people with good intentions. But these nodes could change, or disappear, or run out of battery.

Looking at the longterm picture, if people like Utreexo given the advantages — or even if they don’t like it — if the UTXO set gets too big and takes too long to sync on any normal computer, then you could basically make a soft fork that requires all proofs to be in the block.^[You’d include the hash of the proofs somewhere in the coinbase transaction. As we explained in chapter @sec:segwit for SegWit, the proofs themselves would go in a special place inside the block that old nodes don’t see.] By including proofs in the blocks, they’re guaranteed to be available to all nodes.

The tradeoff there is that bigger blocks require more bandwidth and storage, but less RAM is used. At the moment, bandwidth is probably a bigger constraint than RAM, so a soft fork isn’t likely to happen, but this could change in the decades ahead.

### Cool Things

With this solution, because you wouldn’t need a lot of RAM, you could start doing things in specialized hardware. For example, smartphones tend to have very little RAM, so they could get a big performance boost from Utreexo. Or, you could even have a specialized chip — like a GPU — with a tiny onboard memory that validates Bitcoin blocks.^[Then you have the protocol literally set in stone, or at least set in silicon. If somebody wants to do a hard fork, you’d have to break all the node hardware, and not just all the mining hardware. So, that’s a nice extra barrier to not do hard forks. Unfortunately, this also makes soft forks less attractive, as nodes can’t verify the new rules with the accelerated hardware — so your computer would have to slow down to check all the new rules whenever it encounters transactions that fall under the new rules.]

But even without specialized hardware, there’s a potential speedup if the CPU can do most of the block validation work. A 1KB Merkle forest can easily be kept in a typical CPU cache.^[<https://en.wikipedia.org/wiki/CPU_cache>] This avoids having to verify UTXO set information between the CPU and RAM. Just like using RAM to avoid physical disk reads speeds things up, so does using the CPU cache to avoid using RAM.

In chapter @sec:assume, we described how the source code contains a hash that represents the UTXO set a given snapshot height. The node still needs to obtain that UTXO set, which is several gigabytes in size, and it’d probably download it from its peers. With Utreexo, the UTXO set is so small that it can be put in the source code, thus removing the need to download the UTXO set for the snapshot.

### A Couple Tradeoffs

Although Utreexo has the potential to be cool, there are some tradeoffs. The most apparent is that if you start using it, and then later, somebody finds a better accumulator,^[The general term for what Utreexo uses for its coin accounting is called an accumulator. It’s something you can use to add stuff to, and in this case, to also remove stuff from. But there are all sorts of mathematical tricks you can deploy to do this. The Merkle tree is conceptually very simple, as we hopefully illustrated, but there have been other proposals, like an RSA accumulator. There’s all sorts of cool cryptographic math you can do to just add things to a set and remove them from a set, essentially. It’s too early to set any particular accumulator in stone with a soft fork.] you’d have to switch. Such a switch is easy in a scenario with bridge nodes — multiple solutions could exist in parallel, each with their own bridge nodes. But once the proofs are added into blocks with a soft fork, there’s no easy way back.

Another downside is that bandwidth seems to be the bottleneck for Bitcoin right now, and this could make it worse. For that reason, Utreexo is more of an option that people can opt into if, in their case, bandwidth isn’t a problem. However, if the UTXO set grows to a significant degree where it does become a burden and slows down validation, then this might be more appealing.
