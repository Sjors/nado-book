\newpage
## Utreexo {#sec:utreexo}


![Ep. 15 {l0pt}](qr/ep/15.png)

Whenever a new Bitcoin transaction is made, Bitcoin nodes use a UTXO set to determine that the coins being spent really exist. This UTXO set is currently several gigabytes in size and continues to grow over time, and there's no upper limit to how big it can potentially get.

Because Bitcoin nodes perform best and fastest if the UTXO set is kept in RAM, and because RAM is usually a relatively scarce resource for most computers, it would benefit a node’s performance if the UTXO set could be stored in a more compact format. This is the promise of Utreexo.

Utreexo would take all the UTXOs in existence and include them in a Merkle Tree, which is a data structure consisting only of hashes. This chapter explains how the compact Utreexo structure could suffice in proving that a particular UTXO is included when a new transaction is made. It also covers the potential benefits that could surface if this solution becomes available, along with some of the potential tradeoffs.

<https://bitcoinmagazine.com/articles/bitcoins-growing-utxo-problem-and-how-utreexo-can-help-solve-it>

### The Challenge

When syncing a new Bitcoin node, one of the challenges is the amount of random-access memory (RAM) you have. You don’t need a lot of RAM on your computer, but if you want to sync fast, you do.

The reason this is necessary is due to the UTXO set, which is a list of coins you own. Every time a new block comes in, you check that the transaction is spending something that actually exists. This information is held in a database, and if it's located on your hard disk, this checking is a slow process. However, if the database is located in your RAM, it's extremely fast.

It also works when creating a new coin; the transaction needs to be stored, or written to disk, which is just as slow.

The time it take varies, but say you had a newer MacBook Pro, and you stored this information in your RAM; it would take maybe five hours and 11GB of RAM to sync the entire chain. However, if you had a Raspberry Pi, you might have only 2GB or 4GB of space. So you’d sync the chain and keep as much as possible in RAM, but at some point, it'd overflow. Then it'd write everything to disk, clear everything, and start caching again. This could take several days.

The key point here is that if you can keep more of the UTXO set in RAM, you’ll sync faster. It'd be nice if the size of the UTXO set could be decreased, but that's not necessarily possible. Of course, if you’re spending more coins than you’re creating, then the number of UTXOs and the RAM usage both go down. However, there’s a lot of junk in the UTXO set, because in the past, people created transactions to multi-sig addresses that were fake just to e.g. put pictures of Obama in the blockchain. And those are all sitting in your RAM because your node has no idea they’re nonsense.

However, if we expect everybody in the world to eventually use Bitcoin and to have at least one or two UTXOs each, that’s a lot of people and a lot of RAM. And it could get to the point where fewer and fewer people would even have enough RAM to sync it quickly, which is a problem.

### Utreexo

One way to address this issue is with Tadge Dryja’s proposal, the Utreexo.^[<https://www.youtube.com/watch?v=6Y6n88DmkjU>] Dryja is a research scientist at the MIT Digital Currency Initiative.

Currently with Bitcoin, you can prune things in the sense that you take a block, process it, extract the UTXO set from all the blocks, and throw everything else away. The downside is you don't have the blocks, so if you want to prove to another person that the UTXO set is valid, you can’t actually give them the blocks. However, the assumption is that somebody else will have the block.

But with Utreexo, you’re pruning UTXO sets and you're essentially throwing away all the transactions and just keeping a Merkle root, inside of which is a commitment. Every single UTXO is committed in there, and you only keep the Merkle proofs of the UTXOs that you care about.

To put it another way, normally, when somebody sends you a transaction, the transaction says, “I’m spending this input, and you, the person running a node, have the responsibility to check whether that input exists in your own database.” And here, you’re flipping this around and telling the other node, “I have no idea which coins exist, because I don’t have RAM. You prove to me that this coin actually existed.” So the burden of evidence is reversed, which begs the question of how.

Usually, if someone sends a transaction to you, you check inside your node and the database with your UTXO set to see if the transaction is spending valid UTXOs. But now, the sender will have to provide you with the proof that their transaction is spending existing UTXOs. However, you still need something to make sure the proof is valid — and that’s Utreexo, which is a Merkel tree of hashes.

### Seeing the Forest for the Trees

All the UTXOs in existence would be put into this tree and everybody can construct this tree if they replay the whole blockchain. Basically what the tree would look like is you have the first and second UTXO next to each other. Then, you take the hash of those two — basically combined — which is one new hash. You can do that again for another two UTXOs that exist and combine their hashes. So, for example, you have four UTXOs. Two of them are shared, and then those two are shared again, and you end up with one hash.

They're called perfect trees, which means they're always a multiple of two. So now the challenge is that for every new block, the tree needs to be updated. You end up with a forest of trees, because every tree has to be a multiple of two, so there can be four, or eight, or sixteen things at the bottom. When you have a number of transactions that doesn’t fit that way, you’ll have multiple trees that look like that. So you have a collection of trees for which you really only need to remember the top hashes. And now the question is, how do you add something to that tree?

You can actually take the UTXO you’re spending out of the tree and put the new one into the tree. To do that, you need to recalculate the tree, and that's done by knowing its neighbors. So, the way you prove that something is inside a Merkle tree is to say, well, at the bottom of the tree, there’s these two pairs and I’m going to give you the other side. And then at the next level, again, there’s a pair and I’m going to give you the other side. And again and again and again, and that proves that something is actually in the tree. And that’s exactly the same information that you need to put something else at the bottom of the tree and then provide the new hash.

When you’re syncing the blockchain, you could keep track of the entire tree, but then you'd need a lot of RAM, just like in the original scenario. But what you’ll actually do is remember the top of every tree, and there might be 10 or 20 or whatever trees, and that’s all you’re going to remember. Then, when somebody has a new transaction that you want to verify, they need to give you the Merkle proofs for all the inputs they’re spending to prove that they exist. They'll also tell you which outputs are there, which are going to be swapped in at the same places where those inputs were, and any new trees being made.

This is all very elegant, in that the same proofs that are proving that these UTXOs are in the UTXO set are also exactly what you need to remove them from the set, update your root hash, and add the new UTXOs from the latest block.

### Bridge Nodes

Now consider someone wants to send a transaction to the network and you have a node and want to validate the transaction. With Utreexo, you have the top of the trees in your RAM. The sender is responsible for sending the transaction, as well as the proof that the transaction is valid, which also includes information for you so you know where to find it in the forest.

Another way you could get a transaction is if it’s already in the block. So if a miner mines a block and the transaction is in there, you still have the Utreexo on your node. But to get the proof, you'd need a bridge node. This is a node that has the actual UTXO set, the old-fashioned way, so it has lots of RAM or it’s just slow. And it produces all these proofs and it sends them around to whoever wants them.

This bridge node receives a transaction, and this transaction doesn't have a Merkle proof, so it takes the proof it has, attaches it to the transaction, and sends it to other Utreexo nodes. It’s a bridge between Utreexo nodes and non-Utreexo nodes.

Aaron:
But they could also construct the proof themselves, right? If they see a certain transaction is included in a block, they can just figure-

Sjors:
That’s right, there’s nothing secret here. So if you have the original UTXO set in memory somewhere, you can construct the proof for any transaction.

Ruben:
And they have the entire tree, essentially. So the entire UTXO tree that you create and then prune, they just don’t prune it essentially. So they just have the full UTXO set. Basically, the UTXO set with all the Merkle proofs connecting to it, so then they can just take any UTXO in there and create a proof from it and just send it on, or for an entire block or whatever.

Aaron:
Right, so what would happen in practice? Sjors, your node would see a transaction in a block and it would wonder, ‘Hmm, is there actually proof for that? I never saw the transaction before.’ And you would request it from a bridge node.

Sjors:
Yeah. My guess is, when you get the whole block, you’re going to call a bridge node and say, ‘Give me the proofs for that entire block.’

Why not just the ones you need, the ones you haven’t seen before?

Sjors:
My guess is that’s too much back and forth because if you have to call a node for every single individual transaction, and that’s a lot of overhead, whereas just downloading a couple hundred kilobytes is easier.

The problem is, when you’re the first Utreexo node and you’re pruning all the data, and everybody else on the network is an old-fashioned node, nobody’s going to give you the proofs. What you need is at least a single bridge node to connect to. Other people are also connecting to the bridge node, because it speaks both languages: Utreexo, and the old-fashioned pre-Utreexo.

This does the translation for you, and as long as one bridge node exists, it can bootstrap the network. From the perspective of the Utreexo node, the bridge node is just also an Utreexo node, and from the perspective of the old-fashioned nodes, it’s just an old-fashioned node.

However, not everyone needs to do this translation, because someone can do it for others. And the other nodes know how to relay that information even if they can’t produce it. However, you're relying on these bridge nodes to be backed by people with good intentions. But these nodes could change, or disappear, or run out of battery.

Looking at the long-term picture, if people like this given the advantages — or even if they don’t like it — if the UTXO set just becomes insane and it just takes too long to sync on any normal computer, then you could basically make a soft fork which contains the proofs. So the proofs become part of the blockchain, just like SegWit added the whole bunch of data to blocks. You could then add these proofs to the blocks, making the blocks even bigger. The tradeoff there is you have more bandwidth, but less RAM is used.

The reason this could be done as a soft fork — like with SegWit — is because you’d include the hash of the proofs somewhere in the coinbase transaction. Old nodes won’t notice anything interesting; they'd get blocks and verify them, but nothing about the transactions would change. But upgraded nodes will see a whole tree, which they share with each other, which makes the blocks a bit bigger for them. However, they'll save RAM and use the extra data.

This isn't likely to happen until we really get a UTXO set bloating issue where the UTXO set becomes so big that people start liking this tradeoff to the point where it’s preferable.

### Cool Things

Because you don’t need a lot of RAM, you can start doing things in specialized hardware like in ASIC, because one of the things that’s hard to do in an ASIC is lots of memory. And having specialized hardware, maybe it’s a part of your chip, so maybe Bitcoin becomes the standard and every phone that you buy has a CPU, has a little mini processor right next to it that just checks all the Bitcoin validation rules. And because it’s custom silicon, it might be able to validate the entire blockchain at the speed that it can download it, which is pretty cool.

Then you have the protocol literally set in stone or at least set in silicon. And of course, soft forks can still happen under that circumstance, but if somebody wants to do a hard fork, you’d have to break all the node hardware, and not just all the mining hardware. So, that’s a nice extra barrier to not do hard forks. And with soft forks, you can’t verify them — at least not with the accelerated hardware — so your computer would have to slow down to check all the new rules whenever it encounters it.

In another chapter, we talked about Assume UTXO, where one of the problems is that when you start now, you still need to get the initial gigabytes from somewhere, and the larger it is, the more problematic it is. But now, with this proposal, it's just kilobyte. So you represent the entire UTXO set in a kilobyte, which can just be inside the source code. You don’t need a hash and to fetch something; you just put the thing itself in there and know it’s going to start instantly at that height and sync all the way to the tip and then start the genesis and make sure everything is what it should be.

The final benefit is you could sync with a phone node. Currently, if you have a node on your phone, it might be very slow. Maybe with this proposal, it wouldn’t be slow, but let’s say it’s still slow. You'd sync your node on your desktop, you scan a QR code, and now your phone has the recent UTXO set and that doesn’t even require any kind of commitments, because your phone trusts your laptop. So that’s a feature you could use right now.

That's parallel validation. Theoretically, you can take two computers and just take a Utreexo hash off the middle state of the blockchain. So, if we’re at block 2,000, you just take block 1,000 and the Utreexo hash from that moment in time, and then you start validating 1,000 to 2,000. And on the other computer, you start validating 0 to 1,000. And if they match up after you validated both, then you validate the entire blockchain while splitting up the work.

And it wouldn’t be necessarily multiple computers doing this, but just multiple chips. The problem with the Bitcoin chain is that you can verify signatures in parallel, and a Bitcoin node does that, but some things are intrinsically serial, so you cannot verify block 10 before you’ve verified block 9, and it’s nice if you can get rid of that.

Ruben:
Yeah, so now you can essentially.

Sjors:
You can too with the Assume UTXO but you need multiple, very large snapshots.

One other thing we can also mention is that this tree that we just described, the general name for it is an accumulator. It’s something that you can use to add stuff to, and in this case also remove stuff from. But there are all sorts of mathematical tricks you can deploy to do this. This is just something that’s conceptually simple. If other people than us explain it and you see it in front of you, it’s very simple with the Merkle trees, but there’s been other proposals, like an RSA accumulator. There’s all sorts of cool cryptographic math you can do to just add things to a set and remove them from a set, essentially. Perhaps another mechanism would be used eventually.

### A Couple Downsides

If you start using this, and then later, somebody finds a better accumulator, then you have to, yet again, switch to that next proposal. This is OK, so long as you don’t commit it into a block. But once you make this an actual soft fork, you’re stuck, because you can’t undo a soft fork — at least not unless you put in some kind of sunset date or similar, which generally isn't done.

Another downside is that bandwidth seems to be the bottleneck for Bitcoin right now, and this could make it worse. For that reason, Utreexo is more of an option that people can opt into if, in their case, bandwidth isn’t a problem. However, if the UTXO set grows to a significant degree where it does become a burden and slows down validation, then this might be more appealing.
