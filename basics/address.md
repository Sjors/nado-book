\newpage

<!---
(these comments won't appear in the PDF)
* SegWit (version 0) is explained in another chapter
* bech32m is used in the Taproot softfork (segwit version 1), which will be explained in another chapter
* lightning is mentioned at the end, also covered in other chapters
-->

## Bitcoin Addresses

Listen to Bitcoin, Explained episode 28:\
![](qr/28.png){ width=25% }

Bitcoin addresses aren't part of the Bitcoin protocol, rather they're conventions used by Bitcoin (wallet) software to communicate where coins must be sent to: either a public key (P2PK), a public key hash (P2PKH), a script hash (P2SH), a witness public key hash (P2WPKH), or a witness script hash (P2WSH). Addresses also include some metadata about the address type itself.

Bitcoin addresses communicate these payment options using their own numeric systems, and this chapter will break down what these different systems mean. It'll also delve into some of the benefits of using Bitcoin addresses in general and bech32 addresses specifically — particularly how the first version of bech32 addresses included a (relatively harmless) bug, and how a newer standard for bech32 addresses has fixed this bug.

### Some History

When you send Bitcoin to someone, you're creating a transaction that has a lot of inputs and an output, and the output specifies who can spend it. In theory, you could say anybody could spend it, but that's not a good idea. So what you do is put a constraint on it. And the very first version of that constraint was that whoever had the public key could spend the coins. This is called a Pay-to-Public-Key (P2PK).

In the past, it was possible to send Bitcoin to people’s IP addresses, although it hasn’t been a feature^[<https://en.bitcoin.it/wiki/IP_transaction>] since 2012. When this was possible, you could connect to someone's IP address and ask for a public key, and the person would give you the public key, which is where you sent the bitcoins. Today this workflow might seem strange, but it matches the then common pattern of peer-to-peer apps like Napster or Kaza, where you'd connect directly to other people and download things from them. Nowadays you probably don't know the IP address of your friends, and it might even change all the time when they're on mobile.

Although you can instruct your Bitcoin node to specifically connect to your friends node, it typically just connects to random peers (see chapter @sec:dns). Perhaps in the beginning the idea might have been to connect to peers you know, and then you might as well do transactions with them. But right now, you don't really do transactions with the peers you're directly connected to. At least not on Bitcoin on-chain.

Instead a transaction makes it way through all the nodes on the network (see chapter @sec:mempool), eventually to be seen by a miner node which includes it in a block. Your counter party may see the transaction as their node receives it from one of its peers, or they'll see it once they receive the block its in.

Another way of doing transactions was by mining bitcoins, which means sending the block rewards to your public key. In the beginning, Bitcoin had a piece of mining software built into the software, so if you downloaded the Bitcoin software, it would just start mining.

Later on, there were mining pools, and it all became more professional. For example, the payout would likely go to a multi-signature address, from which it would be paid back to the individual pool participants. Or it could be paid directly to the pool participants, although that's a bit inefficient, because you'd need a long list of addresses in a coinbase.

The P2PK way of paying someone was only ever really used for paying to IP address and for the miner, the block reward. Otherwise what was used was Pay-to-Public-Key-Hash (P2PKH). In this scenario, you're not sending money to a public key, but rather to the hash of that public key.

And this is where addresses come in, because this type of payment actually used addresses for the first time. Not for the first time, this was always there. Also something I learned while doing a little bit of research. This was there since day one. There were Bitcoin addresses since day one, but they were only there for Pay-to-Public-Key-Hash.

The script on the Bitcoin blockchain required that the person spending it had the public key belonging to the hash.

There were a couple of benefits to the P2PKH. The first was that it was thought to be safer against quantum attacks, because you didn't have to say which public key you had. The second was that it's a little bit shorter, so it saves a bit on block space, although of course that wasn't an issue back then, because blocks where nowhere near full.

As an aside, many people are worried that quantum computers will eventually break the security offered by Bitcoin's cryptography, allowing future quantum hackers to steal coins, potentially crashing the market if they steal millions^[Pieter Wuille estimates the total amount of vulnerable coins at 5 to 10 million BTC in this Twitter thread: <https://twitter.com/pwuille/status/1108085284862713856>] of very old coins at the same time. Ironically this means P2PKH is not very useful, and blockspace is much scarce now. So with the new Taproot softfork (discussed in later chapters), Bitcoin addresses will be P2PK again^[Full rationale in BIP 341: <https://github.com/bitcoin/bips/blob/master/bip-0341.mediawiki#cite_note-2>]. The (un)likeliness of such quantum troubles in the near future, as well as possible countermeasures, is explained in two What Bitcoin Did podcast episodes, one with physicist Stepan Snigirev^[<https://www.whatbitcoindid.com/podcast/the-quantum-threat-to-bitcoin-with-quantum-physicist-dr-stepan-snigirev>] and another with mathematician Andrew Poelstra^[<https://www.whatbitcoindid.com/podcast/andrew-poelstra-on-schnorr-taproot-graft-root-coming-to-bitcoin>].

What you see on the blockchain itself, what's recorded on the blockchain is the actual hash of a public key. However, when you're getting paid on a public P2PKH, what you're sharing with someone is the hash, but it's done using an address. And this type of address is essentially the number one, followed by the hash of the public key. But it's encoded using something called base58.

To understand what base58 is, it's important to first understand more about base systems in general.

### Base Systems Explained

With base10, think about your hand. You have 10 fingers. So if you want to, for example, express the number 115, you can make three gestures with your hands by showing a one and a one and a five. That's base10, because you're using your 10 fingers three times. That's also how you write down numbers. But because we're not actually using fingers most of the time, this means is we have a decimal system with 10 different symbols that represent a number.

There are 10 symbols, which means that once you get to the 11th number, you have to start reusing symbols you're already used, and this is done with different combinations.

However, there have been — and still are — different bases. For example, the Babylonians^[<https://blogs.scientificamerican.com/roots-of-unity/ancient-babylonian-number-system-had-no-zero/>] used base 60. And to read machine code, typically you’d use hexadecimal^[<https://en.wikipedia.org/wiki/Hexadecimal>], which is base16 — zero to nine, and then A to F. Meanwhile, computers tend to use base 2 internally — a binary number system — because transistors are either on or off. This translates to using two digits, either zero or one, to do everything, and you can express any number with that.

Satoshi introduced^[<https://tools.ietf.org/id/draft-msporny-base58-01.html>] base58, which uses 58 different symbols: zero through nine, and then most of the alphabet in both lowercase and uppercase. But there are some letters and numbers that are skipped because they're ambiguous and users could easily mistake them for the wrong one — for example, the number zero, the uppercase letter O, capital I, and lowercase l.

Have you ever seen email source code for an attachment or similar? There are a lot of weird characters. That's base64, and base58 is based on that. But base64 includes characters like underscores, plus, equals, and slash. These are omitted in base58 to make visual inspection easier and behave nicely as part of a URL.

### Base58 and the Pay-to-Public-Key-Hash

So how does this relate to P2PKH?  Well, the address is expressed as a one, followed by the public key hash, which is expressed in base58.

That's the information you send to somebody else when you want them to send you Bitcoin. You could also just send them 0x00 ^[a pair of hexadecimal digits, prefixed by 0x, is often used to denote bytes, which contain 16 x 16 = 256 bits, so this represents one byte with the value zero], and then the public key. And maybe they would be able to interpret that, but probably not.

In theory, you could send somebody the Bitcoin script in hexadecimal, the format used on the blockchain, because that's just binary information. The blockchain has this script that says, "If the person has the right public key hash and the public key belonging to this public key hash, then you can spend it." To learn more about how Bitcoin scripts work, refer to Chapter @sec:miniscript.

But even with all these options, the convention is that you use this standardized address format, which explains why all traditional Bitcoin addresses start with a one, and why they're all roughly the same length.

In addition to using base58 for sending a Bitcoin address, you can also use it to communicate a private key. In such a scenario, the leading symbol is a five, though that represents 128. That's then followed by the private key.

This is because, in the past, users had paper wallets they could print. And if they were generated securely without a back door, then on one side of the piece of paper would be something starting with a five, and on the other side of the paper would be something starting with a one. And then it would say something like, "Show this to other people. And don't show this to other people."

There are also addresses that begin with a three. Usually they're multi-signature addresses, but they could also be single-signature addresses, or even SegWit addresses^[As explained below, SegWit typically uses bech32 addresses. But it took a long time for all wallets and exchanges to support sending to bech32 addresses. In order to still take advantage of some of SegWit's benefits (see Chapter @sec:segwit) an address type was introduced that looks like regular P2SH to the sender, but contains SegWit magic under the hood. This is called a P2SH-P2WPKH address: <https://bitcoincore.org/en/segwit_wallet_dev/>]. This signifies a Pay-to-Script-Hash (P2SH), which means the person needs to not only have the script belonging to the hash, but also be able to solve the scripts.

This was all well and good, until something new showed up.

### Along Came Bech32

In March of 2017, Pieter Wuille spoke about a new address format^[<https://www.youtube.com/watch?v=NqiN9VFE4CU>], bech32, and it's been used since SegWit arrived on the scene. It isn't something that exists on the blockchain, rather it's a convention wallets can use. As the name suggests, it's a base 32 system, which means you have almost all the letters, and almost all the numbers, minus some ambiguous characters that you don't want to have because they look too much like numbers or letters.

One of the biggest differences between bech32 and base58 is that there isn't a mixture of uppercase and lowercase letters. Instead, each letter is only in there once, which makes reading things out loud much easier. The other difference is it doesn't start with a specific number, making it appear arbitrary. It begins with bc1 or bc1q, but after that it could be anything. So the value zero is written as a Q, the value one is written as a P, the value two is written as a Z, etc.

If there is a human interpretation that depends on it, then you don't want to do anything confusing. But if your only goal is to make it easy to copy paste things, and if your other goal is for every address to start with bc1q, because bc1 sounds cool, then maybe there's a reason why you want to do them out of order.

Moving on, so there's a set of 32 characters. But it's doing the same thing, right? It's again saying, "OK, here's a P2Pk address. In this case, a Pay-to-Witness-Public-Key-Hash (P2WPKH) because it's using SegWit, but it's the same idea. Public key hash." So it says, "Hello," followed by the hash of the public key.

There's something called the human-readable part, and that doesn't really have any meaning, other than that humans can recognize, "OK, if the address starts with bc, then it refers to Bitcoin as the currency." And the software of course can see this too, but both humans and software can understand this.

The 1 is just a separator with no value. And if you look at the 32 numbers, 1 isn't included — it means "skip this."

Next it starts with the SegWit version, zero, which translates to q in bech32. This is followed by 20 bytes or 32 bytes, which means it's either the public key hash or the script hash, respectively. And they're different lengths now, because SegWit uses the SHA256 hash of the script, rather than in the RIPEMD160 hash of the script.

In base58, the script hash is the same length as the public key hash. But in SegWit, they're not the same length. So by looking at how long the address is, you immediately know whether you're paying to a script or you're paying to a public key hash.

However, conciseness isn't the only benefit here. Another is error correction. In base58, there's a check sum, which means you add something to the address at the end. And that way, if you make a typo, the check sum at the end of the address won't work. There is of course a very low chance of having an unlucky typo in which it has a correct check sum, but it has happened.

With bech32, it won't just tell you that there's a typo; it'll tell you where the typo is. This is determined by taking all the bytes from the address and then hashing it, using some sophisticated mathematical magic ^[Math behind bech32 addresses: <https://medium.com/@MeshCollider/some-of-the-math-behind-bech32-addresses-cf03c7496285>]. You can make about four typos and it'll still know where the typo is and what the real value is. If you do more than that, it won't.

To illustrate this better, it's like if you have a wall and you draw a bunch of non-overlapping circles on it, and each circle represents a correct value. If you throw a dart at it, you might hit the bullseye, and you'll know you have the right value. Or, you might just slightly miss the bullseye but you're still within that big circle, and then you know exactly where it should have been.

The idea there is you want the circles to be as big as possible obviously, but you don't want to waste any space. So that's an optimization problem in general. And of course, in the example of a two-dimensional wall with two-dimensional circles, it's pretty simple to visualize. Right? You throw the dart and you see, "OK, it's still within the big circle, so it should belong to this dot." So that is like saying, "OK, here's your typo and this is how you fix it." And then in the case of bech32, instead of a two-dimensional wall you have a 32-dimensional wall, and the circles are also probably 32-dimensional hyperspheres

So now with bech32, you're hitting your keyboard, and somewhere in that 32-dimensional space you're slightly off, but you're still inside this sphere, whatever that might look like. And so it knows where the mistake is.

### But... There's a Problem

If your bech32 address ends with a P, then you can add an arbitrary number of qs to it, and it still will match the check sum, and you won't be told there's a typo. In turn, your software would think it's correct, you'd be sending money to the wrong address, and it would be unspendable.

The good news is that there's another constraint for the original version of SegWit, SegWit version zero, which is that an address is either 20 bytes or 32 bytes. And because it's constrained, if you add another q to it, then it's too long. So you still know it's wrong.

All in all, this kind of mistake is unlikely to happen with SegWit version zero. Of course, with future versions of SegWit, such as Taproot, the prefix would be bc1p, because P is the version one. And I believe for Taproot there's also a constraint in how long these addresses are supposed to be.

So it's still not an acute problem, but in the future, maybe there will be a need to have addresses that are somewhat more arbitrary in length, because maybe you'll want to add some weird conditions to it. Or you'll want to communicate other information, and not just the address. Maybe you'll want to put the amount inside the address.

### Luckily, There's Also a Solution

So this is why there's a new standard proposed BIP 350, which is called bech32m^[BIP 350 is the spec for bech32m: <https://github.com/bitcoin/bips/blob/master/bip-0350.mediawiki>]. And it's actually a very simple change. It adds one extra number to that math, and then it fixes that particular bug, and everybody's happy, because you can add things to the address without running into problems.

This fix comes with a minor annoyance, which is that if your wallet wants to support sending to a Taproot address, it has to make a small change to the bech32 implementation. And there's some example code on the BIP. It's not a big change because it just adds one number. And if you look at the Bitcoin Core implementation, it's a fairly simple change that does it.

But it does mean that, moving forward, when you see a bech32 address, you have to parse it, then see if it's the version zero or the version one, and then do things slightly differently. In turn, it means that, especially for hardware wallets with firmware updates, it could take a while.

With all these changes, and the shift from base58 to bech32, there's the question of if a new address format could come to replace bech32. However, it seems unlikely to happen — at least for a long while.

Of course, there could actually be more information inside an address, such as is the case with Lightning invoices, which is discussed in Chapter TODO. Lightning invoices use bech32, but they're much longer because they contain a lot more information. They contain the public key, the amount, the deadline, and a bunch of secrets. They contain all sorts of stuff, all sorts of routing hints even. It's like a whole book you're sending over.
