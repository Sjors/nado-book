\newpage
## Eclipse attacks

![Bitcoin, Explained ep. 17](qr/17.png)

discuss Eclipse attacks. More specifically, they discuss the 2015 paper “Eclipse Attacks on Bitcoin’s Peer-to-Peer Network,” written by Ethan Heilman, Alison Kendler, Aviv Zohar and Sharon Goldberg, from Boston University and Hebrew University/MSR Israel.

Eclipse attacks are a type of attack that isolates a Bitcoin node by occupying all of its connection slots to block the node from receiving any transactions, barring it from transactions other than those sent to it by the attacker. This would prevent the node from seeing what’s going on in the Bitcoin network, and potentially even trick the node into accepting an alternative (and thus invalid) version of the Bitcoin blockchain.

Aaron and Sjors explain how this type of attack could be used to dupe users and miners. They also discuss some of the solutions proposed in the paper to counter this type of attack, including solutions that have by now already been implemented in Bitcoin Core software. This includes a solution that will be included in the next Bitcoin Core software release, Bitcoin Core 0.21.0. They also mention one solution that is not included in the paper.
