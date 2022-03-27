<!-- \backmatter -->
\appendix
\pagestyle{headings}
# Appendix {.unnumbered}

## More Episodes {#sec:more_eps}

Not all episodes of _Bitcoin, Explained_ made it into this book. Here are some other episodes you could listen to. The descriptions below are mostly based on the show notes written by co-host Aaron van Wirdum.

### Basics

#### What Is an xpub?

![Ep. 07 {l0pt}](qr/ep/07.png)

In this episode, we explain what an extended public key (xpub) is and how it’s used by Bitcoin wallets. Extended keys were first introduced in BIP 32 to create so-called hierarchical deterministic wallets.^[<https://en.bitcoin.it/wiki/BIP_0032>] Such wallets create a fresh address each time the user wants to receive coins. Unlike earlier wallets that required a fresh backup for every address, these new wallets only require a single backup, usually in the form of the familiar 12-24 word mnemonic.^[BIP 39 <https://en.bitcoin.it/wiki/BIP_0039>]

<!-- The BIP 39 footnote is intentionally inconsistent with BIP 32, so the QR codes aren't directly adjacent -->

#### Replace-By-Fee (RBF)

![Ep. 26 {l0pt}](qr/ep/26.png)

In this episode, we explain Replace-By-Fee (RBF). RBF is a trick that lets unconfirmed transactions be replaced with conflicting transactions that include a higher fee.

With RBF, users can essentially bump a transaction fee to incentivize miners to include a transaction in a block. We detail three advantages of RBF: the option to “speed up” a transaction (1), which can in turn result in a more effective fee market for block space (2), and the potential to make more efficient use of block space by updating transactions to include more recipients (3).

The main disadvantage of RBF is that it makes it slightly easier to double-spend unconfirmed transactions, which was also at the root of a “double-spend” controversy that dominated headlines in early 2021.^[<https://insights.deribit.com/market-research/was-there-a-bitcoin-double-spend-on-jan-20-2021/>] We discuss some solutions to diminish this risk, including “opt-in RBF,” which is currently implemented in Bitcoin Core.

Finally, we explain in some detail how opt-in RBF works and which conditions must be met before a transaction is considered replaceable. In the process, we note some complications with this version of RBF — for example, in the context of the Lightning network.

\newpage
#### Signet

![Ep. 10 {l0pt}](qr/ep/10.png)

A signet is a new type of testnet for Bitcoin. In this episode, we discuss the original version of the public testing blockchain (testnet) and outline its problems. We then explain how signets are similar in nature to testnet, but more reliable and centrally controlled. A signet — there can be more than one — achieves this by adding an additional signature requirement to block validation (hence “sig”).^[Read more about signet(s), or try it for yourself: <https://en.bitcoin.it/wiki/Signet>]

#### Mempools, Child Pays For Parent, and Package Relay

![Ep. 19 {l0pt}](qr/ep/19.png)

In this episode, we discuss Bitcoin memory pools (mempools), Child Pays For Parent (CPFP), and package relay.

Package relay is the project Gloria Zhao is working on as part of her Brink fellowship.^[<https://brink.dev/programs>]. It would make the Lightning network more robust (among other benefits). Mempools are the collections of unconfirmed transactions stored by nodes. Nodes then forward these unconfirmed transactions from their mempool to peers. Miners usually select the transactions from their mempool that include the highest fees to include these in the blocks they mine.

However, mempools can get full, at which point transactions that pay the lowest fees are ejected. This is actually a problem in the context of CPFP, which is a trick that lets users speed up low-fee transactions by spending the coins from those transactions in a new transaction with a high fee to compensate.^[<https://bitcoinops.org/en/topics/cpfp/>] Tricks like these can be particularly important in the context of time-sensitive protocols like the Lightning network.

In this episode, we go into detail about how package relay could enable CPFP — even in cases where low-fee transactions are dropped from mempools — by bundling transactions into packets. We also explore why this may be easier said than done.

#### Death to the Mempool, Long Live the Mempool

![Ep. 50 {l0pt}](qr/ep/50.png)

We discuss a recent thread on the Bitcoin development mailing list, titled “Death to the Mempool, Long Live the Mempool.”^[<https://lists.linuxfoundation.org/pipermail/bitcoin-dev/2021-October/019572.html>]

In the thread, Blockstream engineer Lisa “niftynei” Neigut proposes getting rid of the memory pool (mempool), which is the collection of unconfirmed transactions that Bitcoin nodes use to share transactions over the network and that Bitcoin miners use to create new blocks from. She argues that the Bitcoin system could be drastically simplified if users instead just send their transactions directly to miners (or mining pools).

In the episode, we explain how this would work and why this isn’t as simple as it may sound. We address the responses in the thread, going over the reasons why getting rid of the mempool is in fact not a very good solution for a system like Bitcoin. There’s a specific focus on the implications this would have on mining privacy and decentralization. It also explores some other tradeoffs that would need to be made to make the Bitcoin system work without a mempool.

\newpage
#### Bitcoin Improvement Proposal (BIP) Process

![Ep. 39 {l0pt}](qr/ep/39.png)

In this episode, we explain what Bitcoin Improvement Proposals (BIPs) are and how the BIP process works. We discuss why the BIP process is a useful yet non-binding convention within Bitcoin’s technical community.

First, we explain what a BIP is exactly— and what it isn’t. We also explain that only improvements to Bitcoin software that affect other projects require a BIP. We then dive into the history of the BIP process a little bit, noting that the format was introduced by Libbitcoin developer Amir Taaki, and later updated by Bitcoin Knots maintainer Luke-Jr.

Finally, we explain how the BIP process itself works — that is, how a proposal can be turned into a BIP and eventually be implemented in software. We also briefly explain how the BIP process could become corrupted and why that wouldn’t be a very big deal.

\newpage
### Resource Usage

#### Compact Client-Side Filtering (Neutrino)

![Ep. 25 {l0pt}](qr/ep/25.png)

In this episode, we discuss Compact Client-Side Filtering, also known as Neutrino. This is a solution to use Bitcoin without needing to download and validate the entire blockchain and without sacrificing your privacy to someone who operates a full node (and therefore did download and validate the entire blockchain).

Downloading and validating the entire Bitcoin blockchain can take a couple of days even on a standard laptop, and it takes much longer on smartphones and other limited-performance computers. This is why many people prefer to use light clients. These aren’t quite as secure as full Bitcoin nodes, but they do require fewer computational resources to operate.

Some types of light clients — Simplified Payment Verification (SPV) clients — essentially ask nodes on the Bitcoin network about the particular Bitcoin addresses they’re interested in to check how much bitcoin they own. This is bad for privacy, since the full node operator learns which addresses belong to the SPV user.

Compact Client-Side Filtering is a newer solution to accomplish goals similar to SPV, but without the loss of privacy. This works, in short, by having full node operators create a cryptographic data structure that tells the light client user whether a block could’ve contained activity pertaining to its addresses, so the user can keep track of its funds by downloading only a small subset of all Bitcoin blocks.

We explain how this works in more detail, and we discuss some of the tradeoffs of this solution.

\newpage
#### Compact Blocks

![Ep. 51 {l0pt}](qr/ep/51.png)

We explain how Bitcoin’s peer-to-peer network is made more efficient and faster with compact blocks.^[<https://bitcoincore.org/en/2016/06/07/compact-blocks-faq/>]

Compact blocks are — as the name suggests — compact versions of Bitcoin blocks that have been used by Bitcoin Core nodes since version 0.13. Compact blocks contain the minimal amount of data required for Bitcoin nodes to reconstruct entire blocks. Most notably, compact blocks exclude most transaction data to instead include short transaction identifiers. Bitcoin nodes can use these short identifiers to figure out which transactions from their mempools should be included in the blocks.

We explain how and why compact blocks benefit the Bitcoin network, and specifically how they help counter mining centralization. We also cover some edge cases that can result from the use of compact blocks — like the possibility that different valid transactions can have an identical identifier — and how Bitcoin nodes handle such occurrences.

You may also want to watch Greg Maxwell’s presentation about advances in block propagation, or read the transcript.^[<https://btctranscripts.com/greg-maxwell/gmaxwell-2017-11-27-advances-in-block-propagation/>]

\newpage
#### Erlay

![Ep. 34 {l0pt}](qr/ep/34.png)

In this episode, we discuss the Erlay protocol. Erlay is a proposal to reduce the bandwidth required to run a Bitcoin node. It was proposed and developed by University of British Columbia researchers Gleb Naumenko, Alexandra Fedorova, and Ivan Beschastnikh; Blockstream engineer Pieter Wuille; and independent Bitcoin Core contributor Gregory Maxwell.

Bitcoin nodes use bandwidth to receive and transmit both block data and transaction data. Reducing the amount of bandwidth a node requires to do this would make it cheaper to run a node. Alternatively, it would allow nodes to connect to more peers without increasing bandwidth usage.

We explain that Erlay uses set reconciliation to reduce the amount of data nodes need to share transactions. More specifically, Erlay uses a mathematical trick called Minisketch^[<https://github.com/sipa/minisketch>]. This solution is based on preexisting mathematical formulas used in biometrics technology.

We also outline how this trick is applied in the context of Bitcoin to let different nodes sync their mempools, which are the sets of transactions they’ve received in anticipation of a new block — or, in the case of a miner, to include in a new block.

\newpage
### Attacks

#### Time-Warp Attack


![Ep. 05 {l0pt}](qr/ep/05.png)

In this episode, we explain the “time-warp attack” on Bitcoin. A potential fix for this attack is included in Matt Corallo’s proposed Great Consensus Cleanup soft fork,^[<https://github.com/TheBlueMatt/bips/blob/cleanup-softfork/bip-XXXX.mediawiki>] which — at the time of writing — hasn’t seen much progress.

\

#### PSBT and RBF Attacks

![Ep. 01 {l0pt}](qr/ep/01.png)

In this episode, we break down and explain Partially Signed Bitcoin Transactions (PSBT) and Replace-By-Fee (RBF), along with some really tricky attacks that were discovered.^[<https://blog.trezor.io/latest-firmware-updates-correct-possible-segwit-transaction-vulnerability-266df0d2860> and ]

PSBT is a data format that allows wallets and other tools to exchange information about a Bitcoin transaction and the signatures necessary to complete it.^[PSBT Attack Vector <https://bitcoinops.org/en/topics/psbt/> and RBF Attack Vector <https://zengo.com/bigspender-double-spend-vulnerability-in-bitcoin-wallets/>]

#### Mining Pool Censorship

![Ep. 37 {l0pt}](qr/ep/37.png)

In this episode, we discuss the emergence of Mara Pool, the American Bitcoin mining pool, which — at the time we recorded this episode — claimed to be fully compliant with US regulations. This means it applies anti-money laundering (AML) checks and adheres to the sanction list of the Office of Foreign Assets Control (OFAC). While details haven’t been made explicit, this presumably means that this pool won’t include transactions in blocks if these transactions send coin to or from Bitcoin addresses that have been included on an OFAC blacklist.

Some time after recording, it changed course and announced it wouldn’t be censoring transactions.

In the episode, we discuss the prospects of mining censorship, what that would mean for Bitcoin, and what can be done about it. We expand upon what it could look like if this practice is adopted more widely. We consider what censoring mining pools could accomplish if they ever get close to controlling a majority of hash power and what Bitcoin users could potentially do in such a scenario (if anything).

\newpage
### Wallets

#### Hardware Wallet Integration in Bitcoin Core


![Ep. 30 {l0pt}](qr/ep/30.png)

We discuss hardware wallet integration into Bitcoin Core, which is one of the ongoing projects that Sjors regularly contributes to.

Hardware wallets are a popular solution for storing private keys offline to minimize the risk that hackers gain access to the corresponding coins. They’re used in combination with regular software wallets to sign transactions in such a way that the private keys never leave the device.


#### Hardware Wallet Security and Jade

![Ep. 43 {l0pt}](qr/ep/43.png)

Co-host Aaron is joined by Blockstream’s Lawrence Nahum, one of the developers of the Jade hardware wallet, and Ben Kaufman, one of the developers of Spectre Desktop - a software tool for hardware wallets.

They talk about what hardware wallets are and discuss the design tradeoffs that different hardware wallets have taken by focusing on the Trezor, Ledger, and Coldcard devices specifically. In this light, Lawrence and Ben explain what secure elements and secure chips are and why some hardware wallets choose to rely on using such chips more than others.

Then, Lawrence explains which tradeoffs Jade Wallet makes. He also details how an additional server-based security step is used to further secure Jade Wallet, and he briefly outlines some additional differences in hardware wallet designs— for example, those focused on usability.

Finally, they discuss whether hardware wallets are overrated, or if you might as well use a dedicated smartphone to store your bitcoin.

#### Bitcoin Beach

![Ep. 42 {l0pt}](qr/ep/42.png)

Co-host Aaron speaks with Bitcoin Beach Wallet developer Nicolas Burtey in El Zonte, El Salvador — which has been dubbed Bitcoin Beach — to discuss the Bitcoin Beach Wallet, a Bitcoin and Lightning wallet specifically designed for use in the small Central American coastal town frequented by surfers and, now, bitcoiners.

They discuss the pros and cons of custodial and non-custodial Lightning wallets, and Nicolas explains why he opted to make the Bitcoin Beach Wallet a shared-custodial wallet, and what that means exactly.

They go on to discuss some of the design decisions and tradeoffs that the Bitcoin Beach Wallet has made, which include ledger-based payments between Bitcoin Beach Wallet users, and webpage-based zero invoice payments to facilitate payments from other Lightning wallets. Nicolas also speculates about a potential cross-wallet user account system to further improve the Lightning user experience over time.

Finally, there’s discussion of some of the subtle incompatibilities between different Lightning wallets that use different techniques for routing payments, privacy considerations versus user experience in a community like El Zonte’s, and more.

#### Chivo

![Ep. 46 {l0pt}](qr/ep/46.png)

In this episode, we discuss the Chivo application, the Bitcoin wallet, and the payment terminal provided by the government of El Salvador. The Chivo app is closed source software. Instead of analyzing the source code and design of the application, we had to rely on personal experience with the wallet and payment terminal.

The episode opens with some general information about the Chivo Wallet, like why it was developed and who developed it (insofar anything is known about that). We discuss Aaron’s experiences with the wallet and speculate what that means for the design. After that, we discuss the design of the payment terminal that’s included in the application, and we also briefly touch on the Chivo ATMs that have been deployed across the country. Finally, we discuss the difference in philosophy between the design of the Chivo application and Bitcoin’s free and open source software culture.

#### Payment Pools

![Ep. 06 {l0pt}](qr/ep/06.png)

In this episode, we explain what payment pools are and why they need Taproot. We discuss the user experience of sharing UTXOs and how payment pools can work with Lightning.

For more information, see Aaron’s article.^[<https://bitcoinmagazine.com/articles/building-on-taproot-payment-pools-could-be-bitcoins-next-layer-two-protocol>]

\

#### Accounts with Easypaysy

![Ep. 11 {l0pt}](qr/ep/11.png)

We discuss Jose Femenias’ easypaysy proposal, an account system for Bitcoin, on Bitcoin. One feature it supports is stealth address identities. We discuss several use cases. Finally, we explain what non-repudiation is.

Aaron also wrote an article covering easypaysy for Bitcoin Magazine.^[<https://bitcoinmagazine.com/articles/bitcoin-need-accounts-one-developer-thinks-figured>]

\newpage
### Lightning

One could write an entire book about lightning. And in fact, others have, see e.g. _Mastering the Lightning Network: A Second Layer Blockchain Protocol for Instant Bitcoin Payments_ by Andreas M. Antonopoulos and Olaoluwa Osuntokun (aka Roasbeef).^[<https://www.oreilly.com/library/view/mastering-the-lightning/9781492054856/>]

This book doesn’t cover Lightning, but several _Bitcoin, Explained_ episodes did.

#### Basics

![Ep. 22 {l0pt}](qr/ep/22.png)

We discuss the basics of the Lightning network, Bitcoin’s Layer Two protocol for cheaper, faster, and potentially more private transactions. We explain that the Lightning network works as a scaling layer because it lets users make off-chain transactions through bidirectional payment channels: Two users can pay one another an arbitrary number of times without these transactions being recorded on the blockchain. We went on to explain how, in the Lightning protocol, these off-chain transactions are secure — that is, how each of the participants is at any point guaranteed to claim their respective funds from the payment channel.

Then we explain how bidirectional payment channels can be linked across a network of users to extend the potential of off-chain transactions so any Lightning user can pay any other Lightning user, even if they haven’t set up a payment channel between the two of them specifically.

Finally, we briefly touch on some of the challenges presented by the Lightning network — most notably the requirement of payment channels to have sufficient liquidity locked into them.

\newpage
#### RBF Bug in Bitcoin Core

![Ep. 38 {l0pt}](qr/ep/38.png)

We discuss CVE-2021-31876, a bug in the Bitcoin Core code that affects Replace-By-Fee (RBF) child transactions.^[<https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-31876>] The Common Vulnerabilities and Exposures (CVE) system offers an overview of publicly known software bugs. A new bug in the Bitcoin Core code was discovered and disclosed by Antoine Riard, and it was added to the CVE overview.

We explain that the bug affects how RBF logic is handled by the Bitcoin Core software. When one unconfirmed transaction includes an RBF flag (which means it should be considered replaceable if a conflicting transaction with a higher fee is broadcast over the network), any following transaction that spends coins from the original transaction should also be considered replaceable — even if the second transaction doesn’t itself have an RBF flag. Bitcoin Core software wouldn’t do this, however, which means the second transaction would in fact not be considered replaceable.

This is a fairly innocent bug; in most cases, the second transaction will still confirm eventually, while there are also other solutions to speed confirmation up if the included fee is too low. But in very specific cases, like some fallback security mechanisms on the Lightning network, the bug could in fact cause complications. We try to explain what such a scenario would look like, but we end up totally confused.

\newpage
#### Routing

![Ep. 41 {l0pt}](qr/ep/41.png)

We’re joined by Lightning developer Joost Jager to discuss everything about Lightning network routing.

The Lightning network consists of a network of payment channels. Each payment channel exists between two Lightning users. But even if two users don’t have a payment channel between themselves directly, they can pay each other through one or several other Lightning users, who in that case forward the payment from the payer to the payee.

The challenge is that they need to find a payment path across the network that allows the funds to move from the payer to the payee — ideally the cheapest, fastest, and most reliable payment path available.

Joost explains how Lightning nodes currently construct a map of the Lightning network and what information about all of the (publicly visible) payment channels is included in that map. Next, he outlines on what basis Lightning nodes calculate the best path over the network to reach the payee and how the performance of this route factors into future path-finding calculations.

Finally, we discuss some (potential) optimizations to benefit Lightning network routing, such as rebalancing schemes and trampoline payments.

\newpage
#### Optimally Reliable and Cheap Payment Flows on the Lightning Network

![Ep. 47 {l0pt}](qr/ep/47.png)

In this episode, we interview another expert on Lightning routing, René Pickhardt. We discuss his paper _Optimally Reliable & Cheap Payment Flows on the Lightning Network_.^[<https://arxiv.org/abs/2107.05322>] To cite the abstract:

\

> Today, payment paths in Bitcoin’s Lightning Network are found by searching for shortest paths on the fee graph. We enhance this approach in two dimensions. Firstly, we take into account the probability of a payment actually being possible due to the unknown balance distributions in the channels. Secondly, we use minimum cost flows as a proper generalization of shortest paths to multi-part payments (MPP). In particular we show that under plausible assumptions about the balance distributions we can find the most likely MPP for any given set of senders, recipients and amounts by solving for a (generalized) integer minimum cost flow with a separable and convex cost function. Polynomial time exact algorithms as well as approximations are known for this optimization problem. We present a round-based algorithm of min-cost flow computations for delivering large payment amounts over the Lightning Network. This algorithm works by updating the probability distributions with the information gained from both successful and unsuccessful paths on prior rounds. In all our experiments a single digit number of rounds sufficed to deliver payments of sizes that were close to the total local balance of the sender. Early experiments indicate that our approach increases the size of payments that can be reliably delivered by several orders of magnitude compared to the current state of the art. We observe that finding the cheapest multi-part payments is an NP-hard problem considering the current fee structure and propose dropping the base fee to make it a linear min-cost flow problem. Finally, we discuss possibilities for maximizing the probability while at the same time minimizing the fees of a flow. While this turns out to be a hard problem in general as well - even in the single path case - it appears to be surprisingly tractable in practice.

#### Eltoo and `SIGHASH_ANYPREVOUT`

We covered this topic twice, so there are two episodes to choose from. In episode 35, we explain what this is, and in episode 48, one of the authors, c-lightning developer Christian Decker, joins us to explain it in his words.

![Ep. 35 {l0pt}](qr/ep/35.png)

First, we discuss `SIGHASH_ANYPREVOUT`, a proposed new sighash flag that would enable a cleaner version of the Lightning network and other Layer Two protocols. Sighash flags are included in Bitcoin transactions to indicate which part of the transaction is signed by the required private keys.

This can be (almost) the entire transaction or specific parts of it. Signing only specific parts allows for some flexibility to adjust the transaction even after it’s signed, which can sometimes be useful. We explain that `SIGHASH_ANYPREVOUT` is a new type of sighash flag that would sign most of the transaction, but not the inputs. This means that the inputs could be swapped, as long as the new inputs would still be compatible with the signature.

![Ep. 48 {l0pt}](qr/ep/48.png)

`SIGHASH_ANYPREVOUT` would be especially useful in context of Eltoo, a proposed Layer Two protocol that would enable a new version of the Lightning network. Where Lightning users currently need to store old channel data for security reasons and could also be punished severely if they accidentally broadcast some of this data at the wrong time, we discuss how `SIGHASH_ANYPREVOUT` would do away with this requirement.

#### Bolt 12 — Recurring Payments, Etc.

![Ep. 44 {l0pt}](qr/ep/44.png)

We discuss Basis of Lightning Technology 12 (BOLT 12), a newly proposed Lightning network specification for “offers,” which are a type of “meta invoices” designed by c-lightning developer Rusty Russell.

Where coins on Bitcoin’s base layer are sent to addresses, the Lightning network uses invoices. Invoices communicate the requested amount, the node destination, and the hash of a secret that’s used for payment routing. This works, but it has a number of limitations — notably that the amount must be bitcoin-denominated (as opposed to fiat denominated), and the invoice can only be used once.

BOLT 12, which has been implemented in c-lightning, is a way to essentially refer a payer to the node that is to be paid, in order to request a new invoice. While the BOLT 12 offer can be static and reusable — it always refers to the same node — the payee can generate new invoices on the fly when requested, allowing for much more flexibility.

Finally, we discuss how the new BOLT 12 messages are communicated over the Lightning network through an update to the BOLT 7 specification for message relay.

\newpage
### Sidechains and More

Lightning isn’t the only path forward for scaling Bitcoin, though it’s the most actively developed one at the moment. Sidechains are another approach, and they can optionally be combined with Lightning.

Though there’s no universally agreed upon definition of what a sidechain is, the general idea is that you create a separate blockchain with its own rules that’s somehow pegged to the Bitcoin blockchain. The advantage of this approach, in theory, is that only nodes that care about a particular sidechain need to verify it, while the rest of the network only needs to check that the amount of bitcoin leaving the sidechain doesn’t exceed the amount going in.

We discussed several of these ideas in the podcast, often with the help of Utrecht-based ad hoc co-host Ruben Somsen.

#### Drivechains

![Ep. 23 {l0pt}](qr/ep/23.png)

Drivechain is a sidechain project spearheaded by Paul Sztorc.^[<https://www.drivechain.info>]

This should make the sidechain coins interchangeable with bitcoin and therefore, they should carry an equal value. In a way, sidechains let users “move” bitcoin across blockchains, where they’re subject to different protocol rules, allowing for greater transaction capacity, more privacy, and other benefits. We explain that Drivechain consists of two main innovations.

The first is Blind Merged Mining (BMM), which lets Bitcoin miners secure the drivechain with their existing hash power, but without necessarily needing to validate everything that happens on the sidechain.

The second is Hashrate Escrows, which lets miners “move” coins from the Bitcoin blockchain to the sidechain and back.

We also discuss some of the benefits and complications with Drivechain — most notably the security implications of letting miners control the pegging out process. We consider the arguments of why this process is incentive compatible (which is important for security) — or why it might not be.

#### Perpetual One-Way Peg

![Ep. 12 {l0pt}](qr/ep/12.png)

Ruben explains his proposal to combine Blind Merged Mining and Perpetual One-Way Pegs to create a new type of sidechain. The bad news: It won’t make you rich, but it could help scale Bitcoin!

First, he introduces the concept of a blind merge-mind chain. He then explains the use cases for the perpetual one-way peg and what Merge Mining is. We then get to Perpetual One-Way Peg and try answer the question: Why would the sidechain coin be worth anything?

A blog post by Ruben also explains the concept.^[<https://medium.com/@RubenSomsen/21-million-bitcoins-to-rule-all-sidechains-the-perpetual-one-way-peg-96cb2f8ac302>]

#### Softchains

![Ep. 27 {l0pt}](qr/ep/27.png)

This time, we discuss one of Ruben’s own proposals: Softchains.^[<https://lists.linuxfoundation.org/pipermail/bitcoin-dev/2020-December/018331.html>]

Softchains are a type of two-way peg sidechains that utilize a new type of consensus mechanism: proof-of-work fraud proofs (or as Sjors prefers to call them, proof-of-work fraud indicators). Using this consensus mechanism, users don’t validate the content of each block, but instead only check the proof-of-work header, like Simplified Payment Verification (SPV) clients do. But using proof-of-work fraud proofs, users do validate the entire content of blocks any time a blockchain fork occurs. This offers a security model in between full node security and SPV security.

Ruben explains that by using proof-of-work fraud proofs for sidechains to create Softchains, Bitcoin full nodes could validate entire sidechains at minimal cost. This new model might be useful for certain types of sidechains, most notably “block size increase” sidechains that do nothing fancy but do offer more transaction capacity. We also discuss some of the downsides of the Softchain model.

#### Statechains

![Ep. 08 {l0pt}](qr/ep/08.png)

We discuss yet another one of Ruben’s proposals: Statechains on Bitcoin. Statechains allow you to send keys instead of UTXOs, and they offer quite a few scaling and functionality improvements.

You might also want to refer to Ruben’s presentation^[<https://youtu.be/CKx6eULIC3A>] in Bitcoin Magazine about Statechains, as well as Aaron’s Bitcoin Magazine article.^[<https://bitcoinmagazine.com/articles/statechains-sending-keys-not-coins-to-scale-bitcoin-off-chain>]

\

#### RSK, Federated Sidechains, and Powpeg

![Ep. 20 {l0pt}](qr/ep/20.png)

We discuss RSK’s shift from a federated sidechain model to the project’s new Powpeg solution.

RSK is a merge-mined, Ethereum-like Bitcoin sidechain developed by IOVLabs. Bitcoin users can effectively move their coins to this blockchain that operates more like Ethereum and move the coins back to the Bitcoin blockchain when they so choose. Some Bitcoin miners utilize their hash power to mine blocks on the sidechain and earn some extra transaction fees by doing so.

The tricky part of any sidechain is allowing users to securely move their coins between blockchains. This is technically done by locking coins on the Bitcoin blockchain and issuing corresponding coins on the sidechain, and vice versa: locking coins on the sidechain to unlock the coins on the Bitcoin blockchain.

So far, RSK has done this by locking the coins into a multi-signature address, for which the private keys were controlled by a group of well-known companies (known as a federated sidechain model). A majority was needed to unlock the coins, which they were to only do if and when the corresponding sidechain coins were locked.

RSK is now switching to a Powpeg model where the keys to the multi-signature address are controlled by special tamper-proof hardware modules that are in turn programmed to only unlock coins on the Bitcoin blockchain if and when the corresponding coins on the sidechain are locked, and the transactions to lock these coins up have a significant number of confirmations.

We explain how this works exactly, and we discuss some of Powpeg’s security tradeoffs.

\newpage
### More Stuff on the Chain

#### OpenTimestamps

![Ep. 16 {l0pt}](qr/ep/16.png)

In this episode, we discuss OpenTimestamps,^[<https://opentimestamps.org>] a Bitcoin-based time stamping project by applied cryptography consultant and former Bitcoin Core contributor Peter Todd. OpenTimestamps leverages the security of the Bitcoin blockchain to timestamp any type of data, allowing for irrefutable proof that that data existed at a particular point in time.

We explain that virtually any amount of data can, in fact, be timestamped in the Bitcoin blockchain at minimal cost because OpenTimestamps leverages Merkle trees, the cryptographic trick to aggregate data into a single, compact hash. This hash is then included in a Bitcoin transaction, making all of the data aggregated into the hash as immutable as any other Bitcoin transaction.

Around the time the episode was recorded, Peter offered an interesting showcase of OpenTimestamps, as he proved that the public key used by Google to sign a controversial email to Hunter Biden existed as early as 2016.^[<https://github.com/robertdavidgraham/hunter-dkim/tree/main/ots-timestamp>]

We also discuss some of the other possibilities that a time-stamping system like OpenTimestamps offers, as well as its limitations. Finally, Aaron provides a little bit of context for the history of cryptographic time stamping, which was itself referenced in the Bitcoin white paper.

I timestamped the source code for this book^[<https://github.com/Sjors/nado-book>], so you can verify that a draft version existed as early as March 2022.

```
c=86a7cd200acb1812b6b2f8be27c8380ea44c9470
git verify-commit $c
git cat-file -p $c > appendix/commit
ots verify appendix/commit.ots
```

#### Discreet Log Contracts

![Ep. 53 {l0pt}](qr/ep/53.png)

In this episode, we’re again joined by resident sidechain and Layer Two expert Ruben Somsen, this time to discuss Discreet Log Contracts (DLCs).

Discreet Log Contracts are a type of smart contracts for Bitcoin, first proposed by Lightning network white paper coauthor Tadge Dryja.^[<https://adiabat.github.io/dlc.pdf>] In essence, DLCs are a way to perform bets — but this means they can ultimately be leveraged for all sorts of financial instruments, including futures markets, insurances, and stablecoins.

At the start of the episode, we discuss what can be considered a type of proto-DLC — namely a multi-signature setup for sports betting where two participants add a neutral third party (an “oracle”) that can resolve the bet one way or the other if needed. However, we explain how this solution comes with a number of downsides, like the difficulty of scaling it.

From there, we go on to explain how DLCs solved these problems using a setup that resembles payment channels as used on the Lightning network. When structured like this, oracles merely need to publish a cryptographically signed message about the outcome of an event, which can be used by the winning participant of the bet to create a withdrawal transaction from the payment channel.

Finally, we explain how the original DLC concept could be streamlined by using adaptor signatures,^[<https://bitcoinops.org/en/topics/adaptor-signatures/>] a sort of “incomplete signature” that can be made complete using the signed message from the oracle. With adaptor signatures, DLCs no longer require a separate withdrawal transaction, as the winner can claim funds from the payment channel directly.

#### RGB

![Ep. 33 {l0pt}](qr/ep/33.png)

We’re joined by Ruben Somsen to discuss RGB tokens, a Layer Two protocol for Bitcoin to support alternative currency and token schemes (like the currently popular non-fungible tokens, or NFTs).

We explain that the Bitcoin blockchain has been (ab)used by users to host data since the project’s early days. This was initially done through otherwise-useless transaction outputs, which meant that all Bitcoin users had to store this data locally. A feature called `OP_RETURN` later limited this burden. We also explain that people have been using the Bitcoin blockchain to host alternative currency and token schemes for a long time.

A few years ago, Sjors also gave a presentation about RGB and earlier attempts at using the Bitcoin blockchain to store non-money things: <https://www.youtube.com/watch?v=PgeqT6ruBWU>

\newpage

### Software Releases

#### Bitcoin Core v0.21

![Ep. 24 {l0pt}](qr/ep/24.png)

In this episode, we discuss Bitcoin Core 0.21.0, the 21st major release of the Bitcoin Core software.^[<https://bitcoinmagazine.com/technical/bitcoin-core-0-21-0-released-whats-new>] Bitcoin Core is the oldest and most important Bitcoin node implementation, which is often also regarded as the reference implementation for the Bitcoin protocol.

Guided by the Bitcoin Core 0.21.0 release notes, we discuss this release’s most important changes. These include the new mempool policy for rebroadcasting transactions, Tor v3 support, peer anchors for when the node restarts, BIP 157 (Neutrino) for light clients, the new testnet called Signet, BIP 339 (wtxid relay), Taproot code, RPC changes including a new send RPC, ZeroMQ, descriptor wallets, the new SQLite database system, and the satoshi-per-byte fee denomination.

For each of the new features, we discuss what the features are, how they’ll change using Bitcoin (Core) and — where applicable — what the end goal is. (In Bitcoin Core development, new features are often part of a bigger process.) For any feature we discussed on a previous episode of _Bitcoin, Explained_, we also mention the relevant episode number.

\newpage
#### Bitcoin Core v22.0

![Ep. 45 {l0pt}](qr/ep/45.png)

In this episode, we discuss Bitcoin Core 22.0, the next major release of the Bitcoin Core software client.^[<https://bitcoincore.org/en/releases/22.0/>]

The first of these is hardware wallet support in the graphical user interface (GUI). While hardware wallet support has been rolling out across several previous Bitcoin Core releases, it’s now fully available in the GUI. The second highlighted upgrade is support for the Invisible Internet Project (I2P), a Tor-like internet privacy layer. We also briefly touch on the differences between I2P and Tor.

The third upgrade discussed in the episode is Taproot support. While Taproot activation logic was already included in Bitcoin Core 0.21.1, Bitcoin Core 22.0 is the first major Bitcoin Core release ready to support Taproot, albeit with limited functionality.

The fourth upgrade we discuss is an update to the `testmempoolaccept` logic, which paves the way toward a bigger package relay upgrade. This could, in a future release, allow transactions to be transmitted over the Bitcoin network in packages including several transactions at the same time.

Additionally, we briefly discuss an extension to multisig address creation, the new NAT-PMP option, and more.

\newpage

#### Syncing Old Bitcoin Nodes

![Ep. 55 {l0pt}](qr/ep/55.png)

We discuss research done by CasaHODL co-founder and CTO Jameson Lopp, as well as research done by Sjors on syncing old Bitcoin nodes.^[<https://blog.lopp.net/bitcoin-core-performance-evolution/>]

Whenever a new Bitcoin node comes online, it must first sync with the rest of the Bitcoin network: It needs to download and verify the entire blockchain up until the most recent block to be up to date on the state of bitcoin ownership. This can take quite a while, however, and it should take longer over time as the blockchain keeps growing. To offset this, and to improve user experience more generally, Bitcoin Core developers seek to improve performance of the Bitcoin Core code so that newer releases sync faster than their predecessors.

In the episode, we outline the performance improvements of Bitcoin Core clients over time, as analyzed most recently in two blog posts by Jameson. We first explain why some very old Bitcoin clients have trouble syncing to the current state of the blockchain at all, pointing out some bugs in this early software, as well as issues relating to dependencies and the challenge of using such old clients today (some of which we covered in chapter @sec:libsecp). We then go on to sum up some of the most important performance improvements that have been included in new Bitcoin Core releases over time.

<!-- Add blank page to open on left side -->
\newpage
\null
\newpage
