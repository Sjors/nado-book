\newpage
## Recurring payments, etc (bolt 12)


![Ep. 44 {l0pt}](qr/44.png)

discuss BOLT 12 (Basis of Lightning Technology 12), a newly proposed Lightning Network specification for “offers”, a type of “meta invoices” designed by c-lightning developer Rusty Russell.

Where coins on Bitcoin’s base layer are sent to addresses, the Lightning network uses invoices. Invoices communicate the requested amount, node destination, and the hash of a secret which is used for payment routing. This works, but has a number of limitations, Sjors explains, notably that the amount must be bitcoin-denominated (as opposed for fiat denominated), and the invoice can only be used once.

BOLT 12, which has been implemented in c-ligtning, is a way to essentially refer a payer to the node that is to be paid, in order to request a new invoice. While the BOLT 12 offer can be static and reusable — it always refers to the same node — the payee can generate new invoices on the fly when requested, allowing for much more flexibility, Sjors explains.

Finally, Aaron and Sjors discuss how the new BOLT 12 messages are communicated over the Lightning Network through an update to the BOLT 7 specification for message relay.
