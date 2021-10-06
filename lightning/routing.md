\newpage
## Routing

![Bitcoin, Explained ep. 41](qr/41.png)

are joined by Lightning developer Joost Jager to discuss everything about Lightning Network routing.

The Lightning Network — Bitcoin’s Layer Two protocol for fast and cheap payments — consists of a network of payments channels. Each payment channel exists between two Lightning users. But even if two users don’t have a payment channel between themselves directly, they can pay each other though one or several other Lightning users, who in that case forward the payment from the payer to the payee.

The challenge is that a payment path across the network must be found, which allows the funds to move from the payer to the payee, and ideally the cheapest, fastest and most reliable payment path available.

Joost explains how Lightning nodes currently construct a map of the Lightning Network, and what information about all of the (publicly visible) payment channels is included about in that map. Next, he outlines on what basis Lightning nodes calculate the best path over the network to reach the payee, and how the performance of this route factors into future path finding calculations.

Finally, Aaron, Sjors and Joost discuss some (potential) optimizations to benefit Lightning Network routing, such as rebalancing schemes and Trampoline Payments.

Timestamps:

0:00 - 2:10 Intro
2:10 - 3:02 What is lightning?
3:02 - 7:43 What is routing?
7:43 - 9:50 Does the sender need to have the entire map of the network?
9:50 - 11:14 How does a node know where all of the public channels are?
11:14 - 13:30 What information about the channels are being shared?
13:30 - 14:28 How does a node calculate the best route?
14:28 - 15:25 Path finding using different lightning implementations
15:25 - 18:16 The factors that determine the payment route
18:16 - 20:58 The problem with node reputation
20:58 - 21:54 How is node reliability factored into path finding?
21:54 - 23:45 Reiterating the factors that determine the best payment route
23:45 - 27:21 The concern of keeping track of the entire network
27:21 - 30:12 The problem of channels only being used in one direction
30:12 - 31:53 What problems remain to be solved on lightning?
31:53 - 35:18 What happens if a node has many imbalanced channels?
35:18 - 37:36 How can nodes maintain healthy channels?
37:36 - 39:33 Being careful about what channels you accept
39:33 - 40:04 Closing comments
