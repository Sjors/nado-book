\newpage
## Schnorr Signatures and Libsec256k1

![Bitcoin, Explained ep. 9](qr/09.png)

(continues from basics/libsecp256k1)

<!--

Aaron Van Wirdum:
BIP 340 support was merged into libsecp256k1 this week.

Sjors Provoost:
What was merged?

Aaron Van Wirdum:
Shut up.

Sjors Provoost:
Schnorr was added.

...


Aaron Van Wirdum:
Yeah, so BIP 340 was merged, which is Schnorr.

Sjors Provoost:
Exactly.

Aaron Van Wirdum:
This has been in development for a long time as well I think for years. So this is also a new implementation, so this is the first time Schnorr has been included in any library because you just mentioned that it wasn't-

Sjors Provoost:
I don't know about any library, but at least at the time when Bitcoin was created, there was no library for Schnorr or at least it wasn't in OpenSSL, which is a widely tested library. You wouldn't just want to randomly download, "Oh look, somebody implemented Schnorr." So what happened is, I think Satoshi was aware of Schnorr but there was a patent on it and there was no implementation, so it was kind of both of these things. Because I think the patent was actually expired in 2008.

Aaron Van Wirdum:
Yeah, I think it just lapsed or something, yeah.

Sjors Provoost:
Yeah. But either way, you don't just want to write this stuff from scratch. And if you try and develop a world changing thing, you don't want to then spend three years just implementing the cryptography, given how long it takes to really do this. But actually Schnorr is simpler, and I think we may have explained this in an earlier episode.

Aaron Van Wirdum:
You mean simpler than?

Sjors Provoost:
Than ECDSA.

Aaron Van Wirdum:
Which is the elliptic curve algorithm, that Bitcoin currency currently uses.

Sjors Provoost:
Right, and which the libsecp library implements. But the thing is, you have the same elliptic curve but then in order to make a signature, you have to do slightly different calculations with it. So that also means that the change for Schnorr is not as complicated as, say the initial version of libsecp was. The initial version of libsecp had to implement the curve, all the operations you can do in a curve like addition and multiplication, and then implement the signature algorithm of ECDSA. But in order to do Schnorr, you just need to do the signature algorithm for Schnorr, you don't have to do all the math, the basic foundational math. So it's not a huge change, it's not like adding a whole new curve to it. It would be much more difficult to add, say, a different elliptical curve or even a completely different kind of curve than it is to change just from ECDSA to Schnorr, it's a different way of signing, and in fact a simpler way of signing.

Aaron Van Wirdum:
Okay. So this was implemented, again, by Pieter Wuille, I assume, well I know, right?

Sjors Provoost:
The spec was written by him, I think he also wrote most of the implementation, but there's a lot of people on top of that.

Aaron Van Wirdum:
There's others, sure. And it was merged this week. So what does that mean exactly, where does this get us?

Sjors Provoost:
Right. So what that means is there now is an updated version of this library, but nobody's using that library yet. And another change is that Bitcoin Core was changed I think a few days ago to include that new version of the library. To include it, not to actually use it in any way.

Aaron Van Wirdum:
So the first major release of Bitcoin Core, when you download that you'll download the library that includes Schnorr.

Sjors Provoost:
Exactly, because the usual process is stuff gets merged into the master branch in GitHub and every six months or so we say, "Okay, let's stop at this point and release whatever is in there," and so next time that'll include the Schnorr code. Yeah, it'll be in there, it might not do anything. It might have a few tests that try it, if you don't run the tests you're not going to run it.

Aaron Van Wirdum:
Yeah, the next Bitcoin Core release is not going to use Schnorr yet, is your prediction here. That's your bold prediction?

Sjors Provoost:
I would say it would be extremely reckless if it did. But there are projects that use it, certain Bcash coin uses Schnorr, I believe.

Aaron Van Wirdum:
Oh yeah, I think so.

Sjors Provoost:
But the actual spec for Schnorr was changed a little bit, so I don't know if they're going to change along with it or not. Not a huge change.

Aaron Van Wirdum:
So anyways, it's going to include a library next time you download it. You're downloading this but it doesn't actually do anything probably, or not anything too important. But that would be a next step then. Like I want to excite our audience. We're getting somewhere, right?

Sjors Provoost:
Yeah, we are.

Aaron Van Wirdum:
That's the plan, right?

Sjors Provoost:
So the idea here, of course, is to have Schnorr as part of taproot. So the entire taproot thing, there are already pull requests that describe what it's supposed to do, not completely finished but pretty far along. So maybe they'll go in the next version, so not in the upcoming one but the next one. What I would imagine happens is that it get added not to Mainnet, probably not even to Testnet, but to this new thing called Signet, which is a whole new type of way to do Testnet, which we can do another episode about. But basically, it'll go in as some innocent ways, so maybe there's just tests for it, tests for everything taproot related, and then anybody who knows how to compile code can just flip a switch and try it on their own machine, but it won't be on Mainnet or probably not even on Testnet. And then maybe next version, this stuff takes time.

Aaron Van Wirdum:
Isn't that exciting our audience? Got to pump it, got to pump this coin Sjors.

Sjors Provoost:
I'm pumping low time preference. This stuff takes a long, long time. But basically you add all the code in it, so everything is in there but you don't activate it yet, and then the next time you decide on activation mechanisms, and even those mechanisms might take a while.

Aaron Van Wirdum:
That's a whole debate on its own, which we did an episode about, right, if I'm not misremembering?

Sjors Provoost:
Yes.

Aaron Van Wirdum:
Okay. So, that's what a library is. That's what a libsecp256k1 library specifically. Now you also know what Schnorr is, actually we didn't even get into what Schnorr is. Did we do that in a previous episode?

Sjors Provoost:
I can briefly recap.

Aaron Van Wirdum:
Sure, go for it.

Sjors Provoost:
So it's simpler.

Aaron Van Wirdum:
What's Schnorr actually Sjors?

Sjors Provoost:
So what happened is there was this patent on this very simple system called Schnorr by a person called Schnorr, and it was very nice, it was a good way to make electronic signatures, but there was a patent on it. So people came up with a way to convolute the design, make it more complicated, such that it would no longer fall under the patent. So when the lawyers said, "Okay, this looks obscure enough," so they were just adding numbers to it and abstracting things, just making it more complicated. And then it didn't violate the patent and so they shipped it. But now we ended up with this horrible thing that is basically proof of lawyer, convoluted mess, and now that the patent's expired we just go right back to the original design, which is much better. And mainly it's better because you can add signatures much more easily, and adding signatures is very nice.

Aaron Van Wirdum:
Yeah, you can perform math on it.

Sjors Provoost:
Yeah, you could perform math on the original one, you'd be able to publish papers just on the ability to add two numbers.

Aaron Van Wirdum:
Right. Yeah, so for the layman listener, performing math on it just means you can do cool mathematical tricks like add numbers to both the signature or both publicly key and the private key and then it still adds up and still works or you can add signatures or all that kind of cool stuff.

Sjors Provoost:
Yeah, which in the end translates to more privacy and less block space usage, so it's all good.

-->

Helpful Links:

The Power of Schnorr:

https://bitcoinmagazine.com/articles/the-power-of-schnorr-the-signature-algorithm-to-increase-bitcoin-s-scale-and-privacy-1460642496
