\newpage
## DNS boostrapping and Tor v3 {#sec:dns}

Listen to Bitcoin, Explained episode 13:\
![](qr/13.png){ width=25% }

Bitcoin Core 0.21 will support Tor v3 addresses. Aaron and Sjors explain what this means and why it matters, and also discuss how new Bitcoin nodes find existing Bitcoin nodes when they bootstrap to the network.

Timestamps:

00:00 - 00:34 - intro

1:02 - 2:10: how Tor Works

2:25 - 3:03: benefits of running a bitcoin node behind tor.

7:12 - 8:19 Discussing how Bitcoin node gossip addresses.

8:56 - 10:40 Explaining how DNS works

12:30 - 13:30: DNS is storing list of bitcoin nodes.

<!--

Transcript (computer generated):

Aaron:
Life from Utrecht. This is the Van Wirdum Sjorsnado. Hello? Sure. You pointed out to me, that's Bitcoin core has an amazing new future merged into its repository. Absolutely.

Sjors:
We have bigger onions now. Bigger onions,

Aaron:
Onions.

Sjors:
Right. So I

Aaron:
Had basically no idea what it meant. You, you figured it out. I did, you know everything about,

Sjors:
Well, I wouldn't say that, but I don't know. I think I do. So basically

Aaron:
Let's start at the beginning. It's about tour.

Sjors:
Well, it's also about tour. Okay. But the tour was kind of the big, I guess, the big motivator to get everything in there. So if you're familiar with the, have you ever used tour or do you know what tour is? I shouldn't ask those kinds of questions.

Aaron:
I have a basic understanding of what Torres. Yes, exactly.

Sjors:
And when you see a tour address, this is weird little, it looks quite weird, right? That way. That's way to say it. And so the idea is that it's actually a public key, essentially. It's our address. And that refers to a hidden service somewhere on the internet. Right. And the way you communicate to that hidden is not directly because you don't know its IP address, but indirectly through the tour network and you use onion packages for that. Yeah. So, so the idea is that you start from the inside, like the last hop before the hidden service and you give that hop instructions how to reach the hidden service. And then you write instructions for the second last hop and you give it instructions, how to re reach the first hop.

Aaron:
Sure. Yeah. Everyone's everyone is still using IP addresses. It's just, you don't know the IP address of the, the, the tour notes you're communicating with. Instead you're communicating with other tour nodes and every tour nodes communicates with a direct pair. So they, everyone only knows to IP address of their direct peer, but they don't know where the message originated or where it ends up. Plus take country the message because it's encrypted that's right. And in order to support this, all of these tour nodes have their own sort of IP address, which is their Anjuna address. And that's what they use to, that's what you're communicating with direct to their directly. So to say,

Sjors:
Yeah, and big one core nodes can run behind such a hidden surface so everybody can have their, their Bitcoin or run at a secret location. So your IP address remains secret,

Aaron:
Right? What's the practical benefit of that?

Sjors:
Well, your IP address remains secret. So if you don't want the rest of the world to know that your IP address is running a Bitcoin node, maybe that's useful.

Aaron:
Yeah. And I think it's also because if you're running, if you're sending transactions from a IP address, then network analyzes can reveal where transactions originated. Although I guess that's also being solved, right? There's other solutions for us.

Sjors:
Well, that's defense in depth, right? So ideally your note behaves in a way that it looks indistinguishable from all other notes. So, you know, downloads all the blocks and it downloads all the mental transactions. And you can tell which wallet is running inside, which node, but there's all these sneaky companies that try anyway. So, and then they might know that you sent a specific transaction. Well, then they might know which Bitcoins belong to you. And since your IP address is, you know, quite easy to figure out who you are, it could be nice to have tour right. In theory. But regardless, I mean, that's just how it works.

Aaron:
Okay. So you can use Bitcoin from behind door. And I think the thing was that there's a new type of onion addresses. There was an updating in the Tor protocol that's right. And that uses new addresses.

Sjors:
Yeah. So the, the tour addresses are now longer, essentially, which just makes them more secure. I guess we don't need to go into why that is. Cause I don't know why that is. All we know is that onion addresses now version three are a bit longer. And that being said, if you want to run it, keep running a Bitcoin node on tour. You'll have to use those longer addresses because tourists centralized and they have decided to eventually get rid of the version two addresses.

Aaron:
Okay. But they didn't yet. So right now for sure two addresses are still

Sjors:
Yes. I think they've been officially deprecated now and I think in about a year or so till they won't work anymore.

Aaron:
I see. So every, every, anyone who wants to continue using tour needs to upgrades before next year. So to say something like that, roughly. So that's why Bitcoin would need to be upgraded in order to support this new way.

Sjors:
Yes. So then we get to the question of why, why would this make a difference what's wrong with a longer address. And that has to do with how Bitcoin notes spread the word about who they are, because how do you know which node to connect to? And the idea there is that notes can communicate with each other. They send detailed or lists of no notes. So they ask each other, Hey, which Bitcoin notes do you know? And then they get a list of IP addresses. And generally those are either IPV, four addresses or IPV six addresses, IPV six is the new kid in town since I don't know, 1998 or something. Right.

Aaron:
These are the regular IP addresses. Correct. Yeah. [inaudible] Longer as well. And that's because IP four was running out, right.

Sjors:
There's only a, I think 4 billion potential IPV, four addresses. Whereas there's just enough for every molecule in the universe of IPV six addresses. Right?

Aaron:
So there's a list or a Bitcoin notes keep lists of other Bitcoin nodes and their,

Sjors:
The addresses. Yes. And the way you would communicate a tore address that way is you would kind of piggyback on [inaudible] because there is a convention. I think it's just outside of Bitcoin to where if the IPV six address starts with us, certain prefix, certain care, certain numbers, then everything that follows is the tour address because the, the tour version to address, let me see if I got it right. And IPV six address is 16 bytes and a tour address has only 10 bytes, so right. You can hide inside of it,

Aaron:
Which so bit. So Bitcoin notes keep the IP addresses of other Bitcoin nodes. They know, and these are these IP and IP six and some of the IP six are also the tour addresses. And this is what's if you, if w when nodes connect with each other, they share their lists. So everyone has an even more complete list of all of the Bitcoin nodes. Is this correct? That's right.

Sjors:
Yes. Department with a tour version, three addresses is that they are 32 bytes, which is twice as long as an IPV six address.

Aaron:
Right. So now you can't hide it inside an IP six address.

Sjors:
No. So, so w just notes have no way to, to communicate those addresses at the moment. Right?

Aaron:
So that, that has been upgraded. Exactly.

Sjors:
So this is not rocket science to solve, but somebody actually needs to do it. And somebody flooded me from the land, wrote a standard a while ago, I think in 2019, that has a new way of communicating of gossiping addresses. And the major changes that you can, each, each message says, okay, this is the type of address I'm going to communicate. And that can be various types, including the new tour one, but also future ones. And then it can have different lengths. So, right. So in the future, we have a new address for my comes along. That's too long. That's not going to be a problem. Right?

Aaron:
Yeah. So that, so that sounds like a pretty straightforward upgrades from, from my layman's perspective as a non programmer, but a very important one, because we do want to keep using tour potential.

Sjors:
Yeah. And the nice thing is it's it's a completely new peer-to-peer message. So I guess old notes, just ignore that message. Or if, you know, it's an old note that you're talking to, you don't use that message. So newer notes, we'll we'll know this new message and can communicate all these new address types and all the nodes just carry on like nothing happened. Right.

Aaron:
Okay. I have one, one followup question about this sharing of less than sharing of IP addresses, which is not tore specific, I guess, but what, how does it actually, how do you actually connect to the first note? How do you bootstrap to the network? If you have no idea, if you have no list yet of other nodes, then how do you find the first note that this is actually working? Basically?

Sjors:
Yeah. So the bootstrap problem, basically you've just downloaded Bitcoin core or some other client and you start it up and now what is it just going to gas, random IP addresses. No. Right. So it needs to know another note to connect to at least one preferably couple, the way it tries to do that is using something called DNS seeds. The internet DNS system is used for websites. When you type an address, www.google.com, what your browser does is it asks a DNS server. What IP addresses are from that Google domain. Yep.

Aaron:
How many do you know how many DNS servers, there are

Sjors:
Lots of them, because basically if you run a website, your hosting provider will have a DNS server that point see your website, but then your country will have a DNS server that will point to your hosting provider. And your internet provider has a DNS server that points to all these different countries, et cetera, et cetera. So it's very redundant,

Aaron:
Sorry off the trail here, but I do find it interesting. How are these decent DNS servers? How do they remain in sync?

Sjors:
So basically when you have a DNS record, so if you are maintaining a website, you usually have to go into some control panel and type in the IP address of your server and then your domain name. And that's stored on the DNS server. One of the fields you have to fill out at the timeout. So what you're saying is after 24 hours, for example, or after one hour, you should ask me again. So what, when you're, when you're visiting a website, you're going to ask your maybe your ISP, Hey, do you know the IP address for this website? And if it doesn't, it's going to ask the next Dean that server up up the street, basically say, do you know it? And then as soon as it finds a record, it's going to say, okay, is this record still valid or is this expired? And if it's still valid, it'll use it.

Sjors:
And if it's expired, it'll go up closer and closer to the actual, to the actual hosting provider. So it's, it's basically cashed. Does that make sense? So the easiest would be, if you go to a domain, like say google.com, okay. How do you find the IP address? Well, you ask Google what the IP address is, but how do you know what the IP address is for google.com? You don't know that because that's what you were trying to find out. So you have to ask somebody else. And so you ask your internet provider, do you know the way to google.com? Well, your internet provider might not know that, but I would say as well, I know the way to.com basically, and.com will know the way to duck google.com. So that's kind of how it works. Dot NL. Same. You go to, you ask Danelle. No. Where is Google dot Anelle okay.

Aaron:
Yeah. That makes total

Sjors:
Sense. Yeah. And ideally they already have this cashed because so many people go to google.com that if you asked your ISP, whereas google.com they'll know because somebody else asked, but if they don't know, they'll send you to.com.

Aaron:
Right? Okay. So this is where I'm really getting at the DNS system is ultimately centralized, right? There's a centralization risk there where you're trusting the DNS server.

Sjors:
And for Bitcoin, we're kind of abusing it because they're going nodes are not websites. But the idea is that there are a couple of core developers who run DNS seats, which are essentially DNS servers. And we're just pretending that, for example, seed dot Bitcoin dot S provost dot Anelle, which is what I'm running is a website quote unquote. And when you ask that website, quote, unquote, what its IP address is, you get a whole list of IP addresses, but those appear addresses are Bitcoin nos. And every time you ask it, it's going to give you different IP addresses,

Aaron:
Right? So what if someone corrupts you

Sjors:
And one setbacks? Okay. So this means that the standard infrastructure of the internet, all the internet service providers in the world and all these others are caching exactly where all the Bitcoin nodes are because they think it's just a website. So it's kind of nice that you keep all these lists of nodes. We've done at least store on the internet. And there's quite a few protections on the internet, you know, against censorship of DNS. So you're leveraging all that. But at the same time, of course, if I, and the other people were to lie and run a fake server, we could send you to any note we want, but that will be very visible. All right.

Aaron:
And the reason it's visible is because anyone can request these IP addresses from you, from you, and then check if they're actually Bitcoin nodes or not. Or if you're trying to cheat there, that's the reason they're feasible. Yeah. It would be hard to achieve

Sjors:
If you were to cheat like that, like very non randomly, like to add to the whole world, it'd be very obvious, right?

Aaron:
So, but whatever it happens, like is there another way to connect to the Bitcoin network at that point?

Sjors:
Well, if they're lying, it's tricky, but if they're just offline. So if, if all the Bitcoin DNS seats are not reachable, then inside the Bitcoin core source code and also into debt, the thing you download is a list of IP addresses and as well as you hidden services.

Aaron:
So that's also Bitcoin nodes. They're embedded into the source code, which, which nodes are, these are, why are decent, better than the source code?

Sjors:
It happens every six months or so is we create, we ask all the DNS seed maintainers to provide a list of the most reliable notes, just the older notes sorted by how frequently they're online time. Cause your DNSc tends to track. I've pulled this note once and it was online. So basically what a DNSc does on its site. Is it just, just a crawler? So the DNSc goes to a couple of Bitcoin nodes, ask it for all the nodes. It knows it keeps a list and just go through the list, pinks them all. And then once it's dumping them all, it's just going to ping them all again. And it keeps track of how often they're online. And so you make a list of that sorted by reliability. You take that from all the contributors and that goes into the source code. So that's the fallback. Interesting. But there's only the first time you start your note, at least in theory. So only the very first time you started your note. You need this. After that, you'd keep track of the notes. You, you know about you store all these gossip notes in a file and you start opening the file and you just try to know, do you know about, and only if you run out, if it doesn't work, you asked to see it again. Yep.

Aaron:
And then you keep sinking your list of IP addresses with the new notes.

Sjors:
Yeah, exactly. I think whenever a node connects to you for the first time, they that's one of the first things they ask, who else do you know? I think you can even send them on solicited. Okay. Which is why, you know, if you start a new note, you get inbound connections pretty quickly. Cause, cause you've announced your IP address to other people and they're gossiping it around and these other nodes then start connecting.

Aaron:
Interesting. Okay. So that makes it pretty clear to me. You bootstrapped to the Bitcoin network by first quarrying, DNS records to find other Bitcoin nodes, you get a list of IP addresses. You use these to connect to the actual Bitcoin nodes, which could also be Tor nodes at that point, right? These are already these, you can also query from the DNS records. At that point, you ask about all of the notes that they know and you update your list. And from that point on, you're also sharing your ID, IP addresses you have with other notes. So far, these were [inaudible] and IP six had a subset of Vanya notes. And with this upgrades will be ready for a newer version of onion notes. That's a story that's about right. That's our,

Sjors:
And one, one tiny little thing that was recently added is that the Bitcoin node actually can spin up the version three on your node. But that is actually like a five line change. So that's quite nice. That'll just work TM when you start. I don't know. I think it's version zero point 21. If you start it up, if you were running a version two note before it's gonna run a version three tore note after if you weren't, then you need to read the documentation, how to set it up if you want to use it. Good. So yeah. It's all you guys. That's it.

Aaron:
All right guys. I forgot to mention something. Oh my God. I have amazing news. Tell me actually sure. She already on the news. I know ribbon the fan word. I'm sure NATO has its own feet now. Wow. It's an RSS feed and it showed up in my podcast app. Excellent. So I'm now subscribed to the fender and I'm sure it's NATO. If you're listening and if you want to hear for all our episodes, then you can subscribe to the February. I'm sure NATO I'll be subscribing for sure. It's actually exactly what I was asking you guys for. Like what I was missing. I just want it to be able to subscribe to your appellate cast specifically. So great. So that's two, two subscribers already shows me everyone. That's excellent.

Sjors:
We're on a roll. I was already subscribed. So another related stories, another related news is that we have, have had our first swap.

Speaker 3:
Oh yeah, that's true. Because

Sjors:
We actually featured on the

Speaker 3:
Podcast. That's right. Yeah. So sometimes we're getting technical issues or whatever and unable to record. And then what we do is we look at other podcast or something where maybe I appear or one of the other guys and we broadcast that. So in this case, I came onto your show. So I asked you guys, maybe we can put that on the on podcast. So our announced podcast listeners were also able to listen to the last episode and probably, you know, if I don't know a couple of weeks from now, we run into issues again. Maybe I'll be asking you to air this episode. So yeah. Number two,

Sjors:
If you need an extra motivation to check that out, we actually, we edited the audio. So it's going to be a little bit better than the original. That's correct. Check it out. All right. I want to mention that. Thank you for listening to the ven. Weird. I'm sure as NATO, there you go.


Helpful Links:

* Tor V3 (onion) address support in Bitcoin Core: https://github.com/bitcoin/bitcoin/pull/19954

* the ADDRv2 message added in BIP155 that allows nodes to gossip those new Tor addresses: https://github.com/bitcoin/bips/blob/master/bip-0155.mediawiki#Specification

* DNS seeds and the bootstrap problem: https://stackoverflow.com/questions/41673073/how-does-the-bitcoin-client-determine-the-first-ip-address-to-connect

-->
