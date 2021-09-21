\newpage
## Headers First, Assume Valid and Assume UTXO

Listen to episode 14:

\qrcode{https://bitcoinmagazine.com/technical/video-sync-bitcoin-faster-assume-utxo}

 discuss “Assume UTXO”, a proposal and project by Chaincode Labs alumni James O’Beirne.

One of the biggest bottlenecks for scaling Bitcoin — if not the biggest one — is initial block download: the time it takes for a Bitcoin node to synchronize with the Bitcoin network, as it needs to process all historic transactions and blocks in order to construct the latest UTXO-set: the current state of bitcoin-ownership.

Aaron and Sjors explain some of the ways sync-time has been sped up over time. First, sync-time was improved through “Headers First” synchronization, which ensures that new Bitcoin nodes don’t waste time validating (potentially) weaker blockchains. In recent years, sync-time has been improved with “Assume Valid”, an optional shortcut that lets nodes skip signature verification of older transactions, instead trusting that the Bitcoin Core development process in combination with the resource-expensive nature of mining offers a reliable version of transaction history.

Finally, they explain how the security assumptions underpinning Assume Valid could be extended to allow for the potential future upgrade Assume UTXO to offer new Bitcoin Core users a speedy solution to get up to speed with the Bitcoin network, sacrificing a minimal amount of security during the initial bootstrapping phase.

Helpful Links:

Chaincode podcast about the same:
https://www.youtube.com/watch?v=knBHvzKsIOY

Pull request:
https://github.com/bitcoin/bitcoin/issues/15605
