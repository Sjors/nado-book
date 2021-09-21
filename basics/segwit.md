\newpage
## SegWit

Listen to episode 32:

\qrcode{https://bitcoinmagazine.com/technical/discussing-the-benefits-of-segregated-witness}

discuss Segregated Witness, also known as SegWit. SegWit was the last soft fork to have been activated on the Bitcoin network in the summer of 2017, and the biggest Bitcoin protocol upgrade to date.

In short, SegWit allowed transaction data and signature data to be separated in Bitcoin blocks. In this episode, Aaron and Sjors explain how this works, and that this offered four main benefits:

First, SegWit solved the transaction malleability issue, where transaction IDs could be altered without invalidating the transactions themselves. Solving the transaction malleability issue itself in turn enabled second layer protocols like the Lightning Network.

Second, SegWit offered a modest block size limit increase by discounting the “weight” of witness data, most notably signatures. Importantly, this could be done without the need for a hard fork.

Third, SegWit’s script versioning allows for easier upgrades to new transactions types. The anticipated Taproot upgrade could be a first example of this feature.

And fourth, input signing resolved some edge case problems where wallets needed to make sure they don’t overpay in transaction fees.. Hardware wallets benefit from this solution in particular.
