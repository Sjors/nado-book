\newpage
## Replace by Fee (RBF)

Listen to episode 26:

\qrcode{https://bitcoinmagazine.com/technical/the-advantages-and-drawbacks-of-replace-by-fee}

discuss Replace By Fee (RBF). RBF is a trick that lets unconfirmed transactions be replaced by conflicting transactions that include a higher fee.

With RBF, users can essentially bump a transaction fee to incentivize miners to include the transaction in a block. Aaron and Sjors explain three advantages of RBF: the option the “speed up” a transaction (1), which can in turn result in a more effective fee market for block space (2), as well as the potential to make more efficient use of block space by updating transactions to include more recipients (3).

The main disadvantage of RBF is that it makes it slightly easier to double spend unconfirmed transactions, which was also at the root of last week’s “double spend” controversy that dominated headlines. Aaron and Sjors discuss some solutions to diminish this risk, including “opt-in RBF” which is currently implemented in Bitcoin Core.

Finally, Sjors explains in detail how opt-in RBF works in Bitcoin Core, and which conditions must be met before a transaction is considered replaceable. He also notes some complications with this version of RBF, for example in the context of the Lightning Network.
