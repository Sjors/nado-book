\newpage
## Libsec256k1 (software libraries)

Listen to Bitcoin, Explained episode 9:\
![](qr/09.png){ width=25% }

<!--

Aaron Van Wirdum:
We're going to discuss libsecp25, it's a long name.

Sjors Provoost:
Libsecp256k1.

Aaron Van Wirdum:
And we're going to explain what this library actually is or why it exists or what it does. And the reason we're going to explain that is because I actually didn't know that much about it. It's one of these things for me that I heard about and I kind of know what it is, but I never really got into it to any sort of serious extent. Okay, libraries first of all. Let's start with libraries.

Sjors Provoost:
Let's talk about libraries.

Aaron Van Wirdum:
There's a thing called software libraries. And I'll just let you explain what a software library is, first of all. So for any programmer that's listening, this is probably going to be very noobish for you, but for people like me this is actually kind of interesting.

Sjors Provoost:
The easiest way to explain the library is it's a reusable piece of software. So yeah, for example OpenSSL is a library we'll talk about. It is a piece of software that lets you do all sorts of cryptographic operations from creating random numbers to signing stuff with every curve under the sun. But it's not an actual program, it doesn't really do anything by itself, but other programs can use a library to do whatever they want without having to rewrite that stuff.

Aaron Van Wirdum:
Or I assume you can take part of the library, not necessarily the whole library, but get a specific.

Sjors Provoost:
You take the entire library but you use a subset of it.

Aaron Van Wirdum:
Exactly, yes. So Bitcoin was at some point in the past relying on OpenSSL.

Sjors Provoost:
Yeah, until actually very recently, a few months ago. But for less and less and less stuff. So in the beginning, OpenSSL was used for all the things. In particular, the reason it was needed is because Satoshi picked a cryptographic cure, the libsecp256k1 curve because it was pretty and OpenSSL had support for it. So he did not have to write all this cryptographic functionality, which of course you never want to do yourself because it's very dangerous to write your own cryptographic stuff. And this is also a reason why he didn't use Schnorr because there was no library for it. There were other reasons, but this was a reason, a very practical reason.

Aaron Van Wirdum:
So just to be clear, when you say Bitcoin Core Satoshi used this library, the OpenSSL library, like how does a software program actually use a library?

Sjors Provoost:
You just Google on Stack Overflow how to use OpenSSL and then you just look at the examples.

Aaron Van Wirdum:
Let me rephrase the question. Where is the library?

Sjors Provoost:
Oh, the library is included in the software package when you download it. And the binary file contains some of the Bitcoin Core specific stuff, and then a whole bunch of libraries, and that's what makes it so big, around 20 megabytes.

Aaron Van Wirdum:
Right, so when you download Bitcoin Core, the software, Bitcoin Core 20 is the newest one I guess, then you actually download, when in this case now OpenSSL anymore, but for Bitcoin 19 you actually downloaded a whole OpenSSL library.

Sjors Provoost:
Yeah, that's correct.

Aaron Van Wirdum:
And then it's hosted on your computer from that point on, just you have the library on your computer, your real computer.

Sjors Provoost:
Right. Now there is two ways to go about that. You can have a library sitting on your computer already, and then software can say, "Let me just see if I can find that library and I'll use that." Then your download gets smaller. But the problem is that libraries change and so you don't want to be surprised about what's on the computer, especially with cryptographic stuff. And even if you include in the download, you can be surprised by what happens to the library because somebody else is maintaining that library and if you're not paying attention to what that other person is doing, they might break something very bad.

Aaron Van Wirdum:
Right. So in the case of, let's stick to Bitcoin Core 19.

Sjors Provoost:
Well, in this case maybe take an older one because I think it was Bitcoin Core 0.8 or something.

Aaron Van Wirdum:
Let's take Bitcoin Core, I don't know where you're going with this, but lets take that one.

Sjors Provoost:
Yeah.

Aaron Van Wirdum:
So someone else is maintaining this library?

Sjors Provoost:
Yeah.

Aaron Van Wirdum:
Bitcoin Core developers are maintaining Bitcoin?

Sjors Provoost:
Yeah.

Aaron Van Wirdum:
They write something in the code, they use some part of the library, you download the library from the Bitcoin Core code, the part of the library is used, and then the Bitcoin Core developers may not have noticed some change that happened to the library and all of the sudden the stuff they wanted Bitcoin Core to do isn't actually doing what they wanted Bitcoin Core to do because the library wasn't doing what they thought it would do because someone else was maintaining the library. Is that a correct summary?

Sjors Provoost:
Yeah, that's right. And to clarify what specifically happened here...

Aaron Van Wirdum:
You picked Bitcoin Core 8 because there was a specific example you wanted to go to.

Sjors Provoost:
Yeah, I might be wrong about the number because Bitcoin Core 8 had a different problem. But sort of around that time, there was another bug in OpenSSL that I believe was unrelated to the problem that happened. But they basically had to upgrade OpenSSL because the old version was simply not safe. But unbeknownst to the Core devs, there was another change in OpenSSL when they upgraded. And in particular, this was about when you see a signature, do you consider it valid or not? And the original version of OpenSSL was pretty relaxed, so it would accept signatures as valid even if they did not meet the exact spec. And they wouldn't be signed by somebody else, so it wasn't about stealing funds, but it was just you could be a little bit sloppy about maybe you add a byte to the signature or maybe not. So the notation could be a bit sloppy. And the new version was very picky. Now, if you use Bitcoin software to create a transaction, that was not a problem, because any Bitcoin transaction was signed very strictly according to the protocol. But if you are now validating these transactions, if you use old software and you would see a sloppy version that was made with some other piece of software, the old software would be fine, the new software would say it's invalid. So all of a sudden you have an accidental soft fork.

Aaron Van Wirdum:
Right. And that's what actually happened.

Sjors Provoost:
Well, yes.

Aaron Van Wirdum:
That's the BIP 66 one? Is that what we're talking about here?

Sjors Provoost:
Correct. BIP 66 was introduced because people became aware of this problem, at least some of the developers became aware of this problem. So they knew there was an accidental software time bomb basically in the code, and so they proposed BIP 66 saying, "Oh, by the way, we should be more strict about what these signatures look like," without saying, "Oh, by the way, there's a bug in OpenSSL so we better do this now."

Aaron Van Wirdum:
Oh, it was like a secret bug fix of the problem with OpenSSL?

Sjors Provoost:
Yes.

Aaron Van Wirdum:
I don't think I knew that, okay.

Sjors Provoost:
Well, yeah. OpenSSL essentially improved itself by becoming more strict, but that made it a consensus change because what's consensus code it's also whatever your libraries are doing. So basically OpenSSL introduced a soft fork but without saying, "Oh, there's no deployment date in the OpenSSL update," it just randomly happened.

Aaron Van Wirdum:
Right, so that's a great example of why a dependency because that's the official term is a problem.

Sjors Provoost:
Yeah, exactly.

Aaron Van Wirdum:
This is a good example of that. And there have been more problems with OpenSSL I think.

Sjors Provoost:
I mean, OpenSSL is famous for its vulnerabilities, and you know the main big reason behind that is that these libraries are used by everyone for decades, but they're only maintained by like one guy in Germany who doesn't get funded. It's just like cURL is another famous example of that, it's a library that downloads files, cURL it's used everywhere, it's probably used in the space shuttle. But there's just one guy that maintains it and nobody's helping. And it's not good when the entire internet relies on it. And in the case of OpenSSL, yeah there have been plenty of bugs and it's very easy to make mistakes with cryptographic code. And it's written in C, so you forget a semicolon, whoops, now you're skipping a line. So one of the bugs that was called Heartbleed.

Aaron Van Wirdum:
Yeah, that was fairly recent, a couple years ago.

Sjors Provoost:
Yeah, a couple years ago. I think it was a missing colon or literally just one character mistake that allowed you to log into into any computer on the internet.

Aaron Van Wirdum:
Effected everything.

Sjors Provoost:
Without a password. That's the sort of severity. And something like that in Bitcoin of course could mean, "Oh, now we have a problem, everybody can just steal all the money." At the same time, Pieter Wuille was working on a library.

Aaron Van Wirdum:
For our American and English listeners, that's Peter Wuley or however they want to pronounce it.

Sjors Provoost:
Yeah, or sipa or sippa.

Aaron Van Wirdum:
Pieter Wuille, go on.

Sjors Provoost:
He was working on a library, so a piece of software, that was specifically designed to create and verify Bitcoin signatures. And his original motivation was just to do it faster than OpenSSL.

Aaron Van Wirdum:
Okay, so it wasn't a security motivation, it was just a performance improvement motivation.

Sjors Provoost:
Exactly, he explains this in a podcast he did with Chaincode, so if you Google that, or it might be in the show notes. Basically, he wanted to make it, I think about four times faster and he could try and modify the OpenSSL code itself, but apparently it's such a nightmare to change any of that code and also the OpenSSL code is very generic, it has to support all different kinds of cryptography. So it's more difficult, if you want to change anything you have to be very abstract in all the things you do. So it's just like when you write a law, you can't just say, "John can't go to the supermarket," you have to say something like, "Well, anybody over 20 centimeters in size cannot go to the supermarket." So it's very difficult to write these abstract documents. So he basically wrote it from scratch, specifically for that curve, and it was added to Bitcoin Core I think pretty early, but just to verify signatures, and then later on also to create signature. And that coincided with the security vulnerability. But I don't think it was the cause of it, it was sort of around the same time. It was like, "Okay, we've had this near miss, we could have had a serious problem, let's not use OpenSSL for that critical stuff anymore."

Aaron Van Wirdum:
Yeah, so then the goal was to get rid of that dependent, now I forget the word.

Sjors Provoost:
Yeah, to get rid of the dependency.

Aaron Van Wirdum:
Dependency.

Sjors Provoost:
Exactly.

Aaron Van Wirdum:
And writes a whole new cryptographic software library for Bitcoin.

Sjors Provoost:
Right. It's just the curve.

Aaron Van Wirdum:
Just eliptic curve, just the thing that's used for signatures.

Sjors Provoost:
Yeah, because there's other cryptographic code in the Bitcoin Core code base. For example, SHA-256 is in there and a few other curves. And I think those were originally also from OpenSSL. Those things are a little bit less scary, you can implement SHA-256 in a day if you're bored in any programming language.

Aaron Van Wirdum:
Does it still use libraries for that though or was that rewritten?

Sjors Provoost:
No, so SHA-256, as far as I know, is directly in the code. So it's just copy pasted from somewhere and then improved.

Aaron Van Wirdum:
Right, got it. So libsecp256, am I saying that right?

Sjors Provoost:
Libsecp256k1.

Aaron Van Wirdum:
Thank you, that was meant as a performance improvement, then it was pivoted to actually be a new library for Bitcoin or at least sort of Bitcoin specific library to get rid of this dependency? You mentioned this before, but isn't that also a risk? Like rolling your own crypto?

Sjors Provoost:
Absolutely, absolutely. So the fact that this thing was reviewed by a lot of people, a lot of good cryptographers before adding it, and I think it was also compared against OpenSSL in terms of using the same tests. But yeah, at some point you have to take that risk because the other one is just waiting for OpenSSL to explode.

Aaron Van Wirdum:
Plus it was Pieter Wuille, so can't really go wrong with that.

Sjors Provoost:
Well, you'll want to have proof of wuille. But a lot of very smart people looked at it, probably the same people who would also look at OpenSSL. So that's good, but you don't want to make a habit of this, and in fact they do constantly make very small tweaks to that library to make it a little bit faster, but you want to be very careful with that.

Aaron Van Wirdum:
Right. Okay, so that's the library. Bitcoin has its own library now. Is this used by any other programs?

Sjors Provoost:
But keep in mind is turtles all the way down, because OpenSSL is also just written by people. So everything is an implementation at some point.

Aaron Van Wirdum:
Sure.

Sjors Provoost:
Okay, so your question?

Aaron Van Wirdum:
I guess my first question would be, is this library used by anything other than Bitcoin?

Sjors Provoost:
Yes, so this library is, I just heard it on a podcast with Vitalik, it's also used by Ethereum and a whole bunch of other cryptocurrencies. Basically any cryptocurrencies that uses the secp256k1 elliptic curve, which is just a nice mathematical object.

Aaron Van Wirdum:
Right mostly cryptocurrencies though, only cryptocurrencies. It's pretty cryptocurrency specific, at least.

Sjors Provoost:
Yeah, I'm not aware of any non-cryptocurrency project that uses it. It could. It's just a library that allows you to sign stuff, sign messages and verify the signature on a message. So you could write an encrypted chat application that uses this curve if you wanted to, but I don't know, I guess the encrypted chat applications out there might have their own curve that they use for their thing, I don't know what Signal uses, but they could.

Aaron Van Wirdum:
Yeah. Okay, so that's libsecp256k1, I keep having to pronounce this.

Sjors Provoost:
Yeah, we'll just splice it in the audio later.

Aaron Van Wirdum:
I'll just call it libsec. Is there anything else that's called libsec that would confuse people?

Sjors Provoost:
Libsecp.

Aaron Van Wirdum:
Libsecp, okay. So libsecp. Is that everything we need to know about libsecp?

Sjors Provoost:
I think so.

Helpful Links:

Pieter Wuille interview on Chaincode podcast:

https://podcastaddict.com/episode/94276066

-->
