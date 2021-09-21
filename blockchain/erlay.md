\newpage
## Transaction relay with Erlay

Listen to episode 34:

\qrcode{https://bitcoinmagazine.com/technical/scaling-bitcoin-with-the-erlay-protocol}

discuss the Erlay protocol. Erlay is a proposal to reduce the bandwidth required to run a Bitcoin node, which has been proposed and developed by University of British Columbia researchers Gleb Naumenko, Alexandra Fedorova and Ivan Beschastnikh; Blockstream engineer Pieter Wuille; and independent Bitcoin Core contributor Gregory Maxwell.

Bitcoin nodes use bandwidth to receive and transmit both block data as well as transaction data. Reducing the amount of bandwidth a node requires to do this, would make it cheaper to run a node. Alternatively, it allows nodes to connect to more peers without increasing its bandwidth usage.



In the episode, Aaron and Sjors explain that Erlay uses set reconciliation to reduce the amount of data nodes need to share transactions. More specifically, Erlay uses a mathematical trick called Minisketch. This solution is based on pre-existing mathematical formulas used in biometrics technology.

Aaron and Sjors outline how this trick is applied in the context of Bitcoin to let different nodes sync their mempools: the sets of transactions they’ve received in anticipation of a new block, or, in the case of a miner, to include in a new block.
