<!-- \backmatter -->
\appendix
# More episodes {#sec:more_eps}

Not all episodes of Bitcoin, Explained made it into this book. Here's some other episodes you could listen to:

### Bitcoin Beach

![Ep. 42 {l0pt}](qr/42.png)

Co-host Aaron van Wirdum speaks with Bitcoin Beach Wallet developer Nicolas Burtey in El Zonte, El Salvador — which has been dubbed Bitcoin Beach — to discuss the Bitcoin Beach Wallet, a Bitcoin and Lightning wallet specifically designed for use in the small Central American coastal town frequented by surfers and, now, bitcoiners.

They discuss the pros and cons of custodial and non-custodial Lightning wallets, and Nicolas explains why he opted to make the Bitcoin Beach Wallet a shared-custodial wallet, and what that means exactly.

They go one to discuss some of the design decisions and tradeoffs that the Bitcoin Beach Wallet has made, which include ledger-based payments between Bitcoin Beach Wallet users as well as the webpage-based zero invoice payments to facilitate payments from other Lightning wallets. while Nicolas speculates about a potential cross-wallet user account system to further improve the Lightning user experience over time.

Aaron and Nicolas also discuss some of the subtle incompatibilities between different Lightning wallets that use different techniques for routing payments, privacy considerations versus user experience in a community like El Zonte’s, and more.

### Chivo

![Ep. 46 {l0pt}](qr/46.png)

In this episode we discuss discuss the Chivo application, the Bitcoin wallet, and payment terminal provided by the government of El Salvador. The Chivo app is closed source software. Instead of analyzing the source code and design of the application, we had to rely on Aaron’s personal experience with the wallet and payment terminal or what he remembers of that personal experience. The episode opens with some general information about the Chivo Wallet, like why it was developed and who developed it (insofar anything is known about that). We discuss Aaron’s experiences with the wallet and speculate what that means for the design. After that, we discuss the design of the payment terminal that’s included in the application, and also briefly touch on the Chivo ATMs that have been deployed across the country. Finally, we discuss the difference in philosophy between the design of the Chivo application and Bitcoin’s free and open-source software culture.

### RGB

![Ep. 33 {l0pt}](qr/33.png)

We are joined by Ruben Somsen to discuss RGB tokens, a Layer Two protocol for Bitcoin to support alternative currency and token schemes (like the currently popular non-fungible tokens, or NFTs).

We explain that the Bitcoin blockchain has been (ab)used by users to host data since the project’s early days. This was initially done through otherwise-useless transaction outputs, which meant that all Bitcoin users had to store this data locally. A feature called `OP_RETURN` later limited this burden.They also explain that people have been using the Bitcoin blockchain to host alternative currency and token schemes for a long time.

A few years ago I also gave a presentation about RGB as well as earlier attemps at using the Bitcoin blockchain to store non-money things: <https://www.youtube.com/watch?v=PgeqT6ruBWU>

### Accounts with Easypaysy

![Ep. 11 {l0pt}](qr/11.png)

We discuss Jose Femenias' Easypaysy proposal, an account system for Bitcoin, on Bitcoin. One feature it supports is stealth address identities. We discuss several use cases. Finally we explain what non repudiation is.

Aaron also wrote an article covering Easypaysy for Bitcoin Magazine.^[<https://bitcoinmagazine.com/articles/bitcoin-need-accounts-one-developer-thinks-figured>]

### Payment pools

![Ep. 06 {l0pt}](qr/06.png)

In this episode we explain what payment pools are, and why they need Taproot. We discuss the user experience of sharing UTXOs and how payment pools can work with lightning.

See also Aaron's article.^[<https://bitcoinmagazine.com/articles/building-on-taproot-payment-pools-could-be-bitcoins-next-layer-two-protocol>]

\

\

\

### Lightning

One could write a entire book about lightning. And in fact, others have, see e.g. _Mastering the Lightning Network: A Second Layer Blockchain Protocol for Instant Bitcoin Payments_ by Andreas Antonopoulos and Olaoluwa Osuntokun (aka Roasbeef).

This book does not cover Lightning, but several Bitcoin, Explained episodes did.

#### Basics

![Ep. 22 {l0pt}](qr/22.png)

We discuss the basics of the Lightning Network, Bitcoin’s Layer 2 protocol for cheaper, faster and potentially more private transactions. We explain that the Lightning Network works as a scaling layer because it lets users make off-chain transactions through bi-directional payment channels: two users can pay one another an arbitrary number of times without these transactions being recorded on the blockchain. We went on to explain how, in the Lightning protocol, these off-chain transactions are secure, that is, how each of the participants is at any point guaranteed to claim their respective funds from the payment channel.

Then we explain how bi-directional payment channels can be linked across a network of users, to extend the potential of off-chain transactions so any Lightning user can pay any other Lightning user, even if they haven’t set up a payment channel between the two of them specifically.

Finally, we briefly touch on some of the challenges presented by the Lightning Network, most notably the requirement of payment channels to have sufficient liquidity locked into them.

#### RBF bug in Bitcoin Core

![Ep. 38 {l0pt}](qr/38.png)

We discuss CVE-2021-31876, a bug in the Bitcoin Core code that affects replace-by-fee (RBF) child transactions.^[<https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-31876>] The CVE (Common Vulnerabilities and Exposures) system offers an overview of publicly known software bugs. A newly discovered bug in the Bitcoin Core code was recently discovered and disclosed by Antoine Riard, and added to the CVE overview.

We explain that the bug affects how RBF logic is handled by the Bitcoin Core software. When one unconfirmed transaction includes an RBF flag (which means it should be considered replaceable if a conflicting transaction with a higher fee is broadcast over the network) any following transaction that spends coins from the original transaction should also be considered replaceable — even if the second transaction doesn’t itself have an RBF flag. Bitcoin Core software would not do this, however, which means the second transaction would in fact not be considered replaceable.

This is a fairly innocent bug; in most cases the second transaction will still confirm eventually, while there are also other solutions to speed confirmation up if the included fee is too low. But in very specific cases, like some fallback security mechanisms on the Lightning Network, the bug could in fact cause complications. We try to explain what such a scenario would look like, but end up totally confused.

#### Routing

![Ep. 41 {l0pt}](qr/41.png)

We are joined by Lightning developer Joost Jager to discuss everything about Lightning Network routing.

The Lightning Network consists of a network of payments channels. Each payment channel exists between two Lightning users. But even if two users don’t have a payment channel between themselves directly, they can pay each other though one or several other Lightning users, who in that case forward the payment from the payer to the payee.

The challenge is that a payment path across the network must be found, which allows the funds to move from the payer to the payee, and ideally the cheapest, fastest and most reliable payment path available.

Joost explains how Lightning nodes currently construct a map of the Lightning Network, and what information about all of the (publicly visible) payment channels is included about in that map. Next, he outlines on what basis Lightning nodes calculate the best path over the network to reach the payee, and how the performance of this route factors into future path finding calculations.

Finally we discuss some (potential) optimizations to benefit Lightning Network routing, such as rebalancing schemes and Trampoline Payments.

#### Optimally Reliable & Cheap Payment Flows on the Lightning Network

![Ep. 47 {l0pt}](qr/47.png)

In this episode I interview another expert on Lightning routing, René Pickhardt. We discuss his paper “Optimally Reliable & Cheap Payment Flows on the Lightning Network”.^[<https://arxiv.org/abs/2107.05322>] To cite the abstract:

> Today, payment paths in Bitcoin's Lightning Network are found by searching for shortest paths on the fee graph. We enhance this approach in two dimensions. Firstly, we take into account the probability of a payment actually being possible due to the unknown balance distributions in the channels. Secondly, we use minimum cost flows as a proper generalization of shortest paths to multi-part payments (MPP). In particular we show that under plausible assumptions about the balance distributions we can find the most likely MPP for any given set of senders, recipients and amounts by solving for a (generalized) integer minimum cost flow with a separable and convex cost function. Polynomial time exact algorithms as well as approximations are known for this optimization problem. We present a round-based algorithm of min-cost flow computations for delivering large payment amounts over the Lightning Network. This algorithm works by updating the probability distributions with the information gained from both successful and unsuccessful paths on prior rounds. In all our experiments a single digit number of rounds sufficed to deliver payments of sizes that were close to the total local balance of the sender. Early experiments indicate that our approach increases the size of payments that can be reliably delivered by several orders of magnitude compared to the current state of the art. We observe that finding the cheapest multi-part payments is an NP-hard problem considering the current fee structure and propose dropping the base fee to make it a linear min-cost flow problem. Finally, we discuss possibilities for maximizing the probability while at the same time minimizing the fees of a flow. While this turns out to be a hard problem in general as well - even in the single path case - it appears to be surprisingly tractable in practice.

#### Eltoo and SIGHASH_ANYPREVOUT

We covered this topic twice, so there's two epidodes to choose from. In episode 35 Aaron and I explain it, whereas in episode 48 one of the authors, c-lightning developer Christian joins me to explain it in his words.

![Ep. 35 {l0pt}](qr/35.png)

First we discuss `SIGHASH_ANYPREVOUT`, a proposed new sighash flag that would enable a cleaner version of the Lightning Network and other Layer Two protocols. Sighash flags are included in Bitcoin transactions to indicate which part of the transaction is signed by the required private keys, exactly.

This can be (almost) the entire transaction, or specific parts of it. Signing only specific parts allows for some flexibility to adjust the transaction even after it is signed, which can sometimes be useful. We explain that `SIGHASH_ANYPREVOUT` is a new type of sighash flag, which would sign most of the transaction, but not the inputs. This means that the inputs could be swapped, as long as the new inputs would still be compatible with the signature.

![Ep. 48 {l0pt}](qr/48.png)

`SIGHASH_ANYPREVOUT` would be especially useful in context of Eltoo, a proposed Layer Two protocol that would enable a new version of the Lightning Network. Where Lightning users currently need to store old channel data for security reasons, and could also be punished severely if they accidentally broadcast some of this data at the wrong time, we how SIGHASH_ANYPREVOUT would do away with this requirement.

#### Bolt 12 - Recurring payments, etc

![Ep. 44 {l0pt}](qr/44.png)

We discuss BOLT 12 (Basis of Lightning Technology 12), a newly proposed Lightning Network specification for “offers”, a type of “meta invoices” designed by c-lightning developer Rusty Russell.

Where coins on Bitcoin’s base layer are sent to addresses, the Lightning network uses invoices. Invoices communicate the requested amount, node destination, and the hash of a secret which is used for payment routing. This works, but has a number of limitations, Sjors explains, notably that the amount must be bitcoin-denominated (as opposed for fiat denominated), and the invoice can only be used once.

BOLT 12, which has been implemented in c-lightning, is a way to essentially refer a payer to the node that is to be paid, in order to request a new invoice. While the BOLT 12 offer can be static and reusable — it always refers to the same node — the payee can generate new invoices on the fly when requested, allowing for much more flexibility, Sjors explains.

Finally, we discuss how the new BOLT 12 messages are communicated over the Lightning Network through an update to the BOLT 7 specification for message relay.

### Sidechains

Lightning is not the only path forward for scaling Bitcoin, though it is the most actively developed one at the moment. Sidechains are another approach, optionally combined with Lightning.

Though there is no universally agreed upon definition, the general idea is that you create a separate blockchain with its own rules, that is somehow pegged to the Bitcoin blockchain. The advantage of this approach, in theory, is that only nodes that care about a paricular sidechain need to verify it, while the rest of the network only needs to check that the amount of Bitcoin leaving the sidechain does not exceed the amount going in.

We discussed several of these ideas in the podcast, often with the help of Utrecht based ad hoc co-host Ruben Somsen.

#### Drivechains

![Ep. 23 {l0pt}](qr/23.png)

Drivechain is a sidechain project spearheaded by Paul Sztorc.

This should make the sidechain coins interchangeable with bitcoin and therefore carry an equal value. In a way, sidechains let users “move” bitcoin across blockchains, where they are subject to different protocol rules, allowing for greater transaction capacity, more privacy, and other benefits. We explain that Drivechain consists of two main innovations.

The first is blind merged mining, which lets Bitcoin miners secure the drivechain with their existing hash power, but without necessarily needing to validate everything that happens on the sidechain.

The second is hashrate escrows, which lets miners “move” coins from the Bitcoin blockchain to the sidechain and back.

We also discuss some of the benefits as well as complications with Drivechain, most notably the security implications of letting miners control the pegging out process. They consider the arguments why this process is incentive compatible (in other words: secure) — or why it might not be.

\newpage

#### Perpetual One-Way Peg

![Ep. 12 {l0pt}](qr/12.png)

Ruben explains his proposal to combine blind merged mining and perpetual one-way pegs in order to create a new type of sidechain. The bad news: it won't make you rich but it could help scale Bitcoin!

First Ruben introduces the concept of a blind merge-mind chain. He then explains the use cases for the perpetual one-way peg and what Merge Mining is. We then get to Perpetual One-Way Peg and try answer the question: why would the side chain coin be worth anything?

A blog post by Ruben also explains the concept.^[<https://medium.com/@RubenSomsen/21-million-bitcoins-to-rule-all-sidechains-the-perpetual-one-way-peg-96cb2f8ac302>]

#### Softchains

![Ep. 27 {l0pt}](qr/27.png)

This time, they discuss one of Ruben’s own proposals, called Softchains.

Softchains are a type of two-way peg sidechains that utilize a new type of consensus mechanism: proof-of-work fraud proofs (or as Sjors prefers to call them, proof-of-work fraud indicators). Using this consensus mechanism, users don’t validate the content of each block, but instead only check the proof of work header, like Simplified Payment Verification (SPV) clients do. But using proof-of-work fraud proofs, users do validate the entire content of blocks any time a blockchain fork occurs. This offers a security model in between full node security and SPV security.

Ruben explains that by using proof-of-work fraud proofs for sidechains to create Softchains, Bitcoin full nodes could validate entire sidechains at minimal cost. This new model might be useful for certain types of sidechains, most notably “block size increase” sidechains that do nothing fancy but do offer more transaction capacity. Aaron, Sjors and Ruben also discuss some of the downsides of the Softchain model.

#### Statechains

![Ep. 08 {l0pt}](qr/08.png)

We discuss yet another one of Ruben's proposals: Statechains on Bitcoin. Statechains allow you to send keys not UTXO and it offers quite a few scaling and functionality improvements.

See also Ruben's presentation^[<https://youtu.be/CKx6eULIC3A>] on Bitcoin Magazine about Statechains and Aaron's Bitcoin Magazine article^[<https://bitcoinmagazine.com/articles/statechains-sending-keys-not-coins-to-scale-bitcoin-off-chain>].

#### RSK, federated sidechains and Powpeg

![Ep. 20 {l0pt}](qr/20.png)

We discuss RSK’s shift from a federated sidechain model to the project’s new Powpeg solution.

RSK is a merge-mined, Ethereum-like Bitcoin sidechain developed by IOVlabs. Bitcoin users can effectively move their coins to this blockchain that operates more like Ethereum, and move the coins back to the Bitcoin blockchain when they so choose. Some Bitcoin miners utilize their hash power to mine bocks on the sidechain, and earn some extra transaction fees by doing so.

The tricky part of any sidechain is allowing users to securely move their coins between blockchains. This is technically done by locking coins on the Bitcoin blockchain and issuing corresponding coins on the sidechain, and vice versa: locking coins on the sidechain to unlock the coins on the Bitcoin blockchain.

So far, RSK has done this by locking the coins into a multisignature address, for which the private keys were controlled by a group of well-known companies (known as a federated sidechain model). A majority of them was needed to unlock the coins, which they were to only do if and when the corresponding sidechain coins were locked.

RSK is now switching to a Powpeg model where the keys to the multisignature address are controlled by special tamper-proof hardware modules that are in turn programmed to only unlock coins on the Bitcoin blockchain if and when the corresponding coins on the sidechain are locked, and the transactions to lock these coins up have a significant number of confirmations.

The hosts explain how this works exactly, and discuss some of Powpeg’s security tradeoffs.
