\newpage
## Taproot and Schnorr {#sec:taproot_basics}

![Ep. 02 {l0pt}](qr/ep/02.png)

In this chapter, we first introduce a Merkle tree that hides all the different spending conditions until they’re used. This is called MAST. Next, we explain how Schnorr signatures allow us to hide the MAST itself, which improves privacy further. We cover earlier proposals for MAST, which didn’t have the benefit of Schnorr, which in turn illustrates the power of Taproot. Finally, we point out some cool things Taproot enables.

### Merklized Abstract Syntax Trees

Chapter @sec:miniscript covered how the Pay-to-Script-Hash (P2SH) soft fork from 2012 made it possible to hide the contents of a script until it’s spent. From a privacy point of view, this is much better than immediately putting the script on the chain. However, what’s unfortunate about this is that when you do spend, all the constraints that were placed on the transaction are then visible to everyone.

The example from that chapter outlines a scenario where you need to either have your mom cosign a transaction or else wait two years to spend the coins on your own. One potential downside of showing the contents of the entire script, including the fallback condition, is that an attacker learns that they only need to steal _your_ keys and are then free to spend the coins after two years. The very first time you add coins to this particular wallet, the attacker won’t know anything about how to spend it (thanks to P2SH). And if you only use that wallet once in your lifetime and spend all of it at once, then the attacker won’t learn about the fallback until it’s too late. However, if you use the wallet more than once, then as soon as you make your first spend from it, you’ll have revealed that the fallback condition exists. From then on, you’re in trouble.

This scenario is exaggerated for educational purposes, but the point stands: Once you spend money, it’d be nice to only reveal the solution you use and not all the other options.

This is where Merklized Abstract Syntax Trees (MAST^[<https://bitcoinops.org/en/topics/mast/>]) come in.

A Merkle tree^[Not to be confused with Merkel’s tree: <https://www.reddit.com/r/ProgrammerHumor/comments/qzwjm3/please_dont_confuse_these_two/>] is a tree of hashes of scripts, and it specifies the different ways to spend Bitcoin. Picture it upside down, with the root at the top and the leaves at the bottom. So, if you have a list of four conditions, you build up the tree by starting with those four conditions (or hashes) at the bottom. Then, you bundle them into pairs, resulting in two groups of hashes. They’d again be hashed, up and up the tree, until there’s one hash left at the top, the root, which is the one you share: It’s used to generate the address where coins are sent to.

Later, when you want to spend it, you say, “This is the part of the tree I want to spend,” and then you use that script. You also give the neighbor’s script hash, because scripts come in pairs, and you give a hash of every other point in the tree. By revealing the script and its neighbor leaf hash, you prove you didn’t change the script. This is called a Merkle proof, which we explained in more detail in chapter @sec:utreexo.

![Merkle tree for MAST. To prove the existence of Script 1, you need to provide a Merkle proof consisting of the three marked items.](taproot/mast.svg)

In this example with four conditions, the tree is three levels high. Since you already reveal the script, there’s no need to reveal its hash. That leaves only two hashes to reveal: your script’s neighbor leaf at bottom, and the neighbor of their parent (where the tree is two hashes wide). The top hash doesn’t need to be revealed, because anyone can calculate it from the two hashes you provided. Depending on the scripts, this usually requires less data than the original four scripts, and you keep everything else secret. With 1,024 scripts, you only need to put the script you used, plus nine hashes, on the blockchain.

Now, Merkle trees are common: They’re used in blocks, for file sharing, in BitTorrent, etc. Using them enables you to only share the parts of something you need. In the context of Bitcoin, that might be the script you’re using to spend a coin, whereas in the context of BitTorrent, that might be a specific two seconds of video; your computer can receive lots of short fragments and confidently store those on your hard disk, knowing it’s really a piece of the movie you’re downloading, and not some garbage data. In both scenarios, the rest remains hashed, and you just add some extra data to prove that it — the script or a slice of the video file — was in that tree somewhere.

In addition to keeping things secret, using MAST is also less expensive, because you don’t need to include all of the possible scripts in the blockchain. This is especially true for big trees with lots of scripts, which a “smart contract” might need. The blockchain is a scarce resource, and including everything costs a lot. When spending a coin, you have to reveal the script, which requires fees. Since the introduction of P2SH, it’s the spender who reveals the script. Without MAST, the spender has to reveal all possible scripts, but with MAST, they only have to reveal the script that was actually used.

#### Hiding the MAST

While Merkle trees are a good solution, it’d be even better if you could hide the very MAST itself. Ideally, nobody even knows you’re using MAST.

Let’s return to the previous example of you and your mom. In this smart contract, if you and your mom both agree to spend the money, you don’t have to wait two years. In most smart contracts, no matter how complicated the various possible scripts are, when everyone who’s involved agrees to spend the money, they might as well dispense with the scripts and just create a single joint signature.

It’d be nice to have a way to express this using only the signature — without scripts or an entire tree. This can be done by tweaking your public key, as discussed in BIP 341.^[Taproot (SegWit v1): <https://en.bitcoin.it/wiki/BIP_0341>] Instead of saying, “Send this to my public key,” you’d instead say, “Send this to my public key, plus my mom’s public key, plus this MAST key.”

<!-- BIP 341 intentionally verbose to prevent QR code overlap -->

This tweaking of keys is slightly more complicated than literally adding them, owing to the many subtleties of cryptography, but in essence, if you can add up keys, and you can also add up signatures, and it looks to the outside world as if it’s just a regular signature. As a result, you can hide things inside — but this process is extremely difficult without Schnorr.

### Schnorr {#sec:schnorr}

Chapter @sec:libsecp talks about libsecp256k1, and in May 2021, BIP 340^[Schnorr: <https://en.bitcoin.it/wiki/BIP_0340>] support was merged into libsecp256k1. This added Schnorr signatures to Bitcoin Core.

Schnorr digital signatures were first created by Claus-Peter Schnorr, a German mathematician. He created the Schnorr signature algorithm, which he then patented. It would’ve been great for Bitcoin, as well as many other open source projects that came before it, but because of the patent, people had to find another way to reap the benefits of these signatures.

So a bunch of lawyers, engineers, and cryptographers joined forces and tried to figure out if there was a way to maim Schnorr’s algorithm so far that it would legally not fall under the patent, but still work. The result was a signature algorithm called Elliptic Curve Digital Signature Algorithm (ECDSA), which is the elliptic curve algorithm that Bitcoin currently uses and that the libsecp library implements. Although both Schnorr and ECSDA use public and private keys to create digital signatures, the latter involves a slightly more complicated process.

Although ECDSA is a convoluted version of Schnorr, it was standardized in 2005, and at least a dozen cryptographic libraries implemented it, including OpenSSL. And so, when Satoshi had to pick a cryptographic curve for Bitcoin, he chose ECDSA namely because it wasn’t patented and it’s already in OpenSSL.

Overall, Schnorr is simpler than ECDSA. They use the same elliptic curve, but to make a signature, you have to do slightly different calculations with it. So that also means that the change for Schnorr isn’t as complicated as, say, the initial version of libsecp was.

The initial version of libsecp had to implement the elliptic curve, including all the operations you can do in a curve, like addition and multiplication, and then implement the signature algorithm of ECDSA. But for Schnorr, you just need to do the signature algorithm for Schnorr, and you can skip — or remove — all the needless math.

Moving from ECDSA to Schnorr isn’t a huge change; it’s not modifying the elliptic curve or introducing an entirely new one. Rather, it’s a different — and simpler — way of signing.

The fewer changes developers have to make to a cryptographic library, the better. It means fewer places where critical bugs can be introduced. It also means less code review for the community. With almost a trillion dollars at stake, any bug related to Bitcoin’s digital signatures could have disastrous consequences, so the importance of only needing a simple change is difficult to overstate.

On top of that, because Schnorr is added as a soft fork, using it is entirely opt-in. ECDSA isn’t going anywhere.

### But Why Schnorr?

Simplicity is great, but all the hard work for the more complicated ECDSA had already been done. Why bother changing things? Even before Taproot, people wanted to add Schnorr because of all the things it enabled. But at some point, Bitcoin Core contributor and former Blockstream CTO Gregory Maxwell came up with a clever way of using Schnorr in combination with MAST.

Basically, because you can add anything to a public key, you can also add a script to a public key, because a script is essentially just a number and a private key is essentially just a number, and numbers can be added. Converting an elliptic curve private key to a public key also happens to be commutative. That let’s you do this:

```
public_key(private key + hash) ==
public_key(private_key) + public_key(hash)
```

Let’s now use an example of a backup system that you’d need in case you forget your private key. You start out with two keys: a primary key and a backup key. You keep your primary key on a very secure and tamperproof hardware wallet at home. Your backup key could be a note in a remote safe. If your house burns down, or if the hardware bricked itself after three incorrect PIN attempts, or if it’s stolen, you effectively lose the primary private key. So you’d fetch your backup key.

The backup key is what goes _in_ the MAST. If you never use it, nothing on the blockchain will indicate that you even have this backup. Under normal circumstances, you’d only use the primary key without revealing the MAST or the backup key in it.

But how does this hiding of the MAST work? Well that’s where Schnorr comes in. Schnorr lets you take this MAST and hide it inside your public key. Your wallet adds the root hash of the MAST to your private key, and then it calculates the corresponding, tweaked, public key. That tweaked key is what you put on the blockchain. To the outside world, it looks like any old public key.

And then, when you sign an actual transaction, you sign for this tweaked public key. Anyone else doesn’t see any difference between a tweaked public key and one that isn’t tweaked; they’re both perfectly valid public keys. Again, whether or not you tweaked your public key with this MAST structure, it looks the same to the rest of the world.

Only when you need to use your backup key is it time to reveal the MAST structure. Instead of using the tweaked key in your transaction, you reveal the original untweaked key, and you reveal the script (or one of your scripts, if you have a more complicated setup with more scripts in the tree).

Then, any person verifying, i.e. everyone who runs a full node, will take that script, calculate the hash, and add it up to the public key. They’ll see that this matches the tweaked key that was already on the blockchain, which proves you didn’t just make up a new script. The new script reveals to the world what your backup public key is, and they’ll check if your signature was indeed made using the private key for that public key.

Using this approach of a public key tweaked with a MAST is very space efficient. It improves privacy overall, because there’s no difference between transactions that pay to an individual with a simple single-key wallet and those that pay to an exchange with a super fancy multi-signature setup. It all looks the same, unless any of the backup conditions are used.

In the earlier example of you and your mom, if you accept Bitcoin with your mom this way, the first step is for the two of you to combine your public keys.^[The art of combining public keys and making joint signatures deserves a chapter of its own. It’s an important feature that Schnorr enables. But Taproot doesn’t do this for you. That’s up to wallet software and this is still a work in progress. The MuSig2 protocol is the latest proposal for how future wallet software can do this in a provably secure manner: <https://eprint.iacr.org/2020/1261>] Next, you generate a MAST with at least one leaf: the script specifying that after two years, you can spend the coins alone.^[It might also contain a second leaf that allows you and your mom to bypass the MuSig2 protocol and instead provide two individual signatures. This isn’t as good in terms of privacy, and it incurs higher fees, but it’s easier in some circumstances.]

Under normal circumstances, when you want to spend some coins, you call your mom and produce a joint signature. The coin you spend from specifies the public key, which has been tweaked with the MAST Merkle root. So you tweak your private key before producing a signature with it. What you publish will look like a regular signature for everyone else (because it is).

However, if there’s a scenario where one of you can’t sign and those two years go by, at the end you can reveal that it was actually a tweaked public key.^[Under the hood, every Taproot spend involves a tweaked key, using an empty MAST if there are no script leafs.] The rest of the world can look at that and say, “Yep. That adds up. The math makes total sense. That was what you were always doing; we just never were able to see it. Yep, two years have passed, so you’re allowed to spend this money now on your own.”

As a result, the condition is only revealed if you actually use it. Otherwise, it’ll be a secret forever, unless somebody hacks your wallet.

The ability to have multiple conditions and only reveal one of those conditions is what MAST enables. The ability to combine public keys with other keys and hashes is what Schnorr enables.^[<https://bitcoinmagazine.com/articles/the-power-of-schnorr-the-signature-algorithm-to-increase-bitcoin-s-scale-and-privacy-1460642496>]. But, this magic is combined, like Captain Planet, and now you can hide the MAST.

### Earlier MASTs

To appreciate Taproot even more, let’s take a brief excursion back in time.

The first MAST proposal, BIP 114,^[MAST: <https://en.bitcoin.it/wiki/BIP_0114>] introduced a new SegWit version. It offered privacy benefits similar to the Taproot Merkle tree proposal, and it only revealed the spending condition or script that was used.

Instead of introducing a new SegWit version, the second MAST proposal, BIP 116,^[`MERKLEBRANCHVERIFY`: <https://en.bitcoin.it/wiki/BIP_0116>] added a new opcode, `MERKLEBRANCHVERIFY`, to the existing script system. While the privacy was the same, the implementation varied.

However, there are downsides to both of these earlier MAST proposals:

1. As soon as you spend it, everyone can see that a MAST tree existed, even if they can’t see the full contents of the tree.
2. In the case where everyone agrees, you can’t just ignore the script and put signatures on the chain: You still have to pick a “we all agree” script from the MAST tree and satisfy it, which uses precious blockchain bytes.

By tapping the MAST root onto a Schnorr public key, so to speak, you fix these issues, as explained above.

### But Wait, There’s More…

While it’s true that some of the things you can do with Taproot were already technically possible (but more complicated), there are also some things Taproot unlocks.

For example, M-of-N signatures, or multi signatures, can now be done without a script, because Taproot enables protocols for combining them. This was possible before with threshold signatures in ECDSA,^[<https://eprint.iacr.org/2020/1390.pdf>], but like everything before Schnorr, it was complicated, and now it’s slightly easier.

To the outside world, a threshold signature looks like a single public key and a single signature. For M-of-M signatures, e.g. 2-of-2, the MuSig2 algorithm can be used. For the more general M-of-N, there’s no recommended algorithm yet. This isn’t a problem, because the algorithm for combining keys and signatures doesn’t need to be baked into the protocol; the Bitcoin protocol just needs to support Schnorr. When someone comes up with a new way to combine signatures, the result will look like a single signature — not just to humans, but also to nodes. And single signatures can be verified.

Another cool feature is how Taproot can make the Lightning network,^[<https://lightning.network/>] which is a layer 2 payment protocol, more private. Payments on Lightning involve passing a hash around, which is the same for all intermediate hops. This is a potential privacy concern, because someone with access to many nodes on the network could reconstruct the route a given payment took. With Schnorr, these hashes can be replaced with elliptic curve points that are different for each hop.^[<https://bitcoinops.org/en/topics/ptlc/>]

Additionally, Lightning uses channels, which are coins protected by two signatures, and with Taproot:

1. Those two signatures can be combined into one signature (e.g. using MuSig2).
2. The scripts Lightning uses to enforce good behavior can be hidden in the MAST, only to be revealed in the case of misbehavior.

In other words, if both sides of the channel agree on an operation, it looks like a normal transaction to outsiders. But if they disagree, there are a lot of additional timeout conditions, which can be nicely hidden inside the MAST.

However, most people won’t necessarily notice much of a difference, except that privacy will be slightly better. As these advanced options come along, they’ll use them but not notice them. That said, taking advantage of this functionality makes things cheaper, easier, and more private.
