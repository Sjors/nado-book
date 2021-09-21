\newpage
## DNS boostrapping and Tor v3

Listen to episode 13:

\qrcode{https://bitcoinmagazine.com/technical/the-van-wirdum-sjorsnado-bitcoin-core-0-21-supports-tor-v3}

Bitcoin Core 0.21 will support Tor v3 addresses. Aaron and Sjors explain what this means and why it matters, and also discuss how new Bitcoin nodes find existing Bitcoin nodes when they bootstrap to the network.

Helpful Links:

* Tor V3 (onion) address support in Bitcoin Core: https://github.com/bitcoin/bitcoin/pull/19954

* the ADDRv2 message added in BIP155 that allows nodes to gossip those new Tor addresses: https://github.com/bitcoin/bips/blob/master/bip-0155.mediawiki#Specification

* DNS seeds and the bootstrap problem: https://stackoverflow.com/questions/41673073/how-does-the-bitcoin-client-determine-the-first-ip-address-to-connect

Timestamps:

00:00 - 00:34 - intro

1:02 - 2:10: how Tor Works

2:25 - 3:03: benefits of running a bitcoin node behind tor.

7:12 - 8:19 Discussing how Bitcoin node gossip addresses.

8:56 - 10:40 Explaining how DNS works

12:30 - 13:30: DNS is storing list of bitcoin nodes. 
