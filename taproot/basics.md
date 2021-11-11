\newpage
## Taproot and Schnorr {#sec:taproot_basics}

<!--
The Taproot Basics episode covers the main building blocks of Taproot. One of the
building blocks is Schnorr. We covered Schnorr (again) in episode 9 about libsecp256k1.
So I included the (partial) transcript of that episode in the ### Schnorr section.

This being one of the first episodes, the audio quality wasn't great and we were cross-talking a lot, making it difficult to transcribe.
-->

![Ep. 02 {l0pt}](qr/02.png)

break down and explain Taproot, the building blocks that make Taproot possible, and what it enables Bitcoin to do.

Helpful Links:

Taproot Explainer: <https://bitcoinmagazine.com/articles/taproot-coming-what-it-and-how-it-will-benefit-bitcoin>

<!--

We're going to discuss Taproot today. We're going to dive head first into technical topics, I guess. Well, it's the second episode, but Taproot is one of the biggest technical projects in development today for Bitcoin. This week, there was a lot of discussion about Taproot activation. How are we going to activate this thing, if we're going to activate it? We're not actually going to get into that this episode. This episode, we're going to get into Taproot itself first, so what is it? Why is it interesting? What does it do? I wrote about Taproot myself, at one point, for Bitcoin Magazine. When I wrote about Taproot, I cut it into several pieces to make it easy to understand, I think. At least it seemed to work, people seemed to like that article. We're going to do something similar for this podcast. We're going to cut Taproot into a couple of different parts, and then, hopefully, that will make it clear why it works as a whole.

-->

### Merkelized Abstract Syntax Tree

In chapter @sec:miniscript we explained how the P2SH softfork in 2012 made it
possible to hide the contents of a script until the time of spending.



<!--

jors:
And so, from a privacy point of view, that's much better than immediately putting the script on the chain, but it is still unfortunate that, when you're spending, you have to review all these other options, because maybe I'd rather not reveal to the world what my backup plan was.

Aaron:
Right. That's the step I was skipping ahead to, which is, yes, if you are spending the coins alone after 35 years, then the whole world doesn't need to know that you could have also spent it with your mom. Why do they need to know that? There's no reason for them to know that.

Sjors:
Much more in importantly, if I spent it with my mom, the whole world should not have known that they could have waited 35 years and stolen it.

Aaron:
By kidnapping you, or something.

Sjors:
Whatever, yeah.

Aaron:
Yeah. Okay. Anyways, regardless of specific examples, the point is: Once you spend money, you should only have to reveal the solution you're using, not all of the other options.

Sjors:
Okay. Now, if only there was a way to do that.

Aaron:
If only, Sjors.

Sjors:
Aaron-

Aaron:
Wouldn't that be great?

Sjors:
... tell us about this amazing invention.

Aaron:
This has been in the works for a couple of years. You want to get to MAST, right?

Sjors:
Exactly.

Aaron:
Yes, we want to get to MAST. For a couple of years, there was this idea called MAST, which stands for Merkelized Abstract Syntax Tree.

Sjors:
That's right. Merkelized Abstract Syntax Tree.

Aaron:
Perfect. This is essentially a Merkle tree of, well, hashes, and therefore of the different ways to spend Bitcoin, so off the scripts. Are you going to explain it, or should I?

Sjors:
I'll explain it once, and then you'll correct my explanation, because it's hard to wrap your head around it.

Aaron:
[crosstalk 00:03:14] Merkle tree.

Sjors:
You could see it as a list. There might be eight conditions. You don't want to show all eight of those conditions, so what you do is you group them in a tree. You put, well, eight of them at the bottom. Each of them, you can buy them, so then you have four. Each of those four, you combine them, so you have two. And then, you combine those two and you have one. That's your pyramid.

Aaron:
Yes. By "combine", you mean hash.

Sjors:
You hash, exactly.

Aaron:
So, you have hashes already off the script of the conditions to spend your coins. These are hashed, and then you bundle each of the eight hashes in this example into couples. So now, you have four couples of hashes, and these are themselves hashed, so now you have four hashes. These are couples, and then they are hashed, so then you have two hashes. These are couples and hashed. Well, they're a couple. It's two left, so that's one couple. You hash them, and then you have one hash left. This is the hash you share, and that's where the coins are spent to. In this case, the coins are spent to this hash tree, the Merkle tree.

Sjors:
Yeah. Basically, what you do is, when you want to spend it, you say, "This is the part of the tree that I want to spend," which could just be a number, and then you give that script. Plus, you give the neighbor script, because they come pairs, and you give a hash of every other point in the tree. If the tree is four high, you need to give four hashes in the script, which is a lot less than all eight of them, and you keep everything else secret. So, you still prove that you didn't change the script. Now, Merkle trees are very common, of course. They're used in blocks, too, for the blocks themselves. They were used for file sharing, bit torrent. All those sort of things. They all have these little chunks. You can just ask for one chunk, and you know for sure that the chunk is actually part of the original file and not some made up thing.

Aaron:
Yeah. If I want to simplify that by quite a bit, then it just means you only reveal the script you care about. You only reveal the scripts that you're using to spend the coins. The rest remains hashed, and you just add some extra data to prove that it was in that tree somewhere.

Sjors:
Yeah, and it scales very nicely. You could have millions of scripts, potential scripts, but in order to reveal any one of those millions, you don't need to reveal a lot of extra data.

Aaron:
Would it literally scale that well? Millions, would that be possible? [crosstalk 00:05:36].

Sjors:
There's probably a limit to it, but a million is two to the power of 20-

Aaron:
Doable.

Sjors:
... so that's 20 layers, roughly. That's still big, because you'd have to reveal 20 times 32 bytes, I think.

Aaron:
It's doable.

Sjors:
That's 600 bytes. You probably don't want to have millions of options, but yeah, it's not too bad.

Aaron:
Is it doable, or not?

Sjors:
I don't know. You'd have to ask me that before the podcast, and I can look up the answer. Or, we could pause again and break another computer, and we'll be back.

Aaron:
Fair enough. Anyways, you can hide a lot of [crosstalk 00:06:16] in there, so it's good for privacy.

Sjors:
Yes.

Aaron:
Like with [crosstalk 00:06:19]. And so, yeah, the other thing you're mentioning now is it's good for scale as well, because you don't need to include all of the possible scripts into the blockchain. The blockchain is a scarce resource. Costs a lot of fees to include all that. Even if you're only including it when spending, you still got to pay all of these fees. With something like MAST, you can keep the vast majority of it hidden. It makes it much cheaper, as well as private.

Sjors:
Great. This could have just been another op code, so another instruction in the script, which has been debated for quite a while, but in comes magic.

[Note: my last remark refers to an earlier proposal, called MAST, which simply added an op code to the Bitcoin script language to introduce MAST functionality. Two downsides that solution are:
1. as soon as you spend it, everyone can see that a MAST tree existed, even if they can't see the full contents of the tree
2. in the case where everyone agrees, you can't just ignore the script and put signatures on the chain: you still have to publish the script and satisfy it, which uses precious blockchain bytes
]

-->

#### Hiding the MAST

<!--

Aaron:
Sure. Wouldn't it be great if we could hide that we're even using MAST itself?

Sjors:
Exactly, because there is an ultimate condition, which is that everybody agrees. If everybody agrees, everybody signs, you don't have to reveal that there was a script.

Aaron:
Yeah. So let's take the example-

Sjors:
But, how would you do that?

[note: in the miniscript chapter we replaced "mom" with "a family member", so we should that here too for consistency]

Aaron:
Okay, yeah. Let's take the example we just had, where you're receiving coins, and it's you and your mom, but after 35 years, you can spend it on your own, or she can spend it if she has some secret that you've put in your will. I don't know, it's something I just made up. This means that in this smart contract, because that's essentially what we have here, that's what it's called, there is this option where your mom and... Was it my mom, or your mom?

Sjors:
Whatever, yeah. Both our moms.

Aaron:
Your mom and yourself are in agreement, and both of you agree. "Just let's spend this money," so you don't have to wait 35 years, and you don't have to include the [inaudible 00:08:02]. In most smart contracts, there is or should be this condition where, okay, everyone who's involved with this smart contract just agrees that let's spend the money.

Sjors:
That's right.

Aaron:
That's almost always the case, or it should be the case, arguably.

Sjors:
Yeah, almost always. Yeah.

Aaron:
Right. Are we skipping-

Sjors:
It would be nice if there was a way to express that, right? It would be nice if you could just not show any of these scripts, not show a whole tree, but just show a signature. The way you would could do that is by tweaking your public key. Instead of saying, "Send this to my public key," you roughly would say, "Send this to my public key, plus my mom's public key, plus this MAST key." The idea is that you can tweak keys. It's very oversimplified, because cryptography is very subtle, but in theory, you can add up keys, and then you can also add up signatures, and it looks to the outside world as if it's just a regular signature. And so, you can hide a bunch of stuff in there. The problem, however, is that in an ideal world, you can just add these signatures, but in practice, we have this quite difficult signature algorithm called ECDSA.

[note: we make bridge here between MAST and Schnorr, because the more powerful Schnorr
signatures make it possible to:
1. turn multiple signatures into a single signature (so in a 2-of-2 multisig, if both parties sign, it will look indistinguisable from a normal single signatures 1-of-1 wallet where 1 person signed), saving block space and improving privacy
2. hide a MAST by tweaking the public key and signature, this one is tricky to explain:
   * a MAST is represented by just a hash, i.e. the hash of the top of the tree, which is created by hashing the two items below it, each of which is created by hashing the two items below them, etc
   * a hash is just a big number, so is a private key
   * so we add the hash (number) to the private key, which will look like just any other private key
   * a hash can be turned into a "public key", just like a private key can be turned in a public key
   * it's commutative: public_key(private key + hash) == public_key(private_key) + public_key(hash)
   * when spending this provides two choices:
     1. don't reveal the hash, just sign with the (private key + hash) as if it's a regular private key
     2. do reveal the hash, sign with the original private key; in that case the blockchain requires that you reveal the relevant parts of the merkle tree (which anyone can verify results in that hash) and satisfy the leaf script

Because below I'm splicing in another episode all about Schnorr, we should probably explain the benefits up front, because it will take a while to get back to this.
]


-->

### Schnorr {#sec:schnorr}

<!--

(this transcript is from episode 9, and continues from the libsecp256k1 episode)

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

<!-- back to the basics of taproot episode, we explain Schnorr, public key tweaking and MAST, mostly duplicaing what I explained in the note above


Aaron:
In Bitcoin.

Sjors:
Yes. There was something before that, which is called Schnorr.

Aaron:
Schnorr signatures.

Sjors:
Yes. Mr. Schnorr is a German professor, I believe, who invented a really nice way to do digital signatures. Unfortunately, he patented it, and so nobody wanted to use it. And so, a bunch of lawyers basically, together with engineers and cryptographers, tried to figure out if there was a way to maim Schnorr's algorithm so far that it would legally not fall under the patent, but still work. That is what is ECDSA. That got really standardized; the NSA published some nice numbers for it. OpenSSL, the cryptographic library that many programs use, which is also maintained, I think, by just one person, it used that. And so, when Satoshi, probably when he was working on Bitcoin, he had to pick a cryptographic curve, and he just picked something from OpenSSL, namely ECDSA and not Schnorr. First of all, he knew it was patented, or the patent maybe just ran out, but second, there was just no implementation of it and it's much easier to just use a library, because writing your own cryptography is really, really hard. Whatever this massive team was that Satoshi supposedly had, did not have a cryptographer that could do that.

Aaron:
The nice thing about Schnorr, I guess, if I would put it in one sentence, is that you can perform math on it.

Sjors:
Yeah. You can add signatures in Schnorr trivially, whereas with ECDSA, because of this maiming that they did to get around the patent, you can add signatures if you spend a lot of time and you're very careful, but it's very complicated.

Aaron:
If you simplify it a lot, I would say, or this is how it was explained to me, I think, at some point, simplified a lot. Or, maybe I just made this up at some point; it's also possible. Anyways, the simplified example is that a public key plus one would correspond to a private key plus one.

Sjors:
Exactly.

Aaron:
A signature plus one. You can do math stuffy things with it, and then it still makes sense.

Sjors:
Yeah.

Aaron:
Right?

Sjors:
Well, a public key plus another public key, and then if-

Aaron:
If you develop a public key, and it can be combined with the private key, plus the private key.

Sjors:
Exactly.

Aaron:
[crosstalk 00:11:44].

Sjors:
The signatures can be added; all of it can be added. Yeah, but not with ECDSA, or at least not easily with ECDSA, but with Schnorr, it still works.

Aaron:
The good developers have been wanting to add Schnorr to the protocol anyways. This was a project even before Taproot was thought of. People were thinking of adding Schnorr, because you can do all cool stuff with it. And then, at some point, Greg Maxwell, the former Bitcoin Core developer, I guess we'll call him-

Sjors:
Yeah, he's still a Bitcoin Core developer. He still reviews code.

Aaron:
Is he still contributing?

Sjors:
Yeah, yeah. He mostly reviews code, but yeah.

Aaron:
What's that?

Sjors:
He mostly reviews code, but he's there.

Aaron:
Right, okay. Well, that's definitely contributor then. I thought he was-

Sjors:
No, he's not loud on Twitter, because he's not on Twitter, but that doesn't mean he's not there.

Aaron:
No, I thought he retired, or he was just lurking on IRC or something. Anyways, that's [crosstalk 00:12:31].

Sjors:
No, he's there.

Aaron:
But, he came up with this idea to use Schnorr in this very clever way in combination with MAST, and that brings us Taproot.

Sjors:
Yes.

Aaron:
Correct?

Sjors:
Basically, because you can add anything to a public key, you can also add a script to a public key, because a script is essentially just a number and a private key is essentially just a number, so you can just add numbers.

Aaron:
Well, yeah, or hash.

Sjors:
Well, hash is a number too, and a Merkle root is also just a number.

Aaron:
Yes.

Sjors:
In fact, everything is a number, but yeah.

Aaron:
[inaudible 00:13:00]. Do you mind just explaining what's cool about this?

Sjors:
Yeah, so-

Aaron:
Let's say, we've been taking this example with me and my mom, or you and your mom. Either way, it's someone and his mom.

Sjors:
Yeah. Well, let's simplify that example, because that's multi signature. Let's just say it's just you, or if you forgot your own key, you can use some secret, which is a very bad idea, but let's say you would do that. So your script, your MASTs, would contain two options. Either it's you, your signature, or it's this secret piece of information that you wrote down somewhere else without a signature. Like I said, do not do this, but imagine it was that. If you know your key, if you still have your private key, it's a shame to reveal the fact that you could have revealed the secret number. And so, what you can do now is, in Taproot, thanks to Schnorr, you can actually take this MAST and hide it inside your public key. And then, when you're signing the actual transaction, you are just signing a public key and you're not even revealing the fact that there is a Taproot out there. You're basically just ignoring it, because you just add the hash to your private key. You've added the hash to the public key, and nobody needs to know.

Aaron:
Yes. For The outside world, they don't see any difference between a tweaked public key and the original public key. If you've tweaked your public key with this MAST structure, it looks the same to the rest of the world.

Sjors:
Exactly. If you do want to use this MAST structure, what you do is: Instead of revealing the tweaked key, you review the original key and you reveal the script, one of them.

Aaron:
Which you used to tweak.

Sjors:
Yes, and therefore, the person verifying, can take that script, calculate the hash, calculate the other hash, add it up to the public key. Now, they can see that that's the tweaked public key, and they can see that the signature is valid for the whole thing. It's nice. You can choose to not reveal anything, not even the tree itself, or you can reveal any part of the tree.

Aaron:
Yes.

Sjors:
This is much better. It's also more space efficient, but it also means that if you're sending coins to somebody, it doesn't matter if you are sending to a single person, which is one key, or some super complicated exchange, or some other condition. It all looks the same.

Aaron:
For me and my mom?

Sjors:
Yes.

Aaron:
I do want to give that example, just for extra clarity. If I would accept Bitcoin with my mother using this trick, then we would combine our public keys. And then, we would also have a MAST structure, which includes, "I can spend it after 35 years, and my mom can spend it with the secret number." That's all in the MAST structure, right? And we have the Merkle root for that. Now, if you want to spend the coin, we both agree. We just both sign, combine the signature, and tweak it with this MAST Merkle root. Therefore, what we publish to the outside world just looks like a regular signature, spending the regular public key, which was always public, and the rest of the world will just think, "Okay. Well, that makes total sense. We'll accept that."

Aaron:
Now, if my mom can't sign for whatever reason, or if I can't sign for whatever reason and she has that secret, then... Let's take an example where my mom can't sign for some reason, and five years passed. At that point, I reveal that it was actually a tweaked public key. I reveal the tweak; I show the world. Look, this MAST structure was hidden under this hash, which I used to tweak. The rest of the world can look at that and say, "Yep. That adds up. The math makes total sense. That was what you were always doing; we just never were able to see it. Yep, 35 years have passed, so you're totally allowed to spend this money now on your own."

Sjors:
Exactly. And so, that condition is only revealed if you actually use it. Otherwise, it would've forever been a secret, unless somebody hacked your wallet.

Aaron:
Exactly. As long as my mom is able to sign, and I'm able to sign, no one ever needs to know that there were other ways to spend this coin. So that's great for privacy, fungibility.

Sjors:
Yeah. And so, this tweaking, this disability to hide, is Schnorr. The fact that you can have multiple conditions and only reveal one of those conditions, that is MAST. But, this magic is combined, like Captain Planet, and now you can do all these things, but this is why Taproot is a fairly large proposal.

Aaron:
[crosstalk 00:17:29]. What's that sentence?

Sjors:
Heroes. Earth, wind, fire. Blah, blah, blah. Captain Planet.


-->

#### Great, what are the cool features?

<!--

Aaron:
What do people use this for? Is that the next point, or did we forget something?

Sjors:
People can use this for the complicated scenarios we described.

Aaron:
Is there anything new that's possible now?

Sjors:
A couple of things. One is you can do multi signatures without script, because you can actually just combine multiple signatures, and there's some protocols for that.

Aaron:
[crosstalk 00:18:03]. Different parts of the tree, which allows different people to [crosstalk 00:18:06]?

Sjors:
No, not even the tree. Even without using the MAST structure. The Taproot itself can be one signature, but it can also be a multisig, but just an M-of-N multisig, because there's just general math that you can use to combine signatures. That was possible; it's called threshold signatures in ECDSA. There's lots of papers about it and it's all very complicated, but with Schnorr, it should be slightly easier. By easier, I mean there's still only five people on the planet who can understand the math so they can write tools.

Aaron:
Collaborative spent. That's what we're calling it, right?

Sjors:
Yeah.

Aaron:
That can have a multisig? N-of-M, kind of?

Sjors:
There's a proposal called Musid. What it does, is it adds the signature.

Aaron:
It's spelt M-U-S-I-D.

Sjors:
Exactly. It combines signatures.

Aaron:
It's not M-U-S-I-C. Anyways, go on.

Sjors:
To the outside world, it will look like a regular signature. It just looks like a regular public key and a regular signature, but really, it's a combination of public keys that are then all signing and you can add them up. In theory, I believe you can also do threshold things with that. That will still look like a single signature and a single public key, but actually, it's two out of three signatures. You don't have to bake it into the protocol, so as long you support Schnorr, then somebody can come up with a way to combine these signatures, and to the outside world, it will just look the same. That's not actually part of the protocol, but that math still needs a lot of verification and people need to make tools around it, but Taproot enables that stuff.

Aaron:
Right. What I really like about Taproot is how it makes Lightning more private, like the opening, closing channels.

Sjors:
Yes.

Aaron:
All that stuff just looks like regular transactions. There's no way to tell if people are using the Lightning at all, right?

Sjors:
Correct, because lightning, again, is an example of usually both parties agree. Both sides of the channel agree in an operation, and for the rest of the world, it will just look like a normal transaction. But if they disagree, there's all these additional timeout conditions. Those can be nicely hidden inside the Taproot, so that's very nice. The other benefit is that, if you have a payment on Lightning, it goes from hop to hop to hop. Right now, you're revealing a pre-image, which is just something that you hash, and that thing is the same for every hop. Somebody who can see all the nodes can see that one payment belongs to the same person.

Aaron:
Or, if you're a spy on a route, on different parts of the route, you can see. You can connect to this [crosstalk 00:20:44], right? [crosstalk 00:20:44].

Sjors:
Yes. There's some exploits based on that, actually.

Aaron:
So that would be hard right now?

Sjors:
That would be more difficult, because instead of using a pre-image in a hash, you just use essentially public keys and private keys. Everything would just be points on the elliptic curve that you're adding up, and then every point along the route can tweak the number slightly differently. To an outside observer that does not know the private keys, they just look like random numbers. Now, they can still correlate the amounts, so there's still some problems remaining, but again, it's an increase in privacy, which is very nice. Yeah.

Aaron:
Yeah. One point I would say about Taproot is that it seems, to me at least, but I'm probably going to be proven wrong on this. It seems, to me, like all of the things we want to do with Taproot are technically possible already. It's just, right now, it's just not very privacy friendly or it costs a lot of data.

Sjors:
Some things are not technically possible.

Aaron:
Yeah, [crosstalk 00:21:48].

Sjors:
I think the maximum for multisig is 15, right now, so you can do infinitely large multisigs. Either by adding these signatures, as I just described, but also just by making a very large tree, and you just put all the combinations in.

Aaron:
Right.

Sjors:
Yeah. You can strictly do more, but I would also say that, yeah, for most people, you might not notice the difference, except your privacy is just going to be slightly better. As these advanced options come along, you'll just use them, but you won't notice them. I agree, it's not as dramatic. Segwit, when it was launched... Segwit Zero, by the way, because Segwit is versioned. Taproot is Segwit One, or we use it as Segwit One. When that came along, it enabled Lightning, because Lightning was an absolute pain in the ass to do without Segwit. There were all these papers with trusted hardware modules and all sorts of weird stuff. It was really hard. There came Segwit, and now we have Lightning. Now, Taproot, again, improves things about Lightning. There's other software proposals that can improve things about Lightning, and those improvements should not be trivialized, because I think when Lightning, if it gets real big and is under attack all the time, some of these things that we con currently ignore can't be ignored, and then it's very nice to have a bigger toolbox.

-->

Helpful Links:

The Power of Schnorr:

https://bitcoinmagazine.com/articles/the-power-of-schnorr-the-signature-algorithm-to-increase-bitcoin-s-scale-and-privacy-1460642496

Schnorr and Taproot workshop with text, video and interactive Python notebooks: https://bitcoinops.org/en/schorr-taproot-workshop/

<!--
TODO: continue transcript from episode 2
-->
