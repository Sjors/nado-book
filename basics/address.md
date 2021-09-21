\newpage
## Bitcoin addresses

Listen to episode 28:

\qrcode{https://bitcoinmagazine.com/technical/explaining-bitcoin-addresses}

discuss Bitcoin addresses. Every Bitcoin user has probably at one point used Bitcoin addresses, but what are they, exactly?

Aaron and Sjors explain that Bitcoin addresses are not part of the Bitcoin protocol. Instead, they are conventions used by Bitcoin (wallet) software to communicate where coins must be spent to: either a public key (P2PK), a public key hash (P2PKH), a script hash (P2SH), a witness public key hash (P2WPKH), or a witness script hash (P2WSH). Addresses also include some meta data about the address type itself.

Bitcoin addresses communicate these payment options using their own “numeric systems”, Aaron and Sjors explain. The first version of this was base58, which uses 58 different symbols to represent numbers. Newer address types, bech32 addresses, instead use base32 which uses 32 different symbols to represent numbers.

Aaron and Sjors discuss some of the benefits of using Bitcoin addresses in general. and bech32 addresses in specific. In addition, Sjors explains that the first version of bech32 addresses included a (relatively harmless) bug, and how a newer standard for bech32 addresses has fixed this bug.
