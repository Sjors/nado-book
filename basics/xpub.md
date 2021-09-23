\newpage
## What is an Xpub?

Listen to episode 7:

\qrcode{https://nadobtc.libsyn.com/what-is-an-xpub-nado-7}

explain what an xpub is and how it is used by Bitcoin wallets.

Transcript (computer generated):

Aaron:
So, yeah. Welcome back. We're going to discuss xpubs today.

Sjors:
Xpubs. Yes. Did you get the drama

Aaron:
Apparently?

Sjors:
Exactly. I hear this drama. I have no idea what the drama is about. I'll do my best to, to reconstruct what I think to drama is about. Yeah.

Aaron:
And I'm not sure what the drama is about either, but I think I have a faint idea. Well, we'll get to that later.

Sjors:
Now we can get to it. Now. I think my theory is that for some reason, people were talking about xpubs and then Peter McCormack got really upset and said, I don't know what experts are, but I'm proud of it. And then of course, all the Bitcoins said, oh my God, Peter McCormick does not know what an xpub is and they'll start it, you know, explaining it to him. And yeah. So that's why we're talking it.

Aaron:
It's like the classic cycle where it, where Peter McCormack says something slightly controversial about how everyone's being too, too nerdy about Bitcoin. And then everyone gets mad at him because he's not a real Bitcoiner. So then he gets his controversy for a show and then all the Bitcoiners get their, for two signaling for being a hardcore Bitcoin and everyone is happy.

Sjors:
Well, and if you want to virtue signal properly, you should listen to this podcast.

Aaron:
But I think even, I think that's not where it started, I think, but again, I only have a sort of faint idea of where the drama came from, but I think it started with Samourai wallet posting this article about how Wasabi wallet had some sort of weakness. Which was, I think very overblown, as far as I was able to tell, it seemed like a very overblown concern. They were making a lot of noise about it, which seemed the problem was actually pretty small. As far as I could tell while Samourai themselves, they have this xpub thing where if you're not using a full note, then you're sending your xpub to summarize. So that's actually very bad for privacy, which we'll get into. . Plus if you're mixing with other users on Samurai has their xpub, then that is detrimental to the anonymity set. I think that, so it's kind of these things where, you know, if you live in a glass house, don't throw stones. .

Sjors:
I believe that's a samurai developer once at that.

Aaron:
Oh he said that?

Sjors:
Like years ago in a different drama.

Aaron:
Okay. Well, I think that's sort of what's going on here where Samurai said something about wasabi and then people started to criticize, Samurai themselves for some of the weaknesses. And I guess that's maybe where Peter McCormack came out and said, I don't know an an xpub is.

Sjors:
I don't know if he actually said that I'm making that part up. So

Aaron:
I'm not even, I'm not sure about the first part either. So we're, we're just spit balling here. But this is probably, this is like a, how a classical Bitcoin Bitcoin drama story would unfold. Isn't it? Exactly.

Sjors:
This is a very stereotypical, so

Aaron:
This may well have been how it happened.

Sjors:
All right. So maybe we should then explain what an X puppet is. So let's

Aaron:
Get through to the X ball.

Sjors:
So a long, long time ago, my dear grandchildren, when you roll, you know, anyway, you have this wallet before it was called Pittcon core, but the original Bitcoin wallet, and what it would do is it would give you private keys. And because people already quickly realize that average uses a bad idea. It creates a new private key. Every time you receive coins or every time you send a change back to yourself. And in order to make the new address, you need to make a new private key. And those private keys are perfectly random or they should be perfectly random. A problem then is how do you back up your coins? And the idea was that the first time you start that going, you get about a hundred, maybe it was a different number keys, and you print those out or save them on some, you know, Arctic volt, whatever, and you move on with your life. But then once your 100 keys are all used up, a wallet will just create a hundred more keys. And if you forget to back those up and it's not like the wallet will warn you, uh, right. You're you are toast, your change will go for your keys, correct. Your change will go to the key number 101. And if you, if you then like, I have a boating accident or something, you

Aaron:
Yeah, your, your computer crashes and then you don't have a backup.

Sjors:
So quiet,

Aaron:
But by the way, this isn't even that long ago, I think. Right. Because you started explaining this, like, it's, it's pretty a story, but isn't that like just a couple of bits Glencore versions ago that seats were introduced.

Sjors:
I don't think they can cause the first thing to introduce seeds, it's probably quite

Aaron:
Sure it's not spot Bitcoin core was pretty recent when that was not very long ago.

Sjors:
I think it was 2016 or something since that it started using deterministically derived keys has been only a few years. Yeah. Yeah. But I think there was a standard proposals to do this in 2013. So standards have been around a bit longer. It's called bit 32. Yeah. And the idea there is that you create a single master key from which you derive all the other keys deterministically so that if you know the master key, you know, all the individual keys and to the outside world, while all of these,

Aaron:
All of the individual key. Correct. Right.

Sjors:
Yeah. And to the outside world, you just see random looking addresses, but to you, they're all connected. So let's go into

Aaron:
That in a little bit more detail. So first of all, the master key, that's a random number. That's really all of this and yet, right. And then from that random, because that's all private key ever is just a random number. And from that random number, you can generate seemingly random number, which is the public key, which is actually mathematically linked. But the math only works one way. So one way function.

Sjors:
Yeah. And so the idea is you start with a random number and then you hash the random number and you assume that the hash produces another random number

Aaron:
And would, should look run.

Sjors:
Yeah. That's like, you should not be able to predict the original number from it and you should not get collisions. So should be, if you start with a 256 bit number, that means there are two to the power, 256 possible numbers. You hope that if you run those through a hash function, the result will also be due to the power of 2 56 different numbers. And not for example, with some of the earlier sharp functions or MD five or whatever, where you might have two different numbers that would produce the same end result, that kind of stuff. Yeah. Assuming that's all correct. You basically. Yeah. You start with a single random number and then you generate a whole bunch of private keys for your wallet, which is great. Okay.

Aaron:
So let's see, we started with this random number, the master key. What do you derive from the master kit first?

Sjors:
You basically, you can put these numbers in a tree. So without bothering people with the exact math, if only because I don't know the exact math, you create a child key at one level or multiple child keys at a level. So you can have a tree with branches where you might want to divide your coins into accounts or other things. Yeah.

Aaron:
Clear for Peter. If he's listening, we're not talking about actual trees. We're talking about we're generating numbers from other numbers. Correct. And that's what we call the branches. The numbers we've just generated from a different number. That's what we call a branch, right. From this branch, if you want, you can generate another, that's another number. And then,

Sjors:
Yeah. And there's this somewhat of a standard way to do that. So for example, most Bitcoin wallets, when you create an address, that's not segwayed, you would start with the master key, then you do derivation number 44 hard-earned and we'll get into what hardened means. Then you do derivation number zero hardened, which has, this is Bitcoin. And then you do derivation number zero hardened, which is your first account because we count from zero, of course. And then you do another derivation zero that says this is receive address and another, and then you do derivations zero or one or two or three or four or five or six or seven, depending on which address you're about to use. So that's kind of what it looks like. And while I all do this automatically, and if every wallet does it the same way, then you can actually import it to a different wallet. Now let's say you are not using your own node and you want to look up your balance. Now you have a problem because to the server, you have to ask it, Hey, this is my address. What's my balance. And you could give it a list of a thousand addresses, uh, that could get quite slow. And so what you said would do is you sent this thing cold, the X pub,

Aaron:
The

Sjors:
X Bob. Yes. And so the expo is a master public key, not a master private key at a certain part of the tree. It'll give you all the addresses below that part of the tree. This tree is hanging upside down to be clear. So that's, that's what trees do in technical literature. So for example,

Aaron:
We'll add a, uh, article with a couple of pictures in the show notes, because pictures really do help when, when trying to understand this. Yeah.

Sjors:
But basically if you, if you say you have an account, uh, some sort of separation of funds, then you would give the server the expo for that account. So the server can then see all the addresses for that account, but not addresses for your different account or even for your different coins that you may have on the same tree, somewhere else in a tree.

Aaron:
Yeah. And so I'm, I'm a wallet, I'm a wallet right now. Okay. And you're, you're a surfer. Yeah. Um, I don't have to full blockchain and I want to know how many funds I have, how many Bitcoins I have. I could send you a bunch of addresses that I know I have because I have my, you know, I can generate them. And I know I have my seed so I can generate all my addresses. And I, you know, for example, we'll get to this in a bit, but I'll send you my first 20 addresses. And then I ask you a short, uh, how many Bitcoins do I actually have? Can you please check the blockchain for me? Yeah. I could do that. Or I could send you my ex pub. And that way you can generate my 20 addresses plus way more you can, uh, generate as many as you want. Yeah. And then you tell me how many hats, so that's sort of two different ways of doing it. So yeah. Some wallets shared their X pubs.

Sjors:
Exactly. And if we want to go a little bit more into detail there, the expert is what you do as you derive change, address, sorry. Receive addresses from it and change addresses because your wallet might have changed and stuff. Sure. And then, and so the change, the receive chain is child number zero of the expert. And the change Jane is child number one of the expert. Sure. And then every address is child number zero one, et cetera, all of that. And so typically yeah, you, the server would generate all these addresses, but of course the problem here is, okay, let's say I'm sending the server one expo every 0.1 seconds. And the server has to derive all these actresses that gets pretty painful. So maybe you don't want it to serve it, to derive a million addresses. So then the question is what, what's the reasonable limit and a wise man or woman in 2013 said, let's make that 20.

Aaron:
We're now getting sort of into the problems with [inaudible]. Yes. Yes. Okay. So they're listening to now getting into the problems. So it shows what you're saying. Yes. So you, you want to, I'm asking you, how many, how many phones do I have? So I send you my X-Box I'm the wallet still, and then you're generating, how many are you generally?

Sjors:
I'm going to look at the first 20 addresses of that expo. And then the rule is if I don't find anything, I'm going to stop looking.

Aaron:
Yeah. You're just kind of assume you don't have any funds or you're going to assume, I should say I don't have any fun,

Sjors:
But if I do find something, I'll keep looking basically until there's a gap of 20, that's called the gap limit. Right.

Aaron:
And, and I'm assuming that's, when you say you don't find anything, it doesn't just mean if there's any funds in the address. Now it just means if there's funds now or ever.

Sjors:
Exactly. Yeah. Because the way most block explorers do this is they have an index of every known Bitcoin address. Sorry. I looked at her and the transactions that ever went to that address. So I just generate all these addresses and I see if they're in my database and if they're in my database, then I just keep looking and looking and looking until I don't find anything in my database anymore.

Aaron:
Yeah. So as a Steiner, this is some sort of protocol standard. This is just a way, you know, someone came up with this and did it became sort of a, what do you call it?

Sjors:
It's a wallet standard. Right. But it's not a consensus.

Aaron:
Yeah. W sorry. That's what I meant. It's not electric consensual, but it's become like a one center. So you're, you're looking for the first gap of 20 addresses that have been completely unused. And from then on, you're going to assume, okay, that's how far you got with this addresses.

Sjors:
You were assuming here that the way people use it is they create an address. They send it to a friend, they received some coins, then they do it again. But maybe sometimes their friend doesn't pay. Right. Right. That scenario, it makes sense to have this 20 limit. Yeah. Problem is now you're running a web shop, a, let's say a BDC pay server. And this server generates an invoice every time the user goes to the checkout, but a lot of people just abandoned the checkout. And so

Aaron:
Yeah, they get to the checkout. I figure out, wait, this is actually too expensive or wait, I don't actually have enough Bitcoin in my wallet or, and another, maybe they're just no with webshop that's also possible

Sjors:
Or spying on the web

Aaron:
Travel.

Sjors:
Yeah. Or spying on the web shop. Oh yeah. They might want to know all the addresses. And in the case of BDC pay server, there was a specific thing where it also supports lightening, but it's going to make an on chain address, even if you use lightning, which means that for every lightning payment, there's also an address being generated, which is not used. And so that, that gap of 20 is reached pretty quickly.

Aaron:
Right. So then 20 people in a row use lightning, or for some other reason, don't make a payments, bitsy pay surfer. That's all we were talking about too. Yeah. So they ask some server, how many Bitcoins are in my address and is the surfer checks these 20th verses in the roads that haven't been used. And then they assume, okay, well, that's how far the Walt has been used. So every payment that's came after, it just doesn't show up and bitsy pay for server or

Sjors:
Well, BTC pay server will be fine. But if you let's say you're using VTP server with a hardware wallet, and you then want to see with your normal hardware wallet, software, what is actually on the wallet, your normal hardware wallet, software. It might not show it depending on if they actually honor the gap. Right. Which they might not because a lot of wallets will actually scan a bit more than that. But I mean,

Aaron:
And he's a problem to solve this. Isn't even really a problem with expo. This is the problem with the wallet standard that someone came up with at some point, oh

Sjors:
Yeah. It's nothing to do X-Box specifically,

Aaron:
But it is a problem with deterministic key derivation that you have to do straight off between a dos factor and good privacy, because you could just use the same mattress all the time. That's back for privacy. We could generate a new address all the time, but now somebody needs to track that. And that can get out of hand. If somebody is attacking you still, this seems like a minor problem to me.

Sjors:
I can assure you from having worked on Wallace, that is a major headache, but in the scheme of things for Bitcoin, I'm sure it's a minor problem, right? If you're the one needing to deal with a problem, it's not a minor problem. Exactly. Because also the other thing is maybe a hardware wallet. That's really smart, like a hardware wallet that can actually parse transactions or a blockchain. It needs to go through that. And it might be very slowly derivations. So there's some limits there at least, because I think I, once casually proposed to people to increase the cap, limit, some people who worked on hardware, wallets are like, don't even think about it.

Aaron:
Right? The next problem seems, or I already mentioned it, but that seems like a much bigger problem to me. That's, you're giving up your entire privacy. If you're using a wallet with next pub,

Sjors:
If you're doing it that way, I mean, obviously you should run a full node and do everything yourself. But if you're using a remote server to check your balance, then yeah. It's not good for your privacy. If you just give them the Xbox, because they can see all your transactions and worse than that or your transaction ever. Yeah. And in the future. Yes. So if the, our tax authorities ask you for your expo, you're screwed because now the tax authorities can just watch you forever in real time, unless you, of course, James a wallet. Yeah. So that's not good. I think some hardware walls and some software while it's still do this, others might've gotten a little bit better by actually sending individual addresses. But this is tedious too, because let's say your wallet and you only sent the last 10 addresses to the server. Well, what if somebody sent you money to the first address and now you occasionally still have to check the first address or the user logs in and says, oh my God, the money never arrived. And then there has to be some refresh button or something that sends all the previous addresses. So make that UX work is tedious. Yeah. It's no problem if you run your own node, but the whole point for these experts is kind of to make it easy to communicate with the server.

Aaron:
Yeah. All right. So we have the gap limits, problem, privacy problem, or any other problems.

Sjors:
Well, yes, I think we'll get to that, but maybe we can talk about this original seed again, this, this master key, uh, because there is this really nice.

Aaron:
This is not really a problem with X expo. No. You just want to talk about the seat. Yeah. Okay. Let's talk about the seat.

Sjors:
I mean, we don't have to talk about expo at the time. That's what the episode

Aaron:
Is about those shorts.

Sjors:
Well, we'll get to that. Okay. On. So basically this, you start with the master key and the master key could be written down as, as a hexadecimal number of it's kind of difficult to remember and difficult to write down. I think most people don't like writing Hicks. And so there's a standard called BIP 39, which changes it into a word, a nice goldfish or dokie version of that of a, of such a phrase could be a much surprise, very convinced guard change, right? Radio network leader, et cetera, et cetera,

Aaron:
To be clear, this is an actual, this is something you could actually use. There's a doggy version of CBE. Yes.

Sjors:
I suggest not using it. It suggests not using it, but it is possible. It's possible. Yeah. Yeah. Because there's a set of 4,000 words roughly. And you know, and if you take 12 or 24 of those, you get 128 to two and then 56 bits of randomness.

Aaron:
Yeah. So to be clear, we, we started out saying that the master key is just a random number basically. And what you're explaining here is that you can convert this random number into a series of words.

Sjors:
You can't, you start with a series of words and you convert it into that random number the other way round.

Aaron:
Yeah, you're right.

Sjors:
Um, but that's fine. So that's what people tend to write down. Those 12 to 24 words are the start of the masters seed, which then eventually leads to this X-bar once you get to a specific, uh, sub part of the tree. Yep. That's all good and fun. There are some problems with the choice of words is one of those standards that was developed before people were using it in generally when you do that, it just people then actually start implementing it into wallets and thinking about it a little bit more. And they're like, actually, this kind of sucks. So for example, some of the words are too similar. Other words have too many, the same starting letters. So if you're typing on a, on a tiny little hardware wallet, trying to type in the words, usually it just asks you for the first couple of letters, but the word list was not chosen smart for that. So you often need quite a few letters, even though that could have been done better, there's some other problems would make it hard to translate.

Aaron:
I think there are some very specific Bitcoin words in there, which some people have objected to because it sort of gives away that it is a Bitcoin wallet.

Sjors:
I can assure you if you type 12 or 24 words in any online place that hits any server, there will be some malware on that server that will, that will interpret it as a Bitcoin seed. And we'll take all your coins within seconds. If not now, then by the time you need your seat, it will be the case.

Aaron:
Well, still, you know, there's some burglary in your home and then there's 12 words. And then if one of the words is Satoshi, then that might increase the chance to study.

Sjors:
There are some police manuals floating online that basically say, Hey, look for 12 to 24 words in somebody's flower pot. And if you have that, give it to this guy and he'll take all the Bitcoin, right? Yeah. That's that's well known. I don't think you can fix that unless you also randomize the number of words and to something other obscure. Then of course the trade-off is if you die and nobody knows what the hell to do. So it's, that's tricky

Aaron:
Anyway. So yeah, you think the standards this time could have been optimized,

Sjors:
I will say, but it's not a big enough problem that people want to revamp everything for it.

Aaron:
Yeah. Plus I think it would be a bad idea to revamp everything for us. Like as long as it's worked well enough, I would say, let's keep it because it's good. If people can keep using their seeds into the future. Oh, well, if Wallace update their software all the time to you to use different seeds, then people are going to lose their money because they can't remember which software to use to which

Sjors:
The way you would upgrade this is by making. So that software can tell whether it was an old style or a new style phase

Aaron:
Compatible

Sjors:
Or not backwards compatible, but the opposite. So basically there would always be a word in the new seed that is not valid than the old seed. So old software just won't even recognize it. No, but I

Aaron:
Want, oh wait, also form Woodlands. Recognize it.

Sjors:
So if you, if you were to come up with a new standard, you would put a word in that standard. Yes. That is not part of the old standard.

Aaron:
Yeah. But I'm thinking about the opposite thing. Like in 10 years from now someone at their seed from cold storage, they download a wallet. They want to be able to insert that, even though there was no, it uses a new type of seat.

Sjors:
Yeah. So you would have to have all the modern wa wallets off air would have to support the old standard at least as an import. Yes. And I guess if you don't have a new standard, that's more likely to be the case for the need

Aaron:
To be backwards compatible. Yes.

Sjors:
The software needs to be backwards compatible, but the standard doesn't that's okay.

Aaron:
I, yeah. Good point.

Sjors:
So another thing sort of related to this about standardization is that these 12 to 24 words I think is mostly the same for every wallet, the way that works, but there are derivations. So how do you go from the root of the tree, the master key to each of the addresses in your wallet. And unfortunately several wallets do that in different ways, right. And a headache causing way. So if you find those 12 words and you think you've got somebody who's Bitcoin, well, you, maybe you do, maybe you don't, but they could be anywhere in that tree. So there's a site called wallet, recovery.org, wallets, recovery, that org, sorry to send you to a phishing site, if you typed that wrong

Aaron:
Wallet, recovery, that org,

Sjors:
And that has a list of old and new wallets and how they actually go from the secret or the mnemonic to each individual address. And it just tells you that it's a bit of a headache.

Aaron:
It was just an incredibly long list. Yeah. But a lot of them do sort of use the same thing that in a Mexican looking at list a little bit closer, it's not like they're all doing something different.

Sjors:
Yeah. I mean, th there's basically for the old style addresses, you know, it usually starts with zero it's it's 44 slash zero slash star for the accounts and for SegWit wrapped it's 49 and for a native sequitous 84, once you get to multisig, your headache might increase like how to derive a multisig wallet with two different seeds and the different roles and what sequence and stuff. Yeah. That's painful. So basically when you back up a wallet, you better also back up how, how their patients work. So you may want to not just write down your moniker, but maybe some hints about what wallet software you were using. Yeah. Depending on who's the audience for that information. Of course. Okay.

Aaron:
Is that

Sjors:
Asphalt? I think so. I think we've, we've uncovered the mystery. We've addressed the drama we have, uh, we have deescalated the conflict. That's what we're here for. I think we're good. All right. Anything else you need to cover? No, I don't think so. How long have we been recording now? 25 minutes long enough. It's long enough. All right. Thank you for listening to the van Greer. I'm shorts, NATO. There you go.


Helpful Links:

http://rosenbaum.se/book/grokking-bitcoin-4.html#_hierarchical_deterministic_wallets
https://walletsrecovery.org
