\newpage
## RSK, federated sidechains and Powpeg

Listen to Bitcoin, Explained episode 20:\
![](qr/20.png)

discuss RSK’s shift from a federated sidechain model to the project’s new Powpeg solution.

RSK is a merge-mined, Ethereum-like Bitcoin sidechain developed by IOVlabs. Bitcoin users can effectively move their coins to this blockchain that operates more like Ethereum, and move the coins back to the Bitcoin blockchain when they so choose. Some Bitcoin miners utilize their hash power to mine bocks on the sidechain, and earn some extra transaction fees by doing so.

The tricky part of any sidechain is allowing users to securely move their coins between blockchains. This is technically done by locking coins on the Bitcoin blockchain and issuing corresponding coins on the sidechain, and vice versa: locking coins on the sidechain to unlock the coins on the Bitcoin blockchain.

So far, RSK has done this by locking the coins into a multisignature address, for which the private keys were controlled by a group of well-known companies (known as a federated sidechain model). A majority of them was needed to unlock the coins, which they were to only do if and when the corresponding sidechain coins were locked.

RSK is now switching to a Powpeg model where the keys to the multisignature address are controlled by special tamper-proof hardware modules that are in turn programmed to only unlock coins on the Bitcoin blockchain if and when the corresponding coins on the sidechain are locked, and the transactions to lock these coins up have a significant number of confirmations.

The hosts explain how this works exactly, and discuss some of Powpeg’s security tradeoffs.
