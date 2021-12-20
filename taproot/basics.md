\newpage
## Taproot and Schnorr {#sec:taproot_basics}

![Ep. 02 {l0pt}](qr/02.png)

This chapter is all about Taproot^[<https://bitcoinmagazine.com/articles/taproot-coming-what-it-and-how-it-will-benefit-bitcoin>]: what it is, what it does, and why it's interesting. In particular, it'll break down and explain Taproot, cover the building blocks that make Taproot possible, and explain what it enables Bitcoin to do.

<!-- Blank line to move the next section header below the QR code -->
\

### Taproot, Briefly

Taproot is an upgrade to Bitcoin that was proposed in 2018 and deployed in November 2021. This soft fork increases privacy for "smart contracts" and reduces their transaction fees. It achieves this by hiding all the different spending conditions in a Merkle tree, and only revealing the one that is eventually used. It also introduces Schnorr signatures, which make it much easier to compress signatures from multiple participants into a single signature. Both of these things result in less usage of precious block space, reducing fees, and improving privacy in the process.

### Merklized Abstract Syntax Trees

Chapter @sec:miniscript covered how the Pay-to-Script-Hash (P2SH) soft fork from 2012 made it possible to hide the contents of a script until it's spent. From a privacy point of view, this is much better than immediately putting the script on the chain. However, what's unfortunate about this is that when you do spend, all the constraints that were placed on the transaction are then visible to everyone.

The example from that chapter outlines a scenario where you need to either have your mom cosign a transaction or else wait 35 years to spend the coins on your own. If the latter occurs, the whole world doesn't necessarily need to know that you could have also spent it with your mom. More importantly, if you did spend it with your mom, the whole world shouldn't know they could've waited 35 years and stolen it.

This scenario is exaggerated for the purpose of making a point, but the point stands: Once you spend money, it'd be nice to only reveal the solution you use and not all the other options.

This is where Merklized Abstract Syntax Trees (MAST^[<https://bitcoinops.org/en/topics/mast/>]) comes in.

A Merkle tree^[Not to be confused with Merkel's tree: <https://www.reddit.com/r/ProgrammerHumor/comments/qzwjm3/please_dont_confuse_these_two/>] is a tree of hashes off the script, and it specifies the different ways to spend Bitcoin. So if you had a list of eight conditions, you could group them in a tree, with the eight conditions (or hashes) at the bottom. Then, you'd bundle them into pairs, resulting in four groups of hashes. They'd again be hashed, up and up the tree, until there's one hash left at the top, which is the one you share and the one the coins are spent to.

In other words, when you want to spend it, you say, "This is the part of the tree I want to spend," and then you use that script. You also give the neighbor script, because scripts come in pairs, and you give a hash of every other point in the tree. If the tree is four levels high, you need to give four hashes in the script, which is a lot less than all eight of them, and you keep everything else secret. In this way, you prove you didn't change the script, but you also avoid revealing everything.

Now, Merkle trees are common: They're used in blocks, for file sharing, bit torrent, etc. Using them enables you to only reveal the scripts you're using to spend the coins. The rest remains hashed, and you just add some extra data to prove that it was in that tree somewhere.

In addition to keeping things secret, it's also less expensive using MAST, because you don't need to include all of the possible scripts into the blockchain. The blockchain is a scarce resource, and including everything costs a lot. Even if you're only including it when spending, you still have to pay all of these fees.

TODO This could have just been another op code, so another instruction in the script, which has been debated for quite a while, but in comes magic.

[Note: my last remark refers to an earlier proposal, called MAST, which simply added an op code to the Bitcoin script language to introduce MAST functionality. Two downsides that solution are:
1. as soon as you spend it, everyone can see that a MAST tree existed, even if they can't see the full contents of the tree
2. in the case where everyone agrees, you can't just ignore the script and put signatures on the chain: you still have to publish the script and satisfy it, which uses precious blockchain bytes

#### Hiding the MAST

While Merkle trees are a good solution, it'd be even better if you could hide that you're using MAST.

Let's return to the previous example of you and your mom. In this smart contract, if you and your mom both agree to spend the money, you don't have to wait 35 years. And most smart contracts have this condition where, if everyone who's involved agrees to spend the money, you can.

It'd be nice to have a way to express this using only the signature — without scripts or an entire tree. This can be done by tweaking your public key. Instead of saying, "Send this to my public key," you'd roughly say, "Send this to my public key, plus my mom's public key, plus this MAST key."

The idea of tweaking keys is oversimplified, because cryptography is subtle, but in theory, you can add up keys, and you can also add up signatures, and it looks to the outside world as if it's just a regular signature. As a result, you can hide things inside.

### Schnorr {#sec:schnorr}

Chapter @sec:libsecp talks about libsecp256k1, and in May 2021, BIP 340^[<https://github.com/bitcoin/bips/blob/master/bip-0340.mediawiki>] support was merged into libsecp256k1. This added Schnorr signatures to Bitcoin Core.

Schnorr digital signatures were first created by Claus-Peter Schnorr, a German mathematician. He created the Schnorr signature algorithm, which he then patented. It would've been great for Bitcoin, but because of the patent, people had to find another way.

What happened is a bunch of lawyers, engineers, and cryptographers joined forces and tried to figure out if there was a way to maim Schnorr's algorithm so far that it would legally not fall under the patent, but still work. The result was a signature algorithm called Elliptic Curve Digital Signature Algorithm (ECDSA), which is the elliptic curve algorithm that Bitcoin currency currently uses and that the libsecp library implements. ECDSA uses public and private keys to create digital signatures, but it's difficult...

Although ECDSA is a convoluted version of Schnorr, it's been standardized; the NSA published some nice numbers for it. OpenSSL, the cryptographic library that many programs use, also uses it. And so, when Satoshi, probably when he was working on Bitcoin, he had to pick a cryptographic curve, and he just picked something from OpenSSL, namely ECDSA and not Schnorr.

First of all, he knew it was patented, or the patent maybe just ran out, but second, there was just no implementation of it and it's much easier to just use a library, because writing your own cryptography is really, really hard. Whatever this massive team was that Satoshi supposedly had, did not have a cryptographer that could do that.

Overall, Schnorr is simpler than ECDSA. They use the same elliptic curve, but to make a signature, you have to do slightly different calculations with it. So that also means that the change for Schnorr is not as complicated as, say the initial version of libsecp was.

The initial version of libsecp had to implement the elliptic curve, including all the operations you can do in a curve like addition and multiplication, and then implement the signature algorithm of ECDSA. But for Schnorr, you just need to do the signature algorithm for Schnorr, and you can skip all the math.

It's not a huge change; it's not like adding a whole new curve to it. It would be much more difficult to add, say, a different elliptical curve or even a completely different kind of curve than it is to change just from ECDSA to Schnorr.

It's a different way of signing, and in fact a simpler way of signing.

### How Schnorr Works

Schnorr signatures make it possible to:
1. Turn multiple signatures into a single signature (so in a 2-of-2 multisig, if both parties sign, it'll look indistinguisable from a normal single signature 1-of-1 wallet where 1 person signed) — in turn saving block space and improving privacy.
2. Hide a MAST by tweaking the public key and signature.

A MAST is represented by a hash, i.e. the hash of the top of the tree. It's essentially just a big number, just as a private key is. If you add the hash to the private key, it'll look like any other private key.

Meanwhile, a hash can be turned into a "public key," just like a private key can. Additionally, it's commutative, which means the order of operands changing doesn't change the result:
- public_key(private key + hash) == public_key(private_key) + public_key(hash)

When you spend this, you have two choices:
1. Don't reveal the hash. Instead, sign with the (private key + hash) as if it's a regular private key.
2. Reveal the hash, and sign with the original private key. In this case, the blockchain requires that you reveal the relevant parts of the merkle tree (which anyone can verify results in that hash) and satisfy the leaf script.

### Actually Using Schnorr

Now that it's merged, there's an updated version of this library, but nobody's using that library yet. And another change is that Bitcoin Core was changed I think a few days ago to include that new version of the library. To include it, not to actually use it in any way.

So if you download the first major release of Bitcoin Core, you'll download the library that includes Schnorr.

The usual process is stuff gets merged into the master branch in GitHub, and every six months or so we say, "OK, let's stop at this point and release whatever is in there." So next time that'll include the Schnorr code. It'll be in there, but it might not do anything. It might have a few tests that try it, but if you don't run the tests, you're not going to run it.

The idea is to have Schnorr as part of Taproot. There are already pull requests that describe what Taproot is supposed to do. So maybe they'll go in the next version, so not in the upcoming one but the next one. What I would imagine happens is that it get added not to Mainnet, probably not even to Testnet, but to this new thing called Signet, which is a whole new type of way to do Testnet, which we can do another episode about. But basically, it'll go in as some innocent ways, so maybe there's just tests for it, tests for everything taproot related, and then anybody who knows how to compile code can just flip a switch and try it on their own machine, but it won't be on Mainnet or probably not even on Testnet. And then maybe next version, this stuff takes time.

Basically, you add all the code in it, so everything is in there but you don't activate it yet. Then, the next time you decide on activation mechanisms, and even those mechanisms might take a while.

### What Can You Do with Schnorr?

So we know that Schnorr simplifies signing, but it also makes other things possible. For example, you can perform math on it, meaning you can add numbers to both the signatures or to both the public and private keys, and then it still adds up, etc. This translates to more privacy and less block space use, both of which are good things.

This is also possible with ECDSA, but it's time-consuming, complicated, and potentially dangerous.

### MAST + Schnorr + TODO = Taproot

Even before Taproot, people wanted to add Schnorr because of all the things it enabled. But at some point, Bitcoin Core contributor and former Blockstream CTO Gregory Maxwell came up with a clever way of using Schnorr in combination with MAST.

Basically, because you can add anything to a public key, you can also add a script to a public key, because a script is essentially just a number and a private key is essentially just a number, so you can just add numbers.

An example of this would be if you forgot your own key. You could use some secret, which is a very bad idea, but let's say you would do that. So your script, your MASTs, would contain two options. Either it's you, your signature, or it's this secret piece of information that you wrote down somewhere else without a signature.

If you know your key, if you still have your private key, it's a shame to reveal the fact that you could have revealed the secret number. And so, what you can do now is, in Taproot, thanks to Schnorr, you can actually take this MAST and hide it inside your public key. And then, when you're signing the actual transaction, you're just signing a public key and you're not even revealing the fact that there's a Taproot out there. You're basically just ignoring it, because you just add the hash to your private key. You've added the hash to the public key, and nobody needs to know.

Anyone else doesn't see any difference between a tweaked public key and the original public key. So if you've tweaked your public key with this MAST structure, it looks the same to the rest of the world.

If you want to use this MAST structure, instead of revealing the tweaked key, you review the original key and you reveal the script, one of them.

Then, the person verifying can take that script, calculate the hash, calculate the other hash, add it up to the public key. Now, they can see that that's the tweaked public key, and they can see that the signature is valid for the whole thing. You can choose to not reveal anything, not even the tree itself, or you can reveal any part of the tree.

This option is space efficient, but it also means that if you're sending coins to somebody, it doesn't matter if you're sending to a single person, which is one key, or some super complicated exchange, or some other condition. It all looks the same.

With the example of you and your mom, if you accept Bitcoin with your mom this way, you'd combine your public keys. And you'd have a MAST structure, which includes the two constraints.

If you want to spend it and you both agree, you can both sign it, combine the signatures, and tweak it with the MAST Merkle root. What you publish will look like a regular signature for everyone else.

However, if there's a scenario where one of you doesn't sign, and those 35 years go by, at the end you can reveal that it was actually a tweaked public key. The rest of the world can look at that and say, "Yep. That adds up. The math makes total sense. That was what you were always doing; we just never were able to see it. Yep, 35 years have passed, so you're totally allowed to spend this money now on your own."

As a result, the condition is only revealed if you actually use it. Otherwise, it'll be a secret forever, unless somebody hacks your wallet.

The fact that you can have multiple conditions and only reveal one of those conditions is MAST. The ability to tweak things is Schnorr. But, this magic is combined, like Captain Planet, and now you can do all these things

#### Great, what are the cool features?

People can use this for the complicated scenarios we described.

Additionally, you can do multi signatures without script, because you can actually just combine multiple signatures, and there's some protocols for that.

The Taproot itself can be one signature, but it can also be a multisig, but just an M-of-N multisig, because there's just general math that you can use to combine signatures. That was possible; it's called threshold signatures in ECDSA. There's lots of papers about it and it's all very complicated, but with Schnorr, it should be slightly easier. By easier, I mean there's still only five people on the planet who can understand the math so they can write tools.

Aaron:
Collaborative spent. That's what we're calling it, right?

Sjors:
Yeah.

Aaron:
That can have a multisig? N-of-M, kind of?

Sjors:
There's a proposal called Musid. What it does, is it adds the signature.

Exactly. It combines signatures.

To the outside world, it looks like a regular public key and a regular signature. However, it's a combination of public keys that are then all signing, and you can add them up. In theory, I believe you can also do threshold things with that. That will still look like a single signature and a single public key, but actually, it's two out of three signatures. You don't have to bake it into the protocol; as long as you support Schnorr, somebody can come up with a way to combine these signatures, and to the outside world, it'll look the same.

Taproot enables these things, and it also makes Lightning more private. More specifically, with Lightning, both sides of the channel agree in an operation, and for the rest of the world, it looks like a normal transaction. But if they disagree, there are a lot of additional timeout conditions, which can be nicely hidden inside the Taproot.

Another benefit is that, if you have a payment on Lightning, it goes from hop to hop to hop. Right now, you reveal a pre-image, which is just something that you hash, and that thing is the same for every hop. Somebody who can see all the nodes can see that one payment belongs to the same person.

Aaron:
Or, if you're a spy on a route, on different parts of the route, you can see. You can connect to this [crosstalk 00:20:44], right? [crosstalk 00:20:44].

Sjors:
Yes. There's some exploits based on that, actually.

Aaron:
So that would be hard right now?

Sjors:
That would be more difficult, because instead of using a pre-image in a hash, you just use essentially public keys and private keys. Everything would just be points on the elliptic curve that you're adding up, and then every point along the route can tweak the number slightly differently. To an outside observer that does not know the private keys, they just look like random numbers. Now, they can still correlate the amounts, so there's still some problems remaining, but again, it's an increase in privacy, which is very nice. Yeah.

While it's true that some of the things you can do with Taproot are technically possible (but more complicated) already, there are some things Taproot unlocks.

For example, you can do infinitely large multisigs.

However, most people won't necessarily notice the difference, except that privacy will be slightly better. As these advanced options come along, they'll use them but not notice them.

---

Helpful Links:

The Power of Schnorr:

https://bitcoinmagazine.com/articles/the-power-of-schnorr-the-signature-algorithm-to-increase-bitcoin-s-scale-and-privacy-1460642496

Schnorr and Taproot workshop with text, video and interactive Python notebooks: https://bitcoinops.org/en/schorr-taproot-workshop/
