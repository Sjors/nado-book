\newpage
## DNS Bootstrapping and Tor V3 {#sec:dns}

![Ep. 13 {l0pt}](qr/13.png)

Bitcoin Core 0.21 added support for Tor V3 addresses in 2020. This chapter will explain what this means and why it matters. It'll also discuss how new Bitcoin nodes find existing Bitcoin nodes when they bootstrap to the network.

<!-- Blank paragraphs added for QR and section title alignment -->
\

\

### How Does Tor Work?

When you see a Tor address^[e.g. <https://bitcoincore.org> can also be reached using a Tor browser at <http://6hasakffvppilxgehrswmffqurlcjjjhd76jgvaqmsg6ul25s7t3rzyd.onion/>], it looks quite weird. The idea is that it's actually a public key that refers to a hidden service somewhere on the internet. The way you communicate to that hidden service is not directly — because you don't know its IP address — but rather indirectly, through the Tor network.

Tor is an onion network, which means messages exist in encrypted layers, similar to layers of an onion. This makes it easy to maintain anonymity and security. To connect, you'd use onion packages^[<https://github.com/bitcoin/bitcoin/pull/19954>]: The idea is that you start from the inside, like the last hop before the hidden service, and you give that hop instructions on how to reach the hidden service. Then, you write instructions for the second-to-last hop, and you give it instructions on how to reach the first hop.

When doing this, you're still using IP addresses, but you don't know the IP address of the Tor nodes you're communicating with. Instead, you're communicating with other Tor nodes, and every Tor node communicates with the direct peer. So, everyone only knows the IP address of their direct peer, but they don't know where the message originated from or where it ends up. Additionally, they can't read the message because it's encrypted.

To support this, all of these Tor nodes have their own sort of IP address — their onion address — and that's what you're communicating with directly. Meanwhile, Bitcoin Core nodes can run behind such a hidden service, which means everybody can have their Bitcoin node run at a secret location, resulting in IP addresses remaining secret.

### Running a Bitcoin Node behind Tor

There are a few reasons why you'd want your IP address to be secret. For example, you might not want the rest of the world to know that your IP address is running a Bitcoin node. And if you're sending transactions from an IP address, network analysis can reveal where transactions originated.

Ideally your node behaves in a way that it looks indistinguishable from all nodes. It downloads all the blocks and Mempool transactions, and you can't tell which wallet is running inside. However, there are a lot of sneaky companies that try to determine this, and as a result, they might know you sent a specific transaction or which Bitcoins belong to you, since they could easily figure out who you are based on your IP address. But in theory, it could be nice to have Tor.

You can use Bitcoin from behind Tor,^[<https://github.com/bitcoin/bitcoin/blob/master/doc/tor.md>] and there's a new type of onion address as a result of an update in the Tor protocol. This means Tor addresses are longer, which makes them more secure. So, if you want to keep running a Bitcoin node on Tor, you'll have to use those longer addresses because Tor is centralized and they decided to eventually get rid of the version two addresses. As a result, Bitcoin needed to be upgrade to support these new addresses.

### Bitcoin Nodes and Gossip

This begs the question of why this makes a difference, and what's wrong with the longer address? This has to do with how Bitcoin nodes spread the word about who they are. The idea is that nodes can communicate with each other: They send each other lists of known nodes, and they ask each other, "Hey, which Bitcoin nodes do you know?" In return, they get a list of IP addresses, which are generally either IPv4 addresses or IPv6 addresses.

IPv6 addresses were formalized in 1998 with the intention of replacing IPv4, because the number of IPv4 addresses was limited. There are 4,294,967,296 (232) potential unique IPv4 addresses,^[<https://en.wikipedia.org/wiki/IPv4>] whereas there are just enough IPv6 addresses for every molecule in the universe.

Bitcoin nodes keep lists of other Bitcoin nodes and their IP addresses, which are IPv4 and IPv6 addresses. And the way you'd communicate a Tor address is to piggyback on IPv6, because there's a convention where if the IPv6 address starts with a certain prefix, certain numbers, then everything that follows is the Tor address.

Now, when nodes connect with each other, they share their lists, which is known as gossiping. As a result, everyone has an even more complete list of all of the Bitcoin nodes.

The problem with Tor V3 addresses is they're 32 bytes, which is twice as long as an IPv6 address, and nodes have no way to communicate those addresses at the moment.

Wladimir van der Laan wrote a standard a while ago. I think in 2019, that has a new way of communicating — or gossiping addresses. The major change is that each message says, "OK, this is the type of address I'm going to communicate, and it can be various types, including the new Tor one, but also future ones, and then it can have different lengths". So, in the future, if a new address format^[For example, I2P (Invisible Internet Project, an alternative to Tor) support was added in 2021: <https://github.com/bitcoin/bitcoin/blob/7740ebcb023089d03cd2373da16305a4e501cfad/doc/i2p.md>] comes along that's too long, it's not going to be a problem.

The nice thing is it's a completely new peer-to-peer message. Old nodes just ignore that message, or if you know it's an old node you're talking to, you don't use that message. So newer nodes will know this new message and can communicate all these new address types, and old the nodes carry on like nothing happened.

### How DNS Works

But how do you connect to that first node or bootstrap to the network?^[<https://stackoverflow.com/questions/41673073/how-does-the-bitcoin-client-determine-the-first-ip-address-to-connect>]

Assume you're just downloaded Bitcoin Core or some other client, and you started up. Now what? Is it just going to guess random IP addresses? No. It needs to know at least one other node to connect to, but preferably more than that. The way it tries to connect is using something called DNS seeds. The internet DNS system is used for websites, e.g. you type an address like www.google.com, and what your browser does is it asks a DNS server what IP addresses are from that Google domain.

The DNS system is ultimately centralized. So basically, if you run a website, your hosting provider will have a DNS server that points to your website, and your country will have a DNS server that will point to your hosting provider, and your internet provider has a DNS server that points to all these different countries, etc. It's all very redundant.

If you're maintaining a website, you usually have to go into a control panel and type in the IP address of your server, as well as your domain name, and that's stored on the DNS server. One of the fields you have to fill out is the timeout. What you're saying is after, for example, 24 hours, or one hour, you should be asked again. So, when you're visiting a website, you're going to ask your ISP, "Hey, do you know the IP address for this website?" And if it doesn't, it's going to ask the next DNS server up the street, "Do you know it?" And then as soon as it finds a record, it's going to say, "OK, is this record still valid or is this expired?" If it's still valid, it'll use it, and if it's expired, it'll go up closer and closer to the actual hosting provider. So it's basically cached.

The easiest would be, if you go to a domain, like say google.com. How do you find the IP address? Well, you ask Google what the IP address is, but how do you know what the IP address is for google.com? You don't know that because that's what you were trying to find out. So you have to ask somebody else, and so you ask your internet provider, "Do you know the way to google.com?" Well, your internet provider might not know that, but it says, "Well, I know the way to .com" basically, and .com will know the way to google.com. So, that's kind of how it works. .nl same is the same: You ask .nl, "Where is google.nl?"

Ideally this is already cached, because so many people go to google.com that if you ask your ISP, "Where is google.com?" it'll know because somebody else asked. But if the ISP doesn't know, you'll be sent to .com.

### Some Risks

In the scenario above, there's a centralization risk because you're trusting the DNS server. Where Bitcoin is concerned, it's abused, because Bitcoin nodes are not websites. But the idea is that there are a couple of Core developers who run DNS seeds, which are essentially DNS servers. And we're just pretending that, for example, seed.bitcoin.sprovoost.nl is a "website," and when you ask that "website" what its IP address is, you get a whole list of IP addresses. However, those IP addresses are Bitcoin nodes, and every time you ask, it's going to give you different IP addresses.

This means that the standard infrastructure of the internet — all the ISPs in the world and all these others — are caching exactly where all the Bitcoin nodes are, because they think it's just a website. So it's kind of nice that you keep all these lists of nodes redundantly stored on the internet, and there are quite a few protections against censorship of DNS.

But at the same time, if someone were to lie and run a fake server, it could send you to any node they want, but that would be very visible. The reason it's visible is because anyone can request these IP addresses from you and then check if they actually lead to Bitcoin nodes or not. And them being visible is to prevent cheating.

However, if the DNS seeds aren't reachable because, for example, they're offline, then inside the Bitcoin Core source code and also in the thing you download is a list of IP addresses and as well as view hidden services.

Bitcoin nodes are embedded into the source code. Every six months or so all the DNS seed maintainers are asked to provide a list of the most reliable nodes — just all the nodes sorted by how frequently they're online, because your DNS seed tends to track. What a DNS seed does on its side is it's just a crawler.^[<https://github.com/sipa/bitcoin-seeder>] It goes to a couple of Bitcoin nodes, asks it for all the nodes it knows, keeps a list, goes to the list, and pings them all. Then, once it's done pinging them all, it's just going to be them all again.

It also keeps track of how often they're online, which results in a list sorted by reliability. You take that from all the contributors and that goes into the source code.^[<https://github.com/bitcoin/bitcoin/blob/v22.0/contrib/seeds/nodes_main.txt>] So that's the fallback. But it's only the first time you start your node, at least in theory. So only the very first time you start your node, you need this.

After that, you'd keep track of the nodes you know about, i.e. store all these gossip nodes in a file. You can open the file and first try the nodes you know about, and only if you run out or if it doesn't work, do you ask the seed again. But otherwise, you keep syncing your list of IP addresses with the new nodes.

Whenever a node connects to you for the first time, that's one of the first things it asks: "Who else do you know?" You can even send them unsolicited, which is why, if you start a new node, you get inbound connections pretty quickly because  you've announced your IP address to other people and they're gossiping it around and these other nodes then start connecting.

You bootstrap to the Bitcoin network by first querying DNS records to find other Bitcoin nodes. Then you get a list of IP addresses and use them to connect to the actual Bitcoin nodes, which could also be Tor nodes at that point.

Alternatively, you can query from the DNS records. At that point, you ask about all of the nodes that they know and you update your list. And from that point on, you're also sharing the IP addresses you have with other nodes. So far, these were IPv4 and IPv6, and the latter had a subset of onion nodes. And with this upgrades will be ready for a newer version of onion nodes.

And then one tiny little thing that was recently added, is that the Bitcoin node actually can spin up the V3 onion node. But that's actually a five-line change. If you were running a version 2 node before, it's going to run a version 3 tor node after if you weren't. And then you need to read the documentation on how to set it up if you want to use it.

Helpful Links:

* the ADDRv2 message added in BIP155 that allows nodes to gossip those new Tor addresses: https://github.com/bitcoin/bips/blob/master/bip-0155.mediawiki#Specification
