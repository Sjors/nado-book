\newpage
## libsec256k1 (Software Libraries)

Listen to Bitcoin, Explained episode 9:\
![](qr/09.png){ width=25% }

libsecp256k1^[<https://github.com/bitcoin-core/secp256k1>] is a library that some people might have heard about in passing, but many don't really understand it in depth, nor do they grasp its importance. This chapter will discuss what is it and why it matters for Bitcoin. But before tackling that, an overview of libraries in general would be helpful.

A library is a reusable piece of software. According to Techopedia^[<https://www.techopedia.com/definition/3828/software-library>], "A software library is a suite of data and programming code that is used to develop software programs and applications." An example of this in the cryptography world is OpenSSL: It's a piece of software that lets you perform a variety of cryptographic operations — from creating random numbers, to signing stuff with every curve under the sun. A library isn't an actual program itself, in that it doesn't do anything independently. However, other programs can use a library like OpenSSL — or a subset of it — to accomplish desired actions without having to write all the code themselves.

In the case of OpenSSL, users can download Bitcoin Core, which is the most popular software used to connect to the Bitcoin network. Its binary file contains Bitcoin Core-specific items, along with a lot of relevant libraries. And up until Bitcoin Core version 0.20.0, which was released in June 2020, the file came with the OpenSSL library. That's because Bitcoin still relied on OpenSSL — though much less than it had in the past.

But in the beginning, OpenSSL was in Bitcoin for everything cryptography related, such as signing transactions and generating secure random private keys. Satoshi had to pick one of the cryptographic curves offered by the library. For various reasons about which we can only speculate^[See "Choosing The Right Elliptic Curve" section in this article by (pre Ethereum) Vitalik Buterin: <https://bitcoinmagazine.com/technical/satoshis-genius-unexpected-ways-in-which-bitcoin-dodged-some-cryptographic-bullet-1382996984>], he picked the secp256k1 curve. As a result, he didn't have to write the necessary cryptographic functionality himself — which you never want to do yourself, because it's dangerous. Additionally, Satoshi didn't use Schnorr signature support, a topic that will be covered in Chapter @sec:schnorr, because OpenSSL didn't support it and there was no other library for it either.

With every Bitcoin Core release, the necessary library is included in the file you can download. Not all software includes all its libraries. The alternative is to make use of libraries that are already present on your computer, which makes the download smaller, as the library doesn't have to be redownloaded. However, this can create problems.

The most obvious problem of not including all libraries in the download, is that the user may not have one or more of the required libraries. They would then have to be instructed to download those, which is a bad user experience. As an aside, this is actually a common experience in the life of software developers, who spend much of their time chasing down libraries and other dependencies for the professional tools they try to install. The experience is often recursive, where each library in turn depends on yet another library.

Another concern is that libraries can and do change. The library on your system may be too old or too new. Critical things may have changed that cause the library to no longer be compatible with the program that relies it. The last thing you want when dealing with cryptographic stuff is to be surprised about what's on your computer.

Including libraries in the download means you always have the right version. This is why your computer probably contains many copies and versions of the same libraries.

But even when libraries are included in a download, things can go wrong when a software developer decides to update a library to a newer version.

Someone out there is maintaining the library. They don't have time to test each of their changes in every single software package out there that uses their library. So if you're not paying attention to what the library maintainer is doing — either by looking at changes in the release notes or checking out the code itself — they might break something.

Then, when you download the library along with the rest of Bitcoin Core from its website, your computer now uses that changed part of the library. But what if the Bitcoin Core developers didn't notice this particular change that happened to the library? Then all of the sudden, the stuff they wanted Bitcoin Core to do isn't actually happening.

Most breaking changes in libraries are accidents, but not all. Chapter @sec:guix goes deeper into the process of checking dependencies and attacks from rogue dependency maintainers.

A breaking change in how a library behaves is particularly problematic when it causes a change in the interpretation of the rules of the blockchain: Bitcoin Core would consider a particular block valid in one version of the library, and in another version, it would consider that same block invalid. This leads to a chain split^[<https://coinmarketcap.com/alexandria/glossary/chain-split>]. C

This is exactly what happened with a past version of Bitcoin Core: There was a bug in OpenSSL, which meant the developers of Bitcoin Core had to upgrade OpenSSL because the old version was simply no longer safe. But unbeknownst to the Core developers, there was another change in OpenSSL when they upgraded.

This particular change dealt with what happened with signatures and whether or not they're considered valid. The original version of OpenSSL was pretty relaxed, so it would accept signatures as valid even if they didn't meet the exact specifications. They wouldn't be signed by somebody else, so it wasn't about stealing funds, but it was more about the fact that the notation could be a bit sloppy.

Now, the new version was extremely picky. If you used Bitcoin software to create a transaction, that wasn't a problem, because any Bitcoin transaction was signed strictly, according to the protocol. And if you decided to validate these transactions using old software, it would see the sloppy version that was also made with the old software, and it wouldn't have an issue with the transaction. However, the new software would say it's invalid, because it doesn't accept these sloppy signatures. So all of a sudden, there's an accidental soft fork, which is what happens when previously valid transactions become invalid.

BIP 66^[<https://github.com/bitcoin/bips/blob/master/bip-0066.mediawiki>] is the direct result of this. Essentially, some developers became aware of this problem, and knowing there was an accidental software timebomb in the code, they proposed BIP 66 saying, "Oh, by the way, we should be stricter about what these signatures look like" without saying, "Oh, by the way, there's a bug in OpenSSL, so we better do this now." The push to fix it was to ensure they solved the problem before somebody found out and exploited the opportunity.

This isn't necessarily surprising, as OpenSSL is famous for its vulnerabilities. The main reason for this is because these libraries have been used by everyone for decades, but they're only maintained by a tiny number of volunteers on a shoestring budget.

cURL^[<https://github.com/curl/curl>] is another example of this. It's a library that downloads files, and it's used everywhere, but again, there isn't a well-funded team behind it. It's not good when the entire internet relies on something run by a few dedicated people without a big budget, but unfortunately, this is often the case.

In the case of OpenSSL, there have been plenty of bugs — and to add to that, it's easy to make mistakes with cryptographic code. What's more is OpenSSL is in C, so if you forget a semicolon, whoops, now you're skipping a line, and perhaps that line was actually checking the password. A famous example of this is the Heartbleed^[<https://gizmodo.com/how-heartbleed-works-the-code-behind-the-internets-se-1561341209>] bug from 2014, in which a small mistake made it so anyone with the know-how could log into any computer on the internet without a password.

The equivalent of something like that in Bitcoin could mean, "Oh, now we have a problem: Anyone can trigger a sudden network split." Chain splits can be triggered by all sorts of programming mistakes, not just changes in libraries. There have been a few close calls^[<https://blog.bitmex.com/bitcoins-consensus-forks/>].

While all this was happening, Pieter Wuille^[<https://github.com/sipa>] was working on a library that was specifically designed to create and verify Bitcoin signatures. His original motivation had nothing to do with security; he just wanted it to work faster than OpenSSL.

He explains this in a podcast he did with Chaincode^[<https://podcastaddict.com/episode/94276066>]. Basically, he wanted to make a library that would be about four times faster. He could have tried to modify the OpenSSL code itself, but it's such a nightmare to change that code. Additionally, the OpenSSL code is very generic: It has to support all different kinds of cryptography. So if you want to change anything, you have to be very abstract in all the things you do.

Instead, he decided to basically write it from scratch, specifically for the secp256k1 curve. It was added to Bitcoin Core relatively early — first just to verify signatures, and then later on to create signatures as well.

This happened to coincide with the aforementioned security vulnerability, and the general reaction was that because there was a near miss which could have been a serious problem, moving away from OpenSSL for critical matters would be a good idea. In turn, developers made the decision to get rid of that particular dependency over time by copying or rewriting the various parts of the library that Bitcoin Core needs. This process was completed^[<https://github.com/bitcoin/bitcoin/pull/17265>] in 2019.

So Wuille's libsecp256k1 — initially designed to be a performance improvement — pivoted to be a new library for Bitcoin that would remove the risks that came with OpenSSL. However, this came with two risks of its own:
 - Writing your own cryptographic library (this is dangerous outside of cryptocurrency, too).
 - Swapping out one critical library for another, because even the slightest difference in behavior could cause a chain split.

However, it was deemed a risk worth taking, because the other option was waiting for OpenSSL to explode. Additionally, a lot of good cryptographers reviewed libsecp256k1 and compared it against OpenSSL before its adoption. It's also used by Ethereum and other cryptocurrencies — basically, any cryptocurrency that uses the secp256k1 elliptic curve.
