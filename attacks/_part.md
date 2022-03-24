# Attacking Bitcoin

## Overview {.unlisted .unnumbered}

An important philosophy of Bitcoin, and safety engineering in general, is to be honest about the ways in which it is potentially vulnerable. The following chapters should cause the reader to be paralyzed in fear. Well, at least be slightly worried.

Several of the potential attacks described have never even happened in practice. Nonetheless we want to prevent them, and this effort has led to several cool innovations.

The first attack that comes to mind is probably the infamous 51% attack, but it is extremely expensive to execute and highly visible.^[Some charts that illustrate the difficulty of this attack: <https://bitcoin.sipa.be> The supply chain problems caused by chip shortages in 2020-2022 illustrate that even a well resourced government can't easily get their hands on enough chips to attack the network.] This concern tends to be followed by worries about “quantum”, which we addressed at the end of chapter @sec:address.

But the lesser known eclipse attack is a much more pressing concern. Thwarting those is a a cat and mouse game that we explore in chapters @sec:eclipse and @sec:fake_nodes.

Another thing to worry about as a user is that the software you download doesn’t outright steal your coins, and we’ll go down that rabbit hole in chapter @sec:guix.
