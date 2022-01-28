\newpage
## DNS Bootstrapping and Tor V3 {#sec:dns}

![Ep. 13 {l0pt}](qr/ep/13.png)

Bitcoin Core 0.21 added support for Tor V3 addresses in 2020.^[<https://github.com/bitcoin/bitcoin/pull/19954>] This chapter will explain what this means and why it matters. It'll also discuss how new Bitcoin nodes find existing Bitcoin nodes when they bootstrap to the network.

<!-- Blank paragraphs added for QR and section title alignment -->
\

\

### How Does Tor Work?

When you see a Tor address,^[e.g. <https://bitcoincore.org> can also be reached using a Tor browser at <http://6hasakffvppilxgehrswmffqurlcjjjhd76jgvaqmsg6ul25s7t3rzyd.onion/>] it looks quite weird. The idea is that it's actually a public key that refers to a hidden service somewhere on the internet. The way you communicate to that hidden service isn't directly — because you don't know its IP address — but rather indirectly, through the Tor network.

Tor (short for The Onion Router) is an onion network, in which messages are passed around the network through multiple hops (or servers), with each hop peeling off one encrypted layer, like an onion. The last hop sends a message to the final destination, which peels off the final encryption layer that reveals the actual message. This makes it easy to maintain anonymity and security.

To connect, you use the Tor browser.^[<https://www.torproject.org/download/>] This browser constructs onion packages for you. The messages are just the usual things browsers communicate: asking for an HTML document or image, and, in the other direction, receiving said document or image. The Tor browser first creates a message, which goes on the inside.^[It's slightly more complicated: To protect the privacy of the recipient, the sender only wraps onions up until a rendezvous hop, which then forwards the message.] It wraps another message around it — which only the last hop before the hidden service can read — with instructions about where the final destination is. It then adds wraps another message with instructions for the second-to-last hop on how to reach the last hop, and so forth and so on.

Under the hood, this process uses IP addresses, but you don't know the IP address of the destination Tor node you're communicating with. Instead, you're communicating with other Tor nodes, and each of those nodes communicates with its direct peers. So, everyone only knows the IP addresses of their direct peers, but they don't know where a message originated from or where it ends up. Additionally, they can't read the message because it's encrypted.

To support this, all of these Tor nodes have their own sort of IP address — their onion address — and that's what you're communicating with directly. Meanwhile, Bitcoin Core nodes can run behind such a hidden service, which means everybody can have their Bitcoin node run at a secret location, resulting in IP addresses remaining secret.

### Running a Bitcoin Node behind Tor

For various reasons you might not want the rest of the world to know that your IP address is running a Bitcoin node. In particular, you may not want your Bitcoin addresses associated with your IP addresses, since the former says how much money you have, and the latter can often be tied directly to your name and address — not just by governments, but also by someone with access to e.g. a hacked e-commerce database with the IP addresses and home addresses of its customers.

Bitcoin nodes already try to behave in ways that make them look indistinguishable from other nodes. Ideally, a node doesn't reveal to other nodes which coins it controls. A node downloads the entire blockchain and keeps track of all transactions in the mempool, as opposed to only fetching the information about its own coins.

Unfortunately the system isn't perfect. Especially when you're sending and receiving transactions from your IP address, careful network analysis by an adversary can sometimes reveal where those transactions originated. This type of analysis is a billion-dollar business, where companies don't always behave ethically.^[<https://www.coindesk.com/business/2021/09/21/leaked-slides-show-how-chainalysis-flags-crypto-suspects-for-cops/>, <https://www.coindesk.com/markets/2019/03/05/coinbase-pushes-out-ex-hacking-team-employees-following-uproar/>]

Therefore, using Bitcoin from behind Tor^[<https://github.com/bitcoin/bitcoin/blob/master/doc/tor.md>] may improve your privacy by severing the link between your IP address and any information about you that your node may accidentally reveal.

As a practical matter, if you were already doing this, there's a new type of onion address as a result of an update in the Tor protocol: Tor V3. These new Tor addresses are longer, which makes them more secure.^[<https://blog.torproject.org/v3-onion-services-usage>] Additionally, Bitcoin Core was upgraded to support these new addresses, so if you want to keep running a Bitcoin node on Tor, you'll have to use the longer addresses.

### Bitcoin Nodes and Gossip

This begs the question of why this makes a difference, and what's wrong with the longer address? This has to do with how Bitcoin nodes spread the word about who they are. The idea is that nodes can communicate with each other: They send each other lists of known nodes, and they ask each other, "Hey, which Bitcoin nodes do you know?" In return, they get a list of IP addresses, which are generally either IPv4 addresses or IPv6 addresses.

IPv6 addresses were formalized in 1998 with the intention of replacing IPv4, because the number of IPv4 addresses was limited. There are nearly 4.3 billion potential unique IPv4 addresses,^[<https://en.wikipedia.org/wiki/IPv4>] whereas there are just enough IPv6 addresses for every molecule in the universe.

Bitcoin nodes keep lists of other Bitcoin nodes and their IP addresses, which are IPv4 and IPv6 addresses. And the way you'd communicate a Tor address is to piggyback on IPv6. If an "address" starts with fd87::d87e::eb43, then Bitcoin Core knows that what follows should be interpreted as a Tor address. RFC-4193 ensures that such addresses won't clash with any computer in the real world.^[<https://datatracker.ietf.org/doc/html/rfc4193>]

Now, when nodes connect with each other, they share their lists, which is known as gossiping. As a result, everyone has an even more complete list of all of the Bitcoin nodes.

The problem with Tor V3 addresses is they're 32 bytes, which is twice as long as an IPv6 address, and nodes have no way to communicate those addresses at the moment.

Wladimir van der Laan wrote a standard in 2019 — BIP155 — that has a new way of communicating, or gossiping addresses.^[<https://github.com/bitcoin/bips/blob/master/bip-0155.mediawiki#Specification>] It introduces the new ADDRv2 message, which nodes can use to gossip those new Tor addresses (among other things). A major improvement is that each message says, "OK, this is the type of address I'm going to communicate." It can be various types, including the new Tor one, but also future ones, and each address type can have a different length. So, in the future, if a new address format^[For example, I2P (Invisible Internet Project, an alternative to Tor) support was added in 2021: <https://github.com/bitcoin/bitcoin/blob/7740ebcb023089d03cd2373da16305a4e501cfad/doc/i2p.md>] comes along, it's not going to be a problem.

The nice thing about this new peer-to-peer message is that old nodes just ignore it. And if your node knows it's talking to an old node, it won't use ADDRv2. So newer nodes will know this new message and can communicate all these new address types, and old the nodes carry on like nothing happened. Unless you want to use Tor V3, you're not required to upgrade.

However, since the Tor project _is_ centralized, it can and did force users to — with a long grace period — upgrade from Tor V2 to V3. So if you relied on Tor V2 for the privacy of your Bitcoin node, you'll have no choice but to upgrade your node.

### How DNS Works

But how do you connect to that first node or bootstrap to the network?^[<https://stackoverflow.com/questions/41673073/how-does-the-bitcoin-client-determine-the-first-ip-address-to-connect>]

Assume you just downloaded Bitcoin Core or some other client, and you started up. Now what? Is it just going to guess random IP addresses? No. It needs to know at least one other node to connect to, but preferably more than that. The way it tries to connect is using something called DNS seeds. The internet DNS system is used for websites, e.g. you type an address like www.google.com, and what your browser does is it asks a DNS server what IP addresses are from that Google domain.

The DNS system is ultimately centralized. So basically, if you run a website, your hosting provider will have a DNS server that points to your website, and your country will have a DNS server that points to your hosting provider, and your internet provider will have a DNS server that points to all these different countries, etc.

If you're maintaining a website, you usually have to go into a control panel and type in the IP address of your server, as well as your domain name, and that's stored on the DNS server. One of the fields you have to fill out is the timeout. This is how long others on the internet may assume this IP address still belongs to your website.

So, when you're visiting a website, you're going to ask your ISP, "Hey, do you know the IP address for this website?" If it doesn't, it's going to ask the next DNS server up the street, "Do you know it?" And then as soon as it finds a record, it's going to say, "OK, is this record still valid or is this expired?" If it's still valid, it'll use it, and if it's expired, it'll go up closer and closer to the actual hosting provider. So it's basically cached.

The easiest would be, if you go to a domain, like say google.com. How do you find the IP address? Well, you ask Google what the IP address is, but how do you know what the IP address is for google.com? You don't know that because that's what you were trying to find out. So you have to ask somebody else, and so you ask your internet provider, "Do you know the way to google.com?" Well, your internet provider might not know that, but it says, "Well, I know the way to .com" basically, and .com will know the way to google.com. So, that's kind of how it works. .nl same is the same: You ask .nl, "Where is google.nl?"

Ideally this is already cached, because so many people go to google.com that if you ask your ISP, "Where is google.com?" it'll know because somebody else asked. But if the ISP doesn't know, you'll be sent to .com.

Because of this caching, DNS records are stored very redundantly. That's good for both privacy and availability.

Bitcoin kind of abuses this system, because Bitcoin nodes aren't websites. There are a couple of Core developers who run DNS seeds, which are essentially DNS servers. And we're just pretending that, for example, seed.bitcoin.sprovoost.nl is a "website," and when you ask that "website" what its IP address is, you get a whole list of IP addresses. However, those IP addresses are Bitcoin nodes, and every time you ask, it's going to give you different IP addresses.

What a DNS seed does on its side is it's just a crawler.^[<https://github.com/sipa/bitcoin-seeder>] It goes to a couple of Bitcoin nodes, asks it for all the nodes it knows, keeps a list, goes through the list, and pings them all. Then, once it's done pinging them all, it's just going to ping them all again.

This means that the standard infrastructure of the internet — including all the ISPs in the world — is caching a huge list of Bitcoin nodes that you can connect to, because it thinks it's just a website. So it's kind of nice that you keep all these lists of nodes redundantly stored on the internet, and there are quite a few protections against censorship of DNS.

###  So We Trust These Developers?

But at the same time, if someone were to lie and run a fake server, it could send you to any node they want, but that would be very visible. The reason it's visible is because anyone can request these IP addresses from you and then check if they actually lead to Bitcoin nodes or not and if these nodes are behaving in suspicious ways. This visibility discourages cheating.

However, if the DNS seeds aren't reachable because, for example, they're offline, then inside the Bitcoin Core source code (and thus also the binary you download) is a list of IP addresses, as well as some hidden services.

As a fallback, a number of Bitcoin nodes are embedded into the source code. Every six months or so, all the DNS seed maintainers are asked to provide a list of the most reliable nodes — just all the nodes sorted by how frequently they're online, i.e. which DNS seeds keep track of. The Bitcoin Core developers combine that information from all the DNS seed operators and that goes into the source code.^[<https://github.com/bitcoin/bitcoin/blob/v22.0/contrib/seeds/nodes_main.txt>]

Both DNS seeds and the baked-in fallback addresses are, ideally, only used once in the lifetime of your node: They're used the first time you start your node. After that, your node keeps track of the nodes it learns about by storing all these gossiped nodes in a file. When it restarts, it opens the file and tries some random nodes from it. Only if it runs out of new IP address to try, or if it takes too long, does it ask the seed again.

Whenever a node connects to you for the first time, one of the first things it asks is: "Who else do you know?" Your node can even send IP addresses to its peers unsolicited. In particular, it announces its own IP address to them. As your IP addresses is gossiped further around the network, you start getting inbound connections.

You bootstrap to the Bitcoin network by first querying DNS records to find other Bitcoin nodes. Then you get a list of IP addresses and use them to connect to the actual Bitcoin nodes, which could also be Tor nodes at that point.

Alternatively, you can query from the DNS records. At that point, you ask about all of the nodes that they know and you update your list. And from that point on, you're also sharing the IP addresses you have with other nodes. So far, these were IPv4 and IPv6, and the latter had a subset of onion nodes. And with this (ADDRv2 message), upgraded nodes will be ready for a newer version of onion nodes.
