<!-- \backmatter -->
\appendix
# More episodes {#sec:more_eps}

Not all episodes of Bitcoin, Explained made it into this book. Here's some other episodes you could listen to:

## Basics

### What is an Xpub?

![Ep. 07 {l0pt}](qr/ep/07.png)

In this episode we explain what an xpub is and how it is used by Bitcoin wallets.

\newpage

### Replace by Fee (RBF)

![Ep. 26 {l0pt}](qr/ep/26.png)

In this episode we explain Replace By Fee (RBF). RBF is a trick that lets unconfirmed transactions be replaced by conflicting transactions that include a higher fee.

With RBF, users can essentially bump a transaction fee to incentivize miners to include the transaction in a block. Aaron and Sjors explain three advantages of RBF: the option the “speed up” a transaction (1), which can in turn result in a more effective fee market for block space (2), as well as the potential to make more efficient use of block space by updating transactions to include more recipients (3).

The main disadvantage of RBF is that it makes it slightly easier to double spend unconfirmed transactions, which was also at the root of last week’s “double spend” controversy that dominated headlines. Aaron and Sjors discuss some solutions to diminish this risk, including “opt-in RBF” which is currently implemented in Bitcoin Core.

Finally, we explain in some detail how opt-in RBF works in Bitcoin Core, and which conditions must be met before a transaction is considered replaceable. He also notes some complications with this version of RBF, for example in the context of the Lightning Network.


### Signet

![Ep. 10 {l0pt}](qr/ep/10.png)

Signet is a new type of testnet for Bitcoin. In this episode we discuss discuss the original version of testnet and its problems, as well as alternative testing environment regtest.

\

\

### PSBT and RBF attack

![Ep. 01 {l0pt}](qr/ep/01.png)

In this episode we break down and explain Partially Signed Bitcoin Transactions (PSBT) and Replace By Fee (RBF) and some really tricky attacks that where recently discovered in Bitcoin.

\

\

\

### Mempools, Child Pays for Parent, and Package Relay

![Ep. 19 {l0pt}](qr/ep/19.png)

In this episode we discuss Bitcoin mempools, Child Pays For Parent (CPFP) and package relay.

Package relay is the project that Gloria Zhao will work on as part of her Brink fellowship, which was announced earlier this week, and would make the Lightning Network more robust (among other benefits). Mempools are the collections of unconfirmed transactions stored by nodes, from which they forward transactions to peers. Miners usually select the transactions from their mempools that include the highest fees, to include these in the blocks they mine.

Mempools can get full, however, at which point transactions that pay the lowest fees are ejected. This is actually a problem in context of CPFP, a trick that lets users speed up low-fee transactions by spending the coins from that transactions in a new transaction with a high fee to compensate. Tricks like these can be particularly important in the context of time-sensitive protocols like the Lightning Network.

In this episode, van Wirdum and Provoost explained how package relay could enable CPFP, even in cases where low-fee transactions are dropped from mempools, by bundling transactions into packets. And they explore why this may be easier said than done.

### Bitcoin Improvement Proposal (BIP) process

![Ep. 39 {l0pt}](qr/ep/39.png)

In this episode we explain what Bitcoin Improvement Proposals (BIPs) are, and how the BIP process works. We discuss why the BIP process is a useful, yet non-binding convention within Bitcoin’s technical community.

First we explain what a BIP is exactly— and what it is not. We also explain that only improvements to Bitcoin software that affects other projects require a BIP. We then dive into the history of the BIP process a little bit, noting that the format was introduced by Libbitcoin developer Amir Taaki and later updated by Bitcoin Knots maintainer Luke-jr.

Finally we explain how the BIP process itself works, that is, how a proposal can be turned into a BIP, and eventually be implemented in software. We also briefly explain how the BIP process could become corrupted, and why that wouldn’t be a very big deal.

## Resource usage

### Compact Client Side Filtering (Neutrino)

![Ep. 25 {l0pt}](qr/ep/25.png)

In this episode we discuss Compact Client Side Filtering, also known as Neutrino. Compact Client Side Filtering is a solution to use Bitcoin without needing to download and validate the entire blockchain, and without sacrificing your privacy to someone who operates a full node (and therefore did download and validate the entire blockchain).

Downloading and validating the entire Bitcoin blockchain can take a couple of days even on a standard laptop, and much longer on smart phones or other limited-performance computers. This is why many people prefer to use light clients. These aren’t quite as secure as full Bitcoin nodes, but they do require fewer computational resources to operate.

Some types of light clients — Simplified Payment Verification (SPV) clients — essentially ask nodes on the Bitcoin network about the particular Bitcoin addresses they are interested in, to check how much funds they own. This is bad for privacy, since the full node operators learns which addresses belong to the SPV user.

Compact Client Side Filtering is a newer solution to accomplish similar goals as SPV, but without the loss of privacy. This works, in short, by having full node operators create a cryptographic data-structure that tells the light client user whether a block could have contained activity pertaining to its addresses, so the user can keep track of its funds by downloading only a small subset of all Bitcoin blocks.

We explain how this works in more detail, and discuss some of the tradeoffs of this solution.

### Erlay

![Ep. 34 {l0pt}](qr/ep/34.png)

discuss the Erlay protocol. Erlay is a proposal to reduce the bandwidth required to run a Bitcoin node, which has been proposed and developed by University of British Columbia researchers Gleb Naumenko, Alexandra Fedorova and Ivan Beschastnikh; Blockstream engineer Pieter Wuille; and independent Bitcoin Core contributor Gregory Maxwell.

Bitcoin nodes use bandwidth to receive and transmit both block data as well as transaction data. Reducing the amount of bandwidth a node requires to do this, would make it cheaper to run a node. Alternatively, it allows nodes to connect to more peers without increasing its bandwidth usage.

In the episode, Aaron and Sjors explain that Erlay uses set reconciliation to reduce the amount of data nodes need to share transactions. More specifically, Erlay uses a mathematical trick called Minisketch^[<https://github.com/sipa/minisketch>]. This solution is based on pre-existing mathematical formulas used in biometrics technology.

Aaron and Sjors outline how this trick is applied in the context of Bitcoin to let different nodes sync their mempools: the sets of transactions they’ve received in anticipation of a new block, or, in the case of a miner, to include in a new block.

## Attacks

### Timewarp attack


![Ep. 05 {l0pt}](qr/ep/05.png)

In this episode we explain the "time-warp attack" on Bitcoin. A potential fix for this attack is included in Matt Corallo's proposed Great Consensus Cleanup softfork^[<https://github.com/TheBlueMatt/bips/blob/cleanup-softfork/bip-XXXX.mediawiki>], which at the time of writing has not seen much progress.

### Mining pool censorship

![Ep. 37 {l0pt}](qr/ep/37.png)

In this episode we discuss the emergence of Mara Pool, the American Bitcoin mining pool operated by Marathon Digital Holdings, which at the time claimed to be fully compliance with US regulations. This means that it applies anti-money laundering (AML) checks and adheres to the sanction list of the Office of Foreign Asset Control (OFAC). While details have not been made explicit, this presumably means that this pool will not include transactions in their blocks if these transactions send coin to or from Bitcoin addresses that have been included on an OFAC blacklist.

Some time after recording they changed course and announced that they would not be censoring transactions.

In the episode we discuss the prospects of mining censorship, what that would mean for Bitcoin, and what can be done about it. We discuss what it means that a mining pool is now censoring certain transactions, and go on to expand what it could look like if this practice gets adopted more widely. We consider what censoring mining pools could accomplish if they ever get close to controlling a majority of hash power, and what Bitcoin users could potentially do in such a scenario (if anything).

## Wallets

### Hardware Wallet Security and Jade

![Ep. 43 {l0pt}](qr/ep/43.png)

Co-host Aaron is joined by Blockstream’s Lawrence Nahum, one of the developers behind the Jade wallet, and Ben Kaufman, one of the developers of the Spectre wallet, which is specifically designed to work with hardware wallets.

Aaron, Lawrence and Ben talk about what hardware wallets are, and discuss the design tradeoffs that different hardware wallets have taken by focussing on the Trezor, Ledger and ColdCard specifically. In this light, Lawrence and Ben explain what secure elements and secure chips are, and why some hardware wallets choose to rely on using such chips more than others.

Then, Lawrence explains which tradeoffs the Jade wallet makes. He also details how an additional server-based security step is used to further secure the Jade wallet, and briefly outlines some additional differences in hardware wallet designs, for example those focused on usability.

Finally, Aaron, Lawrence and Ben discuss whether the concept of hardware wallets are a good idea in the first place, or if it would perhaps be better to use dedicated smartphones to store your bitcoin.

### Bitcoin Beach

![Ep. 42 {l0pt}](qr/ep/42.png)

Co-host Aaron van Wirdum speaks with Bitcoin Beach Wallet developer Nicolas Burtey in El Zonte, El Salvador — which has been dubbed Bitcoin Beach — to discuss the Bitcoin Beach Wallet, a Bitcoin and Lightning wallet specifically designed for use in the small Central American coastal town frequented by surfers and, now, bitcoiners.

They discuss the pros and cons of custodial and non-custodial Lightning wallets, and Nicolas explains why he opted to make the Bitcoin Beach Wallet a shared-custodial wallet, and what that means exactly.

They go one to discuss some of the design decisions and tradeoffs that the Bitcoin Beach Wallet has made, which include ledger-based payments between Bitcoin Beach Wallet users as well as the webpage-based zero invoice payments to facilitate payments from other Lightning wallets. while Nicolas speculates about a potential cross-wallet user account system to further improve the Lightning user experience over time.

Aaron and Nicolas also discuss some of the subtle incompatibilities between different Lightning wallets that use different techniques for routing payments, privacy considerations versus user experience in a community like El Zonte’s, and more.

### Chivo

![Ep. 46 {l0pt}](qr/ep/46.png)

In this episode we discuss discuss the Chivo application, the Bitcoin wallet, and payment terminal provided by the government of El Salvador. The Chivo app is closed source software. Instead of analyzing the source code and design of the application, we had to rely on Aaron’s personal experience with the wallet and payment terminal or what he remembers of that personal experience. The episode opens with some general information about the Chivo Wallet, like why it was developed and who developed it (insofar anything is known about that). We discuss Aaron’s experiences with the wallet and speculate what that means for the design. After that, we discuss the design of the payment terminal that’s included in the application, and also briefly touch on the Chivo ATMs that have been deployed across the country. Finally, we discuss the difference in philosophy between the design of the Chivo application and Bitcoin’s free and open-source software culture.

### Accounts with Easypaysy

![Ep. 11 {l0pt}](qr/ep/11.png)

We discuss Jose Femenias' Easypaysy proposal, an account system for Bitcoin, on Bitcoin. One feature it supports is stealth address identities. We discuss several use cases. Finally we explain what non repudiation is.

Aaron also wrote an article covering Easypaysy for Bitcoin Magazine.^[<https://bitcoinmagazine.com/articles/bitcoin-need-accounts-one-developer-thinks-figured>]

\

### Payment pools

![Ep. 06 {l0pt}](qr/ep/06.png)

In this episode we explain what payment pools are, and why they need Taproot. We discuss the user experience of sharing UTXOs and how payment pools can work with lightning.

See also Aaron's article.^[<https://bitcoinmagazine.com/articles/building-on-taproot-payment-pools-could-be-bitcoins-next-layer-two-protocol>]

\

\

\

## Lightning

One could write a entire book about lightning. And in fact, others have, see e.g. _Mastering the Lightning Network: A Second Layer Blockchain Protocol for Instant Bitcoin Payments_ by Andreas Antonopoulos and Olaoluwa Osuntokun (aka Roasbeef).

This book does not cover Lightning, but several Bitcoin, Explained episodes did.

### Basics

![Ep. 22 {l0pt}](qr/ep/22.png)

We discuss the basics of the Lightning Network, Bitcoin’s Layer 2 protocol for cheaper, faster and potentially more private transactions. We explain that the Lightning Network works as a scaling layer because it lets users make off-chain transactions through bi-directional payment channels: two users can pay one another an arbitrary number of times without these transactions being recorded on the blockchain. We went on to explain how, in the Lightning protocol, these off-chain transactions are secure, that is, how each of the participants is at any point guaranteed to claim their respective funds from the payment channel.

Then we explain how bi-directional payment channels can be linked across a network of users, to extend the potential of off-chain transactions so any Lightning user can pay any other Lightning user, even if they haven’t set up a payment channel between the two of them specifically.

Finally, we briefly touch on some of the challenges presented by the Lightning Network, most notably the requirement of payment channels to have sufficient liquidity locked into them.

### RBF bug in Bitcoin Core

![Ep. 38 {l0pt}](qr/ep/38.png)

We discuss CVE-2021-31876, a bug in the Bitcoin Core code that affects replace-by-fee (RBF) child transactions.^[<https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-31876>] The CVE (Common Vulnerabilities and Exposures) system offers an overview of publicly known software bugs. A newly discovered bug in the Bitcoin Core code was recently discovered and disclosed by Antoine Riard, and added to the CVE overview.

We explain that the bug affects how RBF logic is handled by the Bitcoin Core software. When one unconfirmed transaction includes an RBF flag (which means it should be considered replaceable if a conflicting transaction with a higher fee is broadcast over the network) any following transaction that spends coins from the original transaction should also be considered replaceable — even if the second transaction doesn’t itself have an RBF flag. Bitcoin Core software would not do this, however, which means the second transaction would in fact not be considered replaceable.

This is a fairly innocent bug; in most cases the second transaction will still confirm eventually, while there are also other solutions to speed confirmation up if the included fee is too low. But in very specific cases, like some fallback security mechanisms on the Lightning Network, the bug could in fact cause complications. We try to explain what such a scenario would look like, but end up totally confused.

### Routing

![Ep. 41 {l0pt}](qr/ep/41.png)

We are joined by Lightning developer Joost Jager to discuss everything about Lightning Network routing.

The Lightning Network consists of a network of payments channels. Each payment channel exists between two Lightning users. But even if two users don’t have a payment channel between themselves directly, they can pay each other though one or several other Lightning users, who in that case forward the payment from the payer to the payee.

The challenge is that a payment path across the network must be found, which allows the funds to move from the payer to the payee, and ideally the cheapest, fastest and most reliable payment path available.

Joost explains how Lightning nodes currently construct a map of the Lightning Network, and what information about all of the (publicly visible) payment channels is included about in that map. Next, he outlines on what basis Lightning nodes calculate the best path over the network to reach the payee, and how the performance of this route factors into future path finding calculations.

Finally we discuss some (potential) optimizations to benefit Lightning Network routing, such as rebalancing schemes and Trampoline Payments.

### Optimally Reliable & Cheap Payment Flows on the Lightning Network

![Ep. 47 {l0pt}](qr/ep/47.png)

In this episode I interview another expert on Lightning routing, René Pickhardt. We discuss his paper “Optimally Reliable & Cheap Payment Flows on the Lightning Network”.^[<https://arxiv.org/abs/2107.05322>] To cite the abstract:

> Today, payment paths in Bitcoin's Lightning Network are found by searching for shortest paths on the fee graph. We enhance this approach in two dimensions. Firstly, we take into account the probability of a payment actually being possible due to the unknown balance distributions in the channels. Secondly, we use minimum cost flows as a proper generalization of shortest paths to multi-part payments (MPP). In particular we show that under plausible assumptions about the balance distributions we can find the most likely MPP for any given set of senders, recipients and amounts by solving for a (generalized) integer minimum cost flow with a separable and convex cost function. Polynomial time exact algorithms as well as approximations are known for this optimization problem. We present a round-based algorithm of min-cost flow computations for delivering large payment amounts over the Lightning Network. This algorithm works by updating the probability distributions with the information gained from both successful and unsuccessful paths on prior rounds. In all our experiments a single digit number of rounds sufficed to deliver payments of sizes that were close to the total local balance of the sender. Early experiments indicate that our approach increases the size of payments that can be reliably delivered by several orders of magnitude compared to the current state of the art. We observe that finding the cheapest multi-part payments is an NP-hard problem considering the current fee structure and propose dropping the base fee to make it a linear min-cost flow problem. Finally, we discuss possibilities for maximizing the probability while at the same time minimizing the fees of a flow. While this turns out to be a hard problem in general as well - even in the single path case - it appears to be surprisingly tractable in practice.

### Eltoo and SIGHASH_ANYPREVOUT

We covered this topic twice, so there's two epidodes to choose from. In episode 35 Aaron and I explain it, whereas in episode 48 one of the authors, c-lightning developer Christian joins me to explain it in his words.

![Ep. 35 {l0pt}](qr/ep/35.png)

First we discuss `SIGHASH_ANYPREVOUT`, a proposed new sighash flag that would enable a cleaner version of the Lightning Network and other Layer Two protocols. Sighash flags are included in Bitcoin transactions to indicate which part of the transaction is signed by the required private keys, exactly.

This can be (almost) the entire transaction, or specific parts of it. Signing only specific parts allows for some flexibility to adjust the transaction even after it is signed, which can sometimes be useful. We explain that `SIGHASH_ANYPREVOUT` is a new type of sighash flag, which would sign most of the transaction, but not the inputs. This means that the inputs could be swapped, as long as the new inputs would still be compatible with the signature.

![Ep. 48 {l0pt}](qr/ep/48.png)

`SIGHASH_ANYPREVOUT` would be especially useful in context of Eltoo, a proposed Layer Two protocol that would enable a new version of the Lightning Network. Where Lightning users currently need to store old channel data for security reasons, and could also be punished severely if they accidentally broadcast some of this data at the wrong time, we how SIGHASH_ANYPREVOUT would do away with this requirement.

### Bolt 12 - Recurring payments, etc

![Ep. 44 {l0pt}](qr/ep/44.png)

We discuss BOLT 12 (Basis of Lightning Technology 12), a newly proposed Lightning Network specification for “offers”, a type of “meta invoices” designed by c-lightning developer Rusty Russell.

Where coins on Bitcoin’s base layer are sent to addresses, the Lightning network uses invoices. Invoices communicate the requested amount, node destination, and the hash of a secret which is used for payment routing. This works, but has a number of limitations, Sjors explains, notably that the amount must be bitcoin-denominated (as opposed for fiat denominated), and the invoice can only be used once.

BOLT 12, which has been implemented in c-lightning, is a way to essentially refer a payer to the node that is to be paid, in order to request a new invoice. While the BOLT 12 offer can be static and reusable — it always refers to the same node — the payee can generate new invoices on the fly when requested, allowing for much more flexibility, Sjors explains.

Finally, we discuss how the new BOLT 12 messages are communicated over the Lightning Network through an update to the BOLT 7 specification for message relay.

## Sidechains and more

Lightning is not the only path forward for scaling Bitcoin, though it is the most actively developed one at the moment. Sidechains are another approach, optionally combined with Lightning.

Though there is no universally agreed upon definition, the general idea is that you create a separate blockchain with its own rules, that is somehow pegged to the Bitcoin blockchain. The advantage of this approach, in theory, is that only nodes that care about a paricular sidechain need to verify it, while the rest of the network only needs to check that the amount of Bitcoin leaving the sidechain does not exceed the amount going in.

We discussed several of these ideas in the podcast, often with the help of Utrecht based ad hoc co-host Ruben Somsen.

### Drivechains

![Ep. 23 {l0pt}](qr/ep/23.png)

Drivechain is a sidechain project spearheaded by Paul Sztorc.

This should make the sidechain coins interchangeable with bitcoin and therefore carry an equal value. In a way, sidechains let users “move” bitcoin across blockchains, where they are subject to different protocol rules, allowing for greater transaction capacity, more privacy, and other benefits. We explain that Drivechain consists of two main innovations.

The first is blind merged mining, which lets Bitcoin miners secure the drivechain with their existing hash power, but without necessarily needing to validate everything that happens on the sidechain.

The second is hashrate escrows, which lets miners “move” coins from the Bitcoin blockchain to the sidechain and back.

We also discuss some of the benefits as well as complications with Drivechain, most notably the security implications of letting miners control the pegging out process. They consider the arguments why this process is incentive compatible (in other words: secure) — or why it might not be.

\newpage

### Perpetual One-Way Peg

![Ep. 12 {l0pt}](qr/ep/12.png)

Ruben explains his proposal to combine blind merged mining and perpetual one-way pegs in order to create a new type of sidechain. The bad news: it won't make you rich but it could help scale Bitcoin!

First Ruben introduces the concept of a blind merge-mind chain. He then explains the use cases for the perpetual one-way peg and what Merge Mining is. We then get to Perpetual One-Way Peg and try answer the question: why would the side chain coin be worth anything?

A blog post by Ruben also explains the concept.^[<https://medium.com/@RubenSomsen/21-million-bitcoins-to-rule-all-sidechains-the-perpetual-one-way-peg-96cb2f8ac302>]

### Softchains

![Ep. 27 {l0pt}](qr/ep/27.png)

This time, they discuss one of Ruben’s own proposals, called Softchains.

Softchains are a type of two-way peg sidechains that utilize a new type of consensus mechanism: proof-of-work fraud proofs (or as Sjors prefers to call them, proof-of-work fraud indicators). Using this consensus mechanism, users don’t validate the content of each block, but instead only check the proof of work header, like Simplified Payment Verification (SPV) clients do. But using proof-of-work fraud proofs, users do validate the entire content of blocks any time a blockchain fork occurs. This offers a security model in between full node security and SPV security.

Ruben explains that by using proof-of-work fraud proofs for sidechains to create Softchains, Bitcoin full nodes could validate entire sidechains at minimal cost. This new model might be useful for certain types of sidechains, most notably “block size increase” sidechains that do nothing fancy but do offer more transaction capacity. Aaron, Sjors and Ruben also discuss some of the downsides of the Softchain model.

### Statechains

![Ep. 08 {l0pt}](qr/ep/08.png)

We discuss yet another one of Ruben's proposals: Statechains on Bitcoin. Statechains allow you to send keys not UTXO and it offers quite a few scaling and functionality improvements.

See also Ruben's presentation^[<https://youtu.be/CKx6eULIC3A>] on Bitcoin Magazine about Statechains and Aaron's Bitcoin Magazine article^[<https://bitcoinmagazine.com/articles/statechains-sending-keys-not-coins-to-scale-bitcoin-off-chain>].

\

### RSK, federated sidechains and Powpeg

![Ep. 20 {l0pt}](qr/ep/20.png)

We discuss RSK’s shift from a federated sidechain model to the project’s new Powpeg solution.

RSK is a merge-mined, Ethereum-like Bitcoin sidechain developed by IOVlabs. Bitcoin users can effectively move their coins to this blockchain that operates more like Ethereum, and move the coins back to the Bitcoin blockchain when they so choose. Some Bitcoin miners utilize their hash power to mine bocks on the sidechain, and earn some extra transaction fees by doing so.

The tricky part of any sidechain is allowing users to securely move their coins between blockchains. This is technically done by locking coins on the Bitcoin blockchain and issuing corresponding coins on the sidechain, and vice versa: locking coins on the sidechain to unlock the coins on the Bitcoin blockchain.

So far, RSK has done this by locking the coins into a multisignature address, for which the private keys were controlled by a group of well-known companies (known as a federated sidechain model). A majority of them was needed to unlock the coins, which they were to only do if and when the corresponding sidechain coins were locked.

RSK is now switching to a Powpeg model where the keys to the multisignature address are controlled by special tamper-proof hardware modules that are in turn programmed to only unlock coins on the Bitcoin blockchain if and when the corresponding coins on the sidechain are locked, and the transactions to lock these coins up have a significant number of confirmations.

The hosts explain how this works exactly, and discuss some of Powpeg’s security tradeoffs.

## More stuff on the chain

### Open Timestamps

![Ep. 16 {l0pt}](qr/ep/16.png)

In this episode we discuss Open Timestamps, a Bitcoin-based time stamping project by applied cryptography consultant and former Bitcoin Core contributor Peter Todd. Open Timestamps leverages the security of the Bitcoin blockchain to timestamp any type of data, allowing for irrefutable proof that that data existed at a particular point in time.

Aaron and Sjors explain that virtually any amount of data can, in fact, be timestamped in the Bitcoin blockchain at minimal cost because Open Timestamps leverages Merkle trees, the cryptographic trick to aggregate data into a single, compact hash. This hash is then included in a Bitcoin transaction, making all of the data aggregated into the hash as immutable as any other Bitcoin transaction.

Todd offered an interesting showcase of Open Timestamps earlier this week, as he proved that the public key used by Google to sign “the email" to Hunter Biden indeed existed in 2016.

Aaron and Sjors also discuss some of the other possibilities that a time-stamping system like Open Timestamps offers, as well as its limitations. Finally, Aaron provides a little bit of context for the history of cryptographic time stamping, which was itself referenced in the Bitcoin white paper.

### RGB

![Ep. 33 {l0pt}](qr/ep/33.png)

We are joined by Ruben Somsen to discuss RGB tokens, a Layer Two protocol for Bitcoin to support alternative currency and token schemes (like the currently popular non-fungible tokens, or NFTs).

We explain that the Bitcoin blockchain has been (ab)used by users to host data since the project’s early days. This was initially done through otherwise-useless transaction outputs, which meant that all Bitcoin users had to store this data locally. A feature called `OP_RETURN` later limited this burden.They also explain that people have been using the Bitcoin blockchain to host alternative currency and token schemes for a long time.

A few years ago I also gave a presentation about RGB as well as earlier attemps at using the Bitcoin blockchain to store non-money things: <https://www.youtube.com/watch?v=PgeqT6ruBWU>

### Bitcoin Core v0.21

![Ep. 24 {l0pt}](qr/ep/24.png)

In this episode we discuss the newly released Bitcoin Core 0.21.0, the 21st and latest major release of the Bitcoin Core software, the oldest and most important Bitcoin node implementation, which is often also regarded as the reference implementation for the Bitcoin protocol.

Guided by the Bitcoin Core 0.21.0 release notes, van Wirdum and Provoost discussed this release’s most important changes. These include the new mempool policy for rebroadcasting transactions, Tor v3 support, peer anchors for when the node restarts, BIP 157 (Neutrino) for light clients, the new testnet called Signet, BIP 339 (wtxid relay), Taproot code, RPC changes including a new send RPC, ZeroMQ, descriptor wallets, the new SQLite database system and the satoshi-per-byte fee denomination.

For each of the new features, the hosts discussed what the features are, how they will change using Bitcoin (Core) and — where applicable — what the end goal is. (In Bitcoin Core development, new features are often part of a bigger process.) For any feature they discussed on a previous episode of "The Van Wirdum Sjorsnado," they also mentioned the relevant episode number.

https://bitcoinmagazine.com/technical/bitcoin-core-0-21-0-released-whats-new

### Bitcoin Core v22.0

![Ep. 45 {l0pt}](qr/ep/45.png)

In this episode we discuss Bitcoin Core 22.0, the latest major release of the Bitcoin Core software client, currently the de facto reference implementation of the Bitcoin protocol. Aaron and Sjors highlight several improvements to the Bitcoin Core software.

The first of these is hardware wallet support in the graphical user interface (GUI). While hardware wallet support has been rolling out across several previous Bitcoin Core releases, it is now fully available in the GUI. The second highlighted upgrade is support for the Invisible Internet Project (I2P), a Tor-like internet privacy layer. Aaron and Sjors also briefly touch on the differences between I2P and Tor.

The third upgrade discussed in the episode is Taproot support. While Taproot activation logic was already included in Bitcoin Core 0.21.1 Bitcoin Core 22.0 is the first major Bitcoin Core release ready to support Taproot when it activates this November, and includes some basic Taproot functionality.

The fourth upgrade that Aaron and Sjors discuss is an update to the `testmempoolaccept` logic, which paves the way to a bigger package relay upgrade. This could in a future release allow transactions to be transmitted over the Bitcoin network in packages including several transactions at the same time.

Additionally, Aaron and Sjors briefly discuss an extension to create multisig and add multisig address, the new NAT-PMP option, and more.
