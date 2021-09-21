\newpage
## Routing

Listen to episode 41:

\qrcode{https://nadobtc.libsyn.com/lightning-network-routing-nado-41}

are joined by Lightning developer Joost Jager to discuss everything about Lightning Network routing.

The Lightning Network — Bitcoin’s Layer Two protocol for fast and cheap payments — consists of a network of payments channels. Each payment channel exists between two Lightning users. But even if two users don’t have a payment channel between themselves directly, they can pay each other though one or several other Lightning users, who in that case forward the payment from the payer to the payee.

The challenge is that a payment path across the network must be found, which allows the funds to move from the payer to the payee, and ideally the cheapest, fastest and most reliable payment path available.

Joost explains how Lightning nodes currently construct a map of the Lightning Network, and what information about all of the (publicly visible) payment channels is included about in that map. Next, he outlines on what basis Lightning nodes calculate the best path over the network to reach the payee, and how the performance of this route factors into future path finding calculations.

Finally, Aaron, Sjors and Joost discuss some (potential) optimizations to benefit Lightning Network routing, such as rebalancing schemes and Trampoline Payments.
