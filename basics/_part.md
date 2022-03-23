# The Basics

## Overview {.unlisted .unnumbered}

In this part we explain a number of basic concepts, that will be referred to in later chapters. For a more a thorough and structured introduction to Bitcoin, consider reading _Mastering Bitcoin_ by Andreas Antonopoulos^[<https://www.oreilly.com/library/view/mastering-bitcoin/9781491902639/>] or _Grokking Bitcoin_ by Kalle Rosenbaum.^[<https://www.manning.com/books/grokking-bitcoin>] However, these books are not required reading to follow along with this book.

In chapter @sec:address we explain how a Bitcoin address is not something that exists on the blockchain, but rather is a convention used by wallet software to communicate where coins must be sent to. We explain how they are encoded using base58 and more recently with bech32.

In chapter @sec:dns we explain how, the very first time your Bitcoin node starts up, it finds peers to communicate with. You'll also get a primer on Tor.

Chapter @sec:segwit explains the 2017 SegWit soft fork, how it increased the block size and paved the way towards Lightning by solving transaction malleability.

Finally chapter @sec:libsecp explains what libraries are, how they cause problems and what happened with OpenSSL in particular.
