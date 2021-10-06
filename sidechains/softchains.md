---
comment: guest Ruben Somsen
...
\newpage
## Softchains

Listen to Bitcoin, Explained episode 27:\
![](qr/27.png)

This time, they discuss one of Ruben’s own proposals, called Softchains.

Softchains are a type of two-way peg sidechains that utilize a new type of consensus mechanism: proof-of-work fraud proofs (or as Sjors prefers to call them, proof-of-work fraud indicators). Using this consensus mechanism, users don’t validate the content of each block, but instead only check the proof of work header, like Simplified Payment Verification (SPV) clients do. But using proof-of-work fraud proofs, users do validate the entire content of blocks any time a blockchain fork occurs. This offers a security model in between full node security and SPV security.

Ruben explains that by using proof-of-work fraud proofs for sidechains to create Softchains, Bitcoin full nodes could validate entire sidechains at minimal cost. This new model might be useful for certain types of sidechains, most notably “block size increase” sidechains that do nothing fancy but do offer more transaction capacity. Aaron, Sjors and Ruben also discuss some of the downsides of the Softchain model.
