\newpage
## RBF bug in Bitcoin Core

Listen to Bitcoin, Explained episode 38:\
![](qr/38.png)

discuss CVE-2021-31876, a bug in the Bitcoin Core code that affects replace-by-fee (RBF) child transactions.

The CVE (Common Vulnerabilities and Exposures) system offers an overview of publicly known software bugs. A newly discovered bug in the Bitcoin Core code was recently discovered and disclosed by Antoine Riard, and added to the CVE overview.

Aaron and Sjors explain that the bug affects how RBF logic is handled by the Bitcoin Core software. When one unconfirmed transaction includes an RBF flag (which means it should be considered replaceable if a conflicting transaction with a higher fee is broadcast over the network) any following transaction that spends coins from the original transaction should also be considered replaceable — even if the second transaction doesn’t itself have an RBF flag. Bitcoin Core software would not do this, however, which means the second transaction would in fact not be considered replaceable.

This is a fairly innocent bug; in most cases the second transaction will still confirm eventually, while there are also other solutions to speed confirmation up if the included fee is too low. But in very specific cases, like some fallback security mechanisms on the Lightning Network, the bug could in fact cause complications. Aaron and Sjors try to explain what such a scenario would look like — badly.

Timestamps:

0:00 - 1:05 Intro
1:05 - 2:23 What is a CVE?
2:23 - 4:29 What is replace-by-fee?
4:29 - 6:33 What happens if you have two transactions built on top of each other?
6:33 - 7:49 Is this something we need to be concerned about?
7:49 - 11:29 HTLCs
11:29 - 15:42 How can someone exploit this bug in lightning?
15:57 - 16:22 The basic principle
16:22 - 17:28 The heart of the problem
17:55 - 18:50 How worried should lightning people be?
18:50 - 19:26 Is the bug already fixed?
19:26 - 20:20 Closing comments
