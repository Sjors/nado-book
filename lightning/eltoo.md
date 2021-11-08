\newpage
## Eltoo and SIGHASH_ANYPREVOUT


![Ep. 35 {l0pt}](qr/35.png)

discuss SIGHASH_ANYPREVOUT, a proposed new sighash flag that would enable a cleaner version of the Lightning Network and other Layer Two protocols.Sighash flags are included in Bitcoin transactions to indicate which part of the transaction is signed by the required private keys, exactly.

This can be (almost) the entire transaction, or specific parts of it. Signing only specific parts allows for some flexibility to adjust the transaction even after it is signed, which can sometimes be useful.Aaron and Sjors explain that SIGHASH_ANYPREVOUT is a new type of sighash flag, which would sign most of the transaction, but not the inputs. This means that the inputs could be swapped, as long as the new inputs would still be compatible with the signature.

SIGHASH_ANYPREVOUT would be especially useful in context of Eltoo, a proposed Layer Two protocol that would enable a new version of the Lightning Network. Where Lightning users currently need to store old channel data for security reasons, and could also be punished severely if they accidentally broadcast some of this data at the wrong time, Aaron and Sjors explain how SIGHASH_ANYPREVOUT would do away with this requirement.

![Ep. 48 {l0pt}](qr/48.png)
