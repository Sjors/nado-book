\newpage
## Bitcoin addresses

Listen to episode 28:

\qrcode{https://bitcoinmagazine.com/technical/explaining-bitcoin-addresses}

discuss Bitcoin addresses. Every Bitcoin user has probably at one point used Bitcoin addresses, but what are they, exactly?

Aaron and Sjors explain that Bitcoin addresses are not part of the Bitcoin protocol. Instead, they are conventions used by Bitcoin (wallet) software to communicate where coins must be spent to: either a public key (P2PK), a public key hash (P2PKH), a script hash (P2SH), a witness public key hash (P2WPKH), or a witness script hash (P2WSH). Addresses also include some meta data about the address type itself.

Bitcoin addresses communicate these payment options using their own “numeric systems”, Aaron and Sjors explain. The first version of this was base58, which uses 58 different symbols to represent numbers. Newer address types, bech32 addresses, instead use base32 which uses 32 different symbols to represent numbers.

Aaron and Sjors discuss some of the benefits of using Bitcoin addresses in general. and bech32 addresses in specific. In addition, Sjors explains that the first version of bech32 addresses included a (relatively harmless) bug, and how a newer standard for bech32 addresses has fixed this bug.

Transcript (computer generated):

Aaron:
From Utrecht. This is the Van Wirdum Sjorsnado. Hey sjors. It's up the other day. I want us to send Bitcoin to someone, but I'd why

Sjors:
Shouldn't you HODL?

Aaron:
I Hodel all I can, but sometimes I need to eat or I need to pay my rent. Right. I need to buy a new plant or my living room. Yeah, that's true. So the problem was the person that wants to send Bitcoin to, I didn't have their IP address.

Sjors:
You did not have their IP address. I did

Aaron:
Not have their IP address. Okay. Luckily it turns out there's this trick in Bitcoin called Bitcoin addresses. That's right. Have you heard of this? A yes. Maybe our reader cut that place. Maybe our listener hasn't yet yours. So let's explain what Bitcoin addresses are. Okay.

Sjors:
What are Bitcoin addresses? First

Aaron:
Of all. So I made a stupid joke about IP addresses, but this was actually an option, wasn't it? Yeah. So,

Sjors:
So in the initial version of Bitcoin, Satoshi announced it on the mailing list and said, well, if you want to send somebody some coins, you just enter their IP address and then it'll exchange, I guess, an address to send it to.

Aaron:
Yeah. So it was actually possible to send Bitcoins to people's IP addresses. I don't think that's possible anymore. That's not in any of the code. I don't think

Sjors:
I haven't seen it. Yeah. Because the other way is that you just get an address to send to, and then it goes to the blockchain and because the other side is checking the blockchain also it'll show up. Yeah.

Aaron:
Well that's actually not how it works at all, but we're going to explain it now. I think. Yep. Let's go. Okay. First of all, shorts, when you send Bitcoin to someone, what do you actually do? What happens?

Sjors:
Well, you're creating a transaction that has a bunch of inputs and it has an output and that output describes who can spend it. Yep. All right. So you could say anybody can spend this. That's not a good idea. We talked about that in an earlier episode. So what you do is you put a constraint on it and the very first version of that constraint was he who has he or she, or has this public key can spend the coins. So that's called pay to public key.

Aaron:
Yes, exactly. So, and then we just mentioned this IP example. So what actually happened was you would connect to someone's IP. I don't know the nitty-gritty details, but in general you would connect to someone's IP and you'd ask for public public key and that person would give you the public key. And I think that's what you send the Bitcoins to.

Sjors:
Yeah, I believe so too. But I've, I haven't seen that coat in action so we could be slightly wrong there. Somebody should dig it up. I'd love to see screenshots of like what that used to look like.

Aaron:
Yeah. Is there anyone who's ever used this way of paying someone pay to IP address?

Sjors:
Yeah. We'd love to know if it was

Aaron:
Technically possible. If anyone listening has any as ever actually used this, we'd be curious to hear.

Sjors:
I mean, it makes sense to think that way from the, in the first version of Bitcoin, right? Because before that you had all these peer to peer applications and they were generally very direct. So with Napster and all these things, or cause I don't know which one you would connect to other people and you would download things from them. And with Bitcoin, you connect to other peers, but nowadays you just connect to random peers. But perhaps in the beginning, the idea might've been okay, you connect to peers, you know? And so then you might as well, you know, do transactions with them. But right now you don't really do transactions with the PSU directly connected to Lee's not Bitcoin on chain. Yeah.

Aaron:
Well, anyway, so that's one way of paying someone to a public key is you to connect to their IP address and you'd get their public key. The other way is if you mine Bitcoins. So if you're a miner, then you're actually sending the block rewards to your public key. Is that still the case? It used to be the case in the beginning, at least.

Sjors:
Well, in the beginning, Bitcoin had a piece of mining software built into software, right? So if you, if you download it, the Bitcoin software, it would just start mining. And so it would use that

Aaron:
Money. You just have to press a button mojo. Yeah,

Sjors:
I guess. And then later on, you know, you had mining pools and it all became more professional. So the way they would pay out might be very different. Probably, you know, might go to a multisig address from which it's paid back to the individual full participants, or it could be paid directly to the pool participants. Although that's a bit inefficient because you need a long list of addresses in the Coinbase, but I've seen huge Coinbase transaction. So probably people people were doing that right.

Aaron:
Well, anyway, so the point I was making was this pay to public key way of paying someone that was, I learned this while doing a little bit of research for the show. There was only ever really used for pay to IP address and for the minor, the block reward. Okay. It wasn't actually used for anything other than that, what was used other than that was paid to public key hash, right? So you're not sending money to a public key, but you're sending money to the hash of that public key. Yeah. And this is where addresses come in. This type of payment actually used addresses for the first time. Not for the first time. This was always there also something I learned while doing a little buddy research. This was there since day one. There was Bitcoin addresses since day one, but they were only there for pay to public key hash.

Sjors:
Right. So basically, so the script on the Bitcoin blockchain would in that case say, okay, the person who can spend this must have the public key belonging to this hash. So, you know, the nice thing about that is that you're not saying which public key you have, or at least at the time it was thought that maybe that was safer against quantum attacks. But the other benefit is that it's a little bit shorter. So it saves a bit on block space. Although of course that wasn't an issue back then. So yeah. You paid to the public key hash.

Aaron:
Yeah. I guess in a way it's slightly more private as well, right? Because you're only revealing your public, you when you're paying. No, that doesn't make sense.

Sjors:
No, I think that's exactly. It doesn't matter. No.

Aaron:
Okay. So that's the public that's paying for public key hash. And like you said, what you see on the blockchain itself what's recorded on the blockchain is the actual hash of about public key. However, when you're getting paid on a public pay to pub key hash, what you're sharing with someone is not this hash, it's actually an address.

Sjors:
Yes. Well, you are sharing the hash, but you do that using an address.

Aaron:
Exactly. So what is an address? So

Sjors:
An address essentially is policed. This type of address is the number one followed by the hash of the public key, but it is encoded using something called base 58

Aaron:
What's base 58.

Sjors:
Okay. So let's go back to bay 64. I don't know if you've ever seen an email source code, like an attachment, all these weird characters in there that's based 64, but I'm based 58 is based on that. But maybe to say what it is, it is all the lowercase letters, all the uppercase letters and all the numbers and without any of the signs and with some ambiguous things removed. So you do not have the small, oh, the big O and the zero,

Aaron:
Shall we start with base 10? Yeah.

Sjors:
So I mean, there's, there's two things. So this is what actually,

Aaron:
I want people to understand what base means. Yeah, exactly.

Sjors:
So this is what's in base 58, but then the question is what is base? Yes. And so base 10 is you have 10 fingers. And so if you want to express say the number 115, you can make three gestures, right? You show a one and a one and a five, and that is based 10 because you ha you're using your 10 fingers three times. And that's also how you write down numbers, but there have been different basis. Think the [inaudible] into base 360,

Aaron:
Y we have hang on, hang on because we're not actually using fingers most of the time. So I want to make this clear that it just means there we have a decimal system. So that means we have 10 different symbols that represent the number that's right. With discipline symbols, zero, which is around thing. And there's

Sjors:
Probably not a coincidence that, that happens to me.

Aaron:
I totally agree. I just want to make it clear that we're not actually using fingers Moses line. No. And so the, okay, so we have 10 symbols. So that means that once you get by the 11th number, at that point, you're going to have to reuse symbols. You use two, you're now going to use combinations. So in our case, that would be, well, it kind of gets confusing because the first number is zero. So then the 11th number is the one and the zero.

Sjors:
Yeah, exactly. And there've been different basis in use. Right? So base 360, I believe was used. So I have is, or maybe based 60. And then for computers, we tend to use base to internally because chips are either on or off. So it's a zero or a one year long series of zeros and ones. And you can express any number of that. Now, in order to read machine code, typically you would use hexadecimal, which is based 16. So that is zero to nine and then eight to F. Yep. And right. And so base 58 is basically this 58 possible characters to express something with yeah,

Aaron:
It's all numbers. And there's different ways of expressing a number based on your base. And that determines how many symbols you're using and

Sjors:
Right. The trade-off here is readability really because you could represent machine code as normal characters. So the, you know, the ASCII alphabet or the ASCII character set a student and the 56 different characters. So that's based 2 56, which is we've ever done something like print. And then the name of a file, your computer will show complete gibberish on the screen and it will start beeping. And the reason it starts beeping is because one of these codes, somewhere in the base, 2 56 is a beep, which actually makes your terminal beep. So it is completely impractical to view a file using base 2 56, even though there is a character for every of the 256 things there. So that's why you tend to do that in base 16, exit SML is relatively easy to read, but then it's quite long. If you take a public key and you write it as hexadecimal, it's, it's a rather long thing to write down, but Embase 58 is a little bit shorter. So maybe, you know, it's easy to copy paste perhaps, or it's not even easy to read on the phone base, 58. It's pretty terrible because it's uppercase lowercase or uppercase lowercase. So

Aaron:
Yeah. Okay. Just to restate that briefly. So based too, it's just, you're just using two symbols, which is one zero, and based 10 is what we use most of the time. It's 0 1, 2, 3, 4, up until nine. Then you have hexadecimal, which uses zero through nine plus ABCD F and then what we're talking about here is based 58, which uses 58 different symbols, which are zero through nine. And then most of the alphabet in both capital letters and on their case, right?

Sjors:
Yeah. Mostly I think it's lowercase and uppercase and then most of the numbers, but there are some letters and numbers that are skipped, that are ambiguous. So the number zero, the letter O both lowercase and uppercase, or at least upper case is not in there.

Aaron:
Yeah. I think, for example, the capital I, and the lowercase L are both not in there because they look too similar.

Sjors:
It's why you get a little bit less than, you know, if you just add 26 letters plus 26 uppercase plus 10 numbers. Right. So

Aaron:
I think we finally explained what base 58. And

Sjors:
Just as a sidestep, I talked about email earlier, that's base 64. That is the same, but it also has some characters like our underscore and plus an equals. And that was mostly used for email attachments. And I guess they didn't want to use all 2 56 characters either because they didn't want the email to start beeping, but they did want to squeeze a lot of information into the attachment.

Aaron:
Okay. That's base 50 days now. Why, why are we talking about this? What is an address?

Sjors:
Yeah. So the address again is the, actually the values zero, I believe, but that's expressed as a one because that's the first digit in this

Aaron:
System. Yeah. Yeah.

Sjors:
So it starts with a one and then it's followed by the public key hash, which is just expressed in base 58. Right.

Aaron:
Is that all of this? Yes.

Sjors:
And keep in mind. So that is the information you send to somebody else. When you want them to send you a Bitcoin, you could also just send them zero, zero, and then the public key. And maybe they would be able to interpret that. Probably not. You could send them the actual script that's used on the blockchain because on the blockchain, there is no like base 58 or basically, or anything like that. Uh, the blockchain is just, you know, binary information. So the blockchain has this script that says, if the person has the right public key hash has the public key belonging to this public key hash, then you can spend it. And we talked about in an earlier episode, how Bitcoin scripts work. So you could send somebody to Bitcoin script in hexadecimal, anything you want, but the convention is you use this address format, and that's why all traditional Bitcoin addresses start with a one. And they're all the same, roughly the same length. Okay. So

Aaron:
A Bitcoin address is basically just a base 58 representation of a version number. Plus a public key hash shot is base 58 used for anything else in Bitcoin.

Sjors:
Yeah. You can also use it to communicate a private key. And then that case, your version number is, well, it's written as five, but it's actually represents, I think 128. Right. And then followed by the private key.

Aaron:
So that's why all private keys start with five or at least used to start with.

Sjors:
Yeah. So in the old days you had paper wallets that you could print, you know, and if you generate them actually securely without a backdoor, then on one side of the piece of paper, you would have something starting with the five. And on the other, other side of the paper, you'd have something started with one. And then it would say like, show this to other people and don't show this to other people right

Aaron:
Now. I happen to know yours that there are also addresses that start with a free that's right. What's up with that.

Sjors:
Well, usually those are a multisignature addresses, but they don't have to be, they could be single signature actresses or what they are are,

Aaron:
It can also be types of SegWit addresses or they could be many things, right? Yes. Because also be single sick, but you already mentioned that. So let's go on. Okay. Free. It's always, what does it mean? So

Sjors:
He says pay to public key hash. So it is that number followed by, sorry, public script hash, not even public, just pay to script hat.

Aaron:
We're getting there. Eventually pay

Sjors:
To scripts Ash. Yes. And it says basically anybody who has the script belonging to this hash and who can satisfy this script. So just knowing the script is not enough. You actually have to do whatever the script says you should do.

Aaron:
Yeah. So the first version we just described was paid to public key hash, which required people through offer a valid signature corresponding to the public key. And now we're talking about pay to script hash, which means someone needs to present the scripts and be able to solve the scripts. So why do they start with a free

Sjors:
There's this convention? So as we sat, there is a, basically a version number that every, you know, at everything that you communicate through base 58 starts with a version number. And if it starts with a wand and you know, it's, it's beta public key hash. If it starts today, three, you know, it's paid as scripted as you have. It starts with the five, you know, it's a private key. So, so it's just the convention and it helps to meaning on the blockchain.

Aaron:
Once again, all this is is a first year number, plus this hash represented in base 58. Is that all it is? Yeah. This is all so much simpler than I once fought yours.

Sjors:
No, it's really simple. And the only mystery that has been solved today, I guess is, well, what if you only use the public key, but there wasn't done using this system. So there is no initial letter that would represent trying to do that. Yeah.

Aaron:
Th that was never representative.

Sjors:
Otherwise, probably that would have been version zero and then all normal addresses. Might've started with the two who knows.

Aaron:
Okay. I think for anyone who already knew this, which is probably a good chunk of people, this is a very boring episode so far, but I think it's going to get better because, oh my God, because shores, we now have a new type of address since, I don't know, year or two, which starts with B C one

Sjors:
PC one Q even, usually. Yeah.

Aaron:
Usually, but not always. And we're getting into that, I think. Yep. So what is, what is this all about?

Sjors:
That is back 32 or bet 32, or however you want to pronounce it. And it's been used since SegWit basically. And again, it is something that doesn't exist on the blockchain. So it's just a convention that pilots can use. This is a, as the name suggests a base 32 system, which means you have almost all the letters and almost all the numbers minus some ambiguous characters that you don't want to have because they look too much like numbers or letters. Yeah.

Aaron:
I think one of the big differences compared to base 58 is that this time there are no longer uppercase and lowercase letters, there's just any, every letter is only in there ones. Exactly.

Sjors:
The other difference is that it has a benefits.

Aaron:
I'll mention one benefit of that, which is that if you want to read an address out loud, it's going to be a little bit easier now that there's no difference between uppercase and lowercase.

Sjors:
Yeah. And the other difference is I didn't check with pays 58, but basically it doesn't start with zero or anything like that. It's it looks pretty arbitrary. So the value of zero is written as a cue. The value one is written as a P value. Two is written as a Z, et cetera. Why is

Aaron:
It the value one just written as a one? Well, it's completely

Sjors:
Arbitrary first though. Right? You can pick any, you can connect any to any symbol you want. Sure. It's. It is. If there is a human interpretation that depends on it, then you don't want to do anything confusing. But if your only goal is to make it easy to copy paste things. And if your other goal is for every address to start with BC one cue because you know, BC one sounds cool. Then maybe there's a reason why you want to do them out of order. I haven't read with what the, what the rationale is in the, in the order. Okay.

Aaron:
Now back 42.

Sjors:
Yeah. So there's a set of 32 characters and that means your, but it's doing the same thing, right? It's again saying, okay, here's a pay to public key. Yeah. A paid to public key address. In this case, it paid to witness public key because it's using secondary SegWit, but it's the same idea, public key hash. So it says hello, and then followed by the hash of the public key. Okay. So

Aaron:
32 addresses. What are we looking at exactly because what we're seeing for each address, it starts with BC one and then usually queue and then a whole bunch of other symbols. So what does this all mean?

Sjors:
That's right. So there is something called the human readable part and that's doesn't really have any meaning. Other than that, humans can recognize, okay. If the address starts with BC, then it refers to Bitcoin and the software of course can see this too. But both humans and software can understand this. Yes.

Aaron:
So if light coin would want to use these kinds of addresses, maybe they do

Sjors:
Actually, I dunno, probably then they might start with LT. Exactly.

Aaron:
So this, these first two letters just refer to which currency is this about with blockchain? Is this for,

Sjors:
And can be, I think a fairly arbitrary number of letters. The idea is that it's separated by a one, or it could

Aaron:
Be more than two letters

Sjors:
As well. Yeah. I think initially Bitcoin cash was using a much longer, um, introduction. I see. Okay. So that's pretty arbitrary. Obviously you want to conserve space. So PC is nice and short and a one that's a separator has no value. So if you look at the, uh, what, what do all the 32 numbers mean then? Uh, one is not in it.

Aaron:
One just means skip

Sjors:
This [inaudible]

Aaron:
Two is over now. The

Sjors:
Fun stuff starts, the meat and potatoes, right? And, and the fun stuff. It's a little bit easier actually then with base 58, because we ha there's a convention that says if it's, well, the convention is, it starts with the SegWit version. So the first version of segue to zero, which in back 32 is written as Q and then it's either followed by 20 bytes or 32 bytes. And that is, then it means either it's the public key hash, or it is the script hash. And there are different links now because SegWit uses the shot 2 56 hash of the script, rather than the rip mat, one 60 hash of the script. So in, in base 58, the script hash is the same length as the public key hash. But in SegWit, they're not the same length. So simply by looking at how long the addresses, you know, whether you're paying to a script or you're paying to public Yasha, we don't have to say it.

Aaron:
Right. So to reiterate the first two letters, PC, that just means this is about Bitcoin. Then the one says, okay, that was the part telling you which currency, this is now pay attention where you're actually going to pay money to then the queue means which version is going to follow, which version of address. Yep. And then what comes after that? What, yeah. What comes after it's actually the back 32 representation of this hash, which is either paid to publicly hash or pay descriptor.

Sjors:
Yeah, exactly. Or pay to witness public hazard, pay to witness ScriptDash

Aaron:
Is there anything else cool about Beck 42.

Sjors:
Yeah, there is. And it's about error correction. So in base 58, there is a checksum. So it checks on basically means you add something to the address at the end. And that way, if you make a typo, then that checksum at the end of the address is not going to

Aaron:
Work. They're going to compute with the rest of the address.

Sjors:
So it will tell you, okay, this address is wrong right now, there is a certain chance that

Aaron:
I'll tell you what the correct version would be. Just tells you this is wrong.

Sjors:
Exactly. Now there is, you know, there's a chance that you make a typo that happens to have a correct check checksum. I don't know what the odds are with base. 58 are pretty low.

Aaron:
You'd probably have to make several typos boy.

Sjors:
Yeah. You'd have to have the unlucky typo. I dunno if the odds are one in 10,000 or a hundred thousand or something. Right. But you know, there's a lot of Bitcoin users, but in back 32 D it's actually better because it will not just tell you that there's a typo. It'll tell you where to type it is. And that's done differently. So where we talked about in the base 58 system, there is a checksum which just takes all the bytes, basically takes all the bytes from the address and then hashes it here. There is very sophisticated mathematical magic. I don't think it's super sophisticated, but I can't explain what the actual magic is, but the magic makes it so that you can actually make a typo. And it'll actually tell you what the type of way is. And you can make about four typos and it will still know where to type of ways and what the real value is. If you do more than that, it won't. And the analogy I like to make with that, let's say someone once told me is, it's like, if you have a wall and you draw a bunch of circles on it and each circle represents a correct value and you're throwing a dart at it and you know, you might hit the bullseye, then you have the right value. Or you might just slightly miss the bullseye, but you're still within that big circle then, you know, you know, you know exactly where it should have been. Are

Aaron:
You talking about interlocking circles?

Sjors:
No, they're not overlapping. Okay. So, so the idea there is you want to, you want the circles to be as big as possible obviously, but you don't want to waste any space. So that's, that's an optimization problem in general. And of course, you know, in the, in the example of a two dimensional wall with two dimensional circles, it's pretty simple to visualize, right? You, you throw the dart and you see, okay, it's still within the big circle, so it should belong to this dot. So that is like saying, okay, here's your typo and this is how you fix it. Right. But, and then in the case of back 32, the way I think you should imagine it is that instead of a two dimensional wall, you have a 32 dimensional wall and the circles are also probably 32 dimensional. High-fives

Aaron:
I find that a little bit hard to imagine shores, but I'm not a wizard like you.

Sjors:
Well, if you've studied something like physics or math, you know, that anything you can do in two dimensions, you know, you can see it in three dimensions and you can do it in, in dimensions. You can abstract all these things out to, to as many dimensions as you need. But the, the, the general intuition is the same. So now you're hitting your keyboard. And somewhere in that 32 dimensional space, you're slightly off, you know, but you're still inside this sphere, whatever that might look like. And so it knows where the mistake is, but there's a problem. Oh yeah. Hold is amazing. Wizardry missed something. And it basically,

Aaron:
It lost me a long time ago, but go on.

Sjors:
Well, basically it turns out that if you're back 32 address, enter the P and then you can add an arbitrary number of cues to it, and it's still will match the check sum. Oh,

Aaron:
Oh yeah. That was the, this is the bark that was a bargain back free to,

Sjors:
So I guess the analogy would be that the circles are not entirely separate in some weird way, and that's not good. And, and, but that's actually not a problem.

Aaron:
Any address that ended with a P could have any arbitrary numbers of Q following it, then you wouldn't be told that there's a typo. Now your software was think it's right. And then you're sending money to is Roger.

Sjors:
Yeah. Which means it sounds spendable. Right? Right. Exactly. But the good news is that there's another constraint for the original version of SegWit SegWit version zero, which is that an address is either while 20 bytes or 32 bytes. Right. And that means that it's constrained. Right. Because if you add another cue to it, then it's too long. So you still do

Aaron:
It was wrong. Yeah. If you have a 20 byte address and you add one Q, then it's 21, which is still valid. So you accidentally add 15 cues or how many were 12, 12 cues

Sjors:
Or something

Aaron:
Like that. That's pretty unlikely to happen. Yeah.

Sjors:
Because I might be confusing bites and characters, but exactly, that's very unlikely to happen for SegWit version zero. But now we would say, okay, we're going to have a new, you know, w we're going to have future versions of SegWit, such as taproot, right. It would be BC one P because P is version one, but may end for, I believe for taproot, there's also a constraint in how long these addresses are supposed to be. So it's still not an acute problem, but in the future, maybe we want to have addresses that are somewhat more arbitrary in length, because maybe you want to add some weird conditions to it, or you want to communicate other information, not just the address. Maybe you want to put the incite the address, right? So this is why there's a new standard proposed PIP three 50, which is called BEC 32 M. And it's actually a very simple change. Figured it adds to the, all the math, it adds one extra number to that math. And then it fixes that particular bug. And everybody's happy.

Aaron:
It's just a box that the cues don't matter anymore. Yeah. You

Sjors:
Can just add stuff to it without running into problems.

Aaron:
But I guess this does mean that wallets that have, by now upgraded to support these special SegWit addresses back through to two addresses, they now have to upgrade again.

Sjors:
Right. So if that's annoying, because it does mean that if you Rolla wants to support sending to a taproot address, then it has to make a small change to the back 32 implementation. And there's some example code on the BIP. It's not a big change because it just adds one number. And if you look at the Bitcoin core implementation, it's a fairly simple change that does it, but it does mean that moving forward, when you see a back 32 address, you have to parse it, then see if it's the version zero or the version one, and then do things slightly differently. But even that is just a fairly small change. Right. But it is annoying. Yeah. It does mean that especially hardware, wallets, you know, with firmer updates could take awhile.

Aaron:
Right? So we started out with base 58 addresses. Now we're all starting to use Beck 42 addresses. It says final. Are we going to keep using back 32? Or are you anticipating some other address format somewhere in the future?

Sjors:
No, I think this, this will will do for a long time back 32 is a way to write addresses. Now, what is actually inside an address that could be more information in it. Right? And the most interesting example of that is lightening invoices, a lightening invoice users back 32, but they're much longer because they contain a lot more information. They contain the public key. They contain the amount, they contained deadline. They contain a bunch of secrets. They contain all sorts of stuff, all sorts of routing hints. Even it's like a whole book you're sending over. Right? So back 32 is just an alphabet. Essentially. You can make it as long as you want with this, you know, little caveat in mind that we talked about, but you're probably not going to type manually type lightening invoices anyway. Cause they're too long. So you tend to copy paste them.

Aaron:
Yeah. In general, you copy paste any address? I don't read type addresses. Do you short?

Sjors:
Well, you might, I don't know. You might have some like nuclear cold storage. And the address is for the nuclear cold storage might be written down on a piece of paper because you don't want them ever to touch anything that's on the internet, but you know, generally people copy paste, but there was some discussion early on with back 32. I think that was explicitly talking about canvas. We communicated over the phone. Yeah, that's true.

Aaron:
That's why there's this.

Sjors:
Even in your nuclear bunker situation, maybe you need to communicate something to somebody else in another nuclear bunker, through smoke signals. And then, you know, you could use back 32 for smoke signals or though maybe a base two system is easier. I don't know. I've never done smoke cycling. No, I usually copy paste. Okay. That's cool. That's also like a smoke signal. Just bit more complicated. All right. What's up. Everything there is to know about addresses shows. I'm sure there's more, but I think this is a nice primer. You're going to call it a day. We are. So thank you for listening to the event. Weird ensures NATO. There you go.
