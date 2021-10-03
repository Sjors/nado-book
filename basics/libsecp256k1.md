[libsecp256k1](https://github.com/bitcoin-core/secp256k1) is a library that some people might have heard about in passing, but many don't really understand it in depth, nor do they grasp its importance. This chapter will discuss what is it, why it matters for Bitcoin, and what it means that Schnorr signature support was merged into it in September of 2020. But before tackling that, an overview of libraries in general would be helpful.

A library is a reusable piece of software. An example of this is OpenSSL: It's a piece of software that lets you perform a variety of cryptographic operations — from creating random numbers, to signing stuff with every curve under the sun. A library isn't an actual program itself, in that it doesn't do anything independently. However, other programs can use a library like OpenSSL — or a subset of it — to do whatever they want without having to rewrite that stuff.

In the case of OpenSSL, users can download Bitcoin Core, which is the most popular software used to connect to the Bitcoin network. Its binary file contains Bitcoin Core-specific items, along with a lot of relevant libraries. And up until Bitcoin Core version 0.20.0, which was released in June 2020, the file came with the OpenSSL library. That's because Bitcoin still relied on OpenSSL — though much less than it had in the past. 

But in the beginning, OpenSSL was used for everything Bitcoin related. One of the main reasons it was needed is because Satoshi picked a cryptographic cure, the libsecp256k1 curve, because it was pretty and OpenSSL had support for it. As a result, he didn't have to write the necessary cryptographic functionality himself — which you never want to do yourself, because it's dangerous to do. Additionally, Satoshi didn't use Schnorr because there was no library for it. 

With every Bitcoin Core release, the necessary library is included in the file you can download. So there are two ways to go about update. The first is to make use of the preexisting library on your computer, which makes the download smaller, as the library doesn't have to be redownloaded. However, this can create problems, as libraries can and do change, and the last thing you want when dealing with cryptographic stuff is to be surprised about what's on your computer.

On the other hand, if you include the library in the download, that can also cause issues. This is because there's someone out there — a Bitcoin Core developer — maintaining the library, and if you're not paying attention to what that other person is doing, they might break something.

For example, assume a developer writes something in the code and they use some part of the library. Then, you download the library from the Bitcoin Core code, and that changed part of the library is used. The Bitcoin Core developers may not have noticed this particular change that happened to the library, and all of the sudden, the stuff they wanted Bitcoin Core to do isn't actually happening. 

This is exactly what happened with a past version of Bitcoin Core: There was a bug in OpenSSL, which meant the developers of Bitcoin Core had to upgrade OpenSSL because the old version was simply no longer safe. But unbeknownst to the Core developers, there was another change in OpenSSL when they upgraded. 

This particular change dealt with what happened with signatures and whether or not they're considered valid. The original version of OpenSSL was pretty relaxed, so it would accept signatures as valid even if they didn't meet the exact specifications. And they wouldn't be signed by somebody else, so it wasn't about stealing funds, but it was more about the fact that the notation could be a bit sloppy. 

Now, the new version was extremely picky. If you used Bitcoin software to create a transaction, that wasn't a problem, because any Bitcoin transaction was signed strictly according to the protocol. But if you decided to validate these transactions using old software, you'd see a sloppy version made with some other piece of software. And while the old software would be fine, the new software would say it's invalid. So all of a sudden, they had an accidental soft fork, which is what happens when previously valid transactions become invalid.

[BIP 66](https://github.com/bitcoin/bips/blob/master/bip-0066.mediawiki) is the direct result of this. Essentially, some developers became aware of this problem, and knowing there was an accidental software timebomb in the code, they proposed BIP 66 saying, "Oh, by the way, we should be stricter about what these signatures look like" without saying, "Oh, by the way, there's a bug in OpenSSL, so we better do this now."

This isn't necessarily surprising, as OpenSSL is famous for its vulnerabilities. The main reason for this is because these libraries have been used by everyone for decades, but they're only maintained by like one guy in Germany who doesn't get funded. 

[cURL](https://github.com/curl/curl) is another famous example of this. It's a library that downloads files, and it's used everywhere. But there's just one person maintaining it, and nobody's helping. It's not good when the entire internet relies on something like this, but unfortunately, this is often the case.

In the case of OpenSSL, there have been plenty of bugs — and to add to that, it's easy to make mistakes with cryptographic code. What's more is OpenSSL is in C, so if you forget a semicolon, whoops, now you're skipping a line. A famous example of this is the [Heartbleed bug](https://gizmodo.com/how-heartbleed-works-the-code-behind-the-internets-se-1561341209) from 2014, in which a small mistake made it so anyone with the know-how could log into any computer on the internet without a password.

The equivalent of something like that in Bitcoin could mean, "Oh, now we have a problem, everybody can just steal all the money." 

While all this was happening, [Pieter Wuille](https://github.com/sipa) was working on a library that was specifically designed to create and verify Bitcoin signatures. His original motivation had nothing to do with security; he just wanted it to work faster than OpenSSL.

He explains this in a [podcast he did with Chaincode](https://podcastaddict.com/episode/94276066). Basically, he wanted to make a library that would be about four times faster. He could have tried to modify the OpenSSL code itself, but it's such a nightmare to change that code. Additionally, the OpenSSL code is very generic: It has to support all different kinds of cryptography. So if you want to change anything, you have to be very abstract in all the things you do. 

So instead, he decided to basically write it from scratch, specifically for the secp256k1 curve. It was added to Bitcoin Core relatively early — first just to verify signatures, and then later on to create signatures as well. 

This happened to coincide with the security vulnerability, and the general reaction was that because there was a near miss which could have been a serious problem, moving away from OpenSSL for critical matters would be a good idea. In turn, developers made the decision to get rid of that particular dependency and write a new elliptic curve.

So Wuille's libsecp256k1 — initially designed to be a performance improvemen — pivoted to be a new library for Bitcoin that would remove the risks that came with OpenSSL. However, this was a risk in and of itself — but a risk worth taking, because the other option was waiting for OpenSSL to explode. Additionally, a lot of good cryptographers reviewed libsecp256k1 and compared it against OpenSSL before its adoption. It's also used by Ethereum and other cryptocurrencies — basically, any cryptocurrency that uses the secp256k1 elliptic curve.
