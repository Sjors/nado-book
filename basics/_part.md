# The Basics

## Overview {.unlisted .unnumbered}

In this part, we explain a number of basic concepts that will be referred to in later chapters. For a more thorough and structured introduction to Bitcoin, consider reading _Mastering Bitcoin_ by Andreas M. Antonopoulos,^[<https://www.oreilly.com/library/view/mastering-bitcoin/9781491902639/>] or _Grokking Bitcoin_ by Kalle Rosenbaum.^[<https://www.manning.com/books/grokking-bitcoin>] However, these books aren’t required reading to follow along with this book.

In chapter @sec:address, we explain how a Bitcoin address isn’t something that exists on the blockchain, but rather is a convention used by wallet software to communicate where coins must be sent. We also explain how these addresses are encoded using base58, and more recently with bech32.

In chapter @sec:dns, we explain how, the very first time your Bitcoin node starts up, it finds peers to communicate with. You’ll also get a primer on Tor.

Chapter @sec:segwit explains the 2017 SegWit soft fork and talks about how it increased the block size and paved the way toward the Lightning network by solving transaction malleability.

Finally, chapter @sec:libsecp explains what libraries are, how they cause problems, and what happened with OpenSSL in particular.

### Reading Hints

Each chapter contains a QR code that takes you to the corresponding podcast episode and its show notes. The episode number is shown below the QR code. You can also find the episode in your favorite podcasting application by searching for _Bitcoin, Explained_. Or, play it in your browser.^[<https://bitcoinexplainedpodcast.com>]

There is a tiny QR code displayed next to each URL. These go through btcwip.com in order to keep them small. We won't track you.

Throughout the text, there are many references to the Bitcoin Core node software and its built-in wallet. Appendix @sec:crime_on_testnet has some screenshots of it and shows a typical workflow for sending and receiving bitcoin.
