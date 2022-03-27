# The Basics

## Overview {.unlisted .unnumbered}

In this part we explain a number of basic concepts, that will be referred to in later chapters. For a more a thorough and structured introduction to Bitcoin, consider reading _Mastering Bitcoin_ by Andreas Antonopoulos^[<https://www.oreilly.com/library/view/mastering-bitcoin/9781491902639/>] or _Grokking Bitcoin_ by Kalle Rosenbaum.^[<https://www.manning.com/books/grokking-bitcoin>] However, these books are not required reading to follow along with this book.

In chapter @sec:address we explain how a Bitcoin address is not something that exists on the blockchain, but rather is a convention used by wallet software to communicate where coins must be sent to. We explain how they are encoded using base58 and more recently with bech32.

In chapter @sec:dns we explain how, the very first time your Bitcoin node starts up, it finds peers to communicate with. You'll also get a primer on Tor.

Chapter @sec:segwit explains the 2017 SegWit soft fork, how it increased the block size and paved the way towards Lightning by solving transaction malleability.

Finally chapter @sec:libsecp explains what libraries are, how they cause problems and what happened with OpenSSL in particular.

Each chapter contains a QR code which takes you to the corresponding podcast episode and its shownotes. The episode number is shown below the QR. You can also find the episode in your favorite podcasting application by searching for “Bitcoin Explained”. Or play them in your browser from here^[<https://nadobtc.libsyn.com>].

The paper version of this book displays a tiny QR code next to each URL. These go through bit.ly. Although the author can’t track which URL’s you follow - because the short URL’s were generated without an account - bit.ly might be able to, with some effort.

Throughout the text there are many references the Bitcoin Core node software and its built-in wallet. Appendix @sec:crime_on_testnet has some screenshots of it and shows a typical workflow for sending and receiving Bitcoin.
