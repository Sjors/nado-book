\newpage
## Why open source matters (guix) {#sec:guix}


![Ep. 21 {l0pt}](qr/21.png)

discuss why it matters that Bitcoin software is open source… and why even open source software doesn't necessarily solve all software-specific trust issues.

In theory, the fact that most Bitcoin nodes, wallets and applications are open source should ensure that developers can’t include malicious code in the programs: anyone can inspect the source code for malware. In practice, however, the number of people with enough expertise to do this is limited, while the reliance of some Bitcoin projects on external code libraries (“dependencies”) makes it even harder.

Furthermore, even if the open source code is sound, this doesn’t guarantee that the binaries (computer code) really correspond with the open source code. Aaron and Sjors explain how this risk is largely mitigated in Bitcoin through a process called Gitian building, where several Bitcoin Core developers sign the binaries if, and only if, they all produced the exact same binaries from the same source code. This requires special compiler software.

Finally, Aaron and Sjors discuss Guix, a relatively new project that goes above and beyond the Gitian process, to minimize the level of trust required to turn source code into binaries — including trust in the compiler itself.
