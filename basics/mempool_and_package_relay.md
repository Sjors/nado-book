\newpage
## Mempools, Child Pays for Parent, and Package Relay

![Bitcoin, Explained ep. 19](qr/19.png)

discussed Bitcoin mempools, Child Pays For Parent (CPFP) and package relay.

Package relay is the project that Gloria Zhao will work on as part of her Brink fellowship, which was announced earlier this week, and would make the Lightning Network more robust (among other benefits). Mempools are the collections of unconfirmed transactions stored by nodes, from which they forward transactions to peers. Miners usually select the transactions from their mempools that include the highest fees, to include these in the blocks they mine.

Mempools can get full, however, at which point transactions that pay the lowest fees are ejected. This is actually a problem in context of CPFP, a trick that lets users speed up low-fee transactions by spending the coins from that transactions in a new transaction with a high fee to compensate. Tricks like these can be particularly important in the context of time-sensitive protocols like the Lightning Network.

In this episode, van Wirdum and Provoost explained how package relay could enable CPFP, even in cases where low-fee transactions are dropped from mempools, by bundling transactions into packets. And they explore why this may be easier said than done.

Timestamps:
0:00 - 3:00 Intro (Price & Brink)
3:00 - 3:29: What is a Mempool?
5:24 - 6:11 What happens when a nodes mempool gets full. Sjors explains
11:40 - 13:30 The problem with Child pays for parent when the mempool is full
14:40 - 17:25 Package relay and what could go wrong.
