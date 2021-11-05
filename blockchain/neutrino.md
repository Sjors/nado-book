\newpage
## Compact Client Side Filtering (Neutrino)


![Ep. 25 {l0pt}](qr/25.png)

discuss Compact Client Side Filtering, also known as Neutrino. Compact Client Side Filtering is a solution to use Bitcoin without needing to download and validate the entire blockchain, and without sacrificing your privacy to someone who operates a full node (and therefore did download and validate the entire blockchain).

Downloading and validating the entire Bitcoin blockchain can take a couple of days even on a standard laptop, and much longer on smart phones or other limited-performance computers. This is why many people prefer to use light clients. These aren’t quite as secure as full Bitcoin nodes, but they do require fewer computational resources to operate.

Some types of light clients — Simplified Payment Verification (SPV) clients — essentially ask nodes on the Bitcoin network about the particular Bitcoin addresses they are interested in, to check how much funds they own. This is bad for privacy, since the full node operators learns which addresses belong to the SPV user.

Compact Client Side Filtering is a newer solution to accomplish similar goals as SPV, but without the loss of privacy. This works, in short, by having full node operators create a cryptographic data-structure that tells the light client user whether a block could have contained activity pertaining to its addresses, so the user can keep track of its funds by downloading only a small subset of all Bitcoin blocks.

Aaron and Sjors explain how this works in more detail, and discuss some of the tradeoffs of this solution.
