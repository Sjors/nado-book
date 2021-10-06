\newpage

<!---
(these comments won't appear in the PDF)
* send to IP address indeed existed: https://en.bitcoin.it/wiki/IP_transaction
* SegWit (version 0) is explained in another chapter
* bech32m is used in the Taproot softfork (segwit version 1), which will be explained in another chapter
* lightning is mentioned at the end, also covered in other chapters
-->

## Bitcoin addresses

Listen to Bitcoin, Explained episode 28:\
![](qr/28.png){ width=25% }

In this episode of "The Van Wirdum Sjorsnado," hosts Aaron van Wirdum and Sjors Provoost discussed Bitcoin addresses. Every Bitcoin user has probably at one point used Bitcoin addresses, but what are they, exactly?

Van Wirdum and Provoost explained that Bitcoin addresses are not part of the Bitcoin protocol. Instead, they are conventions used by Bitcoin (wallet) software to communicate where coins must be spent to: either a public key (P2PK), a public key hash (P2PKH), a script hash (P2SH), a witness public key hash (P2WPKH) or a witness script hash (P2WSH). Addresses also include some meta data about the address type itself.

Bitcoin addresses communicate these payment options using their own “numeric systems," the hosts explained. The first version of this was base58, which uses 58 different symbols to represent numbers. Newer address types, bech32^[BIP 173 is the spec for bech32: <https://github.com/bitcoin/bips/blob/master/bip-0173.mediawiki>] addresses, instead use base32 which uses 32 different symbols to represent numbers.

Van Wirdum and Provoost discussed some of the benefits of using Bitcoin addresses in general and bech32 addresses in specific. In addition, Provoost explained that the first version of bech32 addresses included a (relatively harmless) bug, and how a newer standard for bech32 addresses has fixed this bug.

<!---
(^ comment marker should be removed during the first editing round)

Aaron Van Wirdum:
Live from Utrecht, this is the Van Wirdum Sjorsnado.

Sjors Provoost:
Hello.

Aaron Van Wirdum:
Hey Sjors.

Sjors Provoost:
What's up?

Aaron Van Wirdum:
The other day I wanted to send Bitcoin to someone, but I didn't-

Sjors Provoost:
Why? Shouldn't you hoddle?

Aaron Van Wirdum:
I hoddle all I can, but sometimes I need to eat, or I need to pay my rent, or I need to buy a new plant for my living room.

Sjors Provoost:
Yeah, that's true.

Aaron Van Wirdum:
So the problem was, the person I wanted to send Bitcoin to, I didn't have their IP address.

Sjors Provoost:
You did not have their IP address.

Aaron Van Wirdum:
I did not have their IP address.

Sjors Provoost:
Okay.

Aaron Van Wirdum:
Luckily, it turns out there's this trick in Bitcoin called Bitcoin addresses.

Sjors Provoost:
That's right.

Aaron Van Wirdum:
Have you heard of this?

Sjors Provoost:
Yes.

Aaron Van Wirdum:
Maybe our reader ... Cut that please. Maybe our listener hasn't yet Sjors, so let's explain what Bitcoin addresses are.

Sjors Provoost:
Okay. What are Bitcoin addresses?

Aaron Van Wirdum:
First of all, so I made a stupid joke about IP addresses, but this was actually an option, wasn't it?

Sjors Provoost:
Yeah. So in the initial version of Bitcoin, Satoshi announced it on the mailing list and said, "Well, if you want to send somebody some coins, you just enter their IP address and then it'll exchange, I guess, an address to send it to."

Aaron Van Wirdum:
Yeah. So it was actually possible to send Bitcoins to people's IP addresses. I don't think that's possible anymore. That's not in any of the code-

Sjors Provoost:
I don't think so either.

Aaron Van Wirdum:
... probably, right?

Sjors Provoost:
I haven't seen it. Yeah. Because the other way is that you just get an address to send to, and then it goes to the blockchain. And, because the other side is checking the blockchain also, it'll show up.

Aaron Van Wirdum:
Yeah. Well, that's actually not how it works at all, but we're going to explain it now. I think.

Sjors Provoost:
Yep.

Aaron Van Wirdum:
Let's go. Okay. First of all, Sjors, when you send Bitcoin to someone, what do you actually do? What happens?

Sjors Provoost:
Well, you're creating a transaction that has a bunch of inputs, and it has an output. And that output describes who can spend it. Right? So you could say anybody can spend this. That's not a good idea. We talked about that in an earlier episode. So what you do is you put a constraint on it. And the very first version of that constraint was he who has, or he or she who has this public key can spend the coins. So that's called Pay-to-Public-Key.

Aaron Van Wirdum:
Yes, exactly. And then we just mentioned this IP example. So what actually happened was you would connect to someone's IP. I don't know the nitty-gritty details, but in general you would connect to someone's IP, and you would ask for a public key, and that person would give you the public key. And I think that's what you send the Bitcoins to.

Sjors Provoost:
Yeah, I believe so too. But I haven't seen that code in action, so we could be slightly wrong there. Somebody should dig it up. I'd love to see screenshots of like what that used to look like.

Aaron Van Wirdum:
Yeah. Is there anyone who's ever used this way of paying someone, pay to IP address?

Sjors Provoost:
Yeah. We'd love to know.

Aaron Van Wirdum:
It was technically possible. If anyone listening has ever actually you use this, we'd be curious to hear that.

Sjors Provoost:
I mean, it makes sense to think that way in the first version of Bitcoin, right? Because before that you had all these peer to peer applications, and they were generally very direct. So with Napster and all these things, or Kazaa, I don't know which one, you would connect to other people and you would download things from them. And with Bitcoin you connect to other peers, but nowadays you just connect to random peers. But perhaps in the beginning the idea might have been, okay, you connect to peers you know, and so then you might as well do transactions with them. But right now you don't really do transactions with the peers you're directly connected to. At least not on Bitcoin on-chain.

Aaron Van Wirdum:
Yeah. Well anyway, so that's one way of paying someone to a public key, is you'd connect to their IP address and you'd get their public key. The other way is if you mine Bitcoins. So if you're a miner, then you're actually sending the block rewards to your public key. Is that still the case? It used to be the case in the beginning, at least.

Sjors Provoost:
Well, in the beginning Bitcoin had a piece of mining software built into software. Right? So if you downloaded the Bitcoin software, it would just start mining. And so it would use that mechanism-

Aaron Van Wirdum:
Well, you just have to press a button. But yeah.

Sjors Provoost:
Yeah, I guess. And then later on you had mining pools, and it all became more professional. So the way they would pay out might be very different. Probably might go to a multisig address from which it's paid back to the individual pool participants. Or it could be paid directly to the pool participants, although that's a bit inefficient because you need a long list of addresses in a coinbase, but I've seen huge coinbase transactions. So probably people were doing that.

Aaron Van Wirdum:
Right. Well anyway, so the point I was making was this pay to public key way of paying someone, I learned this while doing a little bit of research for the show, that was only ever really used for pay to IP address and for the miner, the block reward. It wasn't actually used for anything other than that. What was used other than that was Pay-to-Public-Key-Hash. Right? So you're not sending money to a public key, but you're sending money to the hash of that public key. And this is where addresses come in-

Sjors Provoost:
Yeah, and they had-

Aaron Van Wirdum:
... because this type of payment actually used addresses for the first time. Not for the first time, this was always there. Also something I learned while doing a little bit of research. This was there since day one. There were Bitcoin addresses since day one, but they were only there for Pay-to-Public-Key-Hash.

Sjors Provoost:
Right. So basically, so the script on the Bitcoin blockchain would in that case say, "Okay. The person who can spend this must have the public key belonging to this hash." So the nice thing about that is that you're not saying which public key you have, or at least at the time it was thought that maybe that was safer against quantum attacks. But the other benefit is that it's a little bit shorter so it saves a bit on block space, although of course that wasn't an issue back then. So yeah. You pay to the public key hash.

Aaron Van Wirdum:
Yeah. I guess in a way it's slightly more private as well, right? Because you're only revealing your public key when you're paying. No, that doesn't make sense.

Sjors Provoost:
No, I think that's exactly, it doesn't matter.

Aaron Van Wirdum:
No. Okay. So that's paying to public key hash. And like you said, what you see on the blockchain itself, what's recorded on the blockchain, is the actual hash of a public key. However, when you're getting paid on a public, Pay-to-PubKey-hash, what you're sharing with someone is not the hash, it's actually an address.

Sjors Provoost:
Yes. Well, you are sharing the hash, but you do that using an address.

Aaron Van Wirdum:
Exactly. So what is an address?

Sjors Provoost:
So an address essentially is, at least this type of address, is the number one, followed by the hash of the public key. But it is encoded using something called base58.

Aaron Van Wirdum:
What's base58?

Sjors Provoost:
Okay. So let's go back to base64. I don't know if you've ever seen an email source code, like an attachment, all these weird characters in there. That's base64. And base58 is based on that. But maybe to say what it is, it is all the lowercase letters, all the uppercase letters, and all the numbers, and without any of the signs, and with some ambiguous things removed. So you do not have the small O, the big O, and the zero.

Aaron Van Wirdum:
Should we start with base10?

Sjors Provoost:
Yeah. So, I mean, there's two things. So this is what is actually-

Aaron Van Wirdum:
I want people to understand what base means.

Sjors Provoost:
Yeah, exactly. So this is what's in base58, but then the question is what is base?

Aaron Van Wirdum:
Yes.

Sjors Provoost:
And so base 10 is you have 10 fingers. And so if you want to express, say, the number 115, you can make three gestures. Right? You show a one and a one and a five. And that is base10, because you're using your 10 fingers three times. And that's also how you write down numbers. But there have been different bases. Think the Babylonians were very much into base 360. That's why we have-

Aaron Van Wirdum:
Hang on, hang on. Because we're not actually using fingers most of the time. So I want to make this clear that it just means we have a decimal system, so that means we have 10 different symbols that represent the number.

Sjors Provoost:
That's right.

Aaron Van Wirdum:
There is the symbol zero, which is a round thing. And then we have the one.

Sjors Provoost:
Probably not a coincidence that that happens to match the number of fingers-

Aaron Van Wirdum:
I totally agree. I just want to make it clear that we're not actually using fingers most of the time.

Sjors Provoost:
No. And so I think-

Aaron Van Wirdum:
Okay, so we have 10 symbols. So that means that once you get by the 11th number, at that point you're going to have to reuse symbols you're already used, you're now going to use combinations. So in our case that would be ... Well, it kind of gets confusing because the first number is a zero. So then the 11th number is the one and the zero.

Sjors Provoost:
Yeah, exactly. And there have been different bases in use. Right? So base 360, I believe, was used like Babylonians. Or maybe base 60. And then for computers we tend to use base two internally, because chips are either on or off. So it's zero or a one. So a long series of zeros and ones. And you can express any number with that. Now, in order to read machine code, typically you would use hexadecimal, which is base16. So that is zero to nine, and then A to F.

Aaron Van Wirdum:
Mm-hmm (affirmative). Yep.

Sjors Provoost:
Right. And so base58 is basically there's 58 possible characters to express something with.

Aaron Van Wirdum:
Yeah. It's all numbers, and there's different ways of expressing a number based on your base.

Sjors Provoost:
Yeah. And the trade-off here-

Aaron Van Wirdum:
That determines how many symbols you're using.

Sjors Provoost:
Right. The trade-off here is readability really, because you could represent machine code as normal characters. So the ASCII alphabet, or the ASCII character set is 256 different characters. So that's base 256. But if you've ever done something like print and then the name of a file, your computer will show complete gibberish on the screen and it will start beeping. And the reason it starts beeping is because one of these codes, somewhere in the base 256 is a beep, which actually makes your terminal beep. So it is completely impractical to view a file using base 256, even though there is a character for every one of the 256 things there. So that's why you tend to do that in base 16, hexadecimal is relatively easy to read, but then it's quite long. If you take a public key and you write it as hexadecimal, it's a rather long thing to write down. And base58 is a little bit shorter, so maybe it's easier to copy paste perhaps. Or it's not even easy to read on the phone. Base58 is pretty terrible, because it's uppercase, lowercase, uppercase, lowercase.

Aaron Van Wirdum:
Yeah. Okay. Just to restate that briefly. So base two is you're just using two symbols, which is one and zero. And base10 is what we use most of the time. It's 0, one, two, three, four, up until nine. And you have hexadecimal, which uses zero through nine, plus B, C, D, E, F. And then what we're talking about here is base58, which uses 58 different symbols, which are zero through nine, and then most of the alphabet in both capital letters and under case. Right?

Sjors Provoost:
Yeah. I think it's lowercase and uppercase, and then most of the numbers. But there are some letters and numbers that are skipped, that are ambiguous. So the number zero, the letter O, both lowercase and uppercase, or at least uppercase is not in there.

Aaron Van Wirdum:
Yeah. I think, for example, the capital I and the lowercase L are both not in there, because they look too similar, for example.

Sjors Provoost:
Right. And that's why you get a little bit less than if you just add 26 letters plus 26 uppercase plus 10 numbers. Right?

Aaron Van Wirdum:
Okay. I think we finally explained what base 58 means.

Sjors Provoost:
Yeah. And just as a side step, I talked about email earlier, that's base64. That is the same, but it also has some characters like underscore and plus and equals. And that was mostly used for email attachments. And I guess they didn't want to use al 256 characters either, because they didn't want the email to start beeping, but they did want to squeeze a lot of information into the attachment. Anywho.

Aaron Van Wirdum:
Okay, that's base58. Now, why are we talking about this? What is an address?

Sjors Provoost:
Yeah. So the address again is actually the value of zero, I believe. But that's expressed as a one, because that's the first digit in this character set.

Aaron Van Wirdum:
Base58 system, yeah.

Sjors Provoost:
Yeah. So it starts with a one. And then it's followed by the public key hash, which is just expressed in base58.

Aaron Van Wirdum:
Right. Is that all it is?

Sjors Provoost:
Yes. And keep in mind, so that is the information you send to somebody else when you want them to send you Bitcoin. You could also just send them zero, zero, and then the public key. And maybe they would be able to interpret that. Probably not. You could send them the actual script that's used on the blockchain. Because on the blockchain there is no like base58 or base64 or anything like that. The blockchain is just binary information. So the blockchain has this script that says, "If the person has the right public key hash, has the public key belonging to this public key hash, then you can spend it." And we talked about in an earlier episode how Bitcoin scripts work. So you could send somebody the Bitcoin script in hexadecimal, anything you want. But the convention is you use this address format. And that's why all traditional Bitcoin addresses start with a one. And they're all roughly the same length.

Aaron Van Wirdum:
Okay. So a Bitcoin address is basically just a base58 representation of a version number, plus a public key hash. Sjors, is base58 used for anything else in Bitcoin?

Sjors Provoost:
Yeah. You can also use it to communicate a private key. And in that case, your version number is ... Well, it's written as five. But it actually represents, I think, 128. And then followed by the private key.

Aaron Van Wirdum:
So that's why all private keys start with a five. Or at least used to start with a five?

Sjors Provoost:
Yeah. So in the old days you had paper wallet that you could print. And if you generate them actually securely without a back door, then on one side of the piece of paper you would have something starting with a five. And on the other side of the paper you would have something starting with a one. And then it would say like, "Show this to other people. And don't show this to other people."

Aaron Van Wirdum:
Right. Now, I happen to know, Sjors, that there are also address that start with a three.

Sjors Provoost:
That's right.

Aaron Van Wirdum:
What's up with that?

Sjors Provoost:
Well, usually those are multi signature addresses. But they don't have to be, they could be single signature addresses. What they are are-

Aaron Van Wirdum:
It could also be types of SegWit addresses, or they could be many things, right?

Sjors Provoost:
Yes.

Aaron Van Wirdum:
They could also be single sig, but you already mentioned that. So let's go on. Okay. Three. It starts with a three, what does it mean?

Sjors Provoost:
So it basically says Pay-to-Public-Key-Hash. So it is that number-

Aaron Van Wirdum:
Pay-to-Public-Script-Hash.

Sjors Provoost:
... followed by ... Sorry, Public-Script-Hash.

Aaron Van Wirdum:
Yes.

Sjors Provoost:
Well, not even public. Just Pay-to-Script-Hash.

Aaron Van Wirdum:
Pay-to-Script. We're getting there.

Sjors Provoost:
[crosstalk 00:14:30].

Aaron Van Wirdum:
Eventually. Pay-to-Script-Hash.

Sjors Provoost:
Yes. And it says basically anybody who has the script belonging to this hash, and who can satisfy the script. So just knowing the script is not enough. You actually have to do whatever the script says you should do.

Aaron Van Wirdum:
Yeah. So the first version we just described was Pay-to-Public-Key-Hash, which required people to offer valid signature corresponding to the public key. And now we're talking about Pay-to-Script-Hash, which means someone needs to present the scripts and be able to solve the scripts. So why do these start with the three?

Sjors Provoost:
It's just the convention. So as we said, there is basically a version number that everything that you communicate through base58 starts with a version number. And if it starts with a one then you know it's Pay-Public-Key-Hash. If it starts with a three, you know it's pay-to-Script-Hash. If it starts with a five you know it's a private key. So it's just a convention. And it has-

Aaron Van Wirdum:
Once again.

Sjors Provoost:
... no meaning on the blockchain itself.

Aaron Van Wirdum:
Once again, all this is is a version number plus this hash represented in base58. Is that all it is?

Sjors Provoost:
Yeah.

Aaron Van Wirdum:
This is all so much simpler than I once thought, Sjors.

Sjors Provoost:
No, it's really simple. And the only mystery that has been solved today, I guess, is, well, what if you only use the public key? But there wasn't done using this system, so there is no initial letter that would represent trying to do that.

Aaron Van Wirdum:
Yeah. That was never represented in base58.

Sjors Provoost:
No, otherwise probably that would've been version zero, and then all normal addresses might have started with a two. Who knows?

Aaron Van Wirdum:
Okay. I think for anyone who already knew this, which is probably a good chunk of people, this is a very boring episode so far. But I think it's going to it get better, because-

Sjors Provoost:
Oh my God.

Aaron Van Wirdum:
... because Sjors, we now have a new type of address, since, I don't know, a year or two, which starts with bc1.

Sjors Provoost:
Bc1q even, usually.

Aaron Van Wirdum:
Yeah usually, but not always. And we're getting into that, I think.

Sjors Provoost:
Yep.

Aaron Van Wirdum:
So what is this all about?

Sjors Provoost:
Well, that is bech32, or bech32, or however you want to pronounce it. And it's been used since SegWit basically. And again, it is something that doesn't exist on the blockchain, so it's just a convention that wallets can use. This is, as the name suggests, a base 32 system, which means you have almost all the letters, and almost all the numbers, minus some ambiguous characters that you don't want to have because they look too much like numbers or letters.

Aaron Van Wirdum:
Yeah. And I think one of the big differences compared to base58 is that this time there are no longer uppercase and lowercase letters, there's just every letter is only in there once.

Sjors Provoost:
Exactly. The other day difference is that it doesn't start-

Aaron Van Wirdum:
Which has a benefit ... I'll mention one benefit of that, which is that if you want to read an address out loud, it's going to be a little bit easier now that there's no difference between uppercase and lowercase.

Sjors Provoost:
Yeah. And the other difference is, I didn't check with base58, but basically it doesn't start with zero or anything like that. It looks pretty arbitrary. So the value zero is written as a Q, the value one is written as a P, the value two is written as a Z, et cetera.

Aaron Van Wirdum:
Why isn't the value one just written as a one?

Sjors Provoost:
Well, it's completely arbitrary, first of all. Right? You can connect any value to any symbol you want.

Aaron Van Wirdum:
Sure.

Sjors Provoost:
If there is a human interpretation that depends on it, then you don't want to do anything confusing. But if your only goal is to make it easy to copy paste things, and if your other goal is for every address to start with bc1q, because bc1 sounds cool, then maybe there's a reason why you want to do them out of order. I haven't read what what the rationale is in the order.

Aaron Van Wirdum:
Okay. Now bech32.

Sjors Provoost:
Yeah. So there's a set of 32 characters. But it's doing the same thing, right? It's again saying, 'Okay, here's a Pay-to-Public-Key, yeah, a Pay-to-Public-Key address. In this case, a pay to witness public key because it's using SegWit, but it's the same idea. Public key hash." So it says, "Hello," and then followed by the hash of the public key.

Aaron Van Wirdum:
Okay. So bech32 addresses, what are we looking at exactly? Because what we're seeing for each of address, it starts with bc1, and then usually a q, and then a whole bunch of other symbols. So what does this all mean?

Sjors Provoost:
That's right. So there is something called the human-readable part, and that doesn't really have any meaning, other than that humans can recognize, "Okay, if the address starts with bc, then it refers to Bitcoin." And the software of course can see this too, but both humans and software can understand this.

Aaron Van Wirdum:
Yeah. So if Litecoin would want to use these kinds of addresses, maybe they do actually, I don't know.

Sjors Provoost:
Probably, then they might start with lt.

Aaron Van Wirdum:
Exactly. So these first two letters just refer to which currency is this about, what blockchain is this for?

Sjors Provoost:
Yeah. And it can be, I think, a fairly arbitrary number of letters. The idea is that it's separated by a one.

Aaron Van Wirdum:
Oh, it could be more than two letters as well?

Sjors Provoost:
Yeah. I think initially Bitcoin Cash was using a much longer introduction.

Aaron Van Wirdum:
I see. Okay.

Sjors Provoost:
So that's pretty arbitrary. Obviously you want to conserve space. So bc is nice and short, and a one. That's a separator. It has no value. So if you look at what do all the 32 numbers mean, then one is not in it.

Aaron Van Wirdum:
One just means?

Sjors Provoost:
Skip this.

Aaron Van Wirdum:
The human-readable part is over. Now the fun stuff starts.

Sjors Provoost:
Now the meat and potatoes.

Aaron Van Wirdum:
Right.

Sjors Provoost:
And the fun stuff, it's a little bit easier actually than with base58, because there's a convention that says if it's ... Well, the convention is it starts with the SegWit version. So the first version of SegWit is zero, which in bech32 is written as q. And then it's either followed by 20 bytes or 32 bytes. And then it means either it's the public key hash, or it is the script hash. And they're different lengths now because SegWit uses the SHA256 hash of the script, rather than in the RIPEMD160 hash of the script. So in base58, the script hash is the same length as the public key hash. But in SegWit they're not the same length. So simply by looking at how long the address is you know whether you're paying to a script or you're paying to a public key hash, so we don't have to say it.

Aaron Van Wirdum:
Right. So to reiterate, the first two letters, bc, that just means this is about Bitcoin. Then the one says, "Okay, that was the part telling you which currency this is. Now pay attention where you're actually going to pay money to." Then the q means which version is going to follow, which version of address?

Sjors Provoost:
Yep.

Aaron Van Wirdum:
And then what comes after that-

Sjors Provoost:
Which version of SegWit.

Aaron Van Wirdum:
Yeah, what comes after it is actually the bech32 representation of this hash, which is either Pay-to-Public-Key-Hash or Pay-to-Script-Hash.

Sjors Provoost:
Yeah. Exactly. Or Pay-to-Witness-Public-Key-Hash or Pay-to-Witness-Script-Hash.

Aaron Van Wirdum:
Sjors, is there anything else cool about bech32?

Sjors Provoost:
Yeah, there is. And it's about error correction. So in base58, there is a check sum. So a check sum basically means you add something to the address at the end. And that way, if you make a typo, then that check sum at the end of the address is not going to work.

Aaron Van Wirdum:
Not going to compute with the rest of the address.

Sjors Provoost:
Yeah. So it'll tell you, "Okay, this address is wrong." Now, there is a certain chance-

Aaron Van Wirdum:
It doesn't tell you what the correct version would be, it just tells you, "This is wrong."

Sjors Provoost:
Exactly. Now, there's a chance that you make a typo that happens to have a correct check sum. I don't know what the odds are with base58, but pretty low.

Aaron Van Wirdum:
Mm-hmm (affirmative). You'd probably have to make several typos.

Sjors Provoost:
Well, yeah, you'd have to have the unlucky typo. I don't know if the odds are one in 10,000 or a 100,000 or something. But there's a lot of Bitcoin users. But in bech32 it's actually better, because it will not just tell you that there's a typo, it'll tell you where the typo is. And that's done differently. So where we talked about in the base58 system there is a check sum, which just takes all the bytes, basically takes all the bytes from the address and then hashes it, here there is very sophisticated mathematical magic ^[Math behind bech32 addresses: <https://medium.com/@MeshCollider/some-of-the-math-behind-bech32-addresses-cf03c7496285>]. I don't think it's super sophisticated, but I can't explain what the actual magic is. But the magic makes it so that you can actually make a typo and it'll actually tell you where the typo is. And you can make about four typos and it'll still know where the typo is and what the real value is. If you do more than that, it won't.

Sjors Provoost:
And the analogy I like to make with that, someone once told me, is it's like if you have a wall and you draw a bunch of circles on it, and each circle represents a correct value, and you're throwing a dart at it. And you might hit the bullseye then you have the right value, or you might just slightly miss the bullseye but you're still within that big circle, then you know exactly where it should have been.

Aaron Van Wirdum:
Are you talking about interlocking circles?

Sjors Provoost:
No, they're not overlapping.

Aaron Van Wirdum:
Okay.

Sjors Provoost:
So the idea there is you want the circles to be as big as possible obviously, but you don't want to waste any space. So that's an optimization problem in general. And of course, in the example of a two dimensional wall with two dimensional circles, it's pretty simple to visualize. Right? You throw the dart and you see, "Okay, it's still within the big circle, so it should belong to this dot." So that is like saying, "Okay, here's your typo and this is how you fix it." And then in the case of bech32 the way I think you should imagine it is that, instead of a two dimensional wall you have a 32 dimensional wall, and the circles are also probably 32 dimensional hyperspheres-

Aaron Van Wirdum:
I find that a little bit hard to imagine, Sjors, but I'm not a wizard like you.

Sjors Provoost:
Well, if you've studied something like physics or math, you know that anything you can do in two dimensions you can see it in three dimensions, and you can do it in n dimensions. You can abstract all these things out to as many dimensions as you need. But the general intuition is the same. So now you're hitting your keyboard, and somewhere in that 32 dimensional space you're slightly off, but you're still inside this sphere, whatever that might look like. And so it knows where the mistake is. But there's a problem.

Aaron Van Wirdum:
Oh.

Sjors Provoost:
Yes.

Aaron Van Wirdum:
Oh no.

Sjors Provoost:
All this amazing wizardry missed something. And it basically-

Aaron Van Wirdum:
It lost me a long time ago, but go on.

Sjors Provoost:
Well, basically it turns out that if your bech32 address ends with a P, then you can add an arbitrary number of qs to it, and it's still will match the check sum.

Aaron Van Wirdum:
Oh yeah. This is the bug. There was a bug in bech32.

Sjors Provoost:
Yeah. So I guess the analogy would be that the circles are not entirely separate in some weird way. And that's not good. But that's actually not a problem originally-

Aaron Van Wirdum:
So any address that ended with a P could have any arbitrary numbers of q following it?

Sjors Provoost:
Exactly.

Aaron Van Wirdum:
And then you wouldn't be told that there's a typo.

Sjors Provoost:
No.

Aaron Van Wirdum:
Your software would think it's right, and then you're sending money to the wrong address.

Sjors Provoost:
Yeah. Which means it's un-spendable.

Aaron Van Wirdum:
Right. Yeah, yeah, yeah. Exactly.

Sjors Provoost:
But the good news is that there's another constraint for the original version of SegWit, SegWit version zero, which is that an address is either, well, 20 bytes or 32 bytes. And that means that it's constrained. Right? Because if you add another q to it, then it's too long. So you still know it's wrong.

Aaron Van Wirdum:
Yeah. If you have a 20 byte address and you add one q, then it's 21, which is still invalid. So you'd have to accidentally add 15 qs? Or how many were?

Sjors Provoost:
12.

Aaron Van Wirdum:
12 qs.

Sjors Provoost:
Yeah. Or something like that. I don't know.

Aaron Van Wirdum:
That's pretty unlikely to happen.

Sjors Provoost:
Yeah. Because I might be confusing bytes and characters. But exactly, that's very unlikely to happen for SegWit version zero. But now we would say, "Okay, we're going to have a new ... We're going to have future versions of SegWit, such as Taproot," which would be bc1p, because P is the version one. And I believe for Taproot there's also a constraint in how long these addresses are supposed to be. So it's still not an acute problem, but in the future maybe we want to have addresses that are somewhat more arbitrary in length, because maybe you want to add some weird conditions to it. Or you want to communicate other information, not just the address. Maybe you want to put the amount inside the address. So this is why there's a new standard proposed BIP 350, which is called bech32m^[BIP 350 is the spec for bech32m: <https://github.com/bitcoin/bips/blob/master/bip-0350.mediawiki>]. And it's actually a very simple change. Think it adds to all the math, it adds one extra number to that math. And then it fixes that particular bug. And everybody's happy.

Aaron Van Wirdum:
So it fixes the bug that the qs don't matter anymore.

Sjors Provoost:
Yeah. You can just add stuff to it without running into problems.

Aaron Van Wirdum:
But I guess this does mean that wallets that have by now upgraded to support these special SegWit address, bech32 addresses, they now have to upgrade again.

Sjors Provoost:
That's right. So that's annoying, because it does mean that if your wallet wants to support sending to a taproot address, then it has to make a small change to the bech32 implementation. And there's some example code on the BIP. It's not a big change because it just adds one number. And if you look at the Bitcoin Core implementation, it's a fairly simple change that does it. But it does mean that, moving forward, when you see a bech32 address, you have to parse it, then see if it's the version zero or the version one, and then do things slightly differently. But even that is just a very small change. But it is annoying, yeah. It does mean that, especially hardware wallets with firmware updates, could take a while.

Aaron Van Wirdum:
Right. So we started out with base58 addresses. Now we're all starting to use bech32 addresses. Is this final? Are we going to keep using bech32? Or are you anticipating some other address format somewhere in the future?

Sjors Provoost:
No, I think this will do for a long time. Bech32 is a way to write addresses now. What is actually inside an address, there could be more information in it. Right? And the most interesting example of that is Lightning invoices. A Lightning invoices uses bech32, but they're much longer because they contain a lot more information. They contain the public key, they contain the amount, they contained the deadline, they contained a bunch of secrets. They contain all sorts of stuff, all sorts of routing hints even. It's like a whole book you're sending over. So bech32 is just an alphabet, essentially. You can make it as long as you want, with this little caveat in mind that we talked about. But you're probably not going to type type Lightning invoices anyway because they're too long. So you tend to copy paste them.

Aaron Van Wirdum:
Yeah. In general you copy paste any address. I don't retype addresses. Do you, Sjors?

Sjors Provoost:
Well, I don't know. You might have some like nuclear cold storage, and the addresses for the nuclear cold storage might be written down on a piece of paper because you don't want them ever to touch anything that's on the internet. But generally people copy paste. But there was some discussion early on, with bech32 I think, that was explicitly talking about, can this be communicated over the phone?

Aaron Van Wirdum:
Yeah, true. That's why there's this-

Sjors Provoost:
Yeah. Even in your nuclear bunker situation maybe you need to communicate something to somebody else in another nuclear bunker through smoke signals. And then you could use bech32 for smoke signals. Although maybe a base two system is easier. I don't know. I've never done smoke signaling.

Aaron Van Wirdum:
No, I usually copy paste.

Sjors Provoost:
Okay. That's cool. It's also like a smoke signal, just a bit more complicated. All right.

Aaron Van Wirdum:
Was that everything there is to know about addresses, Sjors?

Sjors Provoost:
Well, I'm sure there's more, but I think this is a nice primer.

Aaron Van Wirdum:
You're going to call it a day?

Sjors Provoost:
We are. So thank you for listening to the Van Wirdum Sjorsnado.

Aaron Van Wirdum:
There you go.

Aaron Van Wirdum:
(music).
-->
