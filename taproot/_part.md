# Taproot {#sec:taproot}

## Overview {.unlisted .unnumbered}

This part is all about Taproot: what it is, why it's interesting and how it came to be.

Taproot is an upgrade to Bitcoin that was proposed in 2018 and deployed in November 2021. This soft fork increases privacy for "smart contracts" and reduces their transaction fees. It achieves this by hiding all the different spending conditions in a Merkle tree and only revealing the one that's eventually used. It also introduces Schnorr signatures, which make it much easier to compress signatures from multiple participants into a single signature. Both of these things result in less use of precious block space, reduced fees, and improved privacy.

Chapter @sec:taproot_basics breaks down and explains Taproot^[See also: <https://bitcoinmagazine.com/articles/taproot-coming-what-it-and-how-it-will-benefit-bitcoin>] — covering the building blocks that make Taproot possible — and explains what it enables Bitcoin to do.

Chapter @sec:taproot_activation goes into how the soft fork was activated and the discussion that went into that.
