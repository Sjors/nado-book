---
comment: guest Ruben
...
\newpage
## Utreexo


![Ep. 15 {l0pt}](qr/15.png)

they dive into a concept by Tadge Dryja called Utreexo.

Whenever a new Bitcoin transaction is made, Bitcoin nodes use a UTXO set (the overview of all bitcoin in existence at any given time) to determine that the coins that are being spent really exist. This UTXO set is currently several gigabytes in size and continues to grow over time and there is no upper limit to how big it can potentially get.

Because Bitcoin nodes perform best and fastest if the UTXO set is kept in RAM (in particular when syncing a new node), and RAM is usually a relatively scarce resource for most computers, it would benefits a node’s performance if the UTXO set could be stored in a more compact format. This is the promise of Utreexo.

Utreexo would take all the UTXOs in existence and include them in a Merkle Tree, a data-structure consisting only of hashes. Aaron, Sjors and Ruben explain how the compact Utreexo structure could suffice in proving that a particular UTXO is included when a new transaction is made, and they discuss the potential benefits that could surface if this solution becomes available, as well as some of its potential tradeoffs.

Timestamps:

1:16 - 3:35: Ruben explains the difference between assume utxo and assume valid.
4:40 - Utreexo
8:16 - 10:11 the problem with a limitless UTXO set.
10:44 - 11:55 How Utreexo works.
12:55 - 13:58 The Cryptographic Technicals to Utreexo
21:00 - 21:49 the boostrapping issue with utreexo and why bridge nodes are needed.
22:00 - 23:20: how Utreexo could be implemented with a soft fork.
25:33 - 27:07 the benefits of Utreexo
27:08 - 28:34 parallel validation with utreexo
29:50 - 30:37 Risks if utreexo


Helpful links:
<https://www.youtube.com/watch?v=6Y6n88DmkjU>

<https://bitcoinmagazine.com/articles/bitcoins-growing-utxo-problem-and-how-utreexo-can-help-solve-it>
